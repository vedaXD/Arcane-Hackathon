from django.db import models
from ecopool_apps.authentication.models import User
from ecopool_apps.rides.models import Ride


class Payment(models.Model):
    """Payment transactions"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('processing', 'Processing'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
        ('refunded', 'Refunded'),
    ]

    PAYMENT_METHOD_CHOICES = [
        ('card', 'Credit/Debit Card'),
        ('upi', 'UPI'),
        ('wallet', 'Digital Wallet'),
        ('rewards', 'Reward Points'),
    ]

    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='payments')
    passenger = models.ForeignKey(User, on_delete=models.CASCADE, related_name='payments_made')
    driver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='payments_received')
    amount = models.DecimalField(max_digits=8, decimal_places=2)
    payment_method = models.CharField(max_length=20, choices=PAYMENT_METHOD_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    transaction_id = models.CharField(max_length=100, unique=True, blank=True, null=True)
    reward_points_used = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Payment {self.id} - {self.amount}"


class RewardTransaction(models.Model):
    """Reward points transactions"""
    TRANSACTION_TYPE_CHOICES = [
        ('earned', 'Earned'),
        ('redeemed', 'Redeemed'),
        ('expired', 'Expired'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reward_transactions')
    ride = models.ForeignKey(Ride, on_delete=models.CASCADE, related_name='reward_transactions', null=True, blank=True)
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPE_CHOICES)
    points = models.IntegerField()
    co2_saved = models.DecimalField(max_digits=8, decimal_places=2, default=0)  # in kg
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.transaction_type} - {self.points} points for {self.user.username}"
