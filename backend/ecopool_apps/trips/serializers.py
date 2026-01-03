from rest_framework import serializers
from .models import Trip, TripRequest
from ecopool_apps.authentication.serializers import UserSerializer, VehicleSerializer


class TripSerializer(serializers.ModelSerializer):
    driver_details = UserSerializer(source='driver', read_only=True)
    vehicle_details = VehicleSerializer(source='vehicle', read_only=True)
    
    class Meta:
        model = Trip
        fields = [
            'id', 'driver', 'driver_details', 'vehicle', 'vehicle_details',
            'start_location', 'start_latitude', 'start_longitude',
            'end_location', 'end_latitude', 'end_longitude',
            'departure_time', 'available_seats', 'gender_preference',
            'price_per_seat', 'status', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'driver', 'created_at', 'updated_at']


class TripCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trip
        fields = [
            'vehicle', 'start_location', 'start_latitude', 'start_longitude',
            'end_location', 'end_latitude', 'end_longitude',
            'departure_time', 'available_seats', 'gender_preference', 'price_per_seat'
        ]

    def create(self, validated_data):
        validated_data['driver'] = self.context['request'].user
        return super().create(validated_data)


class TripRequestSerializer(serializers.ModelSerializer):
    passenger_details = UserSerializer(source='passenger', read_only=True)
    trip_details = TripSerializer(source='trip', read_only=True)
    
    class Meta:
        model = TripRequest
        fields = [
            'id', 'trip', 'trip_details', 'passenger', 'passenger_details',
            'seats_requested', 'status', 'message', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'passenger', 'created_at', 'updated_at']


class TripSearchSerializer(serializers.Serializer):
    """Serializer for trip search parameters"""
    start_latitude = serializers.DecimalField(max_digits=10, decimal_places=7, required=True)
    start_longitude = serializers.DecimalField(max_digits=10, decimal_places=7, required=True)
    end_latitude = serializers.DecimalField(max_digits=10, decimal_places=7, required=True)
    end_longitude = serializers.DecimalField(max_digits=10, decimal_places=7, required=True)
    departure_date = serializers.DateField(required=False)
    seats_needed = serializers.IntegerField(required=False, default=1)
    max_distance_km = serializers.DecimalField(max_digits=5, decimal_places=2, required=False, default=5.0)
