import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # Telegram Bot Token
    TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
    
    # Django Backend API
    DJANGO_API_URL = os.getenv('DJANGO_API_URL', 'http://localhost:8000/api')
    
    # Google Gemini API Key
    GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
    
    # Bot Configuration
    BOT_USERNAME = os.getenv('BOT_USERNAME')
    ADMIN_USER_IDS = [int(id) for id in os.getenv('ADMIN_USER_IDS', '').split(',') if id]
    
    # API Endpoints
    ENDPOINTS = {
        'login': f'{DJANGO_API_URL}/auth/login/',
        'register': f'{DJANGO_API_URL}/auth/register/',
        'search_rides': f'{DJANGO_API_URL}/rides/search/',
        'offer_ride': f'{DJANGO_API_URL}/rides/offer/',
        'my_carpools': f'{DJANGO_API_URL}/rides/my-carpools/',
        'rewards': f'{DJANGO_API_URL}/rewards/',
        'carbon_stats': f'{DJANGO_API_URL}/sustainability/stats/',
        'popular_locations': f'{DJANGO_API_URL}/rides/popular-locations/',
    }

config = Config()
