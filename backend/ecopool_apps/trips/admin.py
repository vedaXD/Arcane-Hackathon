from django.contrib import admin
from .models import Trip, TripRequest


@admin.register(Trip)
class TripAdmin(admin.ModelAdmin):
    list_display = ['driver', 'start_location', 'end_location', 'departure_time', 'available_seats', 'status']
    search_fields = ['driver__username', 'start_location', 'end_location']
    list_filter = ['status', 'gender_preference', 'departure_time']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(TripRequest)
class TripRequestAdmin(admin.ModelAdmin):
    list_display = ['trip', 'passenger', 'status', 'created_at']
    search_fields = ['trip__origin_name', 'passenger__username']
    list_filter = ['status', 'created_at']
