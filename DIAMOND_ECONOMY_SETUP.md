# 💎 Diamond Economy System - Complete Setup Guide

## 🎯 System Overview

**Brand Name:** **Carbon Crystals** ✨  
**Tagline:** *"The purest form of sustainable living"*

Diamonds represent the purest, most valuable form of carbon - symbolizing how carpooling transforms harmful emissions into precious rewards.

---

## 🌟 How It Works

### 💎 Earning Diamonds

#### 1. **Travel & Save** (Primary Method)
- **Formula:** `(CO₂ Saved × 10) + (Distance × 2)`
- Example: 2.5kg CO₂ saved + 15km distance = **55 Diamonds**
- Real-time calculation after each carpool
- Higher carpooling frequency = more diamonds

#### 2. **Donate to NGOs** (Secondary Method)
- **Formula:** `Donation Amount × 5`
- Example: ₹100 donation = **500 Diamonds**
- CO₂ Equivalent: ₹1 = 0.1kg CO₂ offset
- Support verified environmental NGOs

### 💰 Redeeming Diamonds

Convert diamonds to real-world value:
- Discount coupons (Amazon, Flipkart, etc.)
- Gift vouchers
- Product discounts
- Service benefits

**Exchange Rate:** ~1 Diamond ≈ ₹1 value (varies by partner)

---

## 🚀 Backend Setup

### 1. **Run Migrations**

```powershell
cd "d:\Arcane Hax\Arcane-Hackathon\backend"
python manage.py makemigrations rewards
python manage.py migrate
```

### 2. **Create Conversion Rates**

Open Django shell:
```powershell
python manage.py shell
```

Run this code:
```python
from ecopool_apps.rewards.models import ConversionRate

# Create conversion rates
ConversionRate.objects.create(
    name='CO2_TO_DIAMOND',
    rate=10.0,
    description='Diamonds earned per kg of CO2 saved',
    active=True
)

ConversionRate.objects.create(
    name='KM_TO_DIAMOND',
    rate=2.0,
    description='Diamonds earned per kilometer traveled',
    active=True
)

ConversionRate.objects.create(
    name='DONATION_TO_DIAMOND',
    rate=5.0,
    description='Diamonds earned per rupee donated',
    active=True
)

ConversionRate.objects.create(
    name='RUPEE_TO_CO2',
    rate=0.1,
    description='kg CO2 offset per rupee donated',
    active=True
)

print("✅ Conversion rates created!")
```

### 3. **Add NGO Partners**

```python
from ecopool_apps.rewards.models import NGOPartner

# Create sample NGOs
NGOPartner.objects.create(
    name='Green Earth Foundation',
    description='Focused on reforestation and clean energy projects across India',
    focus_area='Reforestation',
    website='https://greenearthfoundation.org',
    verified=True,
    active=True
)

NGOPartner.objects.create(
    name='Clean Air Initiative',
    description='Working to reduce air pollution in urban areas',
    focus_area='Air Quality',
    website='https://cleanairinitiative.org',
    verified=True,
    active=True
)

NGOPartner.objects.create(
    name='Solar For All',
    description='Promoting solar energy adoption in rural communities',
    focus_area='Clean Energy',
    website='https://solarforall.org',
    verified=True,
    active=True
)

print("✅ NGO partners created!")
```

### 4. **Add Redemption Options**

```python
from ecopool_apps.rewards.models import RedemptionOption

# Amazon Vouchers
RedemptionOption.objects.create(
    title='Amazon ₹500 Voucher',
    description='Get ₹500 off on Amazon shopping',
    category='VOUCHER',
    diamond_cost=400,
    value=500,
    partner_name='Amazon India',
    terms_conditions='Valid for 90 days. Non-transferable.',
    validity_days=90,
    stock_available=100,
    active=True,
    featured=True
)

RedemptionOption.objects.create(
    title='Flipkart ₹1000 Voucher',
    description='Get ₹1000 off on Flipkart',
    category='VOUCHER',
    diamond_cost=850,
    value=1000,
    partner_name='Flipkart',
    terms_conditions='Valid for 90 days',
    validity_days=90,
    stock_available=50,
    active=True,
    featured=True
)

# Discounts
RedemptionOption.objects.create(
    title='Zomato 50% Off (Up to ₹200)',
    description='Get 50% discount on your next Zomato order',
    category='DISCOUNT',
    diamond_cost=150,
    value=200,
    partner_name='Zomato',
    terms_conditions='Valid on orders above ₹400',
    validity_days=30,
    stock_available=200,
    active=True,
    featured=False
)

RedemptionOption.objects.create(
    title='BookMyShow Movie Ticket Free',
    description='Get 1 movie ticket free',
    category='VOUCHER',
    diamond_cost=250,
    value=300,
    partner_name='BookMyShow',
    terms_conditions='Valid on any cinema',
    validity_days=60,
    stock_available=75,
    active=True,
    featured=True
)

print("✅ Redemption options created!")
```

### 5. **Update URLs**

Add to `backend/ecopool/urls.py`:
```python
from django.urls import path, include

urlpatterns = [
    # ... existing patterns
    path('api/rewards/', include('ecopool_apps.rewards.urls')),
]
```

### 6. **Update Settings**

Add to `INSTALLED_APPS` in `settings.py`:
```python
INSTALLED_APPS = [
    # ... existing apps
    'ecopool_apps.rewards.apps.RewardsConfig',
]
```

---

## 📱 Frontend Setup (Flutter)

### 1. **Navigation Updates**

Update `lib/screens/home/home_screen.dart` to add Diamond wallet button:

```dart
// Add to quick actions or navigation
IconButton(
  icon: Icon(Icons.diamond, color: AppTheme.primaryOrange),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DiamondWalletScreen()),
    );
  },
)
```

### 2. **Import Screens**

Already created:
- `lib/screens/rewards/diamond_wallet_screen.dart` ✅

Need to create:
- `lib/screens/rewards/donate_screen.dart` - Donate to NGOs
- `lib/screens/rewards/redeem_screen.dart` - Redeem diamonds

### 3. **API Integration**

Create `lib/services/rewards_service.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class RewardsService {
  static const String baseUrl = 'http://localhost:8000/api/rewards';
  
  static Future<Map<String, dynamic>> getDashboard(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/dashboard/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
  
  static Future<List> getNGOs(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ngos/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
  
  static Future<Map<String, dynamic>> donate(String token, int ngoId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/donations/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'ngo': ngoId,
        'amount': amount,
        'payment_id': 'demo_${DateTime.now().millisecondsSinceEpoch}',
      }),
    );
    return json.decode(response.body);
  }
  
  static Future<List> getRedemptionOptions(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/redemptions/options/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
  
  static Future<Map<String, dynamic>> redeemDiamonds(String token, int optionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/redemptions/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'option': optionId}),
    );
    return json.decode(response.body);
  }
}
```

---

## 🤖 Telegram Bot Integration

Diamond commands already integrated in bot! Users can:

**Check Diamonds:**
- "Show my diamonds"
- "How many rewards do I have?"
- "What's my balance?"

**View Stats:**
- "Show my carbon savings"
- "How much CO2 have I saved?"

The agentic AI automatically:
1. Calls `GetRewards` tool
2. Calls `GetCarbonStats` tool
3. Presents combined diamond + CO₂ information

---

## 🎮 Gamification Levels

Users progress through levels based on lifetime earnings:

| Level | Diamonds Required | Title |
|-------|------------------|-------|
| 1 | 0-99 | Carbon Novice 🌱 |
| 2 | 100-499 | Eco Warrior 🌿 |
| 3 | 500-999 | Green Champion 🍀 |
| 4 | 1000-4999 | Diamond Collector 💎 |
| 5 | 5000+ | Carbon Legend 👑 |

---

## 📊 API Endpoints

### Diamond Wallet
- `GET /api/rewards/wallet/dashboard/` - Complete dashboard
- `GET /api/rewards/transactions/` - Transaction history

### NGO & Donations
- `GET /api/rewards/ngos/` - List verified NGOs
- `POST /api/rewards/donations/` - Make donation
- `GET /api/rewards/donations/` - User's donation history

### Redemptions
- `GET /api/rewards/redemptions/options/` - Available rewards
- `GET /api/rewards/redemptions/options/?category=VOUCHER` - Filter by category
- `GET /api/rewards/redemptions/options/?featured=true` - Featured only
- `POST /api/rewards/redemptions/` - Redeem diamonds
- `GET /api/rewards/redemptions/` - User's redemption history

---

## 🧪 Testing

### Test Diamond Earning (Manual)

```python
from ecopool_apps.rewards.services import DiamondEconomyService
from django.contrib.auth import get_user_model

User = get_user_model()
user = User.objects.first()

# Award diamonds for a ride
diamonds = DiamondEconomyService.award_ride_diamonds(
    user=user,
    co2_saved_kg=2.5,
    distance_km=15,
    carpool_id='test123'
)
print(f"✅ Awarded {diamonds} diamonds!")
```

### Test Donation

```python
from ecopool_apps.rewards.models import NGOPartner, Donation
from ecopool_apps.rewards.services import DiamondEconomyService

ngo = NGOPartner.objects.first()

# Create donation
donation = Donation.objects.create(
    user=user,
    ngo=ngo,
    amount=100,
    diamonds_earned=500,  # 100 * 5
    co2_equivalent=10,    # 100 * 0.1
    payment_id='test_payment',
    status='completed'
)
print(f"✅ Donation processed! User earned {donation.diamonds_earned} diamonds")
```

### Test Redemption

```python
option = RedemptionOption.objects.first()

redemption = DiamondEconomyService.redeem_diamonds(user, option)
print(f"✅ Redeemed! Voucher code: {redemption.voucher_code}")
```

---

## 🎨 Branding Guidelines

### Logo/Icon Usage
- Use diamond icon (💎) consistently
- Primary color: Green (#4CAF50) - representing sustainability
- Secondary color: Purple/Gold - representing value and premium

### Messaging
- "Earn Carbon Crystals" (not points/coins)
- "Transform emissions into rewards"
- "Every ride purifies your impact"
- "Donate, offset, earn"

---

## 🚀 Next Steps

1. ✅ Run migrations and create data
2. ✅ Test API endpoints
3. Create donate_screen.dart
4. Create redeem_screen.dart
5. Integrate with carpool completion
6. Add payment gateway for donations
7. Partner with actual brands for redemptions

---

**Your Diamond Economy is ready to demo!** 💎✨
