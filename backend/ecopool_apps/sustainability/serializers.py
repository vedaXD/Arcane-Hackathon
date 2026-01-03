from rest_framework import serializers
from .models import SustainabilityMetrics, CarbonEmissionFactor


class SustainabilityMetricsSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    organization_name = serializers.CharField(source='organization.name', read_only=True)
    
    class Meta:
        model = SustainabilityMetrics
        fields = [
            'id', 'user', 'user_name', 'organization', 'organization_name',
            'total_rides', 'total_distance', 'total_co2_saved',
            'trees_equivalent', 'last_updated'
        ]
        read_only_fields = ['id', 'trees_equivalent', 'last_updated']


class CarbonEmissionFactorSerializer(serializers.ModelSerializer):
    class Meta:
        model = CarbonEmissionFactor
        fields = ['id', 'fuel_type', 'emission_factor', 'description', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']
