from rest_framework import serializers
from .models import Organization, OrganizationMember, OrganizationRoute


class OrganizationSerializer(serializers.ModelSerializer):
    member_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Organization
        fields = ['id', 'name', 'organization_type', 'address', 'latitude', 'longitude',
                  'contact_email', 'contact_phone', 'is_verified', 'member_count', 
                  'created_at', 'updated_at']
        read_only_fields = ['is_verified', 'created_at', 'updated_at']
    
    def get_member_count(self, obj):
        return obj.members.filter(is_active=True).count()


class OrganizationMemberSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.username', read_only=True)
    organization_name = serializers.CharField(source='organization.name', read_only=True)
    
    class Meta:
        model = OrganizationMember
        fields = ['id', 'organization', 'organization_name', 'user', 'user_name',
                  'employee_id', 'department', 'is_active', 'joined_at']
        read_only_fields = ['joined_at']


class OrganizationRouteSerializer(serializers.ModelSerializer):
    organization_name = serializers.CharField(source='organization.name', read_only=True)
    created_by_name = serializers.CharField(source='created_by.username', read_only=True)
    
    class Meta:
        model = OrganizationRoute
        fields = ['id', 'organization', 'organization_name', 'name',
                  'origin_name', 'origin_latitude', 'origin_longitude',
                  'destination_name', 'destination_latitude', 'destination_longitude',
                  'estimated_distance', 'estimated_duration', 'is_active', 
                  'usage_count', 'created_by', 'created_by_name',
                  'created_at', 'updated_at']
        read_only_fields = ['usage_count', 'created_at', 'updated_at']


class RouteReverseSerializer(serializers.Serializer):
    """Serializer for reversed route data"""
    name = serializers.CharField()
    origin_name = serializers.CharField()
    origin_latitude = serializers.DecimalField(max_digits=10, decimal_places=7)
    origin_longitude = serializers.DecimalField(max_digits=10, decimal_places=7)
    destination_name = serializers.CharField()
    destination_latitude = serializers.DecimalField(max_digits=10, decimal_places=7)
    destination_longitude = serializers.DecimalField(max_digits=10, decimal_places=7)
    estimated_distance = serializers.DecimalField(max_digits=8, decimal_places=2)
    estimated_duration = serializers.IntegerField()
