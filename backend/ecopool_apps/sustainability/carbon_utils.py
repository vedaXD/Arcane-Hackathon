"""
Carbon emission calculation utilities
"""
from decimal import Decimal
from ecopool_apps.sustainability.models import CarbonEmissionFactor


def calculate_co2_saved(distance_km, fuel_type, num_passengers=1):
    """
    Calculate CO2 saved by carpooling
    
    Args:
        distance_km: Distance traveled in kilometers
        fuel_type: Type of fuel used by vehicle
        num_passengers: Number of passengers sharing the ride
    
    Returns:
        Decimal: CO2 saved in kilograms
    """
    try:
        emission_factor = CarbonEmissionFactor.objects.get(fuel_type=fuel_type)
        emission_per_km = emission_factor.emission_factor
    except CarbonEmissionFactor.DoesNotExist:
        # Default emission factors if not in database
        default_factors = {
            'petrol': Decimal('0.21'),
            'diesel': Decimal('0.24'),
            'electric': Decimal('0.05'),
            'hybrid': Decimal('0.12'),
        }
        emission_per_km = default_factors.get(fuel_type, Decimal('0.21'))
    
    # Calculate total emissions if everyone drove alone
    total_emissions_alone = emission_per_km * Decimal(str(distance_km)) * (num_passengers + 1)
    
    # Calculate emissions with carpooling (only driver's car used)
    emissions_carpooling = emission_per_km * Decimal(str(distance_km))
    
    # CO2 saved
    co2_saved = total_emissions_alone - emissions_carpooling
    
    return co2_saved


def calculate_trees_equivalent(co2_kg):
    """
    Calculate trees equivalent based on CO2 saved
    One tree absorbs approximately 21.77 kg of CO2 per year
    """
    TREES_FACTOR = Decimal('21.77')
    return co2_kg / TREES_FACTOR


def calculate_reward_points(co2_saved):
    """
    Calculate reward points based on CO2 saved
    1 kg CO2 = 10 reward points
    """
    POINTS_PER_KG = 10
    return int(co2_saved * POINTS_PER_KG)
