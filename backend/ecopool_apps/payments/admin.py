from django.contrib import admin
from .models import Payment, RewardTransaction


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['ride', 'passenger', 'amount', 'payment_method', 'status', 'created_at']
    search_fields = ['passenger__username', 'transaction_id']
    list_filter = ['status', 'payment_method', 'created_at']


@admin.register(RewardTransaction)
class RewardTransactionAdmin(admin.ModelAdmin):
    list_display = ['user', 'points', 'transaction_type', 'created_at']
    search_fields = ['user__username', 'description']
    list_filter = ['transaction_type', 'created_at']
