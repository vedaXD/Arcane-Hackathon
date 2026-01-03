from django.contrib.auth.models import AbstractUser
from django.db import models


class Organization(models.Model):
    """Organization model for company/institution"""
    name = models.CharField(max_length=255)
    domain = models.CharField(max_length=255, unique=True)  # e.g., company.com
    address = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class User(AbstractUser):
    """Extended User model with EcoPool specific fields"""
    ROLE_CHOICES = [
        ('driver', 'Driver'),
        ('passenger', 'Passenger'),
        ('admin', 'Admin'),
    ]
    
    GENDER_CHOICES = [
        ('male', 'Male'),
        ('female', 'Female'),
        ('other', 'Other'),
        ('prefer_not_to_say', 'Prefer not to say'),
    ]

    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='users', null=True, blank=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='passenger')
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    gender = models.CharField(max_length=20, choices=GENDER_CHOICES, blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profiles/', blank=True, null=True)
    face_id_data = models.TextField(blank=True, null=True)  # Stores face recognition data
    trust_score = models.DecimalField(max_digits=3, decimal_places=2, default=5.0)
    total_rides = models.IntegerField(default=0)
    total_co2_saved = models.DecimalField(max_digits=10, decimal_places=2, default=0)  # in kg
    reward_points = models.IntegerField(default=0)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.username} - {self.role}"


class Vehicle(models.Model):
    """Vehicle model for drivers"""
    FUEL_TYPE_CHOICES = [
        ('petrol', 'Petrol'),
        ('diesel', 'Diesel'),
        ('electric', 'Electric'),
        ('hybrid', 'Hybrid'),
    ]

    driver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='vehicles')
    vehicle_type = models.CharField(max_length=50)  # e.g., Sedan, SUV, Hatchback
    model = models.CharField(max_length=100)
    registration_number = models.CharField(max_length=20, unique=True)
    fuel_type = models.CharField(max_length=20, choices=FUEL_TYPE_CHOICES)
    capacity = models.IntegerField()  # Number of passengers
    color = models.CharField(max_length=30)
    year = models.IntegerField()
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.model} - {self.registration_number}"
