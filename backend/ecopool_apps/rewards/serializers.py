from rest_framework import serializers
from .models import (
    DiamondWallet, DiamondTransaction, NGOPartner, 
    Donation, RedemptionOption, Redemption, ConversionRate
)


class DiamondWalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiamondWallet
        fields = ['balance', 'lifetime_earned', 'lifetime_redeemed', 'updated_at']


class DiamondTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiamondTransaction
        fields = [
            'id', 'transaction_type', 'amount', 'co2_saved', 
            'distance_km', 'description', 'created_at'
        ]


class NGOPartnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = NGOPartner
        fields = [
            'id', 'name', 'description', 'logo_url', 'focus_area',
            'website', 'verified', 'trees_planted', 'co2_offset_kg'
        ]


class DonationSerializer(serializers.ModelSerializer):
    ngo_name = serializers.CharField(source='ngo.name', read_only=True)
    
    class Meta:
        model = Donation
        fields = [
            'id', 'ngo', 'ngo_name', 'amount', 'diamonds_earned',
            'co2_equivalent', 'status', 'created_at'
        ]
        read_only_fields = ['diamonds_earned', 'co2_equivalent', 'status']


class RedemptionOptionSerializer(serializers.ModelSerializer):
    savings_percentage = serializers.SerializerMethodField()
    
    class Meta:
        model = RedemptionOption
        fields = [
            'id', 'title', 'description', 'category', 'diamond_cost',
            'value', 'partner_name', 'partner_logo', 'image_url',
            'validity_days', 'stock_available', 'featured', 'savings_percentage'
        ]
    
    def get_savings_percentage(self, obj):
        # Assuming 1 diamond = ₹1 for calculation
        if obj.value > 0:
            savings = ((obj.value - float(obj.diamond_cost)) / obj.value) * 100
            return round(savings, 1)
        return 0


class RedemptionSerializer(serializers.ModelSerializer):
    option_title = serializers.CharField(source='option.title', read_only=True)
    option_category = serializers.CharField(source='option.category', read_only=True)
    
    class Meta:
        model = Redemption
        fields = [
            'id', 'option', 'option_title', 'option_category',
            'diamonds_spent', 'status', 'voucher_code',
            'expires_at', 'created_at'
        ]
        read_only_fields = ['diamonds_spent', 'voucher_code', 'expires_at']


class DashboardSerializer(serializers.Serializer):
    """Complete dashboard data"""
    wallet = DiamondWalletSerializer()
    recent_transactions = DiamondTransactionSerializer(many=True)
    total_co2_saved = serializers.DecimalField(max_digits=10, decimal_places=2)
    total_distance_km = serializers.DecimalField(max_digits=10, decimal_places=2)
    total_donations = serializers.DecimalField(max_digits=10, decimal_places=2)
    rank = serializers.IntegerField()
    level = serializers.CharField()
