import requests
from typing import Dict, Optional, List
from config import config

class DjangoAPIClient:
    """Client to interact with Django backend APIs"""
    
    def __init__(self):
        self.base_url = config.DJANGO_API_URL
        self.session = requests.Session()
    
    def set_auth_token(self, token: str):
        """Set authentication token for API requests"""
        self.session.headers.update({
            'Authorization': f'Bearer {token}'
        })
    
    def login(self, email: str, password: str) -> Dict:
        """Login user and get auth token"""
        response = self.session.post(
            config.ENDPOINTS['login'],
            json={'email': email, 'password': password}
        )
        return response.json()
    
    def register(self, user_data: Dict) -> Dict:
        """Register new user"""
        response = self.session.post(
            config.ENDPOINTS['register'],
            json=user_data
        )
        return response.json()
    
    def search_rides(self, pickup: str, dropoff: str, date: str, seats: int = 1) -> List[Dict]:
        """Search available carpools"""
        response = self.session.get(
            config.ENDPOINTS['search_rides'],
            params={
                'pickup': pickup,
                'dropoff': dropoff,
                'date': date,
                'seats_needed': seats
            }
        )
        return response.json()
    
    def offer_ride(self, ride_data: Dict) -> Dict:
        """Create new carpool offer"""
        response = self.session.post(
            config.ENDPOINTS['offer_ride'],
            json=ride_data
        )
        return response.json()
    
    def get_my_carpools(self) -> List[Dict]:
        """Get user's active carpools"""
        response = self.session.get(config.ENDPOINTS['my_carpools'])
        return response.json()
    
    def get_rewards(self) -> Dict:
        """Get user's rewards and points"""
        response = self.session.get(config.ENDPOINTS['rewards'])
        return response.json()
    
    def get_carbon_stats(self) -> Dict:
        """Get user's carbon savings statistics"""
        response = self.session.get(config.ENDPOINTS['carbon_stats'])
        return response.json()
    
    def get_popular_locations(self) -> List[Dict]:
        """Get list of popular pickup/drop locations"""
        response = self.session.get(config.ENDPOINTS['popular_locations'])
        return response.json()

api_client = DjangoAPIClient()
