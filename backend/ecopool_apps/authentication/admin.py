from django.contrib import admin
from .models import Organization, User, Vehicle


@admin.register(Organization)
class OrganizationAdmin(admin.ModelAdmin):
    list_display = ['name', 'domain', 'is_active', 'created_at']
    search_fields = ['name', 'domain']
    list_filter = ['is_active', 'created_at']


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['username', 'email', 'role', 'organization', 'trust_score', 'total_rides', 'is_verified']
    search_fields = ['username', 'email', 'first_name', 'last_name']
    list_filter = ['role', 'is_verified', 'gender', 'organization']
    readonly_fields = ['total_rides', 'total_co2_saved', 'reward_points', 'trust_score']


@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = ['driver', 'vehicle_type', 'model', 'registration_number', 'is_verified']
    search_fields = ['registration_number', 'model']
    list_filter = ['vehicle_type', 'fuel_type', 'is_verified']
