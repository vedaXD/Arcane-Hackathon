from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
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


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True, required=True)
    
    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'password_confirm',
            'first_name', 'last_name', 'organization', 'role',
            'phone_number', 'gender', 'profile_picture'
        ]
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user


class UserProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'first_name', 'last_name', 'phone_number',
            'gender', 'profile_picture'
        ]


class VehicleSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.get_full_name', read_only=True)
    
    class Meta:
        model = Vehicle
        fields = [
            'id', 'driver', 'driver_name', 'vehicle_type', 'model',
            'registration_number', 'fuel_type', 'capacity', 'color',
            'year', 'is_verified', 'created_at'
        ]
        read_only_fields = ['id', 'driver', 'driver_name', 'is_verified', 'created_at']

