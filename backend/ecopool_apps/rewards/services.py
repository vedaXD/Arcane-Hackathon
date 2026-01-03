from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from decimal import Decimal
from datetime import timedelta
from django.utils import timezone
import uuid
from .models import DiamondWallet, DiamondTransaction, Donation, Redemption, ConversionRate

User = get_user_model()


@receiver(post_save, sender=User)
def create_diamond_wallet(sender, instance, created, **kwargs):
    """Create diamond wallet when user is created"""
    if created:
        DiamondWallet.objects.create(user=instance)


class DiamondEconomyService:
    """Service for managing diamond economy"""
    
    @staticmethod
    def calculate_ride_diamonds(co2_saved_kg, distance_km):
        """
        Calculate diamonds earned from a ride
        Formula: (CO2 saved * CO2_rate) + (Distance * Distance_rate)
        """
        co2_rate = ConversionRate.get_rate('CO2_TO_DIAMOND', 10.0)  # 10 diamonds per kg CO2
        distance_rate = ConversionRate.get_rate('KM_TO_DIAMOND', 2.0)  # 2 diamonds per km
        
        co2_diamonds = Decimal(str(co2_saved_kg)) * Decimal(str(co2_rate))
        distance_diamonds = Decimal(str(distance_km)) * Decimal(str(distance_rate))
        
        total = co2_diamonds + distance_diamonds
        return round(total, 2)
    
    @staticmethod
    def calculate_donation_diamonds(donation_amount):
        """
        Calculate diamonds earned from donation
        Formula: Donation amount * Donation_rate
        Also calculate CO2 equivalent
        """
        donation_rate = ConversionRate.get_rate('DONATION_TO_DIAMOND', 5.0)  # 5 diamonds per ₹1
        co2_per_rupee = ConversionRate.get_rate('RUPEE_TO_CO2', 0.1)  # 0.1 kg CO2 per ₹1 donated
        
        diamonds = Decimal(str(donation_amount)) * Decimal(str(donation_rate))
        co2_equivalent = Decimal(str(donation_amount)) * Decimal(str(co2_per_rupee))
        
        return round(diamonds, 2), round(co2_equivalent, 2)
    
    @staticmethod
    def award_ride_diamonds(user, co2_saved_kg, distance_km, carpool_id):
        """Award diamonds after completing a ride"""
        wallet = DiamondWallet.objects.get(user=user)
        diamonds = DiamondEconomyService.calculate_ride_diamonds(co2_saved_kg, distance_km)
        
        # Update wallet
        wallet.balance += diamonds
        wallet.lifetime_earned += diamonds
        wallet.save()
        
        # Create transaction
        DiamondTransaction.objects.create(
            wallet=wallet,
            transaction_type='EARN_RIDE',
            amount=diamonds,
            co2_saved=Decimal(str(co2_saved_kg)),
            distance_km=Decimal(str(distance_km)),
            description=f"Earned from carpool ride - Saved {co2_saved_kg}kg CO₂",
            reference_id=str(carpool_id)
        )
        
        return diamonds
    
    @staticmethod
    def award_donation_diamonds(donation):
        """Award diamonds after donation"""
        wallet = DiamondWallet.objects.get(user=donation.user)
        
        # Update wallet
        wallet.balance += donation.diamonds_earned
        wallet.lifetime_earned += donation.diamonds_earned
        wallet.save()
        
        # Create transaction
        DiamondTransaction.objects.create(
            wallet=wallet,
            transaction_type='EARN_DONATION',
            amount=donation.diamonds_earned,
            co2_saved=donation.co2_equivalent,
            description=f"Earned from donation to {donation.ngo.name} - ₹{donation.amount}",
            reference_id=str(donation.id)
        )
        
        # Update NGO stats
        ngo = donation.ngo
        ngo.total_donations_received += donation.amount
        ngo.co2_offset_kg += donation.co2_equivalent
        ngo.save()
    
    @staticmethod
    def redeem_diamonds(user, redemption_option):
        """Redeem diamonds for rewards"""
        wallet = DiamondWallet.objects.get(user=user)
        
        # Check balance
        if wallet.balance < redemption_option.diamond_cost:
            raise ValueError("Insufficient diamond balance")
        
        # Check stock
        if redemption_option.stock_available <= 0:
            raise ValueError("This reward is out of stock")
        
        # Deduct diamonds
        wallet.balance -= redemption_option.diamond_cost
        wallet.lifetime_redeemed += redemption_option.diamond_cost
        wallet.save()
        
        # Create redemption
        voucher_code = f"EC-{uuid.uuid4().hex[:8].upper()}"
        expires_at = timezone.now() + timedelta(days=redemption_option.validity_days)
        
        redemption = Redemption.objects.create(
            user=user,
            option=redemption_option,
            diamonds_spent=redemption_option.diamond_cost,
            status='APPROVED',
            voucher_code=voucher_code,
            expires_at=expires_at
        )
        
        # Update stock
        redemption_option.stock_available -= 1
        redemption_option.save()
        
        # Create transaction
        DiamondTransaction.objects.create(
            wallet=wallet,
            transaction_type='REDEEM_VOUCHER',
            amount=-redemption_option.diamond_cost,
            description=f"Redeemed: {redemption_option.title}",
            reference_id=str(redemption.id)
        )
        
        return redemption
    
    @staticmethod
    def get_user_level(lifetime_earned):
        """Calculate user level based on lifetime earnings"""
        if lifetime_earned < 100:
            return "Carbon Novice", 1
        elif lifetime_earned < 500:
            return "Eco Warrior", 2
        elif lifetime_earned < 1000:
            return "Green Champion", 3
        elif lifetime_earned < 5000:
            return "Diamond Collector", 4
        else:
            return "Carbon Legend", 5


@receiver(post_save, sender=Donation)
def process_donation(sender, instance, created, **kwargs):
    """Process donation and award diamonds"""
    if created:
        DiamondEconomyService.award_donation_diamonds(instance)
