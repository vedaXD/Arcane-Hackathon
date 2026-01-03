import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class VehicleService {
  final AuthService _authService = AuthService();

  // Create a new vehicle
  Future<Map<String, dynamic>> createVehicle(Vehicle vehicle) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.post(
        Uri.parse(ApiConfig.vehicles),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(vehicle.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'vehicle': Vehicle.fromJson(data)};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Failed to create vehicle'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get all vehicles (user's vehicles)
  Future<Map<String, dynamic>> getVehicles() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.vehicles),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
        return {'success': true, 'vehicles': vehicles};
      } else {
        return {'success': false, 'message': 'Failed to fetch vehicles'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get vehicle details
  Future<Map<String, dynamic>> getVehicleDetails(int vehicleId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.vehicleDetail(vehicleId)),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'vehicle': Vehicle.fromJson(data)};
      } else {
        return {'success': false, 'message': 'Failed to fetch vehicle details'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update vehicle
  Future<Map<String, dynamic>> updateVehicle(int vehicleId, Vehicle vehicle) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.put(
        Uri.parse(ApiConfig.vehicleDetail(vehicleId)),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(vehicle.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'vehicle': Vehicle.fromJson(data)};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Failed to update vehicle'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Delete vehicle
  Future<Map<String, dynamic>> deleteVehicle(int vehicleId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.delete(
        Uri.parse(ApiConfig.vehicleDetail(vehicleId)),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 204) {
        return {'success': true, 'message': 'Vehicle deleted successfully'};
      } else {
        return {'success': false, 'message': 'Failed to delete vehicle'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
