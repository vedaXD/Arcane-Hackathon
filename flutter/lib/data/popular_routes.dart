import 'package:flutter/material.dart';

class PopularRoute {
  final String id;
  final String name;
  final String pickupPoint;
  final String dropPoint;
  final IconData icon;
  final double estimatedKm;
  final int estimatedMinutes;
  final String peakTimings;
  final int avgRiders;
  final double co2SavedPerRide;

  const PopularRoute({
    required this.id,
    required this.name,
    required this.pickupPoint,
    required this.dropPoint,
    required this.icon,
    required this.estimatedKm,
    required this.estimatedMinutes,
    required this.peakTimings,
    required this.avgRiders,
    required this.co2SavedPerRide,
  });
}

class PopularRoutesData {
  static const List<PopularRoute> routes = [
    // VESIT College Routes
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
    ),
    PopularRoute(
      id: 'kurla_vesit',
      name: 'Kurla to VESIT',
      pickupPoint: 'Kurla Railway Station',
      dropPoint: 'VESIT College, Chembur',
      icon: Icons.school,
      estimatedKm: 5.2,
      estimatedMinutes: 18,
      peakTimings: '7:30 AM - 9:30 AM',
      avgRiders: 38,
      co2SavedPerRide: 1.8,
    ),
    PopularRoute(
      id: 'ghatkopar_vesit',
      name: 'Ghatkopar to VESIT',
      pickupPoint: 'Ghatkopar Railway Station',
      dropPoint: 'VESIT College, Chembur',
      icon: Icons.school,
      estimatedKm: 4.8,
      estimatedMinutes: 16,
      peakTimings: '7:30 AM - 9:30 AM',
      avgRiders: 32,
      co2SavedPerRide: 1.6,
    ),
    
    // IIT Bombay Routes
    PopularRoute(
      id: 'borivali_iitb',
      name: 'Borivali to IIT Bombay',
      pickupPoint: 'Borivali Railway Station',
      dropPoint: 'IIT Bombay, Powai',
      icon: Icons.account_balance,
      estimatedKm: 18.5,
      estimatedMinutes: 45,
      peakTimings: '7:00 AM - 9:00 AM',
      avgRiders: 52,
      co2SavedPerRide: 6.2,
    ),
    PopularRoute(
      id: 'andheri_iitb',
      name: 'Andheri to IIT Bombay',
      pickupPoint: 'Andheri Railway Station',
      dropPoint: 'IIT Bombay, Powai',
      icon: Icons.account_balance,
      estimatedKm: 12.3,
      estimatedMinutes: 32,
      peakTimings: '7:00 AM - 9:00 AM',
      avgRiders: 48,
      co2SavedPerRide: 4.1,
    ),
    
    // Corporate Routes - BKC
    PopularRoute(
      id: 'churchgate_bkc',
      name: 'Churchgate to BKC',
      pickupPoint: 'Churchgate Railway Station',
      dropPoint: 'Bandra Kurla Complex',
      icon: Icons.business,
      estimatedKm: 14.2,
      estimatedMinutes: 38,
      peakTimings: '8:00 AM - 10:30 AM',
      avgRiders: 65,
      co2SavedPerRide: 4.8,
    ),
    PopularRoute(
      id: 'andheri_bkc',
      name: 'Andheri to BKC',
      pickupPoint: 'Andheri Railway Station',
      dropPoint: 'Bandra Kurla Complex',
      icon: Icons.business,
      estimatedKm: 8.5,
      estimatedMinutes: 25,
      peakTimings: '8:00 AM - 10:30 AM',
      avgRiders: 58,
      co2SavedPerRide: 2.9,
    ),
    PopularRoute(
      id: 'thane_bkc',
      name: 'Thane to BKC',
      pickupPoint: 'Thane Railway Station',
      dropPoint: 'Bandra Kurla Complex',
      icon: Icons.business,
      estimatedKm: 16.8,
      estimatedMinutes: 42,
      peakTimings: '8:00 AM - 10:30 AM',
      avgRiders: 62,
      co2SavedPerRide: 5.6,
    ),
    
    // Corporate Routes - Lower Parel
    PopularRoute(
      id: 'dadar_lowerparel',
      name: 'Dadar to Lower Parel',
      pickupPoint: 'Dadar Railway Station',
      dropPoint: 'Lower Parel Tech Hub',
      icon: Icons.business_center,
      estimatedKm: 5.5,
      estimatedMinutes: 18,
      peakTimings: '8:30 AM - 10:30 AM',
      avgRiders: 44,
      co2SavedPerRide: 1.9,
    ),
    PopularRoute(
      id: 'mulund_lowerparel',
      name: 'Mulund to Lower Parel',
      pickupPoint: 'Mulund Railway Station',
      dropPoint: 'Lower Parel Tech Hub',
      icon: Icons.business_center,
      estimatedKm: 22.4,
      estimatedMinutes: 55,
      peakTimings: '8:30 AM - 10:30 AM',
      avgRiders: 38,
      co2SavedPerRide: 7.5,
    ),
    
    // Corporate Routes - Andheri SEEPZ
    PopularRoute(
      id: 'virar_seepz',
      name: 'Virar to SEEPZ',
      pickupPoint: 'Virar Railway Station',
      dropPoint: 'SEEPZ, Andheri',
      icon: Icons.work,
      estimatedKm: 45.2,
      estimatedMinutes: 90,
      peakTimings: '7:00 AM - 9:00 AM',
      avgRiders: 72,
      co2SavedPerRide: 15.2,
    ),
    PopularRoute(
      id: 'ghatkopar_seepz',
      name: 'Ghatkopar to SEEPZ',
      pickupPoint: 'Ghatkopar Railway Station',
      dropPoint: 'SEEPZ, Andheri',
      icon: Icons.work,
      estimatedKm: 12.8,
      estimatedMinutes: 35,
      peakTimings: '8:00 AM - 10:00 AM',
      avgRiders: 48,
      co2SavedPerRide: 4.3,
    ),
    
    // Airport Routes
    PopularRoute(
      id: 'andheri_airport',
      name: 'Andheri to Airport',
      pickupPoint: 'Andheri Railway Station',
      dropPoint: 'Mumbai Airport T2',
      icon: Icons.flight,
      estimatedKm: 4.2,
      estimatedMinutes: 15,
      peakTimings: 'All day',
      avgRiders: 28,
      co2SavedPerRide: 1.4,
    ),
    PopularRoute(
      id: 'bandra_airport',
      name: 'Bandra to Airport',
      pickupPoint: 'Bandra Railway Station',
      dropPoint: 'Mumbai Airport T2',
      icon: Icons.flight,
      estimatedKm: 6.8,
      estimatedMinutes: 22,
      peakTimings: 'All day',
      avgRiders: 32,
      co2SavedPerRide: 2.3,
    ),
    
    // Mall/Shopping Routes
    PopularRoute(
      id: 'dadar_phoenix',
      name: 'Dadar to Phoenix Mall',
      pickupPoint: 'Dadar Railway Station',
      dropPoint: 'Phoenix Marketcity, Kurla',
      icon: Icons.shopping_bag,
      estimatedKm: 6.2,
      estimatedMinutes: 20,
      peakTimings: '6:00 PM - 10:00 PM',
      avgRiders: 25,
      co2SavedPerRide: 2.1,
    ),
    PopularRoute(
      id: 'thane_viviana',
      name: 'Thane Station to Viviana Mall',
      pickupPoint: 'Thane Railway Station',
      dropPoint: 'Viviana Mall, Thane',
      icon: Icons.shopping_bag,
      estimatedKm: 4.5,
      estimatedMinutes: 14,
      peakTimings: '6:00 PM - 10:00 PM',
      avgRiders: 22,
      co2SavedPerRide: 1.5,
    ),
  ];

  // Get routes by organization
  static List<PopularRoute> getRoutesByOrganization(String organization) {
    switch (organization.toLowerCase()) {
      case 'vesit':
      case 'vesit.edu.in':
        return routes.where((route) => route.id.contains('vesit')).toList();
      case 'iit bombay':
      case 'iitb.ac.in':
        return routes.where((route) => route.id.contains('iitb')).toList();
      case 'tcs':
      case 'infosys':
      case 'reliance':
        return routes.where((route) => 
          route.id.contains('bkc') || 
          route.id.contains('lowerparel') || 
          route.id.contains('seepz')
        ).toList();
      default:
        return routes;
    }
  }

  // Get routes by pickup point
  static List<PopularRoute> getRoutesByPickup(String pickup) {
    return routes.where((route) => 
      route.pickupPoint.toLowerCase().contains(pickup.toLowerCase())
    ).toList();
  }

  // Get routes by drop point
  static List<PopularRoute> getRoutesByDrop(String drop) {
    return routes.where((route) => 
      route.dropPoint.toLowerCase().contains(drop.toLowerCase())
    ).toList();
  }

  // Get top routes by rider count
  static List<PopularRoute> getTopRoutes({int limit = 5}) {
    final sortedRoutes = List<PopularRoute>.from(routes);
    sortedRoutes.sort((a, b) => b.avgRiders.compareTo(a.avgRiders));
    return sortedRoutes.take(limit).toList();
  }

  // Get routes by icon/category
  static List<PopularRoute> getRoutesByCategory(IconData icon) {
    return routes.where((route) => route.icon == icon).toList();
  }

  // Search routes
  static List<PopularRoute> searchRoutes(String query) {
    final lowerQuery = query.toLowerCase();
    return routes.where((route) =>
      route.name.toLowerCase().contains(lowerQuery) ||
      route.pickupPoint.toLowerCase().contains(lowerQuery) ||
      route.dropPoint.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

// Common pickup points for autocomplete
class CommonPickupPoints {
  static const List<String> points = [
    // Railway Stations - Western Line
    'Churchgate Railway Station',
    'Marine Lines Railway Station',
    'Charni Road Railway Station',
    'Grant Road Railway Station',
    'Mumbai Central Railway Station',
    'Mahalaxmi Railway Station',
    'Lower Parel Railway Station',
    'Prabhadevi Railway Station',
    'Dadar Railway Station',
    'Matunga Road Railway Station',
    'Mahim Railway Station',
    'Bandra Railway Station',
    'Khar Road Railway Station',
    'Santacruz Railway Station',
    'Vile Parle Railway Station',
    'Andheri Railway Station',
    'Jogeshwari Railway Station',
    'Goregaon Railway Station',
    'Malad Railway Station',
    'Kandivali Railway Station',
    'Borivali Railway Station',
    'Dahisar Railway Station',
    'Mira Road Railway Station',
    'Virar Railway Station',
    
    // Railway Stations - Central Line
    'CSMT Railway Station',
    'Masjid Railway Station',
    'Sandhurst Road Railway Station',
    'Byculla Railway Station',
    'Chinchpokli Railway Station',
    'Curry Road Railway Station',
    'Parel Railway Station',
    'Dadar Railway Station',
    'Matunga Railway Station',
    'Sion Railway Station',
    'Kurla Railway Station',
    'Vidyavihar Railway Station',
    'Ghatkopar Railway Station',
    'Vikhroli Railway Station',
    'Kanjurmarg Railway Station',
    'Bhandup Railway Station',
    'Nahur Railway Station',
    'Mulund Railway Station',
    'Thane Railway Station',
    'Kalwa Railway Station',
    'Dombivli Railway Station',
    
    // Railway Stations - Harbour Line
    'Chembur Railway Station',
    'Mankhurd Railway Station',
    'Vashi Railway Station',
    'Nerul Railway Station',
    'Panvel Railway Station',
    
    // Metro Stations
    'Ghatkopar Metro Station',
    'Andheri Metro Station',
    'Versova Metro Station',
    'DN Nagar Metro Station',
    
    // Colleges & Universities
    'VESIT College, Chembur',
    'IIT Bombay, Powai',
    'VJTI College, Matunga',
    'DJ Sanghvi College, Vile Parle',
    'SPIT College, Andheri',
    'KJ Somaiya College, Vidyavihar',
    'Mumbai University, Kalina',
    'NMIMS, Vile Parle',
    'Mithibai College, Vile Parle',
    
    // Corporate Hubs
    'Bandra Kurla Complex',
    'Lower Parel Tech Hub',
    'SEEPZ, Andheri',
    'Powai Tech Park',
    'Airoli IT Park',
    'Navi Mumbai SEZ',
    'Mindspace, Malad',
    'Hiranandani Business Park, Powai',
    
    // Airports
    'Mumbai Airport T1',
    'Mumbai Airport T2',
    
    // Malls & Shopping
    'Phoenix Marketcity, Kurla',
    'Inorbit Mall, Malad',
    'Viviana Mall, Thane',
    'R City Mall, Ghatkopar',
    'Infinity Mall, Malad',
    'Oberoi Mall, Goregaon',
    
    // Hospitals
    'KEM Hospital, Parel',
    'Sion Hospital',
    'Lilavati Hospital, Bandra',
    'Hinduja Hospital, Mahim',
    'Fortis Hospital, Mulund',
    
    // Tourist Spots
    'Gateway of India',
    'Marine Drive',
    'Juhu Beach',
    'Bandra Fort',
    'Elephanta Caves Ferry Point',
  ];

  // Get suggestions based on input
  static List<String> getSuggestions(String query, {int limit = 10}) {
    if (query.isEmpty) return points.take(limit).toList();
    
    final lowerQuery = query.toLowerCase();
    return points
        .where((point) => point.toLowerCase().contains(lowerQuery))
        .take(limit)
        .toList();
  }

  // Get points by category
  static List<String> getPointsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'railway':
        return points.where((p) => p.contains('Railway Station')).toList();
      case 'metro':
        return points.where((p) => p.contains('Metro Station')).toList();
      case 'college':
        return points.where((p) => p.contains('College') || p.contains('University')).toList();
      case 'corporate':
        return points.where((p) => 
          p.contains('Complex') || 
          p.contains('Tech') || 
          p.contains('IT Park') ||
          p.contains('SEZ')
        ).toList();
      case 'mall':
        return points.where((p) => p.contains('Mall')).toList();
      case 'hospital':
        return points.where((p) => p.contains('Hospital')).toList();
      case 'airport':
        return points.where((p) => p.contains('Airport')).toList();
      default:
        return points;
    }
  }
}
