from rest_framework import serializers
from .models import Ride, RideTracking, SOSAlert, ChatMessage, Feedback, Complaint
from ecopool_apps.authentication.serializers import UserSerializer


class RideSerializer(serializers.ModelSerializer):
    driver_details = UserSerializer(source='driver', read_only=True)
    passenger_details = UserSerializer(source='passengers', many=True, read_only=True)
    
    class Meta:
        model = Ride
        fields = [
            'id', 'trip', 'driver', 'driver_details', 'passengers', 'passenger_details',
            'start_time', 'end_time', 'current_latitude', 'current_longitude',
            'status', 'distance_covered', 'co2_saved', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'driver', 'created_at', 'updated_at']


class RideTrackingSerializer(serializers.ModelSerializer):
    class Meta:
        model = RideTracking
        fields = ['id', 'ride', 'latitude', 'longitude', 'timestamp']
        read_only_fields = ['id', 'timestamp']


class SOSAlertSerializer(serializers.ModelSerializer):
    triggered_by_details = UserSerializer(source='triggered_by', read_only=True)
    resolved_by_details = UserSerializer(source='resolved_by', read_only=True)
    
    class Meta:
        model = SOSAlert
        fields = [
            'id', 'ride', 'triggered_by', 'triggered_by_details',
            'latitude', 'longitude', 'status', 'message',
            'resolved_by', 'resolved_by_details', 'created_at', 'resolved_at'
        ]
        read_only_fields = ['id', 'triggered_by', 'created_at']


class ChatMessageSerializer(serializers.ModelSerializer):
    sender_details = UserSerializer(source='sender', read_only=True)
    
    class Meta:
        model = ChatMessage
        fields = [
            'id', 'ride', 'sender', 'sender_details',
            'message', 'timestamp', 'is_read'
        ]
        read_only_fields = ['id', 'sender', 'timestamp']


class FeedbackSerializer(serializers.ModelSerializer):
    from_user_details = UserSerializer(source='from_user', read_only=True)
    to_user_details = UserSerializer(source='to_user', read_only=True)
    
    class Meta:
        model = Feedback
        fields = [
            'id', 'ride', 'from_user', 'from_user_details',
            'to_user', 'to_user_details', 'rating', 'comment', 'created_at'
        ]
        read_only_fields = ['id', 'from_user', 'created_at']

    def validate_rating(self, value):
        if value < 1 or value > 5:
            raise serializers.ValidationError("Rating must be between 1 and 5")
        return value


class ComplaintSerializer(serializers.ModelSerializer):
    complainant_details = UserSerializer(source='complainant', read_only=True)
    against_user_details = UserSerializer(source='against_user', read_only=True)
    
    class Meta:
        model = Complaint
        fields = [
            'id', 'ride', 'complainant', 'complainant_details',
            'against_user', 'against_user_details', 'title', 'description',
            'status', 'admin_notes', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'complainant', 'created_at', 'updated_at']
