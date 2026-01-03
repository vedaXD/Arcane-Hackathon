from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum, Q
from decimal import Decimal
from .models import (
    DiamondWallet, DiamondTransaction, NGOPartner,
    Donation, RedemptionOption, Redemption
)
from .serializers import (
    DiamondWalletSerializer, DiamondTransactionSerializer,
    NGOPartnerSerializer, DonationSerializer,
    RedemptionOptionSerializer, RedemptionSerializer,
    DashboardSerializer
)
from .services import DiamondEconomyService


class DiamondWalletViewSet(viewsets.ReadOnlyModelViewSet):
    """View and manage diamond wallet"""
    serializer_class = DiamondWalletSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return DiamondWallet.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def dashboard(self, request):
        """Get complete dashboard data"""
        wallet = DiamondWallet.objects.get(user=request.user)
        transactions = DiamondTransaction.objects.filter(wallet=wallet)[:10]
        
        # Calculate stats
        ride_transactions = transactions.filter(
            transaction_type='EARN_RIDE'
        )
        total_co2 = ride_transactions.aggregate(
            total=Sum('co2_saved')
        )['total'] or Decimal('0')
        
        total_distance = ride_transactions.aggregate(
            total=Sum('distance_km')
        )['total'] or Decimal('0')
        
        total_donations = Donation.objects.filter(
            user=request.user
        ).aggregate(total=Sum('amount'))['total'] or Decimal('0')
        
        # Calculate rank
        all_wallets = DiamondWallet.objects.all().order_by('-lifetime_earned')
        rank = list(all_wallets.values_list('id', flat=True)).index(wallet.id) + 1
        
        # Get level
        level_name, level_num = DiamondEconomyService.get_user_level(
            float(wallet.lifetime_earned)
        )
        
        data = {
            'wallet': DiamondWalletSerializer(wallet).data,
            'recent_transactions': DiamondTransactionSerializer(transactions, many=True).data,
            'total_co2_saved': total_co2,
            'total_distance_km': total_distance,
            'total_donations': total_donations,
            'rank': rank,
            'level': f"{level_name} (Level {level_num})",
        }
        
        return Response(data)


class DiamondTransactionViewSet(viewsets.ReadOnlyModelViewSet):
    """View transaction history"""
    serializer_class = DiamondTransactionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        wallet = DiamondWallet.objects.get(user=self.request.user)
        return DiamondTransaction.objects.filter(wallet=wallet)


class NGOPartnerViewSet(viewsets.ReadOnlyModelViewSet):
    """View NGO partners"""
    serializer_class = NGOPartnerSerializer
    queryset = NGOPartner.objects.filter(active=True, verified=True)
    permission_classes = [IsAuthenticated]


class DonationViewSet(viewsets.ModelViewSet):
    """Make and view donations"""
    serializer_class = DonationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Donation.objects.filter(user=self.request.user)
    
    def create(self, request):
        """Create a donation"""
        ngo_id = request.data.get('ngo')
        amount = Decimal(str(request.data.get('amount', 0)))
        payment_id = request.data.get('payment_id', 'test_payment')
        
        if amount <= 0:
            return Response(
                {'error': 'Invalid donation amount'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            ngo = NGOPartner.objects.get(id=ngo_id, active=True)
        except NGOPartner.DoesNotExist:
            return Response(
                {'error': 'NGO not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Calculate diamonds and CO2 equivalent
        diamonds, co2_eq = DiamondEconomyService.calculate_donation_diamonds(float(amount))
        
        # Create donation (signal will award diamonds)
        donation = Donation.objects.create(
            user=request.user,
            ngo=ngo,
            amount=amount,
            diamonds_earned=diamonds,
            co2_equivalent=co2_eq,
            payment_id=payment_id,
            status='completed'
        )
        
        serializer = self.get_serializer(donation)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class RedemptionOptionViewSet(viewsets.ReadOnlyModelViewSet):
    """View available redemption options"""
    serializer_class = RedemptionOptionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        queryset = RedemptionOption.objects.filter(active=True, stock_available__gt=0)
        
        # Filter by category
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category=category)
        
        # Featured items
        featured = self.request.query_params.get('featured')
        if featured == 'true':
            queryset = queryset.filter(featured=True)
        
        return queryset.order_by('-featured', 'diamond_cost')


class RedemptionViewSet(viewsets.ModelViewSet):
    """Redeem diamonds and view redemptions"""
    serializer_class = RedemptionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Redemption.objects.filter(user=self.request.user)
    
    def create(self, request):
        """Redeem diamonds for a reward"""
        option_id = request.data.get('option')
        
        try:
            option = RedemptionOption.objects.get(id=option_id, active=True)
        except RedemptionOption.DoesNotExist:
            return Response(
                {'error': 'Redemption option not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        try:
            redemption = DiamondEconomyService.redeem_diamonds(request.user, option)
            serializer = self.get_serializer(redemption)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except ValueError as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
