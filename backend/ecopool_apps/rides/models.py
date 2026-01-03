from django.db import models
from ecopool_apps.authentication.models import User
from ecopool_apps.trips.models import Trip


class Ride(models.Model):
    """Active ride model tracking real-time journey"""
    STATUS_CHOICES = [
        ('started', 'Started'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
        ('emergency', 'Emergency'),
    ]

    trip = models.OneToOneField(Trip, on_delete=models.CASCADE, related_name='ride')
    driver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='driver_rides')
    passengers = models.ManyToManyField(User, related_name='passenger_rides')
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(null=True, blank=True)
    current_latitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    current_longitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='started')
    distance_covered = models.DecimalField(max_digits=8, decimal_places=2, default=0)  # in km
    co2_saved = models.DecimalField(max_digits=8, decimal_places=2, default=0)  # in kg
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Ride {self.id} - {self.trip}"


class RideTracking(models.Model):
    """Real-time location tracking for rides"""
    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='tracking_points')
    latitude = models.DecimalField(max_digits=10, decimal_places=7)
    longitude = models.DecimalField(max_digits=10, decimal_places=7)
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-timestamp']

    def __str__(self):
        return f"Tracking {self.ride.id} at {self.timestamp}"


class SOSAlert(models.Model):
    """Emergency SOS alerts during rides"""
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('resolved', 'Resolved'),
        ('false_alarm', 'False Alarm'),
    ]

    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='sos_alerts')
    triggered_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sos_triggered')
    latitude = models.DecimalField(max_digits=10, decimal_places=7)
    longitude = models.DecimalField(max_digits=10, decimal_places=7)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')
    message = models.TextField(blank=True, null=True)
    resolved_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='sos_resolved')
    created_at = models.DateTimeField(auto_now_add=True)
    resolved_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"SOS {self.id} - Ride {self.ride.id}"


class ChatMessage(models.Model):
    """In-app chat between driver and passengers"""
    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    message = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    class Meta:
        ordering = ['timestamp']

    def __str__(self):
        return f"Message from {self.sender.username} in Ride {self.ride.id}"


class Feedback(models.Model):
    """Post-ride feedback and ratings"""
    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='feedbacks')
    from_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='feedback_given')
    to_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='feedback_received')
    rating = models.IntegerField()  # 1-5 stars
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Feedback from {self.from_user.username} to {self.to_user.username}"


class Complaint(models.Model):
    """Complaint system for reporting issues"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('under_review', 'Under Review'),
        ('resolved', 'Resolved'),
        ('dismissed', 'Dismissed'),
    ]

    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='complaints', null=True, blank=True)
    complainant = models.ForeignKey(User, on_delete=models.CASCADE, related_name='complaints_filed')
    against_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='complaints_received')
    title = models.CharField(max_length=200)
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    admin_notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Complaint {self.id} - {self.title}"
