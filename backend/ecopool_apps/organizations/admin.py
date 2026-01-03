from django.contrib import admin
from .models import Organization, OrganizationMember, OrganizationRoute


@admin.register(Organization)
class OrganizationAdmin(admin.ModelAdmin):
    list_display = ['name', 'organization_type', 'is_verified', 'admin', 'created_at']
    list_filter = ['organization_type', 'is_verified']
    search_fields = ['name', 'contact_email']


@admin.register(OrganizationMember)
class OrganizationMemberAdmin(admin.ModelAdmin):
    list_display = ['user', 'organization', 'employee_id', 'department', 'is_active']
    list_filter = ['organization', 'is_active']
    search_fields = ['user__username', 'employee_id']


@admin.register(OrganizationRoute)
class OrganizationRouteAdmin(admin.ModelAdmin):
    list_display = ['name', 'organization', 'origin_name', 'destination_name', 'usage_count', 'is_active']
    list_filter = ['organization', 'is_active']
    search_fields = ['name', 'origin_name', 'destination_name']
