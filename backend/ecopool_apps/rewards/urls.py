from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    DiamondWalletViewSet, DiamondTransactionViewSet,
    NGOPartnerViewSet, DonationViewSet,
    RedemptionOptionViewSet, RedemptionViewSet
)

router = DefaultRouter()
router.register(r'wallet', DiamondWalletViewSet, basename='diamond-wallet')
router.register(r'transactions', DiamondTransactionViewSet, basename='diamond-transactions')
router.register(r'ngos', NGOPartnerViewSet, basename='ngo-partners')
router.register(r'donations', DonationViewSet, basename='donations')
router.register(r'redemptions/options', RedemptionOptionViewSet, basename='redemption-options')
router.register(r'redemptions', RedemptionViewSet, basename='redemptions')

urlpatterns = [
    path('', include(router.urls)),
]
