from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from django.db.models import Sum, Avg, Count
from datetime import datetime, timedelta
from .models import SustainabilityMetrics, CarbonEmissionFactor
from .serializers import SustainabilityMetricsSerializer, CarbonEmissionFactorSerializer
from ecopool_apps.authentication.models import User


class SustainabilityMetricsViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for sustainability metrics (read-only)
    Metrics are automatically created after each ride
    """
    serializer_class = SustainabilityMetricsSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Return metrics for current user"""
        return SustainabilityMetrics.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def dashboard(self, request):
        """
        Get comprehensive sustainability dashboard data
        """
        user = request.user
        
        # Get date range (default: last 30 days)
        days = int(request.query_params.get('days', 30))
        start_date = datetime.now() - timedelta(days=days)
        
        # Get metrics for the period
        metrics = SustainabilityMetrics.objects.filter(
            user=user,
            created_at__gte=start_date
        )
        
        # Calculate aggregated statistics
        total_metrics = metrics.aggregate(
            total_co2_saved=Sum('co2_saved_kg'),
            total_distance=Sum('distance_km'),
            total_fuel_saved=Sum('fuel_saved_liters'),
            total_rides=Count('id'),
            avg_co2_per_ride=Avg('co2_saved_kg')
        )
        
        # Get all-time statistics
        all_time_metrics = SustainabilityMetrics.objects.filter(user=user).aggregate(
            all_time_co2=Sum('co2_saved_kg'),
            all_time_rides=Count('id'),
            all_time_fuel=Sum('fuel_saved_liters')
        )
        
        # Calculate trees equivalent
        trees_equivalent = (total_metrics['total_co2_saved'] or 0) / 21.77
        all_time_trees = (all_time_metrics['all_time_co2'] or 0) / 21.77
        
        # Get recent metrics (last 7 entries)
        recent_metrics = SustainabilityMetricsSerializer(
            metrics.order_by('-created_at')[:7],
            many=True
        ).data
        
        # Get organization leaderboard
        org_leaderboard = []
        if user.organization:
            top_users = User.objects.filter(
                organization=user.organization
            ).order_by('-total_co2_saved')[:10]
            
            org_leaderboard = [{
                'rank': idx + 1,
                'user_id': u.id,
                'username': u.username,
                'full_name': u.get_full_name(),
                'total_co2_saved': float(u.total_co2_saved),
                'total_rides': u.total_rides,
                'is_current_user': u.id == user.id
            } for idx, u in enumerate(top_users)]
        
        return Response({
            'period_stats': {
                'days': days,
                'total_co2_saved_kg': float(total_metrics['total_co2_saved'] or 0),
                'total_distance_km': float(total_metrics['total_distance'] or 0),
                'total_fuel_saved_liters': float(total_metrics['total_fuel_saved'] or 0),
                'total_rides': total_metrics['total_rides'],
                'avg_co2_per_ride': float(total_metrics['avg_co2_per_ride'] or 0),
                'trees_equivalent': round(trees_equivalent, 2)
            },
            'all_time_stats': {
                'total_co2_saved_kg': float(all_time_metrics['all_time_co2'] or 0),
                'total_rides': all_time_metrics['all_time_rides'],
                'total_fuel_saved_liters': float(all_time_metrics['all_time_fuel'] or 0),
                'trees_equivalent': round(all_time_trees, 2),
                'reward_points': user.reward_points
            },
            'recent_metrics': recent_metrics,
            'organization_leaderboard': org_leaderboard
        })
    
    @action(detail=False, methods=['get'])
    def global_impact(self, request):
        """
        Get global impact statistics across all users
        """
        if not request.user.organization:
            return Response(
                {'error': 'User must belong to an organization'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Get organization-wide statistics
        org_metrics = SustainabilityMetrics.objects.filter(
            user__organization=request.user.organization
        ).aggregate(
            total_co2=Sum('co2_saved_kg'),
            total_distance=Sum('distance_km'),
            total_fuel=Sum('fuel_saved_liters'),
            total_rides=Count('id'),
            total_users=Count('user', distinct=True)
        )
        
        trees_equivalent = (org_metrics['total_co2'] or 0) / 21.77
        
        return Response({
            'organization': request.user.organization.name,
            'total_co2_saved_kg': float(org_metrics['total_co2'] or 0),
            'total_distance_km': float(org_metrics['total_distance'] or 0),
            'total_fuel_saved_liters': float(org_metrics['total_fuel'] or 0),
            'total_rides': org_metrics['total_rides'],
            'total_users': org_metrics['total_users'],
            'trees_equivalent': round(trees_equivalent, 2),
            'avg_co2_per_user': round(
                (org_metrics['total_co2'] or 0) / max(org_metrics['total_users'], 1),
                2
            )
        })


class CarbonEmissionFactorViewSet(viewsets.ModelViewSet):
    """
    ViewSet for carbon emission factors (admin only for CUD, read for all)
    """
    serializer_class = CarbonEmissionFactorSerializer
    queryset = CarbonEmissionFactor.objects.all()
    
    def get_permissions(self):
        """
        Allow read access to authenticated users, write access to admins only
        """
        if self.action in ['list', 'retrieve']:
            permission_classes = [IsAuthenticated]
        else:
            permission_classes = [IsAdminUser]
        return [permission() for permission in permission_classes]
    
    @action(detail=False, methods=['get'])
    def by_fuel_type(self, request):
        """Get emission factors grouped by fuel type"""
        fuel_type = request.query_params.get('fuel_type')
        
        if fuel_type:
            factors = CarbonEmissionFactor.objects.filter(
                fuel_type=fuel_type,
                is_active=True
            )
        else:
            factors = CarbonEmissionFactor.objects.filter(is_active=True)
        
        serializer = self.get_serializer(factors, many=True)
        return Response(serializer.data)
