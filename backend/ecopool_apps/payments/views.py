from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db import transaction
from decimal import Decimal
from .models import Payment, RewardTransaction
from .serializers import PaymentSerializer, RewardTransactionSerializer
from ecopool_apps.authentication.models import User
from ecopool_apps.rides.models import Ride


class PaymentViewSet(viewsets.ModelViewSet):
    """
    ViewSet for payment management
    """
    serializer_class = PaymentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Return payments for current user (as payer or recipient)"""
        return Payment.objects.filter(
            payer=self.request.user
        ) | Payment.objects.filter(
            ride__driver=self.request.user
        )
    
    @action(detail=False, methods=['post'])
    def process_payment(self, request):
        """
        Process payment for a ride
        Expected data: ride_id, amount, payment_method
        """
        ride_id = request.data.get('ride_id')
        amount = request.data.get('amount')
        payment_method = request.data.get('payment_method', 'cash')
        
        if not ride_id or not amount:
            return Response(
                {'error': 'Ride ID and amount are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            ride = Ride.objects.get(id=ride_id)
        except Ride.DoesNotExist:
            return Response(
                {'error': 'Ride not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Verify the user is a passenger on this ride
        if request.user != ride.passenger:
            return Response(
                {'error': 'You are not authorized to pay for this ride'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Check if payment already exists
        if Payment.objects.filter(ride=ride, payer=request.user).exists():
            return Response(
                {'error': 'Payment already processed for this ride'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        with transaction.atomic():
            # Create payment
            payment = Payment.objects.create(
                ride=ride,
                payer=request.user,
                amount=Decimal(amount),
                payment_method=payment_method,
                status='completed'
            )
            
            # TODO: Integrate actual payment gateway
            # For now, mark as completed
            
            # Update ride status
            ride.status = 'completed'
            ride.save()
        
        return Response(
            PaymentSerializer(payment).data,
            status=status.HTTP_201_CREATED
        )
    
    @action(detail=True, methods=['post'])
    def refund(self, request, pk=None):
        """Process payment refund"""
        payment = self.get_object()
        
        if payment.status != 'completed':
            return Response(
                {'error': 'Only completed payments can be refunded'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # TODO: Implement actual refund logic with payment gateway
        
        payment.status = 'refunded'
        payment.save()
        
        return Response(
            PaymentSerializer(payment).data
        )


class RewardTransactionViewSet(viewsets.ModelViewSet):
    """
    ViewSet for reward transactions
    """
    serializer_class = RewardTransactionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Return reward transactions for current user"""
        return RewardTransaction.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def redeem_points(self, request):
        """
        Redeem reward points
        Expected data: points, description
        """
        points = request.data.get('points')
        description = request.data.get('description', 'Points redemption')
        
        if not points:
            return Response(
                {'error': 'Points amount is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        points = int(points)
        
        if points <= 0:
            return Response(
                {'error': 'Points must be positive'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        user = request.user
        
        if user.reward_points < points:
            return Response(
                {'error': f'Insufficient points. You have {user.reward_points} points'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        with transaction.atomic():
            # Deduct points from user
            user.reward_points -= points
            user.save()
            
            # Create transaction record
            reward_transaction = RewardTransaction.objects.create(
                user=user,
                points=-points,  # Negative for redemption
                transaction_type='redemption',
                description=description
            )
        
        return Response(
            RewardTransactionSerializer(reward_transaction).data,
            status=status.HTTP_201_CREATED
        )
    
    @action(detail=False, methods=['get'])
    def balance(self, request):
        """Get current reward points balance"""
        return Response({
            'user_id': request.user.id,
            'reward_points': request.user.reward_points,
            'total_co2_saved': request.user.total_co2_saved
        })
