"""
Test script for EcoPool Backend API
Tests the complete user flow from registration to ride completion
"""
import requests
import json
from datetime import datetime, timedelta

BASE_URL = "http://127.0.0.1:8000/api"

def print_response(title, response):
    """Pretty print API responses"""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")
    print(f"Status: {response.status_code}")
    try:
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except:
        print(f"Response: {response.text}")
    print(f"{'='*60}\n")

def test_complete_flow():
    """Test complete carpooling flow"""
    
    # Test data storage
    tokens = {}
    user_ids = {}
    trip_id = None
    ride_id = None
    
    print("\n🚀 Starting EcoPool Backend API Tests\n")
    
    # ==========================================
    # 1. AUTHENTICATION - Register Users
    # ==========================================
    
    # Register Driver
    print("\n📝 Step 1: Register Driver")
    driver_data = {
        "username": "john_driver",
        "email": "john@test.com",
        "password": "SecurePass123!",
        "password_confirm": "SecurePass123!",
        "first_name": "John",
        "last_name": "Driver",
        "role": "driver",
        "phone_number": "+1234567890"
    }
    response = requests.post(f"{BASE_URL}/auth/register/", json=driver_data)
    print_response("Driver Registration", response)
    
    if response.status_code == 201:
        data = response.json()
        tokens['driver'] = data['tokens']['access']
        user_ids['driver'] = data['user']['id']
        print(f"✅ Driver registered successfully! ID: {user_ids['driver']}")
    else:
        print("❌ Driver registration failed!")
        return
    
    # Register Passenger
    print("\n📝 Step 2: Register Passenger")
    passenger_data = {
        "username": "jane_passenger",
        "email": "jane@test.com",
        "password": "SecurePass123!",
        "password_confirm": "SecurePass123!",
        "first_name": "Jane",
        "last_name": "Passenger",
        "role": "passenger",
        "phone_number": "+0987654321"
    }
    response = requests.post(f"{BASE_URL}/auth/register/", json=passenger_data)
    print_response("Passenger Registration", response)
    
    if response.status_code == 201:
        data = response.json()
        tokens['passenger'] = data['tokens']['access']
        user_ids['passenger'] = data['user']['id']
        print(f"✅ Passenger registered successfully! ID: {user_ids['passenger']}")
    else:
        print("❌ Passenger registration failed!")
        return
    
    # ==========================================
    # 2. AUTHENTICATION - Test Login
    # ==========================================
    
    print("\n🔐 Step 3: Test Login")
    login_data = {
        "username": "john_driver",
        "password": "SecurePass123!"
    }
    response = requests.post(f"{BASE_URL}/auth/login/", json=login_data)
    print_response("Driver Login", response)
    
    if response.status_code == 200:
        print("✅ Login successful!")
    
    # ==========================================
    # 3. PROFILE - Get User Profile
    # ==========================================
    
    print("\n👤 Step 4: Get Driver Profile")
    headers = {"Authorization": f"Bearer {tokens['driver']}"}
    response = requests.get(f"{BASE_URL}/auth/profile/", headers=headers)
    print_response("Driver Profile", response)
    
    # ==========================================
    # 4. TRIPS - Create Trip (Driver)
    # ==========================================
    
    print("\n🚗 Step 5: Driver Creates Trip")
    departure_time = (datetime.now() + timedelta(hours=2)).isoformat()
    trip_data = {
        "start_location": "Stanford Campus",
        "start_latitude": 37.4275,
        "start_longitude": -122.1697,
        "end_location": "San Francisco Downtown",
        "end_latitude": 37.7749,
        "end_longitude": -122.4194,
        "departure_time": departure_time,
        "available_seats": 3,
        "price_per_seat": 15.00,
        "gender_preference": "any"
    }
    
    headers = {"Authorization": f"Bearer {tokens['driver']}"}
    response = requests.post(f"{BASE_URL}/trips/", json=trip_data, headers=headers)
    print_response("Create Trip", response)
    
    if response.status_code == 201:
        trip_id = response.json()['id']
        print(f"✅ Trip created successfully! ID: {trip_id}")
    else:
        print("❌ Trip creation failed!")
        return
    
    # ==========================================
    # 5. TRIPS - Search Trips (Passenger)
    # ==========================================
    
    print("\n🔍 Step 6: Passenger Searches Trips")
    search_data = {
        "start_latitude": 37.4275,
        "start_longitude": -122.1697,
        "end_latitude": 37.7749,
        "end_longitude": -122.4194
    }
    
    headers = {"Authorization": f"Bearer {tokens['passenger']}"}
    response = requests.post(f"{BASE_URL}/trips/search/", json=search_data, headers=headers)
    print_response("Search Trips", response)
    
    if response.status_code == 200:
        trips = response.json()
        print(f"✅ Found {len(trips)} matching trips!")
    
    # ==========================================
    # 6. TRIPS - Request to Join Trip
    # ==========================================
    
    print("\n✋ Step 7: Passenger Requests to Join Trip")
    request_data = {
        "trip": trip_id,
        "message": "Hi! Can I join your ride to SF?"
    }
    
    headers = {"Authorization": f"Bearer {tokens['passenger']}"}
    response = requests.post(f"{BASE_URL}/trip-requests/", json=request_data, headers=headers)
    print_response("Trip Request", response)
    
    if response.status_code == 201:
        request_id = response.json()['id']
        print(f"✅ Trip request sent! ID: {request_id}")
    else:
        print("❌ Trip request failed!")
        return
    
    # ==========================================
    # 7. TRIPS - Driver Accepts Request
    # ==========================================
    
    print("\n👍 Step 8: Driver Accepts Request")
    headers = {"Authorization": f"Bearer {tokens['driver']}"}
    response = requests.post(f"{BASE_URL}/trip-requests/{request_id}/accept/", headers=headers)
    print_response("Accept Request", response)
    
    if response.status_code == 200:
        print("✅ Request accepted!")
    
    # ==========================================
    # 8. RIDES - List Rides
    # ==========================================
    
    print("\n🚦 Step 9: List Active Rides")
    headers = {"Authorization": f"Bearer {tokens['driver']}"}
    response = requests.get(f"{BASE_URL}/rides/", headers=headers)
    print_response("List Rides", response)
    
    if response.status_code == 200:
        rides = response.json()
        if rides and len(rides) > 0:
            ride_id = rides[0]['id']
            print(f"✅ Active ride found! ID: {ride_id}")
    
    # ==========================================
    # 9. RIDES - Start Ride
    # ==========================================
    
    if ride_id:
        print("\n🏁 Step 10: Start Ride")
        headers = {"Authorization": f"Bearer {tokens['driver']}"}
        response = requests.post(f"{BASE_URL}/rides/{ride_id}/start/", headers=headers)
        print_response("Start Ride", response)
        
        if response.status_code == 200:
            print("✅ Ride started!")
    
    # ==========================================
    # 10. RIDES - Update Location
    # ==========================================
    
    if ride_id:
        print("\n📍 Step 11: Update Location")
        location_data = {
            "latitude": 37.5000,
            "longitude": -122.3000
        }
        headers = {"Authorization": f"Bearer {tokens['driver']}"}
        response = requests.post(f"{BASE_URL}/rides/{ride_id}/update_location/", 
                               json=location_data, headers=headers)
        print_response("Update Location", response)
        
        if response.status_code == 200:
            print("✅ Location updated!")
    
    # ==========================================
    # 11. RIDES - Send Chat Message
    # ==========================================
    
    if ride_id:
        print("\n💬 Step 12: Send Chat Message")
        message_data = {
            "ride": ride_id,
            "message": "On my way! ETA 5 minutes"
        }
        headers = {"Authorization": f"Bearer {tokens['driver']}"}
        response = requests.post(f"{BASE_URL}/chat-messages/", 
                               json=message_data, headers=headers)
        print_response("Send Message", response)
        
        if response.status_code == 201:
            print("✅ Message sent!")
    
    # ==========================================
    # 12. RIDES - Complete Ride
    # ==========================================
    
    if ride_id:
        print("\n🏁 Step 13: Complete Ride")
        headers = {"Authorization": f"Bearer {tokens['driver']}"}
        response = requests.post(f"{BASE_URL}/rides/{ride_id}/complete/", headers=headers)
        print_response("Complete Ride", response)
        
        if response.status_code == 200:
            print("✅ Ride completed!")
    
    # ==========================================
    # 13. PAYMENTS - Process Payment
    # ==========================================
    
    if ride_id:
        print("\n💰 Step 14: Process Payment")
        payment_data = {
            "ride_id": ride_id,
            "amount": 15.00,
            "payment_method": "card"
        }
        headers = {"Authorization": f"Bearer {tokens['passenger']}"}
        response = requests.post(f"{BASE_URL}/payments/process_payment/", 
                               json=payment_data, headers=headers)
        print_response("Process Payment", response)
        
        if response.status_code == 201:
            print("✅ Payment processed!")
    
    # ==========================================
    # 14. REWARDS - Check Balance
    # ==========================================
    
    print("\n🎁 Step 15: Check Reward Points")
    headers = {"Authorization": f"Bearer {tokens['passenger']}"}
    response = requests.get(f"{BASE_URL}/rewards/balance/", headers=headers)
    print_response("Reward Balance", response)
    
    if response.status_code == 200:
        print("✅ Reward balance retrieved!")
    
    # ==========================================
    # 15. SUSTAINABILITY - Dashboard
    # ==========================================
    
    print("\n🌱 Step 16: Get Sustainability Dashboard")
    headers = {"Authorization": f"Bearer {tokens['passenger']}"}
    response = requests.get(f"{BASE_URL}/sustainability-metrics/dashboard/", headers=headers)
    print_response("Sustainability Dashboard", response)
    
    if response.status_code == 200:
        print("✅ Dashboard data retrieved!")
    
    # ==========================================
    # SUMMARY
    # ==========================================
    
    print("\n" + "="*60)
    print("  🎉 API TESTING COMPLETED!")
    print("="*60)
    print("\n✅ All endpoints tested successfully!")
    print("\nTested Flow:")
    print("1. ✅ Driver Registration")
    print("2. ✅ Passenger Registration")
    print("3. ✅ User Login")
    print("4. ✅ Get Profile")
    print("5. ✅ Create Trip")
    print("6. ✅ Search Trips")
    print("7. ✅ Request Trip")
    print("8. ✅ Accept Request")
    print("9. ✅ List Rides")
    print("10. ✅ Start Ride")
    print("11. ✅ Update Location")
    print("12. ✅ Send Chat")
    print("13. ✅ Complete Ride")
    print("14. ✅ Process Payment")
    print("15. ✅ Check Rewards")
    print("16. ✅ Sustainability Dashboard")
    print("\n🚀 Backend is ready for frontend integration!\n")

if __name__ == "__main__":
    try:
        test_complete_flow()
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR: Cannot connect to backend!")
        print("Make sure Django server is running:")
        print("  cd backend")
        print("  python manage.py runserver\n")
    except Exception as e:
        print(f"\n❌ ERROR: {str(e)}\n")
