# RouteOpt - Login & Popular Routes Feature Documentation

## Overview
Complete authentication system with face verification and popular routes integration for sustainable carpooling.

## Features Implemented

### 1. Login Screen (`lib/screens/auth/login_screen.dart`)
**Security Features:**
- ✅ Organization-based domain authentication
- ✅ Email validation by organization domain
- ✅ Password field with show/hide toggle
- ✅ Face verification integration
- ✅ Security features info display

**Organizations Supported:**
- VESIT College (`vesit.edu.in`)
- IIT Bombay (`iitb.ac.in`)
- TCS (`tcs.com`)
- Reliance Industries (`ril.com`)
- Infosys (`infosys.com`)
- Other Organization

**UI Features:**
- Gradient logo with eco icon
- Dropdown organization selector
- Email validation based on selected organization
- Forgot password link
- Sign up link
- Beautiful beige/orange theme

### 2. Face Verification Screen (`lib/screens/auth/face_verification_screen.dart`)
**Features:**
- ✅ Camera preview placeholder
- ✅ Animated scanning line with gradient
- ✅ Face frame with corner brackets
- ✅ Guide dots for facial features (eyes, nose, mouth)
- ✅ Real-time scanning animation (2s loop)
- ✅ Pulsing effect during scan
- ✅ Success state with green checkmark
- ✅ Instructions overlay (lighting, positioning, glasses)

**Animation Details:**
- Scanning line sweeps top to bottom
- Orange glow effect
- Face frame changes to green on verification
- Pulse animation at 1.5s intervals
- Auto-starts after 1s delay
- Auto-verifies after 4s (demo)
- Auto-navigates back after success

### 3. Popular Routes Data (`lib/data/popular_routes.dart`)
**16 Pre-configured Routes Including:**

#### Educational Routes:
- **Chembur Railway Station → VESIT College** (3.5 km, 12 min)
- Kurla Railway Station → VESIT College (5.2 km, 18 min)
- Ghatkopar Railway Station → VESIT College (4.8 km, 16 min)
- Borivali → IIT Bombay (18.5 km, 45 min)
- Andheri → IIT Bombay (12.3 km, 32 min)

#### Corporate Routes:
- Churchgate → BKC (14.2 km, 38 min)
- Andheri → BKC (8.5 km, 25 min)
- Thane → BKC (16.8 km, 42 min)
- Dadar → Lower Parel (5.5 km, 18 min)
- Mulund → Lower Parel (22.4 km, 55 min)
- Virar → SEEPZ (45.2 km, 90 min)
- Ghatkopar → SEEPZ (12.8 km, 35 min)

#### Airport Routes:
- Andheri → Mumbai Airport T2 (4.2 km, 15 min)
- Bandra → Mumbai Airport T2 (6.8 km, 22 min)

#### Shopping Routes:
- Dadar → Phoenix Mall (6.2 km, 20 min)
- Thane → Viviana Mall (4.5 km, 14 min)

**Route Data Includes:**
- Pickup & drop points
- Estimated distance (km)
- Estimated time (minutes)
- Peak timings
- Average riders
- CO2 saved per ride (kg)
- Category icon

### 4. Common Pickup Points (`lib/data/popular_routes.dart`)
**100+ Pre-configured Locations:**

#### Railway Stations:
- Western Line: Churchgate to Virar (24 stations)
- Central Line: CSMT to Dombivli (21 stations)
- Harbour Line: Chembur to Panvel (5 stations)

#### Metro Stations:
- Ghatkopar, Andheri, Versova, DN Nagar

#### Colleges & Universities:
- VESIT, IIT Bombay, VJTI, DJ Sanghvi, SPIT, KJ Somaiya, Mumbai University, NMIMS, Mithibai

#### Corporate Hubs:
- BKC, Lower Parel Tech Hub, SEEPZ, Powai Tech Park, Airoli IT Park, Navi Mumbai SEZ, Mindspace, Hiranandani Business Park

#### Airports:
- Mumbai Airport T1, T2

#### Malls & Shopping:
- Phoenix Marketcity, Inorbit Mall, Viviana Mall, R City Mall, Infinity Mall, Oberoi Mall

#### Hospitals:
- KEM Hospital, Sion Hospital, Lilavati Hospital, Hinduja Hospital, Fortis Hospital

#### Tourist Spots:
- Gateway of India, Marine Drive, Juhu Beach, Bandra Fort, Elephanta Caves Ferry Point

### 5. Enhanced Search Screen (`lib/screens/rides/search_rides_screen.dart`)
**New Features Added:**

#### Popular Routes Section:
- Displays top 6 most popular routes
- Shows rider count and CO2 savings
- Tap to auto-fill pickup/drop locations
- "View All Routes" button opens bottom sheet

#### Autocomplete for Locations:
- Real-time suggestions as you type
- Dropdown with matching locations
- 5 suggestions shown at a time
- Searches across 100+ pickup points
- Smart filtering by category

#### All Routes Bottom Sheet:
- Draggable scrollable sheet
- Lists all 16 popular routes
- Beautiful route cards with:
  - Category icon
  - Distance & time
  - Pickup/drop visualization
  - Peak timings
  - Average riders
  - CO2 savings
- Tap any route to auto-fill

#### Route Cards Display:
- Visual pickup/drop point indicator (green → red)
- Distance and time estimates
- Peak timing information
- Rider statistics
- Environmental impact (CO2)

### 6. Helper Functions
**Search & Filter:**
```dart
PopularRoutesData.getTopRoutes(limit: 5)
PopularRoutesData.getRoutesByOrganization('vesit')
PopularRoutesData.getRoutesByPickup('Chembur')
PopularRoutesData.searchRoutes('VESIT')
CommonPickupPoints.getSuggestions('Chembur', limit: 10)
CommonPickupPoints.getPointsByCategory('railway')
```

## User Flow

### Login Flow:
1. App opens → Splash Screen (3s)
2. → Login Screen
3. Select organization from dropdown
4. Enter email (validated against domain)
5. Enter password
6. Option A: Click "Login" → (Backend integration pending)
7. Option B: Click "Login with Face Verification"
   - → Face Verification Screen
   - Camera preview + scanning animation
   - Success → Navigate back
   - Snackbar confirmation

### Popular Routes Flow:
1. Login success → Navigate to Search Rides Screen
2. See popular routes section at top
3. Option A: Tap popular route chip → Auto-fills form
4. Option B: Type in location fields → Autocomplete suggestions appear
5. Option C: Tap "View All Routes" → Bottom sheet opens
6. Select route from sheet → Auto-fills + closes sheet
7. Select date/time + preferences
8. Tap "Search Rides" → Radar animation → Results

## Color Scheme
- Primary: Beige (#FAF9F6, #F5F5DC)
- Secondary: Orange (#FF8C42, #FF6B00)
- Accent: Green (eco indicators)
- Text: Dark Gray (#333333)

## Animations
- Login screen: Fade-in animation (800ms)
- Face verification: 
  - Scan line animation (2s repeat)
  - Pulse animation (1.5s)
  - Success state animation
- Popular routes: FadeInDown on appearance
- Route cards: Ink splash on tap

## Files Created
1. `lib/screens/auth/login_screen.dart` - Complete login UI
2. `lib/screens/auth/face_verification_screen.dart` - Face scan UI
3. `lib/data/popular_routes.dart` - Routes & pickup points data
4. `lib/widgets/popular_route_categories.dart` - Category filter chips

## Files Modified
1. `lib/main.dart` - Added login screen import
2. `lib/screens/splash_screen.dart` - Navigate to login instead of home
3. `lib/screens/rides/search_rides_screen.dart` - Added popular routes integration, autocomplete

## Backend Integration Points (TODO)
- [ ] Login API endpoint for email/password
- [ ] Face verification API with ML model
- [ ] JWT token storage and management
- [ ] Organization verification
- [ ] Popular routes API (currently using static data)
- [ ] Pickup points API with real-time location data
- [ ] User preferences storage

## Testing Checklist
- [x] Login screen displays correctly
- [x] Organization dropdown works
- [x] Email validation checks domain
- [x] Password show/hide toggle works
- [x] Face verification screen opens
- [x] Scanning animation runs smoothly
- [x] Popular routes display in search screen
- [x] Autocomplete suggestions appear
- [x] Tapping route auto-fills form
- [x] All routes bottom sheet opens
- [x] Route cards are interactive
- [x] App runs on Android emulator ✓

## Special Highlight: Chembur → VESIT Route
```dart
PopularRoute(
  id: 'chembur_vesit',
  name: 'Chembur to VESIT',
  pickupPoint: 'Chembur Railway Station',
  dropPoint: 'VESIT College, Chembur',
  icon: Icons.school,
  estimatedKm: 3.5,
  estimatedMinutes: 12,
  peakTimings: '7:30 AM - 9:30 AM',
  avgRiders: 45,
  co2SavedPerRide: 1.2,
)
```
This route appears in:
- Popular routes section (top 6 by rider count)
- VESIT organization filtered routes
- College category routes
- "Chembur" pickup point search
- "VESIT" general search

## Ready for Demo! 🎉
All features are fully functional in the UI. Backend integration can be added without modifying the UI structure.
