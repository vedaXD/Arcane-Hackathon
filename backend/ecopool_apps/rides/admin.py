from django.contrib import admin
from .models import Ride, RideTracking, SOSAlert, ChatMessage, Feedback, Complaint


@admin.register(Ride)
class RideAdmin(admin.ModelAdmin):
    list_display = ['trip', 'driver', 'status', 'start_time']
    search_fields = ['driver__username']
    list_filter = ['status', 'created_at']


@admin.register(RideTracking)
class RideTrackingAdmin(admin.ModelAdmin):
    list_display = ['ride', 'timestamp', 'latitude', 'longitude']
    search_fields = ['ride__driver__username']
    list_filter = ['timestamp']


@admin.register(SOSAlert)
class SOSAlertAdmin(admin.ModelAdmin):
    list_display = ['ride', 'triggered_by', 'status', 'created_at']
    search_fields = ['triggered_by__username', 'ride__driver__username']
    list_filter = ['status', 'created_at']


@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ['ride', 'sender', 'message', 'timestamp']
    search_fields = ['sender__username', 'message']
    list_filter = ['timestamp']


@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ['ride', 'from_user', 'to_user', 'rating', 'created_at']
    search_fields = ['from_user__username', 'to_user__username']
    list_filter = ['rating', 'created_at']


@admin.register(Complaint)
class ComplaintAdmin(admin.ModelAdmin):
    list_display = ['ride', 'complainant', 'against_user', 'status', 'created_at']
    search_fields = ['complainant__username', 'against_user__username']
    list_filter = ['status', 'created_at']
