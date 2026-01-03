from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db import models
from .models import Organization, OrganizationMember, OrganizationRoute
from .serializers import (OrganizationSerializer, OrganizationMemberSerializer,
                          OrganizationRouteSerializer, RouteReverseSerializer)


class OrganizationViewSet(viewsets.ModelViewSet):
    """ViewSet for managing organizations"""
    queryset = Organization.objects.all()
    serializer_class = OrganizationSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(admin=self.request.user)
    
    @action(detail=True, methods=['get'])
    def routes(self, request, pk=None):
        """Get all preset routes for an organization"""
        organization = self.get_object()
        routes = organization.preset_routes.filter(is_active=True)
        serializer = OrganizationRouteSerializer(routes, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['get'])
    def members(self, request, pk=None):
        """Get all members of an organization"""
        organization = self.get_object()
        members = organization.members.filter(is_active=True)
        serializer = OrganizationMemberSerializer(members, many=True)
        return Response(serializer.data)


class OrganizationMemberViewSet(viewsets.ModelViewSet):
    """ViewSet for managing organization memberships"""
    queryset = OrganizationMember.objects.all()
    serializer_class = OrganizationMemberSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Filter to show only user's own memberships or managed orgs"""
        user = self.request.user
        return OrganizationMember.objects.filter(
            models.Q(user=user) | models.Q(organization__admin=user)
        )


class OrganizationRouteViewSet(viewsets.ModelViewSet):
    """ViewSet for managing organization preset routes"""
    queryset = OrganizationRoute.objects.all()
    serializer_class = OrganizationRouteSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Filter routes by organization"""
        queryset = OrganizationRoute.objects.filter(is_active=True)
        org_id = self.request.query_params.get('organization', None)
        if org_id:
            queryset = queryset.filter(organization_id=org_id)
        return queryset

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=['get'])
    def reverse(self, request, pk=None):
        """Get reversed route (swap origin and destination)"""
        route = self.get_object()
        reversed_data = route.get_reversed_route()
        serializer = RouteReverseSerializer(reversed_data)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def use(self, request, pk=None):
        """Increment usage count when route is used"""
        route = self.get_object()
        route.usage_count += 1
        route.save()
        serializer = self.get_serializer(route)
        return Response(serializer.data)
