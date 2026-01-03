import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import 'ride_chat_room_screen.dart';

class RouteOptimizationScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final List<Map<String, dynamic>> passengers;

  const RouteOptimizationScreen({
    Key? key,
    required this.tripData,
    required this.passengers,
  }) : super(key: key);

  @override
  State<RouteOptimizationScreen> createState() => _RouteOptimizationScreenState();
}

class _RouteOptimizationScreenState extends State<RouteOptimizationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isOptimizing = true;
  bool _showOptimizedRoute = false;

  // Static coordinates for the route
  static const LatLng _chemburStation = LatLng(19.063056, 72.900556);
  static const LatLng _vesitCollege = LatLng(19.046111, 72.887222);
  static const LatLng _kurlaStation = LatLng(19.0728, 72.8794);
  static const LatLng _sionStation = LatLng(19.0434, 72.8618);

  List<LatLng> _optimizedRoute = [];
  List<Map<String, dynamic>> _routeStops = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _initializeRoute();
    _startOptimization();
  }

  void _initializeRoute() {
    // Hardcoded optimized route with multiple stops
    _optimizedRoute = [
      _chemburStation, // Start: Chembur Station
      _kurlaStation,   // Stop 1: Kurla Station (pickup passenger)
      _sionStation,    // Stop 2: Sion Station (pickup passenger)
      _vesitCollege,   // Final: VESIT College
    ];

    _routeStops = [
      {
        'location': 'Chembur Railway Station',
        'coordinates': _chemburStation,
        'type': 'start',
        'time': '9:00 AM',
        'passengers': ['You'],
        'icon': Icons.play_circle_filled,
        'color': AppTheme.ecoGreen,
      },
      {
        'location': 'Kurla Railway Station',
        'coordinates': _kurlaStation,
        'type': 'pickup',
        'time': '9:08 AM',
        'passengers': ['Rahul S.', 'Priya M.'],
        'icon': Icons.person_add,
        'color': AppTheme.primaryOrange,
      },
      {
        'location': 'Sion Railway Station',
        'coordinates': _sionStation,
        'type': 'pickup',
        'time': '9:15 AM',
        'passengers': ['Amit K.'],
        'icon': Icons.person_add,
        'color': AppTheme.primaryOrange,
      },
      {
        'location': 'VESIT College',
        'coordinates': _vesitCollege,
        'type': 'destination',
        'time': '9:22 AM',
        'passengers': [],
        'icon': Icons.location_on,
        'color': Colors.red,
      },
    ];
  }

  void _startOptimization() {
    _animationController.forward();
    
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isOptimizing = false;
        _showOptimizedRoute = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Route Optimization'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_showOptimizedRoute)
            TextButton(
              onPressed: _startRide,
              child: Text(
                'Start Ride',
                style: TextStyle(
                  color: AppTheme.ecoGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _isOptimizing ? _buildOptimizingView() : _buildOptimizedRouteView(),
    );
  }

  Widget _buildOptimizingView() {
    return FadeIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optimization Animation
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.ecoGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 6.28,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.ecoGreen,
                              AppTheme.ecoGreen.withOpacity(0.3),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.route,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Optimizing Route...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptimizationStep('📍 Analyzing pickup points', true),
                  _buildOptimizationStep('🛣️ Calculating best routes', true),
                  _buildOptimizationStep('⏱️ Optimizing travel time', true),
                  _buildOptimizationStep('💰 Minimizing fuel costs', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationStep(String text, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? AppTheme.ecoGreen : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? AppTheme.darkGray : Colors.grey,
              fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedRouteView() {
    return FadeIn(
      child: Column(
        children: [
          // Route Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.ecoGreen, AppTheme.ecoGreen.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ecoGreen.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Route Optimized!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('⏱️', '22 min', 'Total Time'),
                    _buildSummaryItem('📏', '8.5 km', 'Distance'),
                    _buildSummaryItem('👥', '4', 'Passengers'),
                    _buildSummaryItem('💰', '₹30', 'Per Person'),
                  ],
                ),
              ],
            ),
          ),
          
          // Map View
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(19.055, 72.890),
                    zoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.ecopool',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _optimizedRoute,
                          color: AppTheme.ecoGreen,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: _routeStops.map((stop) {
                        return Marker(
                          point: stop['coordinates'],
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: stop['color'],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              stop['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Route Steps
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _routeStops.length,
                      itemBuilder: (context, index) {
                        final stop = _routeStops[index];
                        final isLast = index == _routeStops.length - 1;
                        
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: stop['color'],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    stop['icon'],
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        stop['time'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.ecoGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (stop['passengers'].isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: stop['color'].withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${stop['passengers'].length}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: stop['color'],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    stop['location'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.darkGray,
                                    ),
                                  ),
                                  if (stop['passengers'].isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      children: stop['passengers'].map<Widget>((passenger) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            passenger,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                  if (!isLast) const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _startRide() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RideChatRoomScreen(
          ridemates: [
            {'name': 'Rahul S.', 'rating': 4.8, 'trips': 45},
            {'name': 'Priya M.', 'rating': 4.9, 'trips': 32},
            {'name': 'Amit K.', 'rating': 4.7, 'trips': 28},
          ],
          mode: 'driver',
          pickup: 'Chembur Railway Station',
          dropoff: 'VESIT College',
          pickupLocation: 'Chembur Railway Station',
          dropoffLocation: 'VESIT College',
        ),
      ),
    );
  }
}