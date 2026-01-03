from rest_framework import serializers
from .models import User, Organization, Vehicle


class OrganizationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ['id', 'name', 'domain', 'address', 'created_at', 'is_active']


class UserSerializer(serializers.ModelSerializer):
    organization_name = serializers.CharField(source='organization.name', read_only=True)
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name',
            'organization', 'organization_name', 'role', 'phone_number',
            'gender', 'profile_picture', 'trust_score', 'total_rides',
            'total_co2_saved', 'reward_points', 'is_verified', 'created_at'
        ]
        read_only_fields = ['trust_score', 'total_rides', 'total_co2_saved', 'reward_points']


class VehicleSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.get_full_name', read_only=True)
    
    class Meta:
        model = Vehicle
        fields = [
            'id', 'driver', 'driver_name', 'vehicle_type', 'model',
            'registration_number', 'fuel_type', 'capacity', 'color',
            'year', 'is_verified', 'created_at'
        ]
