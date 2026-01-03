from rest_framework.routers import DefaultRouter
from .views import OrganizationViewSet, OrganizationMemberViewSet, OrganizationRouteViewSet

router = DefaultRouter()
router.register(r'organizations', OrganizationViewSet, basename='organization')
router.register(r'members', OrganizationMemberViewSet, basename='organization-member')
router.register(r'routes', OrganizationRouteViewSet, basename='organization-route')

urlpatterns = router.urls
