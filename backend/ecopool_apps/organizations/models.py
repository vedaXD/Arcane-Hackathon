from django.db import models
from ecopool_apps.authentication.models import User


class Organization(models.Model):
    """Organization model for companies, schools, etc."""
    name = models.CharField(max_length=255)
    organization_type = models.CharField(max_length=50, choices=[
        ('company', 'Company'),
        ('school', 'School/College'),
        ('hospital', 'Hospital'),
        ('government', 'Government Office'),
        ('other', 'Other'),
    ])
    address = models.TextField()
    latitude = models.DecimalField(max_digits=10, decimal_places=7)
    longitude = models.DecimalField(max_digits=10, decimal_places=7)
    contact_email = models.EmailField()
    contact_phone = models.CharField(max_length=20)
    admin = models.ForeignKey(User, on_delete=models.CASCADE, related_name='managed_organizations')
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class OrganizationMember(models.Model):
    """Members of organizations"""
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='members')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='organizations')
    employee_id = models.CharField(max_length=100, blank=True, null=True)
    department = models.CharField(max_length=100, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    joined_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ['organization', 'user']

    def __str__(self):
        return f"{self.user.username} - {self.organization.name}"


class OrganizationRoute(models.Model):
    """Preset routes for organizations (e.g., common commute paths)"""
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='preset_routes')
    name = models.CharField(max_length=255, help_text="e.g., 'Home to Office Morning Route'")
    
    # Origin details
    origin_name = models.CharField(max_length=255)
    origin_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    origin_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    
    # Destination details
    destination_name = models.CharField(max_length=255)
    destination_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    destination_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    
    # Route metadata
    estimated_distance = models.DecimalField(max_digits=8, decimal_places=2, help_text="Distance in km")
    estimated_duration = models.IntegerField(help_text="Duration in minutes")
    is_active = models.BooleanField(default=True)
    usage_count = models.IntegerField(default=0)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_routes')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.organization.name} - {self.name}"

    def get_reversed_route(self):
        """Return route data with origin and destination swapped"""
        return {
            'name': f"{self.name} (Return)",
            'origin_name': self.destination_name,
            'origin_latitude': self.destination_latitude,
            'origin_longitude': self.destination_longitude,
            'destination_name': self.origin_name,
            'destination_latitude': self.origin_latitude,
            'destination_longitude': self.origin_longitude,
            'estimated_distance': self.estimated_distance,
            'estimated_duration': self.estimated_duration,
        }
