from django.core.management.base import BaseCommand
from ecopool_apps.sustainability.models import CarbonEmissionFactor


class Command(BaseCommand):
    help = 'Populate initial carbon emission factors for different fuel types'

    def handle(self, *args, **options):
        """
        Create default carbon emission factors
        Source: EPA and international carbon emission standards
        """
        
        emission_factors = [
            {
                'fuel_type': 'petrol',
                'vehicle_type': 'car',
                'co2_per_liter': 2.31,  # kg CO2 per liter
                'description': 'Standard petrol/gasoline car'
            },
            {
                'fuel_type': 'diesel',
                'vehicle_type': 'car',
                'co2_per_liter': 2.68,  # kg CO2 per liter
                'description': 'Standard diesel car'
            },
            {
                'fuel_type': 'cng',
                'vehicle_type': 'car',
                'co2_per_liter': 1.94,  # kg CO2 per liter equivalent
                'description': 'Compressed Natural Gas (CNG) car'
            },
            {
                'fuel_type': 'electric',
                'vehicle_type': 'car',
                'co2_per_liter': 0.45,  # kg CO2 per kWh (grid mix dependent)
                'description': 'Electric vehicle (average grid mix)'
            },
            {
                'fuel_type': 'hybrid',
                'vehicle_type': 'car',
                'co2_per_liter': 1.85,  # kg CO2 per liter
                'description': 'Hybrid petrol-electric car'
            },
            {
                'fuel_type': 'petrol',
                'vehicle_type': 'motorcycle',
                'co2_per_liter': 2.31,
                'description': 'Standard petrol motorcycle'
            },
            {
                'fuel_type': 'petrol',
                'vehicle_type': 'suv',
                'co2_per_liter': 2.65,
                'description': 'Large SUV or truck'
            },
        ]
        
        created_count = 0
        updated_count = 0
        
        for factor_data in emission_factors:
            factor, created = CarbonEmissionFactor.objects.update_or_create(
                fuel_type=factor_data['fuel_type'],
                vehicle_type=factor_data['vehicle_type'],
                defaults={
                    'co2_per_liter': factor_data['co2_per_liter'],
                    'description': factor_data['description'],
                    'is_active': True
                }
            )
            
            if created:
                created_count += 1
                self.stdout.write(
                    self.style.SUCCESS(
                        f'✓ Created: {factor.vehicle_type} ({factor.fuel_type})'
                    )
                )
            else:
                updated_count += 1
                self.stdout.write(
                    self.style.WARNING(
                        f'↻ Updated: {factor.vehicle_type} ({factor.fuel_type})'
                    )
                )
        
        self.stdout.write(
            self.style.SUCCESS(
                f'\n✅ Complete! Created {created_count}, Updated {updated_count} emission factors'
            )
        )
