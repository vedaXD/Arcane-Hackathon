from django.db import models
from ecopool_apps.authentication.models import User, Vehicle


class Trip(models.Model):
    """Trip model for ride listings"""
    STATUS_CHOICES = [
        ('scheduled', 'Scheduled'),
        ('active', 'Active'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    ]
    
    GENDER_PREF_CHOICES = [
        ('any', 'Any'),
        ('male', 'Male Only'),
        ('female', 'Female Only'),
    ]
    
    TRIP_TYPE_CHOICES = [
        ('offering', 'Offering Ride'),  # Has vehicle, offering seats
        ('seeking', 'Seeking Ride'),    # No vehicle, looking for ride-mates for auto/public transport
    ]
    
    TRANSPORT_MODE_CHOICES = [
        ('car', 'Car'),
        ('bike', 'Bike'),
        ('auto', 'Auto Rickshaw'),
        ('public', 'Public Transport'),
        ('any', 'Any Mode'),
    ]

    driver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='driver_trips')
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE, related_name='trips', null=True, blank=True)
    trip_type = models.CharField(max_length=20, choices=TRIP_TYPE_CHOICES, default='offering')
    transport_mode = models.CharField(max_length=20, choices=TRANSPORT_MODE_CHOICES, default='car')
    start_location = models.CharField(max_length=255)
    start_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    start_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    end_location = models.CharField(max_length=255)
    end_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    end_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    departure_time = models.DateTimeField()
    available_seats = models.IntegerField()
    gender_preference = models.CharField(max_length=10, choices=GENDER_PREF_CHOICES, default='any')
    price_per_seat = models.DecimalField(max_digits=8, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.start_location} to {self.end_location} - {self.driver.username}"


class TripRequest(models.Model):
    """Trip request from passengers"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
        ('cancelled', 'Cancelled'),
    ]

    trip = models.ForeignKey(Trip, on_delete=models.CASCADE, related_name='requests')
    passenger = models.ForeignKey(User, on_delete=models.CASCADE, related_name='trip_requests')
    seats_requested = models.IntegerField(default=1)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    message = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.passenger.username} - {self.trip}"
