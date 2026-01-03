"""Quick setup script for development"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'routeopt_backend.settings')
django.setup()

from ecopool_apps.authentication.models import User, Organization

# Create test organization
org, _ = Organization.objects.get_or_create(
    domain='test.edu',
    defaults={'name': 'Test University', 'address': '123 Campus Drive'}
)

# Create superuser
if not User.objects.filter(username='admin').exists():
    admin = User.objects.create_superuser(
        username='admin',
        email='admin@test.com',
        password='admin',
        first_name='Admin',
        last_name='User',
        organization=org
    )
    print('✅ Superuser created: admin/admin')

print('✅ Database setup complete!')
print('✅ Backend ready at: http://localhost:8000')
print('✅ Admin panel: http://localhost:8000/admin (admin/admin)')
print('✅ API: http://localhost:8000/api/')
