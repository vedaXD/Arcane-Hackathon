from django.contrib import admin
from .models import SustainabilityMetrics, CarbonEmissionFactor


@admin.register(SustainabilityMetrics)
class SustainabilityMetricsAdmin(admin.ModelAdmin):
    list_display = ['user', 'organization', 'total_rides', 'total_co2_saved', 'last_updated']
    search_fields = ['user__username', 'organization__name']
    list_filter = ['last_updated']


@admin.register(CarbonEmissionFactor)
class CarbonEmissionFactorAdmin(admin.ModelAdmin):
    list_display = ['fuel_type', 'emission_factor', 'created_at', 'updated_at']
    search_fields = ['fuel_type', 'description']
    list_filter = ['fuel_type', 'created_at']
