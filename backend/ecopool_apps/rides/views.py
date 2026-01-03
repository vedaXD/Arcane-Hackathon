from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db.models import Q
from .models import Ride, RideTracking, SOSAlert, ChatMessage, Feedback, Complaint
from .serializers import (
    RideSerializer, RideTrackingSerializer, SOSAlertSerializer,
    ChatMessageSerializer, FeedbackSerializer, ComplaintSerializer
)
from ecopool_apps.sustainability.carbon_utils import calculate_co2_saved, calculate_reward_points
from ecopool_apps.payments.models import RewardTransaction


class RideViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing active rides
    """
    permission_classes = [IsAuthenticated]
    serializer_class = RideSerializer
    
    def get_queryset(self):
        user = self.request.user
        return Ride.objects.filter(
            Q(driver=user) | Q(passengers=user)
        ).distinct().select_related('trip', 'driver').prefetch_related('passengers')
    
    @action(detail=True, methods=['post'])
    def start(self, request, pk=None):
        """Start a ride"""
        ride = self.get_object()
        
        if ride.driver != request.user:
            return Response(
                {'error': 'Only the driver can start the ride'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        if ride.status != 'started':
            return Response(
                {'error': 'Ride has already been started or completed'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        ride.status = 'in_progress'
        ride.start_time = timezone.now()
        ride.save()
        
        return Response({'message': 'Ride started successfully'})
    
    @action(detail=True, methods=['post'])
    def update_location(self, request, pk=None):
        """Update current location during ride"""
        ride = self.get_object()
        
        if ride.driver != request.user:
            return Response(
                {'error': 'Only the driver can update location'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')
        
        if not latitude or not longitude:
            return Response(
                {'error': 'Latitude and longitude required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Update ride current location
        ride.current_latitude = latitude
        ride.current_longitude = longitude
        ride.save()
        
        # Create tracking point
        RideTracking.objects.create(
            ride=ride,
            latitude=latitude,
            longitude=longitude
        )
        
        return Response({'message': 'Location updated successfully'})
    
    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        """Complete a ride and calculate CO2 saved"""
        ride = self.get_object()
        
        if ride.driver != request.user:
            return Response(
                {'error': 'Only the driver can complete the ride'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        if ride.status != 'in_progress':
            return Response(
                {'error': 'Ride is not in progress'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        distance = request.data.get('distance_km')
        if not distance:
            return Response(
                {'error': 'Distance is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Calculate CO2 saved
        num_passengers = ride.passengers.count()
        fuel_type = ride.trip.vehicle.fuel_type
        co2_saved = calculate_co2_saved(float(distance), fuel_type, num_passengers)
        
        # Update ride
        ride.status = 'completed'
        ride.end_time = timezone.now()
        ride.distance_covered = distance
        ride.co2_saved = co2_saved
        ride.save()
        
        # Update trip status
        ride.trip.status = 'completed'
        ride.trip.save()
        
        # Award reward points to all participants
        reward_points = calculate_reward_points(co2_saved)
        points_per_person = reward_points // (num_passengers + 1)
        
        # Driver rewards
        ride.driver.reward_points += points_per_person
        ride.driver.total_co2_saved += float(co2_saved)
        ride.driver.total_rides += 1
        ride.driver.save()
        
        RewardTransaction.objects.create(
            user=ride.driver,
            ride=ride,
            transaction_type='earned',
            points=points_per_person,
            co2_saved=co2_saved,
            description=f'Earned from completing ride #{ride.id}'
        )
        
        # Passenger rewards
        for passenger in ride.passengers.all():
            passenger.reward_points += points_per_person
            passenger.total_co2_saved += float(co2_saved)
            passenger.total_rides += 1
            passenger.save()
            
            RewardTransaction.objects.create(
                user=passenger,
                ride=ride,
                transaction_type='earned',
                points=points_per_person,
                co2_saved=co2_saved,
                description=f'Earned from ride #{ride.id}'
            )
        
        return Response({
            'message': 'Ride completed successfully',
            'co2_saved': str(co2_saved),
            'reward_points': points_per_person,
            'distance_km': distance
        })
    
    @action(detail=True, methods=['get'])
    def tracking(self, request, pk=None):
        """Get ride tracking history"""
        ride = self.get_object()
        tracking_points = ride.tracking_points.all()[:50]  # Last 50 points
        serializer = RideTrackingSerializer(tracking_points, many=True)
        return Response(serializer.data)


class SOSAlertViewSet(viewsets.ModelViewSet):
    """
    ViewSet for SOS emergency alerts
    """
    permission_classes = [IsAuthenticated]
    serializer_class = SOSAlertSerializer
    
    def get_queryset(self):
        user = self.request.user
        if user.role == 'admin':
            # Admins see all SOS alerts for their organization
            return SOSAlert.objects.filter(
                triggered_by__organization=user.organization
            )
        else:
            # Users see alerts related to their rides
            return SOSAlert.objects.filter(
                Q(triggered_by=user) |
                Q(ride__driver=user) |
                Q(ride__passengers=user)
            ).distinct()
    
    def create(self, request):
        """Trigger SOS alert"""
        ride_id = request.data.get('ride')
        
        try:
            ride = Ride.objects.get(id=ride_id)
        except Ride.DoesNotExist:
            return Response(
                {'error': 'Ride not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Verify user is part of the ride
        if request.user not in [ride.driver] + list(ride.passengers.all()):
            return Response(
                {'error': 'You are not part of this ride'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Create SOS alert
        sos_alert = SOSAlert.objects.create(
            ride=ride,
            triggered_by=request.user,
            latitude=request.data.get('latitude', ride.current_latitude),
            longitude=request.data.get('longitude', ride.current_longitude),
            message=request.data.get('message', '')
        )
        
        # Update ride status
        ride.status = 'emergency'
        ride.save()
        
        # TODO: Send notifications to organization admins
        # TODO: Send SMS/WhatsApp alerts
        
        serializer = SOSAlertSerializer(sos_alert)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['post'])
    def resolve(self, request, pk=None):
        """Resolve SOS alert (admin only)"""
        sos_alert = self.get_object()
        
        if request.user.role != 'admin':
            return Response(
                {'error': 'Only admins can resolve SOS alerts'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        sos_alert.status = request.data.get('status', 'resolved')
        sos_alert.resolved_by = request.user
        sos_alert.resolved_at = timezone.now()
        sos_alert.save()
        
        return Response({'message': 'SOS alert resolved'})


class ChatMessageViewSet(viewsets.ModelViewSet):
    """
    ViewSet for in-app chat messages
    """
    permission_classes = [IsAuthenticated]
    serializer_class = ChatMessageSerializer
    
    def get_queryset(self):
        user = self.request.user
        ride_id = self.request.query_params.get('ride')
        
        queryset = ChatMessage.objects.filter(
            Q(ride__driver=user) | Q(ride__passengers=user)
        )
        
        if ride_id:
            queryset = queryset.filter(ride_id=ride_id)
        
        return queryset.select_related('sender', 'ride').order_by('timestamp')
    
    def create(self, request):
        """Send a chat message"""
        ride_id = request.data.get('ride')
        
        try:
            ride = Ride.objects.get(id=ride_id)
        except Ride.DoesNotExist:
            return Response(
                {'error': 'Ride not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Verify user is part of the ride
        if request.user not in [ride.driver] + list(ride.passengers.all()):
            return Response(
                {'error': 'You are not part of this ride'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        message = ChatMessage.objects.create(
            ride=ride,
            sender=request.user,
            message=request.data.get('message')
        )
        
        serializer = ChatMessageSerializer(message)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class FeedbackViewSet(viewsets.ModelViewSet):
    """
    ViewSet for post-ride feedback
    """
    permission_classes = [IsAuthenticated]
    serializer_class = FeedbackSerializer
    
    def get_queryset(self):
        user = self.request.user
        return Feedback.objects.filter(
            Q(from_user=user) | Q(to_user=user)
        ).select_related('from_user', 'to_user', 'ride')
    
    def create(self, request):
        """Submit feedback"""
        ride_id = request.data.get('ride')
        to_user_id = request.data.get('to_user')
        
        try:
            ride = Ride.objects.get(id=ride_id)
        except Ride.DoesNotExist:
            return Response(
                {'error': 'Ride not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Verify ride is completed
        if ride.status != 'completed':
            return Response(
                {'error': 'Can only give feedback for completed rides'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Check if already gave feedback
        existing_feedback = Feedback.objects.filter(
            ride=ride,
            from_user=request.user,
            to_user_id=to_user_id
        ).exists()
        
        if existing_feedback:
            return Response(
                {'error': 'You have already given feedback for this user'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        feedback = Feedback.objects.create(
            ride=ride,
            from_user=request.user,
            to_user_id=to_user_id,
            rating=request.data.get('rating'),
            comment=request.data.get('comment', '')
        )
        
        # Update user trust score (simple average for now)
        from django.db.models import Avg
        avg_rating = Feedback.objects.filter(
            to_user_id=to_user_id
        ).aggregate(Avg('rating'))['rating__avg']
        
        if avg_rating:
            user_to_update = feedback.to_user
            user_to_update.trust_score = avg_rating
            user_to_update.save()
        
        serializer = FeedbackSerializer(feedback)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class ComplaintViewSet(viewsets.ModelViewSet):
    """
    ViewSet for complaints
    """
    permission_classes = [IsAuthenticated]
    serializer_class = ComplaintSerializer
    
    def get_queryset(self):
        user = self.request.user
        if user.role == 'admin':
            return Complaint.objects.filter(
                complainant__organization=user.organization
            )
        return Complaint.objects.filter(
            Q(complainant=user) | Q(against_user=user)
        )
    
    def create(self, request):
        """File a complaint"""
        complaint = Complaint.objects.create(
            ride_id=request.data.get('ride'),
            complainant=request.user,
            against_user_id=request.data.get('against_user'),
            title=request.data.get('title'),
            description=request.data.get('description')
        )
        
        # TODO: Notify organization admins
        
        serializer = ComplaintSerializer(complaint)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        """Update complaint status (admin only)"""
        complaint = self.get_object()
        
        if request.user.role != 'admin':
            return Response(
                {'error': 'Only admins can update complaint status'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        complaint.status = request.data.get('status')
        complaint.admin_notes = request.data.get('admin_notes', complaint.admin_notes)
        complaint.save()
        
        return Response({'message': 'Complaint updated successfully'})
