"""
Main URL configuration for RouteOpt Backend API
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
# from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

# Import viewsets
from ecopool_apps.authentication import views as auth_views
from ecopool_apps.trips import views as trip_views
from ecopool_apps.rides import views as ride_views
from ecopool_apps.payments import views as payment_views
from ecopool_apps.sustainability import views as sustainability_views

# Create router
router = DefaultRouter()

# Authentication routes
router.register(r'users', auth_views.UserViewSet, basename='user')
router.register(r'organizations', auth_views.OrganizationViewSet, basename='organization')
router.register(r'vehicles', auth_views.VehicleViewSet, basename='vehicle')

# Trip routes
router.register(r'trips', trip_views.TripViewSet, basename='trip')
router.register(r'trip-requests', trip_views.TripRequestViewSet, basename='trip-request')

# Ride routes
router.register(r'rides', ride_views.RideViewSet, basename='ride')
router.register(r'sos-alerts', ride_views.SOSAlertViewSet, basename='sos-alert')
router.register(r'chat-messages', ride_views.ChatMessageViewSet, basename='chat-message')
router.register(r'feedback', ride_views.FeedbackViewSet, basename='feedback')
router.register(r'complaints', ride_views.ComplaintViewSet, basename='complaint')

# Payment routes
router.register(r'payments', payment_views.PaymentViewSet, basename='payment')
router.register(r'rewards', payment_views.RewardTransactionViewSet, basename='reward')

# Sustainability routes
router.register(r'sustainability-metrics', sustainability_views.SustainabilityMetricsViewSet, basename='sustainability-metrics')
router.register(r'carbon-factors', sustainability_views.CarbonEmissionFactorViewSet, basename='carbon-factor')

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # API Documentation (commented out - install drf-spectacular to enable)
    # path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    # path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    
    # Authentication endpoints
    path('api/auth/', include('ecopool_apps.authentication.urls')),
    
    # Main API routes
    path('api/', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
