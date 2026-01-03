from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db.models import Q
from .models import Trip, TripRequest
from .serializers import (
    TripSerializer, TripCreateSerializer, 
    TripRequestSerializer, TripSearchSerializer
)
from .matching_utils import match_trips


class TripViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing trips
    """
    permission_classes = [IsAuthenticated]
    
    def get_serializer_class(self):
        if self.action == 'create':
            return TripCreateSerializer
        return TripSerializer
    
    def get_queryset(self):
        user = self.request.user
        queryset = Trip.objects.filter(driver__organization=user.organization)
        
        # Filter by status
        status_filter = self.request.query_params.get('status')
        if status_filter:
            queryset = queryset.filter(status=status_filter)
        
        return queryset.select_related('driver', 'vehicle').order_by('-created_at')
    
    @action(detail=False, methods=['post'])
    def search(self, request):
        """
        Search for matching trips based on route and preferences
        """
        serializer = TripSearchSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        # Get available trips (scheduled and not full)
        available_trips = Trip.objects.filter(
            status='scheduled',
            available_seats__gt=0,
            departure_time__gte=timezone.now(),
            driver__organization=request.user.organization
        ).select_related('driver', 'vehicle')
        
        # Apply matching algorithm
        matched_trips = match_trips(
            serializer.validated_data,
            available_trips,
            request.user
        )
        
        # Serialize results
        result_serializer = TripSerializer(matched_trips, many=True)
        return Response(result_serializer.data)
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel a trip"""
        trip = self.get_object()
        
        if trip.driver != request.user:
            return Response(
                {'error': 'Only the driver can cancel the trip'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        if trip.status in ['completed', 'cancelled']:
            return Response(
                {'error': 'Trip cannot be cancelled'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        trip.status = 'cancelled'
        trip.save()
        
        # TODO: Notify all passengers
        
        return Response({'message': 'Trip cancelled successfully'})
    
    @action(detail=True, methods=['get'])
    def requests(self, request, pk=None):
        """Get all requests for a trip"""
        trip = self.get_object()
        
        if trip.driver != request.user:
            return Response(
                {'error': 'Only the driver can view requests'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        requests = trip.requests.all()
        serializer = TripRequestSerializer(requests, many=True)
        return Response(serializer.data)


class TripRequestViewSet(viewsets.ModelViewSet):
    """
    ViewSet for trip requests (passengers requesting to join trips)
    """
    permission_classes = [IsAuthenticated]
    serializer_class = TripRequestSerializer
    
    def get_queryset(self):
        user = self.request.user
        if user.role == 'driver':
            # Drivers see requests for their trips
            return TripRequest.objects.filter(
                trip__driver=user
            ).select_related('trip', 'passenger')
        else:
            # Passengers see their own requests
            return TripRequest.objects.filter(
                passenger=user
            ).select_related('trip', 'passenger')
    
    def create(self, request):
        """Create a trip request"""
        trip_id = request.data.get('trip')
        
        try:
            trip = Trip.objects.get(id=trip_id)
        except Trip.DoesNotExist:
            return Response(
                {'error': 'Trip not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Validate
        if trip.driver == request.user:
            return Response(
                {'error': 'Cannot request your own trip'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if trip.available_seats < request.data.get('seats_requested', 1):
            return Response(
                {'error': 'Not enough seats available'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Check if already requested
        existing_request = TripRequest.objects.filter(
            trip=trip,
            passenger=request.user,
            status__in=['pending', 'accepted']
        ).exists()
        
        if existing_request:
            return Response(
                {'error': 'You have already requested this trip'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Create request
        trip_request = TripRequest.objects.create(
            trip=trip,
            passenger=request.user,
            seats_requested=request.data.get('seats_requested', 1),
            message=request.data.get('message', '')
        )
        
        serializer = TripRequestSerializer(trip_request)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['post'])
    def accept(self, request, pk=None):
        """Accept a trip request (driver only)"""
        trip_request = self.get_object()
        
        if trip_request.trip.driver != request.user:
            return Response(
                {'error': 'Only the driver can accept requests'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        if trip_request.status != 'pending':
            return Response(
                {'error': 'Request is not pending'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if trip_request.trip.available_seats < trip_request.seats_requested:
            return Response(
                {'error': 'Not enough seats available'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        trip_request.status = 'accepted'
        trip_request.save()
        
        # Update available seats
        trip = trip_request.trip
        trip.available_seats -= trip_request.seats_requested
        trip.save()
        
        # TODO: Notify passenger
        
        return Response({'message': 'Request accepted successfully'})
    
    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        """Reject a trip request (driver only)"""
        trip_request = self.get_object()
        
        if trip_request.trip.driver != request.user:
            return Response(
                {'error': 'Only the driver can reject requests'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        trip_request.status = 'rejected'
        trip_request.save()
        
        # TODO: Notify passenger
        
        return Response({'message': 'Request rejected'})
