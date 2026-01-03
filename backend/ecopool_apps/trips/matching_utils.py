"""
Utility functions for trip matching algorithm
"""
from geopy.distance import geodesic
from decimal import Decimal


def calculate_distance(lat1, lon1, lat2, lon2):
    """Calculate distance between two coordinates in kilometers"""
    return geodesic((lat1, lon1), (lat2, lon2)).kilometers


def check_route_overlap(trip_start, trip_end, search_start, search_end, max_deviation_km=5):
    """
    Check if two routes overlap within acceptable deviation
    Returns tuple: (bool: is_match, float: overlap_percentage)
    """
    # Calculate distances
    start_distance = calculate_distance(
        float(trip_start['lat']), float(trip_start['lon']),
        float(search_start['lat']), float(search_start['lon'])
    )
    
    end_distance = calculate_distance(
        float(trip_end['lat']), float(trip_end['lon']),
        float(search_end['lat']), float(search_end['lon'])
    )
    
    # Check if both start and end points are within acceptable range
    if start_distance <= max_deviation_km and end_distance <= max_deviation_km:
        # Calculate overlap percentage (simple approximation)
        total_route_distance = calculate_distance(
            float(search_start['lat']), float(search_start['lon']),
            float(search_end['lat']), float(search_end['lon'])
        )
        
        deviation = start_distance + end_distance
        if total_route_distance > 0:
            overlap = max(0, 100 - (deviation / total_route_distance * 100))
        else:
            overlap = 100
            
        return True, overlap
    
    return False, 0


def match_trips(search_params, available_trips, user):
    """
    Main matching algorithm
    Filters trips based on:
    - Organization
    - Gender preference
    - Route overlap
    - Available seats
    - Departure time
    """
    matched_trips = []
    
    search_start = {
        'lat': search_params.get('start_latitude'),
        'lon': search_params.get('start_longitude')
    }
    search_end = {
        'lat': search_params.get('end_latitude'),
        'lon': search_params.get('end_longitude')
    }
    max_distance = float(search_params.get('max_distance_km', 5.0))
    seats_needed = search_params.get('seats_needed', 1)
    
    for trip in available_trips:
        # Filter by organization
        if trip.driver.organization != user.organization:
            continue
        
        # Filter by gender preference
        if trip.gender_preference != 'any':
            if user.gender and trip.gender_preference.lower() != user.gender.lower():
                continue
        
        # Filter by available seats
        if trip.available_seats < seats_needed:
            continue
        
        # Check route overlap
        trip_start = {
            'lat': trip.start_latitude,
            'lon': trip.start_longitude
        }
        trip_end = {
            'lat': trip.end_latitude,
            'lon': trip.end_longitude
        }
        
        is_match, overlap_pct = check_route_overlap(
            trip_start, trip_end,
            search_start, search_end,
            max_distance
        )
        
        if is_match:
            # Add match score
            trip.match_score = overlap_pct
            matched_trips.append(trip)
    
    # Sort by match score (highest first)
    matched_trips.sort(key=lambda x: x.match_score, reverse=True)
    
    return matched_trips
