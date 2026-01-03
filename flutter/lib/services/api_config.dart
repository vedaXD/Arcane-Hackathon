class ApiConfig {
  // Base URL - Change this to your backend URL
  static const String baseUrl = 'http://192.168.29.107:8000';
  static const String apiUrl = '$baseUrl/api';
  
  // API Endpoints
  static const String authRegister = '$apiUrl/auth/register/';
  static const String authLogin = '$apiUrl/auth/login/';
  static const String authProfile = '$apiUrl/auth/profile/';
  static const String authLogout = '$apiUrl/auth/logout/';
  
  // Vehicles
  static const String vehicles = '$apiUrl/vehicles/';
  static String vehicleDetail(int id) => '$apiUrl/vehicles/$id/';
  
  // Trips
  static const String trips = '$apiUrl/trips/';
  static String tripDetail(int id) => '$apiUrl/trips/$id/';
  static const String tripsSearch = '$apiUrl/trips/search/';
  static const String tripsUpcoming = '$apiUrl/trips/upcoming/';
  static String tripAcceptRequest(int tripId) => '$apiUrl/trips/$tripId/accept_request/';
  
  // Trip Requests
  static const String tripRequests = '$apiUrl/trip-requests/';
  static String tripRequestDetail(int id) => '$apiUrl/trip-requests/$id/';
  
  // Rides
  static const String rides = '$apiUrl/rides/';
  static String rideDetail(int id) => '$apiUrl/rides/$id/';
  static String rideStart(int rideId) => '$apiUrl/rides/$rideId/start/';
  static String rideComplete(int rideId) => '$apiUrl/rides/$rideId/complete/';
  static String rideCancel(int rideId) => '$apiUrl/rides/$rideId/cancel/';
  static String rideUpdateLocation(int rideId) => '$apiUrl/rides/$rideId/update_location/';
  
  // SOS Alerts
  static const String sosAlerts = '$apiUrl/sos-alerts/';
  static String sosAlertDetail(int id) => '$apiUrl/sos-alerts/$id/';
  
  // Chat Messages
  static const String chatMessages = '$apiUrl/chat-messages/';
  static String rideChatMessages(int rideId) => '$apiUrl/rides/$rideId/messages/';
  
  // Feedback
  static const String feedback = '$apiUrl/feedback/';
  
  // Complaints
  static const String complaints = '$apiUrl/complaints/';
  
  // Payments
  static const String payments = '$apiUrl/payments/';
  static String paymentDetail(int id) => '$apiUrl/payments/$id/';
  
  // Rewards
  static const String rewardsBalance = '$apiUrl/rewards/balance/';
  static const String rewardsTransactions = '$apiUrl/rewards/transactions/';
  
  // Sustainability
  static const String sustainabilityDashboard = '$apiUrl/sustainability-metrics/dashboard/';
  static const String sustainabilityMetrics = '$apiUrl/sustainability-metrics/';
  
  // Headers
  static Map<String, String> headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}
