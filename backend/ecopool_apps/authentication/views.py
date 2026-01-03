from rest_framework import viewsets, status, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from .models import User, Organization, Vehicle
from .serializers import (
    UserSerializer, OrganizationSerializer, VehicleSerializer,
    UserRegistrationSerializer, UserProfileUpdateSerializer
)


class RegisterView(generics.CreateAPIView):
    """User registration endpoint"""
    permission_classes = [AllowAny]
    serializer_class = UserRegistrationSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    """User login endpoint"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        
        if not username or not password:
            return Response(
                {'error': 'Please provide both username and password'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        user = authenticate(username=username, password=password)
        
        if user is None:
            return Response(
                {'error': 'Invalid credentials'},
                status=status.HTTP_401_UNAUTHORIZED
            )
        
        if not user.is_active:
            return Response(
                {'error': 'User account is disabled'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        })


class LogoutView(APIView):
    """User logout endpoint"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh_token')
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Successfully logged out'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class ProfileView(APIView):
    """Get current user profile"""
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)


class ProfileUpdateView(APIView):
    """Update current user profile"""
    permission_classes = [IsAuthenticated]
    
    def patch(self, request):
        serializer = UserProfileUpdateSerializer(
            request.user,
            data=request.data,
            partial=True
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        
        return Response(UserSerializer(request.user).data)


class FaceAuthRegisterView(APIView):
    """Register face authentication data"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        face_data = request.data.get('face_data')
        
        if not face_data:
            return Response(
                {'error': 'Face data is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Store face authentication data
        request.user.face_id_data = face_data
        request.user.save()
        
        return Response({'message': 'Face authentication registered successfully'})


class FaceAuthLoginView(APIView):
    """Login using face authentication"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        user_id = request.data.get('user_id')
        face_data = request.data.get('face_data')
        
        if not user_id or not face_data:
            return Response(
                {'error': 'User ID and face data are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {'error': 'User not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # TODO: Implement actual face recognition comparison
        # For now, simple comparison
        if user.face_id_data and user.face_id_data == face_data:
            refresh = RefreshToken.for_user(user)
            
            return Response({
                'user': UserSerializer(user).data,
                'tokens': {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }
            })
        
        return Response(
            {'error': 'Face authentication failed'},
            status=status.HTTP_401_UNAUTHORIZED
        )


class OrganizationViewSet(viewsets.ModelViewSet):
    queryset = Organization.objects.all()
    serializer_class = OrganizationSerializer
    permission_classes = [IsAuthenticated]


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['get'])
    def me(self, request):
        """Get current user profile"""
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def verify_face(self, request, pk=None):
        """Verify face authentication"""
        # Implement face verification logic here
        return Response({'status': 'Face verification successful'})


class VehicleViewSet(viewsets.ModelViewSet):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Filter vehicles by current user if they are a driver"""
        if self.request.user.role == 'driver':
            return self.queryset.filter(driver=self.request.user)
        return self.queryset
    
    def perform_create(self, serializer):
        """Auto-assign driver when creating vehicle"""
        serializer.save(driver=self.request.user)
