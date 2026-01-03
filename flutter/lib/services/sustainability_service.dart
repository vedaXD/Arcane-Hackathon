import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class SustainabilityService {
  final AuthService _authService = AuthService();

  // Get sustainability dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.sustainabilityDashboard),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch dashboard'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get user sustainability metrics
  Future<Map<String, dynamic>> getMetrics() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.sustainabilityMetrics),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'metrics': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch metrics'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}

class RewardsService {
  final AuthService _authService = AuthService();

  // Get rewards balance
  Future<Map<String, dynamic>> getBalance() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.rewardsBalance),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'balance': data['balance']};
      } else {
        return {'success': false, 'message': 'Failed to fetch balance'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get transaction history
  Future<Map<String, dynamic>> getTransactions() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.rewardsTransactions),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {'success': true, 'transactions': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch transactions'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
