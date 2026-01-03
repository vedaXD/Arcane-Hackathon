# EcoPool Backend - Django REST API

Django backend for the EcoPool sustainable car pooling application.

## 🏗️ Project Structure

```
backend/
├── ecopool_apps/
│   ├── authentication/      # User authentication, organizations, vehicles
│   ├── trips/              # Trip creation and management
│   ├── rides/              # Active ride tracking, SOS, chat, feedback
│   ├── payments/           # Payment processing and rewards
│   └── sustainability/     # CO2 tracking and metrics
├── venv/                   # Virtual environment
├── requirements.txt        # Python dependencies
├── .env.example           # Environment variables template
└── manage.py              # Django management script
```

## 🚀 Setup Instructions

### 1. Create Virtual Environment
```bash
python -m venv venv
```

### 2. Activate Virtual Environment
**Windows:**
```bash
.\venv\Scripts\Activate.ps1
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Environment Configuration
```bash
cp .env.example .env
# Edit .env with your actual credentials
```

### 5. Database Setup
```bash
python manage.py makemigrations
python manage.py migrate
```

### 6. Create Superuser
```bash
python manage.py createsuperuser
```

### 7. Run Development Server
```bash
python manage.py runserver
```

The API will be available at `http://localhost:8000/`

## 📡 API Modules

### Authentication (`/api/auth/`)
- User registration and login
- Organization management
- Vehicle registration
- Face authentication
- JWT token management

### Trips (`/api/trips/`)
- Create trip listings
- Search available trips
- Matching algorithm
- Trip requests management

### Rides (`/api/rides/`)
- Start and track active rides
- Real-time GPS tracking
- SOS emergency alerts
- In-app chat
- Post-ride feedback
- Complaint system

### Payments (`/api/payments/`)
- Process payments
- Reward points system
- Transaction history
- Payment status tracking

### Sustainability (`/api/sustainability/`)
- CO2 emission calculations
- User sustainability dashboard
- Organization-wide metrics
- Trees equivalent tracking

## 🔧 Key Features

### Smart Matching Algorithm
```python
# Filters trips based on:
- Organization affiliation
- Route overlap (>70% match)
- Gender preferences
- Available seats
- Departure time proximity
```

### Carbon Calculation
```python
CO₂ saved = Distance (km) × Emission Factor × Passengers Pooled

Emission Factors:
- Petrol: 0.192 kg CO₂/km
- Diesel: 0.171 kg CO₂/km
- Electric: 0.053 kg CO₂/km
- Hybrid: 0.120 kg CO₂/km
```

### Reward System
- Earn points based on CO2 saved
- 1 kg CO₂ saved = 10 reward points
- Redeem points on future rides
- Gamification leaderboards

## 🔐 Authentication

Uses JWT (JSON Web Tokens) with SimpleJWT:

```python
# Login
POST /api/auth/login/
{
  "email": "user@organization.com",
  "password": "password123"
}

# Response
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}

# Use in headers
Authorization: Bearer <access_token>
```

## 🔌 Third-party Integrations

### Google Maps API
- Route calculation
- Distance matrix
- Geocoding
- Real-time navigation

### Stripe Payment
- Secure payment processing
- Refunds handling
- Subscription management

### Twilio (WhatsApp)
- Ride notifications
- OTP verification
- Status updates

### Telegram Bot
- Quick ride searches
- Booking confirmations
- Alerts

## 🧪 Testing

```bash
# Run all tests
pytest

# Run specific app tests
pytest ecopool_apps/authentication/tests/

# With coverage
pytest --cov=ecopool_apps
```

## 📊 Database Models

### Key Models
- **User**: Extended Django user with roles (Driver/Passenger/Admin)
- **Organization**: Company/institution details
- **Vehicle**: Driver vehicle information
- **Trip**: Ride listings
- **Ride**: Active journey tracking
- **Payment**: Transaction records
- **SustainabilityMetrics**: CO2 and environmental impact

## 🔄 Real-time Features

Using Django Channels for WebSocket connections:

```python
# WebSocket connections for:
- Live ride tracking
- Real-time chat
- SOS alerts
- Ride status updates
```

## 🛡️ Security Features

- JWT authentication
- Organization-based access control
- Face recognition integration
- SOS emergency system
- Trust score calculation
- Complaint and dispute resolution

## 📝 API Documentation

Interactive API documentation available at:
- **Swagger UI**: `http://localhost:8000/api/docs/`
- **ReDoc**: `http://localhost:8000/api/redoc/`

## 🌍 Environment Variables

Required in `.env`:

```env
SECRET_KEY=your-secret-key
DEBUG=True
DATABASE_URL=postgresql://user:pass@localhost/db
GOOGLE_MAPS_API_KEY=your-key
STRIPE_SECRET_KEY=your-key
TWILIO_ACCOUNT_SID=your-sid
TELEGRAM_BOT_TOKEN=your-token
```

## 🚀 Deployment

### Using Gunicorn
```bash
gunicorn navibus_backend.wsgi:application --bind 0.0.0.0:8000
```

### Using Docker
```bash
docker-compose up -d
```

## 📦 Dependencies

Key packages:
- Django 5.0+
- Django REST Framework
- SimpleJWT
- Channels (WebSockets)
- Celery (Background tasks)
- Redis (Caching)
- PostgreSQL adapter
- Stripe, Twilio, Google Maps clients

## 🤝 Integration with Flutter App

The Flutter app (`../flutter/`) consumes this API:

```dart
// Example API call from Flutter
final response = await http.get(
  Uri.parse('http://localhost:8000/api/trips/'),
  headers: {'Authorization': 'Bearer $token'},
);
```

## 📞 Support

For API issues or questions, contact the development team.

---

**Built with 💚 for sustainable transportation**
