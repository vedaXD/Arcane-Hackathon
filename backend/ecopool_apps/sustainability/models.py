from django.db import models
from ecopool_apps.authentication.models import User, Organization


class SustainabilityMetrics(models.Model):
    """Track overall sustainability metrics"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='sustainability_metrics', null=True, blank=True)
    organization = models.OneToOneField(Organization, on_delete=models.CASCADE, related_name='sustainability_metrics', null=True, blank=True)
    total_rides = models.IntegerField(default=0)
    total_distance = models.DecimalField(max_digits=12, decimal_places=2, default=0)  # in km
    total_co2_saved = models.DecimalField(max_digits=12, decimal_places=2, default=0)  # in kg
    trees_equivalent = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    last_updated = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = "Sustainability Metrics"
        verbose_name_plural = "Sustainability Metrics"

    def calculate_trees_equivalent(self):
        """Calculate trees equivalent based on CO2 saved"""
        # 1 tree absorbs approximately 21.77 kg of CO2 per year
        if self.total_co2_saved > 0:
            self.trees_equivalent = self.total_co2_saved / 21.77
            self.save()

    def __str__(self):
        if self.user:
            return f"Metrics for {self.user.username}"
        return f"Metrics for {self.organization.name}"


class CarbonEmissionFactor(models.Model):
    """Emission factors for different vehicle types"""
    FUEL_TYPE_CHOICES = [
        ('petrol', 'Petrol'),
        ('diesel', 'Diesel'),
        ('electric', 'Electric'),
        ('hybrid', 'Hybrid'),
    ]

    fuel_type = models.CharField(max_length=20, choices=FUEL_TYPE_CHOICES, unique=True)
    emission_factor = models.DecimalField(max_digits=6, decimal_places=4)  # kg CO2 per km
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.fuel_type} - {self.emission_factor} kg CO2/km"
