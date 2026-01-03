from django.contrib import admin
from .models import (
    DiamondWallet, DiamondTransaction, NGOPartner,
    Donation, RedemptionOption, Redemption, ConversionRate
)


@admin.register(DiamondWallet)
class DiamondWalletAdmin(admin.ModelAdmin):
    list_display = ['user', 'balance', 'lifetime_earned', 'lifetime_redeemed', 'updated_at']
    search_fields = ['user__email']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(DiamondTransaction)
class DiamondTransactionAdmin(admin.ModelAdmin):
    list_display = ['wallet', 'transaction_type', 'amount', 'co2_saved', 'distance_km', 'created_at']
    list_filter = ['transaction_type', 'created_at']
    search_fields = ['wallet__user__email', 'description']
    readonly_fields = ['created_at']


@admin.register(NGOPartner)
class NGOPartnerAdmin(admin.ModelAdmin):
    list_display = ['name', 'focus_area', 'verified', 'active', 'trees_planted', 'co2_offset_kg']
    list_filter = ['verified', 'active', 'focus_area']
    search_fields = ['name', 'description']


@admin.register(Donation)
class DonationAdmin(admin.ModelAdmin):
    list_display = ['user', 'ngo', 'amount', 'diamonds_earned', 'co2_equivalent', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['user__email', 'ngo__name']


@admin.register(RedemptionOption)
class RedemptionOptionAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'diamond_cost', 'value', 'stock_available', 'featured', 'active']
    list_filter = ['category', 'featured', 'active']
    search_fields = ['title', 'partner_name']


@admin.register(Redemption)
class RedemptionAdmin(admin.ModelAdmin):
    list_display = ['user', 'option', 'diamonds_spent', 'status', 'voucher_code', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['user__email', 'voucher_code']


@admin.register(ConversionRate)
class ConversionRateAdmin(admin.ModelAdmin):
    list_display = ['name', 'rate', 'active', 'updated_at']
    list_filter = ['active']
    search_fields = ['name']
