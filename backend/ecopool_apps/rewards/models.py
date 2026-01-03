from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class DiamondWallet(models.Model):
    """User's Diamond (Carbon Crystals) wallet"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='diamond_wallet')
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    lifetime_earned = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    lifetime_redeemed = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.user.email} - {self.balance} Diamonds"

    class Meta:
        db_table = 'diamond_wallets'


class DiamondTransaction(models.Model):
    """Transaction history for diamonds"""
    TRANSACTION_TYPES = [
        ('EARN_RIDE', 'Earned from Ride'),
        ('EARN_DONATION', 'Earned from Donation'),
        ('EARN_REFERRAL', 'Earned from Referral'),
        ('EARN_BONUS', 'Bonus Reward'),
        ('REDEEM_DISCOUNT', 'Redeemed for Discount'),
        ('REDEEM_VOUCHER', 'Redeemed for Voucher'),
        ('REDEEM_PRODUCT', 'Redeemed for Product'),
    ]
    
    wallet = models.ForeignKey(DiamondWallet, on_delete=models.CASCADE, related_name='transactions')
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    co2_saved = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    distance_km = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    description = models.TextField()
    reference_id = models.CharField(max_length=100, null=True, blank=True)  # Carpool ID or Redemption ID
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.wallet.user.email} - {self.transaction_type} - {self.amount}"

    class Meta:
        db_table = 'diamond_transactions'
        ordering = ['-created_at']


class NGOPartner(models.Model):
    """NGO partners for donations"""
    name = models.CharField(max_length=200)
    description = models.TextField()
    logo_url = models.URLField(null=True, blank=True)
    focus_area = models.CharField(max_length=100)  # e.g., "Reforestation", "Clean Energy"
    website = models.URLField()
    verified = models.BooleanField(default=False)
    active = models.BooleanField(default=True)
    total_donations_received = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    trees_planted = models.IntegerField(default=0)
    co2_offset_kg = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'ngo_partners'


class Donation(models.Model):
    """User donations to NGO partners"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='donations')
    ngo = models.ForeignKey(NGOPartner, on_delete=models.CASCADE, related_name='donations')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    diamonds_earned = models.DecimalField(max_digits=10, decimal_places=2)
    co2_equivalent = models.DecimalField(max_digits=10, decimal_places=2)
    payment_id = models.CharField(max_length=100)
    status = models.CharField(max_length=20, default='completed')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} donated ₹{self.amount} to {self.ngo.name}"

    class Meta:
        db_table = 'donations'
        ordering = ['-created_at']


class RedemptionOption(models.Model):
    """Available redemption options for diamonds"""
    CATEGORY_CHOICES = [
        ('DISCOUNT', 'Discount Coupon'),
        ('VOUCHER', 'Gift Voucher'),
        ('PRODUCT', 'Physical Product'),
        ('SERVICE', 'Service Benefit'),
    ]
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    diamond_cost = models.DecimalField(max_digits=10, decimal_places=2)
    value = models.DecimalField(max_digits=10, decimal_places=2)  # Actual monetary value
    partner_name = models.CharField(max_length=200)
    partner_logo = models.URLField(null=True, blank=True)
    image_url = models.URLField(null=True, blank=True)
    terms_conditions = models.TextField()
    validity_days = models.IntegerField(default=90)
    stock_available = models.IntegerField(default=100)
    active = models.BooleanField(default=True)
    featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.title} - {self.diamond_cost} Diamonds"

    class Meta:
        db_table = 'redemption_options'
        ordering = ['diamond_cost']


class Redemption(models.Model):
    """User redemptions"""
    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('APPROVED', 'Approved'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='redemptions')
    option = models.ForeignKey(RedemptionOption, on_delete=models.CASCADE, related_name='redemptions')
    diamonds_spent = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    voucher_code = models.CharField(max_length=50, unique=True, null=True, blank=True)
    expires_at = models.DateTimeField(null=True, blank=True)
    redeemed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} redeemed {self.option.title}"

    class Meta:
        db_table = 'redemptions'
        ordering = ['-created_at']


class ConversionRate(models.Model):
    """Conversion rates for diamond economy"""
    name = models.CharField(max_length=100, unique=True)
    rate = models.DecimalField(max_digits=10, decimal_places=4)
    description = models.TextField()
    active = models.BooleanField(default=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name}: {self.rate}"

    class Meta:
        db_table = 'conversion_rates'

    @staticmethod
    def get_rate(name, default=1.0):
        try:
            rate = ConversionRate.objects.get(name=name, active=True)
            return float(rate.rate)
        except ConversionRate.DoesNotExist:
            return default
