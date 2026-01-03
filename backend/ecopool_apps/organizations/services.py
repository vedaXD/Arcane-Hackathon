"""
Service for automatically assigning users to organizations based on email domain
"""
from django.core.exceptions import ValidationError
from ecopool_apps.organizations.models import Organization, OrganizationMember


class EmailDomainMatchingService:
    """
    Service to match users to organizations based on their email domain
    """
    
    # Predefined domain -> organization mappings
    DOMAIN_MAPPINGS = {
        # Tech Companies
        'techcorp.com': 'Tech Corp',
        'google.com': 'Google India',
        'microsoft.com': 'Microsoft',
        'amazon.in': 'Amazon India',
        'infosys.com': 'Infosys',
        'tcs.com': 'Tata Consultancy Services',
        'wipro.com': 'Wipro',
        
        # Educational Institutions
        'iitb.ac.in': 'IIT Bombay',
        'iitd.ac.in': 'IIT Delhi',
        'iisc.ac.in': 'IISc Bangalore',
        'bits-pilani.ac.in': 'BITS Pilani',
        
        # Healthcare
        'apollohospitals.com': 'Apollo Hospitals',
        'fortishealthcare.com': 'Fortis Healthcare',
        
        # Government
        'nic.in': 'Government of India',
        'gov.in': 'Government Organization',
    }
    
    @classmethod
    def extract_domain(cls, email):
        """Extract domain from email address"""
        try:
            return email.split('@')[1].lower()
        except (IndexError, AttributeError):
            raise ValidationError("Invalid email format")
    
    @classmethod
    def get_organization_name(cls, email):
        """Get organization name from email domain"""
        domain = cls.extract_domain(email)
        return cls.DOMAIN_MAPPINGS.get(domain)
    
    @classmethod
    def auto_assign_to_organization(cls, user):
        """
        Automatically assign user to organization based on email domain
        Returns (organization, created) tuple or (None, False) if no match
        """
        if not user.email:
            return None, False
        
        try:
            domain = cls.extract_domain(user.email)
            org_name = cls.DOMAIN_MAPPINGS.get(domain)
            
            if not org_name:
                return None, False
            
            # Find or create organization
            organization, org_created = Organization.objects.get_or_create(
                name=org_name,
                defaults={
                    'organization_type': cls._get_org_type(domain),
                    'address': f'{org_name} Headquarters',
                    'latitude': 12.9716,  # Default Bangalore coordinates
                    'longitude': 77.5946,
                    'contact_email': f'admin@{domain}',
                    'contact_phone': '+919876543210',
                    'admin': user,  # First user becomes admin
                    'is_verified': cls._is_known_domain(domain),
                }
            )
            
            # Create membership if doesn't exist
            membership, member_created = OrganizationMember.objects.get_or_create(
                organization=organization,
                user=user,
                defaults={
                    'employee_id': cls._generate_employee_id(user),
                    'is_active': True,
                }
            )
            
            return organization, member_created
            
        except ValidationError:
            return None, False
    
    @classmethod
    def _get_org_type(cls, domain):
        """Determine organization type from domain"""
        if any(x in domain for x in ['iit', 'iisc', 'bits', 'edu', 'ac.in']):
            return 'school'
        elif any(x in domain for x in ['hospital', 'healthcare', 'clinic']):
            return 'hospital'
        elif 'gov.in' in domain or 'nic.in' in domain:
            return 'government'
        return 'company'
    
    @classmethod
    def _is_known_domain(cls, domain):
        """Check if domain is in our known list (auto-verify)"""
        return domain in cls.DOMAIN_MAPPINGS
    
    @classmethod
    def _generate_employee_id(cls, user):
        """Generate employee ID from user info"""
        return f"EMP{user.id:06d}"
    
    @classmethod
    def get_organization_for_user(cls, user):
        """Get user's organization based on email domain"""
        try:
            membership = OrganizationMember.objects.filter(
                user=user,
                is_active=True
            ).first()
            return membership.organization if membership else None
        except Exception:
            return None
