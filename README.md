# 🌱 EcoPool - Sustainable Organization Car Pooling Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Django-4.2+-092E20?logo=django)](https://www.djangoproject.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue)]()
[![Telegram Bot](https://img.shields.io/badge/Telegram-@RouteOpt__bot-26A5E4?logo=telegram)](https://t.me/RouteOpt_bot)

> **Reducing carbon emissions, one shared ride at a time.**

## 🚀 Live Demo

<div align="center">

### 📱 **[Try the App Live on Appetize →](https://appetize.io/app/b_4ura6dlmgfd5oppvfhxm6twe5e)**

**Experience EcoPool directly in your browser - no installation required!**

### 🎥 **[Watch Demo Video on YouTube →](https://youtu.be/g-GMM4rRC1A)**

**See EcoPool in action - Full feature walkthrough**

---

🤖 **Or use Telegram:** [@RouteOpt_bot](https://t.me/RouteOpt_bot) - AI-powered carpooling assistant

</div>

---

## 📖 About

A comprehensive Flutter-based mobile application with Django backend designed to promote sustainability by reducing carbon emissions through organization-based car pooling and ride-mate matching. Built with safety, trust, community pooling, and real-time environmental impact tracking at its core.

---

## 👥 Team Information

**Team Name:** Arcane Hackathon Team

**Domain:** Sustainability & Green Technology

**Team Members:**
- Veda Patki
- Soham Patil

---

## 📋 Table of Contents

- [Problem Statement](#-problem-statement)
- [Key Innovations](#-key-innovations)
- [Key Features](#-key-features)
- [Feature Comparison](#-feature-comparison)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [User Roles](#-user-roles)
- [Implemented Modules](#-implemented-modules)
- [Quick Start Guide](#-quick-start-guide)
- [Setup & Installation](#-setup--installation)
- [API Documentation](#-api-documentation)
- [Sustainability Metrics](#-sustainability-metrics)
- [Security & Safety](#-security--safety)
- [FAQ](#-frequently-asked-questions)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [Impact Goals](#-impact-goals)
- [Contact & Support](#-contact--support)

---

## 🎯 Problem Statement

Transportation is one of the largest contributors to carbon emissions globally. Single-occupancy vehicles contribute significantly to:
- **High CO₂ emissions** per capita
- Traffic congestion in urban areas
- Increased fuel consumption
- Poor air quality

**Our Solution:** A secure, organization-based car pooling platform that incentivizes shared rides through rewards, ensures rider safety with built-in security features, and tracks real environmental impact.

---

## 💡 Key Innovations

### 1. **Community Pooling Without Cars** 🚗➡️🛺
Unlike traditional carpooling apps that require vehicle ownership, EcoPool enables ride-seeking mode where users can find ride-mates for auto-rickshaws, public transport, or any shared mode. This democratizes sustainable commuting.

### 2. **Organization Preset Routes with Reverse** 🏢🔄
Organizations create common routes (e.g., "Koramangala → Office"). Users can:
- Use routes instantly with one tap
- Reverse routes for return trips (Office → Home)
- Save time on repetitive commutes

### 3. **24-Hour Privacy-First Chat** 💬⏱️
Temporary chat rooms that auto-expire after 24 hours ensure:
- No phone number sharing needed
- Privacy protection by design
- Safe coordination between ride-mates
- Countdown timer for transparency

### 4. **4-Category Detailed Feedback** ⭐📊
Beyond simple ratings, our system captures:
- ⏰ Punctuality scores
- 😊 Behavior ratings
- 🧼 Cleanliness standards
- 💬 Communication quality

This feeds into AI-powered matching for continuously improving ride quality.

### 5. **Diamond Economy Rewards** 💎
Earn diamonds based on actual CO₂ saved, creating a tangible incentive system:
- Real environmental impact = Real rewards
- Redeem for future rides
- Gamification that drives behavior change

---

## ✨ Key Features

### 🔐 Authentication & Security
- **Organization Email Verification** with automatic organization assignment based on email domain
- **Facial Verification** during registration with animated scanning interface
- **Role-based Access Control** (Driver/Passenger/Admin/Organization)
- Phone number and email authentication
- Secure password handling with JWT tokens

### 🚗 Smart Ride Matching & Community Pooling
- **Two Trip Types:**
  - 🚗 **Offering Ride**: Share your vehicle (car/bike)
  - 👥 **Seeking Ride**: Find ride-mates for auto-rickshaw, public transport, or any mode
- **Intelligent Matching Algorithm** considering:
  - Organization affiliation (only matches within same organization)
  - Route overlap using Google Maps API
  - Gender preferences and safety
  - Transport mode compatibility
  - Real-time availability and timing

### 🏢 Organization Preset Routes
- **Common Routes Library**: Organizations create frequently-used routes
- **One-Click Reverse**: Morning route becomes evening route with one tap
- **Usage Tracking**: Popular routes highlighted
- Example: "Koramangala → Office" instantly becomes "Office → Koramangala"

### 🌍 Sustainability Tracking & Diamond Rewards
- **Real-time Dashboard** displaying:
  - Total pooled rides completed
  - CO₂ emissions saved (kg) with precise calculations
  - Equivalent trees planted metric
  - Personal carbon footprint reduction graph
- **Diamond-Based Rewards System:**
  - Earn diamonds based on CO₂ saved per ride
  - Redeem diamonds for ride discounts
  - Track diamond balance and transaction history
  - Gamification to encourage consistent pooling

### 🛡️ Safety & Communication Features
- **Live GPS Tracking** throughout journey with real-time updates
- **SOS Button** with instant alert to organization admins
- **24-Hour Temporary Chat Rooms:**
  - In-app messaging (no phone number sharing)
  - Auto-expires after 24 hours for privacy
  - Coordinate pickups safely
  - Orange countdown timer banner
- **ETA Calculation** and route monitoring
- **Trust Scoring** based on detailed feedback

### 💰 Flexible Payment System
- **Three Payment Options:**
  - 💎 Pay with Diamonds (earned rewards)
  - 💰 Pay with Cash (mark as paid)
  - 💳 UPI/Card Payment (Razorpay integration)
- Real-time fare calculation based on distance
- Automatic payment distribution
- Transaction history tracking

### ⭐ Comprehensive Feedback System
- **4-Category Detailed Ratings:**
  - ⏰ **Punctuality**: Were they on time?
  - 😊 **Behavior**: How was their conduct?
  - 🧼 **Cleanliness**: Vehicle/personal hygiene rating
  - 💬 **Communication**: Response quality and clarity
- Written feedback with optional comments
- AI-powered matching improvement based on ratings
- Trust score calculation and display

### 📱 Bot Integration & Notifications
- **Telegram Bot (@RouteOpt_bot):**
  - AI-powered natural language understanding
  - Search and offer rides via Telegram
  - Check rewards and CO₂ savings
  - Receive instant notifications
  - No app installation required
- Push notifications for ride updates
- Real-time chat message notifications
- SOS alerts to admins

---

## 🆚 Feature Comparison

| Feature | Traditional Carpooling | EcoPool |
|---------|----------------------|---------|
| **Vehicle Requirement** | Must own a car | ❌ Optional - Seek rides without vehicle |
| **Organization Focus** | Open to everyone | ✅ Organization-based for trust |
| **Ride Types** | Car pooling only | ✅ Car, Bike, Auto, Public Transport |
| **Privacy** | Phone numbers shared | ✅ Temporary chats (24hr auto-delete) |
| **Preset Routes** | Manual entry each time | ✅ One-click preset + reverse routes |
| **Rewards** | Basic points | ✅ Diamonds based on actual CO₂ saved |
| **Feedback Detail** | Simple star rating | ✅ 4-category detailed ratings |
| **Payment Options** | Cash only or card | ✅ Diamonds / Cash / UPI |
| **Safety Features** | Basic tracking | ✅ SOS + Live GPS + Admin alerts |
| **Facial Verification** | ❌ Not available | ✅ During registration |
| **Environmental Impact** | Not tracked | ✅ Real-time CO₂ & tree metrics |

---

## 🛠️ Tech Stack

### Frontend
- **Framework:** Flutter 3.0+ with Dart
- **State Management:** Provider pattern
- **Maps:** Google Maps Flutter Plugin with route optimization
- **UI Components:** Material Design 3
- **Real-time:** WebSocket connections for live updates
- **Camera:** Image picker for profile photos

### Backend
- **Framework:** Django 4.2+ with Django REST Framework
- **Database:** SQLite (development) / PostgreSQL (production-ready)
- **Authentication:** JWT tokens with SimpleJWT
- **Real-time:** Django Channels for WebSocket support
- **Payment:** Razorpay SDK integration
- **Task Queue:** Django management commands for cleanup

### APIs & Services
- **Google Maps API** for geocoding, routing, and distance calculations
- **Razorpay Payment Gateway** for secure transactions
- **Telegram Bot API** for notifications and alerts
- **Face Recognition** during registration

### Project Structure
```
Arcane-Hackathon/
├── backend/                    # Django REST API
│   ├── ecopool_apps/
│   │   ├── authentication/    # User auth, organizations, vehicles
│   │   ├── organizations/     # Org management, preset routes, members
│   │   ├── trips/            # Trip creation (offering/seeking)
│   │   ├── rides/            # Active rides, chat, feedback, SOS
│   │   ├── payments/         # Payment processing, diamonds
│   │   ├── rewards/          # Reward calculations and redemption
│   │   └── sustainability/   # CO₂ tracking and metrics
│   └── requirements.txt
├── flutter/                   # Mobile app (Android/iOS)
│   ├── lib/
│   │   ├── screens/          # All UI screens
│   │   ├── services/         # API clients and business logic
│   │   ├── models/           # Data models
│   │   └── widgets/          # Reusable components
│   └── pubspec.yaml
└── telegram-bot/             # Telegram integration
    ├── bot.py
    └── requirements.txt
```

---

## ⚡ Quick Start Guide

### For Users

#### Option 1: Mobile App (Full Experience)
1. **Download & Install** the EcoPool mobile app
2. **Register** with your organization email (e.g., name@company.com)
3. **Complete Facial Verification** for security
4. **Choose Mode:**
   - Have a vehicle? Select "Offering Ride" and add vehicle details
   - Need a ride? Select "Seeking Ride" for any transport mode
5. **Create or Search Trips** based on your daily commute
6. **Start Pooling** and earn diamonds for every CO₂ saved!

#### Option 2: Telegram Bot (Quick Access) 🤖
1. **Open Telegram** and search for `@RouteOpt_bot`
2. **Click Start** and login with your organization email
3. **Use commands** or just chat naturally:
   - "Find me a ride to Whitefield tomorrow"
   - "/search" - Search available rides
   - "/rewards" - Check your diamonds
   - "/carbon" - View CO₂ savings
4. **Get instant notifications** for rides, matches, and rewards!

*The bot is perfect for quick actions while the mobile app offers full features like live GPS tracking.*

### For Developers
```bash
# Clone repository
git clone https://github.com/vedaXD/Arcane-Hackathon.git
cd Arcane-Hackathon

# Setup backend
cd backend
python -m venv venv
.\venv\Scripts\Activate.ps1  # Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver

# Setup Flutter app (in new terminal)
cd flutter
flutter pub get
flutter run
```

---

## 🧪 Testing

### Backend Testing
```bash
cd backend

# Run all tests
python manage.py test

# Run specific app tests
python manage.py test ecopool_apps.trips
python manage.py test ecopool_apps.rides

# Check test coverage
pip install coverage
coverage run --source='.' manage.py test
coverage report
```

### Flutter Testing
```bash
cd flutter

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### API Testing
Use tools like Postman or curl:
```bash
# Test authentication
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"user@techcorp.com","password":"pass123"}'

# Test trip creation
curl -X POST http://localhost:8000/api/trips/ \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"trip_type":"offering","origin":"12.9716,77.5946",...}'
```

---

## 🏗️ Architecture

### System Overview

Our platform uses a client-server architecture with the following components:

#### Frontend (Flutter)
- **Screens Layer**: 20+ screens for complete user journey
- **Services Layer**: API clients, authentication, state management
- **Models Layer**: Data classes matching backend schemas
- **Widgets Layer**: Reusable UI components

#### Backend (Django)
- **API Layer**: RESTful endpoints with DRF
- **Business Logic**: Services for matching, calculations, notifications
- **Database**: Models for users, trips, rides, payments, feedback
- **Real-time**: WebSocket support for chat and tracking

#### Key Workflows

**1. User Registration & Onboarding:**
```
User enters email → Facial verification → Email domain check →
Auto-assign organization → Role selection → Profile setup → Complete
```

**2. Trip Creation (Offering Ride):**
```
Select "Offering" → Choose vehicle → Enter route →
Set preferences → Publish → Wait for matches
```

**3. Trip Search (Seeking Ride):**
```
Select "Seeking" → Choose transport mode → Enter route →
View matches → Select ride-mate → Start chat → Coordinate
```

**4. Active Ride:**
```
Start ride → Live GPS tracking → Real-time ETA →
24-hr chat active → Reach destination → Complete ride →
Calculate CO₂ saved → Award diamonds → Request feedback
```

**5. Payment & Rewards:**
```
Ride complete → Choose payment (Diamonds/Cash/UPI) →
Process payment → Update balances → Record transaction
```

### Data Flow

```
Mobile App → REST API → Django Backend → PostgreSQL
     ↓
  WebSocket → Real-time Updates (Chat, GPS)
     ↓
  Telegram Bot → Notifications
```

### Security Architecture

1. **Authentication Layer**: JWT tokens with refresh mechanism
2. **Authorization**: Role-based permissions per endpoint
3. **Data Privacy**: Temporary chats, no phone number sharing
4. **Organization Verification**: Email domain matching
5. **Face Verification**: Identity confirmation at registration

---

## 👥 User Roles

### 1️⃣ **Driver (Offering Ride)**
- Create trip listings with vehicle details
- Specify available seats and occupancy
- Set gender and organization preferences
- Accept/reject ride requests from passengers
- Track sustainability impact and rewards earned
- Receive payments or diamond rewards

### 2️⃣ **Passenger (Seeking Ride)**
- **With Vehicle:** Offer rides in their car/bike
- **Without Vehicle:** Find ride-mates for auto-rickshaw/public transport
- Search compatible trips based on route and preferences
- Book rides and track in real-time
- Pay with diamonds, cash, or UPI
- Rate drivers after ride completion

### 3️⃣ **Organization Admin**
- Monitor all rides within organization
- Receive SOS alerts with live GPS location
- Create and manage preset routes
- Handle complaints and disputes
- Access organization-wide sustainability metrics
- Manage member verification and trust scores

### 4️⃣ **Organization Member**
- Automatically assigned based on email domain
- Access organization preset routes
- Only matched with verified colleagues
- Enhanced trust and safety within organization
- Participate in organization sustainability goals

---

## 🧩 Implemented Modules

### 🔐 Authentication & Onboarding
- Organization email verification
- Facial verification with animated scanning
- Role selection (Driver/Passenger)
- Profile creation with preferences
- Vehicle registration for drivers
- Automatic organization assignment

### 🏢 Organization Management
- Organization creation and configuration
- Email domain-based auto-assignment
- Preset route library with reverse feature
- Member management and verification
- Organization-wide statistics

### 🚗 Trip Management
- Two trip types: Offering vs Seeking rides
- Multiple transport modes (car, bike, auto, public)
- Route input with Google Maps integration
- Schedule-based trip creation
- Gender preference settings
- Available seats configuration

### 🔍 Smart Matching & Search
- Organization-based filtering
- Route overlap calculation
- Transport mode compatibility
- Gender preference matching
- Real-time availability checking
- Distance-based sorting

### 🛣️ Live Ride Experience
- Real-time GPS tracking
- ETA calculations and updates
- 24-hour temporary chat rooms
- SOS button with admin alerts
- Route monitoring and notifications
- Pick-up/drop-off coordination

### 💎 Rewards & Payments
- Diamond earning based on CO₂ saved
- Three payment methods (Diamonds/Cash/UPI)
- Razorpay integration for card payments
- Transaction history tracking
- Reward redemption system
- Balance management

### ⭐ Feedback & Trust System
- 4-category detailed ratings
- Written feedback submission
- Trust score calculation
- Feedback history viewing
- Rating-based matching improvement

### 🌱 Sustainability Dashboard
- Total rides completed counter
- CO₂ emissions saved calculation
- Tree equivalent metric
- Personal contribution graphs
- Organization leaderboard
- Environmental impact visualization

---

## � Screenshots

### Authentication Flow
Coming soon: Registration → Facial Verification → Profile Setup

### Main Features
Coming soon: Search Screen → Preset Routes → Live Ride → Chat Room → Feedback

### Dashboard & Stats
Coming soon: Sustainability Dashboard → Rewards → Payment Options

*Screenshots will be added as the UI is finalized*

---

## �🚀 Setup & Installation

### Prerequisites
```bash
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Python 3.8+
- pip (Python package manager)
- Google Maps API key
- Razorpay account (for payments)
```

### Backend Setup

1. **Navigate to backend directory**
```bash
cd backend
```

2. **Create and activate virtual environment**
```bash
# Windows
python -m venv venv
.\venv\Scripts\Activate.ps1

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Configure environment variables**
Create `.env` file in backend directory:
```env
SECRET_KEY=your_django_secret_key
DEBUG=True
GOOGLE_MAPS_API_KEY=your_google_maps_key
RAZORPAY_KEY_ID=your_razorpay_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
TELEGRAM_BOT_TOKEN=your_telegram_token
```

5. **Run migrations**
```bash
python manage.py makemigrations
python manage.py migrate
```

6. **Create superuser (optional)**
```bash
python manage.py createsuperuser
```

7. **Start development server**
```bash
python manage.py runserver
```

Backend will be available at `http://localhost:8000`

### Flutter App Setup

1. **Navigate to flutter directory**
```bash
cd flutter
```

2. **Install Flutter dependencies**
```bash
flutter pub get
```

3. **Configure API endpoint**
Edit `lib/services/api_client.dart`:
```dart
static const String baseUrl = 'http://your-backend-url:8000/api';
```

4. **Add Google Maps API Key**

**Android:** Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**iOS:** Edit `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

5. **Run the app**
```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>
```

### Telegram Bot Setup & Usage

#### 🤖 Bot Username: **@RouteOpt_bot**

#### For Users (No Setup Required!)

**How to Use the Telegram Bot:**

1. **Find the Bot**
   - Open Telegram
   - Search for `@RouteOpt_bot`
   - Click "Start" or send `/start`

2. **Login & Connect**
   ```
   /start - Start bot and authenticate with your EcoPool account
   ```
   - Bot will ask for your email and password
   - Once logged in, you're ready to use all features!

3. **Available Commands**
   ```
   /search - Search for available carpools near you
   /offer - Offer your ride to colleagues
   /mycarpools - View your active and past rides
   /rewards - Check your diamond balance
   /carbon - View your CO₂ savings and environmental impact
   /help - Show all available commands
   /logout - Logout from the bot
   ```

4. **Natural Language Support**
   - You don't need to use commands!
   - Just chat naturally:
     - "I need a ride to VESIT tomorrow morning"
     - "Show me my rewards"
     - "How much CO₂ have I saved?"
     - "Find carpools going to Whitefield"
   
5. **Get Notifications**
   - Ride match found
   - Ride starting soon
   - New message in chat room
   - Payment received
   - Rewards earned

#### For Developers (Bot Setup)

1. **Navigate to telegram-bot directory**
```bash
cd telegram-bot
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Configure bot token**
Edit `config.py` with your Telegram bot token from @BotFather

4. **Set environment variables**
```bash
# Windows PowerShell
$env:TELEGRAM_BOT_TOKEN="your_token_here"
$env:API_BASE_URL="http://localhost:8000/api"

# Linux/Mac
export TELEGRAM_BOT_TOKEN="your_token_here"
export API_BASE_URL="http://localhost:8000/api"
```

5. **Start bot**
```bash
python bot.py
```

The bot uses **GPT-4 powered agentic AI** that:
- Understands natural language intent
- Makes autonomous decisions
- Performs multi-step actions
- Self-corrects when errors occur

See [telegram-bot/README.md](telegram-bot/README.md) for detailed technical documentation.

---

## 🌐 Deployment

### Backend Deployment (Production)

**Option 1: Heroku**
```bash
# Install Heroku CLI
heroku create ecopool-backend
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
heroku run python manage.py migrate
```

**Option 2: AWS/DigitalOcean**
```bash
# Setup PostgreSQL database
# Configure nginx & gunicorn
# Setup SSL certificates
# Configure environment variables
```

**Environment Variables for Production:**
```env
DEBUG=False
ALLOWED_HOSTS=your-domain.com
DATABASE_URL=postgresql://...
SECRET_KEY=your-secret-key
GOOGLE_MAPS_API_KEY=...
RAZORPAY_KEY_ID=...
```

### Flutter App Deployment

**Android (Google Play Store):**
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release
```

**iOS (App Store):**
```bash
# Build iOS release
flutter build ios --release

# Archive and upload via Xcode
```

**Update API endpoint in production:**
```dart
// lib/services/api_client.dart
static const String baseUrl = 'https://api.ecopool.com/api';
```

---

## 📡 API Documentation

### Base URL
```
http://localhost:8000/api
```

### Authentication Endpoints
```http
POST   /api/auth/register/              # Register new user
POST   /api/auth/login/                 # Login with credentials
POST   /api/auth/logout/                # Logout
POST   /api/auth/token/refresh/         # Refresh JWT token
GET    /api/auth/profile/               # Get user profile
PUT    /api/auth/profile/               # Update profile
```

### Organization Endpoints
```http
GET    /api/orgs/organizations/         # List all organizations
POST   /api/orgs/organizations/         # Create organization
GET    /api/orgs/organizations/{id}/    # Get organization details
GET    /api/orgs/organizations/{id}/routes/  # Get preset routes
GET    /api/orgs/organizations/{id}/members/ # Get members

GET    /api/orgs/routes/                # List routes
POST   /api/orgs/routes/                # Create route
GET    /api/orgs/routes/{id}/           # Route details
GET    /api/orgs/routes/{id}/reverse/   # Get reversed route data
POST   /api/orgs/routes/{id}/use/       # Increment usage count
```

### Trip Endpoints
```http
GET    /api/trips/                      # List trips
POST   /api/trips/                      # Create trip (offering/seeking)
GET    /api/trips/{id}/                 # Trip details
PUT    /api/trips/{id}/                 # Update trip
DELETE /api/trips/{id}/                 # Cancel trip
GET    /api/trips/my-trips/             # User's trips
GET    /api/trips/search/               # Search compatible trips
```

### Ride Endpoints
```http
POST   /api/rides/                      # Book/join a ride
GET    /api/rides/{id}/                 # Ride details
GET    /api/rides/{id}/track/           # Live tracking data
POST   /api/rides/{id}/sos/             # Trigger SOS alert
PUT    /api/rides/{id}/start/           # Start ride
PUT    /api/rides/{id}/complete/        # Complete ride
GET    /api/rides/{id}/chat/            # Get chat messages
POST   /api/rides/{id}/chat/            # Send chat message
```

### Payment & Rewards Endpoints
```http
POST   /api/payments/initiate/          # Start payment
POST   /api/payments/verify/            # Verify payment
GET    /api/payments/history/           # Payment history
GET    /api/rewards/balance/            # Get diamond balance
POST   /api/rewards/redeem/             # Redeem diamonds
GET    /api/rewards/transactions/       # Reward transactions
```

### Feedback Endpoints
```http
POST   /api/feedback/                   # Submit ride feedback
GET    /api/feedback/user/{id}/         # Get user's feedback
GET    /api/feedback/trust-score/       # Get trust score
```

### Sustainability Endpoints
```http
GET    /api/sustainability/stats/       # User's sustainability stats
GET    /api/sustainability/leaderboard/ # Organization leaderboard
```

### Request/Response Examples

**Create Trip (Offering Ride):**
```json
POST /api/trips/
{
  "trip_type": "offering",
  "transport_mode": "car",
  "origin": "12.9716,77.5946",
  "destination": "12.2958,76.6394",
  "departure_time": "2026-01-05T09:00:00Z",
  "available_seats": 3,
  "gender_preference": "any",
  "vehicle": 1
}
```

**Create Trip (Seeking Ride):**
```json
POST /api/trips/
{
  "trip_type": "seeking",
  "transport_mode": "auto",
  "origin": "12.9716,77.5946",
  "destination": "12.2958,76.6394",
  "departure_time": "2026-01-05T09:00:00Z",
  "gender_preference": "female"
}
```

---

## 🌱 Sustainability Metrics

### Carbon Emission Calculation

**Formula Used:**
```python
CO₂ saved = (Distance in km) × (Emission factor) × (Passengers pooled)

Emission Factors:
- Petrol car: 0.192 kg CO₂/km
- Diesel car: 0.171 kg CO₂/km
- Electric car: 0.053 kg CO₂/km
- Bike: 0.084 kg CO₂/km
- Auto-rickshaw: 0.070 kg CO₂/km
```

**Real Example:**
```
Trip: Koramangala to Whitefield (20 km)
Vehicle: Petrol car
Passengers: Driver + 2 ride-mates = 3 people total

Without pooling: 3 cars × 20 km × 0.192 = 11.52 kg CO₂
With pooling: 1 car × 20 km × 0.192 = 3.84 kg CO₂
CO₂ saved = 11.52 - 3.84 = 7.68 kg CO₂

💎 Diamond Reward = 7.68 kg × 10 = 77 diamonds
🌳 Tree Impact = 7.68 / 21.77 = 0.35 trees (or ~128 days of tree growth)
```

### Diamond Rewards System
- **1 kg CO₂ saved = 10 diamonds**
- Diamonds can be redeemed for ride discounts
- Minimum redemption: 100 diamonds
- 100 diamonds = ₹10 off on ride payment

### Tree Equivalence Calculation
- **1 tree absorbs ~21.77 kg CO₂ per year**
- Displayed as "days of tree growth" for better understanding
- Example: 7.68 kg CO₂ saved = 128 days of one tree's work

### Dashboard Metrics
Users can track:
- **Total Rides**: Number of pooled rides completed
- **CO₂ Saved**: Cumulative emissions prevented (kg)
- **Trees Planted**: Equivalent environmental impact
- **Diamonds Earned**: Total reward balance
- **Money Saved**: Cost sharing benefits
- **Rank**: Position in organization leaderboard

---

## 🛡️ Security & Safety

### Safety Measures
1. **SOS System**
   - One-tap emergency alert
   - Live location shared with admin
   - Auto-dial emergency contact

2. **Identity Verification**
   - Organization email mandatory
   - Face authentication
   - Government ID verification (optional)

3. **Privacy Protection**
   - Phone numbers never shared
   - In-app chat only
   - Location shared only during active ride

4. **Trust System**
   - Minimum trust score required to ride
   - Automatic suspension on multiple complaints
   - Admin review process

---

## 🤝 Contributing

We welcome contributions to make EcoPool even better! Here's how you can help:

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Make** your changes following our coding standards
4. **Test** thoroughly on both Android and iOS
5. **Commit** with clear messages
   ```bash
   git commit -m 'Add: Amazing new feature'
   ```
6. **Push** to your fork
   ```bash
   git push origin feature/AmazingFeature
   ```
7. **Open** a Pull Request with detailed description

### Coding Standards

**Flutter/Dart:**
- Follow official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add comments for complex logic
- Format code: `flutter format .`

**Python/Django:**
- Follow [PEP 8](https://peps.python.org/pep-0008/) style guide
- Use type hints where applicable
- Write docstrings for functions
- Format code: `black .`

**General:**
- Write unit tests for new features
- Update documentation (README, API docs)
- Ensure all existing tests pass
- Add screenshots for UI changes

### Areas We Need Help With
- 🌐 Multi-language translations
- 🎨 UI/UX improvements
- 🧪 Test coverage
- 📱 iOS platform testing
- 🤖 ML model for better matching
- 📖 Documentation improvements

---

## 🗺️ Roadmap

### Phase 1 (Completed) ✅
- [x] Django backend with REST API
- [x] Organization-based user authentication
- [x] Facial verification during registration
- [x] Email domain-based organization matching
- [x] Vehicle registration and management
- [x] Trip creation (offering/seeking rides)
- [x] Community pooling for multiple transport modes
- [x] Organization preset routes with reverse feature
- [x] Live GPS tracking
- [x] 24-hour temporary chat rooms
- [x] Comprehensive 4-category feedback system
- [x] Diamond-based rewards system
- [x] Multi-payment options (Diamonds/Cash/UPI)
- [x] SOS feature with admin alerts
- [x] Sustainability metrics and CO₂ tracking
- [x] Telegram bot integration (@RouteOpt_bot) with AI agent

### Phase 2 (Current)
- [ ] Advanced AI-powered route optimization
- [ ] Enhanced matching algorithm with ML
- [ ] Admin dashboard with analytics
- [ ] Real-time ride status notifications
- [ ] WhatsApp bot integration
- [ ] Social media sharing features
- [ ] Multi-language support (Hindi, Kannada, Tamil)

### Phase 3 (Future)
- [ ] Carbon credit marketplace
- [ ] Corporate partnership program
- [ ] Gamification leaderboards
- [ ] Referral rewards system
- [ ] Electric vehicle incentives
- [ ] Integration with public transit APIs
- [ ] Predictive ride matching
- [ ] Blockchain-based carbon credits

---

## 📊 Impact Goals

**Current Achievements:**
- ✅ Complete backend infrastructure with 6 Django apps
- ✅ 30+ API endpoints for comprehensive functionality
- ✅ Flutter mobile app with 20+ screens
- ✅ Multi-mode transport support (car, bike, auto, public)
- ✅ Organization-based community building
- ✅ Precise CO₂ emission tracking

**By End of 2026:**
- 🚗 10,000+ pooled rides
- 🌍 5,000 kg CO₂ emissions reduced
- 🌳 230 trees equivalent impact
- 👥 1,000+ active users
- 🏢 10+ partner organizations (tech companies, universities)

**By 2027:**
- 🚗 100,000+ pooled rides
- 🌍 50,000 kg CO₂ emissions reduced
- 🌳 2,300 trees equivalent planted
- 👥 10,000+ active users
- 🏢 50+ partner organizations

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ❓ Frequently Asked Questions

### General
**Q: Do I need a car to use EcoPool?**  
A: No! With our "Seeking Ride" feature, you can find ride-mates for auto-rickshaws, public transport, or any shared mode.

**Q: Can I only match with people from my organization?**  
A: Yes, for safety and trust. Organization-based matching ensures you pool with verified colleagues.

**Q: How does facial verification work?**  
A: During registration, we capture your face for identity verification. This enhances security without storing biometric data permanently.

### Rides & Matching
**Q: What is the "Reverse Route" feature?**  
A: If your organization has a preset route like "Home → Office", you can instantly reverse it to "Office → Home" for your return trip.

**Q: How are ride-mates matched?**  
A: Based on organization, route overlap, gender preferences, transport mode, and timing compatibility.

**Q: Are phone numbers shared with ride-mates?**  
A: No! Use our temporary 24-hour chat rooms to coordinate. Privacy is built-in.

### Rewards & Payments
**Q: How do I earn diamonds?**  
A: Complete pooled rides! You earn 10 diamonds per kg of CO₂ saved.

**Q: Can I pay with diamonds?**  
A: Yes! Use earned diamonds, cash, or UPI for ride payments.

**Q: How is CO₂ calculated?**  
A: Based on distance, vehicle type emission factors, and number of passengers pooled.

### Safety
**Q: What happens when I press SOS?**  
A: Organization admins receive immediate alerts with your live GPS location and ride details.

**Q: How long is chat history retained?**  
A: Chat rooms auto-delete after 24 hours to protect your privacy.

### Telegram Bot
**Q: How do I use the Telegram bot?**  
A: Search for `@RouteOpt_bot` on Telegram, click Start, and login with your EcoPool credentials. You can then use commands like `/search` or just chat naturally.

**Q: What can the Telegram bot do?**  
A: Search rides, offer rides, check rewards, view CO₂ savings, and receive notifications. It uses AI to understand natural language, so you can chat like you would with a person.

**Q: Do I need to download the mobile app to use the bot?**  
A: No! The Telegram bot provides core features without the app. However, the mobile app offers the complete experience with live tracking and advanced features.

**Q: Can I get ride notifications on Telegram?**  
A: Yes! Once logged in to @RouteOpt_bot, you'll receive notifications for ride matches, messages, payments, and rewards.

---

## 👏 Acknowledgments

- **EPA** for emission factor data and environmental standards
- **Google Maps Platform** for routing, geocoding, and distance matrix APIs
- **Razorpay** for secure payment gateway integration
- **Django & DRF Community** for excellent backend framework
- **Flutter Community** for amazing packages and support
- **Our Beta Testers** for valuable feedback
- **Environmental Organizations** inspiring sustainable solutions

Special thanks to all contributors who believe in a greener future! 🌱

---

## 📞 Contact & Support

- **GitHub Repository:** [Arcane-Hackathon](https://github.com/vedaXD/Arcane-Hackathon)
- **Team Lead:** [@vedaXD](https://github.com/vedaXD)
- **Email:** support@ecopool.com
- **Issues:** [GitHub Issues](https://github.com/vedaXD/Arcane-Hackathon/issues)
- **Telegram Bot:** [@RouteOpt_bot](https://t.me/RouteOpt_bot) - Try it now!

### Quick Access
- 🤖 **Use the bot:** Open Telegram → Search `@RouteOpt_bot` → Start chatting!
- 📱 **Mobile App:** Download from releases
- 🌐 **Web:** Coming soon

### Documentation
- 📖 [Complete Features Guide](COMPLETE_FEATURES_GUIDE.md) - Detailed implementation guide
- 🚀 [New Features Guide](NEW_FEATURES_GUIDE.md) - Latest features documentation
- 📝 [Quick Summary](QUICK_SUMMARY.md) - Quick reference guide
- 🏗️ [Architecture Diagram](ARCHITECTURE_DIAGRAM.md) - System design
- 💎 [Diamond Economy Setup](DIAMOND_ECONOMY_SETUP.md) - Rewards system

---

<div align="center">

**Made with 💚 for a sustainable future**

*Every ride shared is a step towards cleaner air and a healthier planet.*

**EcoPool** - Connecting people, reducing emissions, building communities.

</div>