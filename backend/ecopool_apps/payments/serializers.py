from rest_framework import serializers
from .models import Payment, RewardTransaction


class PaymentSerializer(serializers.ModelSerializer):
    passenger_name = serializers.CharField(source='passenger.get_full_name', read_only=True)
    driver_name = serializers.CharField(source='driver.get_full_name', read_only=True)
    
    class Meta:
        model = Payment
        fields = [
            'id', 'ride', 'passenger', 'passenger_name', 'driver', 'driver_name',
            'amount', 'payment_method', 'status', 'transaction_id',
            'reward_points_used', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'passenger', 'driver', 'transaction_id', 'created_at', 'updated_at']


class RewardTransactionSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    
    class Meta:
        model = RewardTransaction
        fields = [
            'id', 'user', 'user_name', 'ride', 'transaction_type',
            'points', 'co2_saved', 'description', 'created_at'
        ]
        read_only_fields = ['id', 'user', 'created_at']
