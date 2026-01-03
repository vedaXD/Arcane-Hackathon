import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class TripService {
  final AuthService _authService = AuthService();

  // Create a new trip
  Future<Map<String, dynamic>> createTrip(Trip trip, {int? vehicleId}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final tripData = trip.toJson();
      if (vehicleId != null) {
        tripData['vehicle'] = vehicleId;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.trips),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(tripData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'trip': Trip.fromJson(data)};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Failed to create trip'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get all trips
  Future<Map<String, dynamic>> getTrips({String? status}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      var url = ApiConfig.trips;
      if (status != null) {
        url += '?status=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final trips = data.map((json) => Trip.fromJson(json)).toList();
        return {'success': true, 'trips': trips};
      } else {
        return {'success': false, 'message': 'Failed to fetch trips'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Search trips
  Future<Map<String, dynamic>> searchTrips({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    DateTime? departureTime,
    int? seatsNeeded,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final body = {
        'start_latitude': startLatitude,
        'start_longitude': startLongitude,
        'end_latitude': endLatitude,
        'end_longitude': endLongitude,
        if (departureTime != null) 'departure_time': departureTime.toIso8601String(),
        if (seatsNeeded != null) 'seats_needed': seatsNeeded,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.tripsSearch),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final trips = data.map((json) => Trip.fromJson(json)).toList();
        return {'success': true, 'trips': trips};
      } else {
        return {'success': false, 'message': 'Search failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get trip details
  Future<Map<String, dynamic>> getTripDetails(int tripId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.tripDetail(tripId)),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'trip': Trip.fromJson(data)};
      } else {
        return {'success': false, 'message': 'Failed to fetch trip details'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Request to join a trip
  Future<Map<String, dynamic>> requestTrip({
    required int tripId,
    required int seatsRequested,
    String? message,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(ApiConfig.tripRequests),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode({
          'trip': tripId,
          'seats_requested': seatsRequested,
          if (message != null) 'message': message,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'request': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Failed to request trip'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get upcoming trips
  Future<Map<String, dynamic>> getUpcomingTrips() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.tripsUpcoming),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final trips = data.map((json) => Trip.fromJson(json)).toList();
        return {'success': true, 'trips': trips};
      } else {
        return {'success': false, 'message': 'Failed to fetch upcoming trips'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
