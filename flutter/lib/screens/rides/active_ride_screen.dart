import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';
import '../payment/ride_payment_screen.dart';
import 'post_ride_feedback_screen.dart';

class ActiveRideScreen extends StatefulWidget {
  final String mode; // 'auto' or 'carpooling'
  final String pickup;
  final String dropoff;
  final List<Map<String, dynamic>> ridemates;

  const ActiveRideScreen({
    Key? key,
    required this.mode,
    required this.pickup,
    required this.dropoff,
    required this.ridemates,
  }) : super(key: key);

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _rideStarted = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Simulate ride progress
    _simulateRideProgress();
  }

  void _simulateRideProgress() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _rideStarted = true);
        _startProgressSimulation();
      }
    });
  }

  void _startProgressSimulation() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _progress < 1.0) {
        setState(() => _progress += 0.1);
        _startProgressSimulation();
      } else if (_progress >= 1.0) {
        _completeRide();
      }
    });
  }

  void _completeRide() {
    // Navigate to payment screen (only for auto-rickshaw)
    if (widget.mode == 'auto') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RidePaymentScreen(
            ridemates: widget.ridemates,
            distance: 5.2,
            co2Saved: 2.5,
            mode: widget.mode,
            pickupLocation: widget.pickupLocation,
            dropoffLocation: widget.dropoffLocation,
          ),
        ),
      );
    } else {
      // For carpooling, show completion dialog (no payment)
      _showCarpoolCompletionDialog();
    }
  }

  void _showCarpoolCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInDown(
              child: Icon(
                Icons.check_circle,
                color: AppTheme.ecoGreen,
                size: 80,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ride Complete! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'You saved the planet together!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.ecoGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CO₂ Saved:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('2.5 kg', style: TextStyle(color: AppTheme.ecoGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Distance:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('5.2 km', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No payment needed! 🌱',
              style: TextStyle(
                color: AppTheme.ecoGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.ecoGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_rideStarted ? 'Ride in Progress' : 'Starting Ride...'),
        backgroundColor: widget.mode == 'auto' ? AppTheme.primaryOrange : AppTheme.ecoGreen,
      ),
      body: Stack(
        children: [
          // Map placeholder with animation
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[100]!,
                  Colors.blue[50]!,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeIn(
                    child: Icon(
                      Icons.map,
                      size: 120,
                      color: Colors.blue[300],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.pickup} → ${widget.dropoff}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Bottom sheet with ride details
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeInUp(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    if (_rideStarted) ...[
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppTheme.ecoGreen, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '${(_progress * 100).toInt()}% Complete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[200],
                          color: widget.mode == 'auto' ? AppTheme.primaryOrange : AppTheme.ecoGreen,
                          minHeight: 10,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Ridemates list
                    Text(
                      'Your Squad 🚗',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...widget.ridemates.map((mate) => _buildRidemateCard(mate)).toList(),

                    SizedBox(height: 20),

                    // Status message
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _rideStarted
                            ? AppTheme.ecoGreen.withOpacity(0.1)
                            : AppTheme.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) => Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.2),
                              child: Icon(
                                _rideStarted ? Icons.directions_car : Icons.timer,
                                color: _rideStarted ? AppTheme.ecoGreen : AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _rideStarted
                                  ? 'Ride in progress... Stay safe!'
                                  : 'Waiting for everyone to join...',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _rideStarted ? AppTheme.ecoGreen : AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRidemateCard(Map<String, dynamic> mate) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: widget.mode == 'auto' ? AppTheme.primaryOrange.withOpacity(0.2) : AppTheme.ecoGreen.withOpacity(0.2),
            child: Text(
              mate['avatar'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.mode == 'auto' ? AppTheme.primaryOrange : AppTheme.ecoGreen,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mate['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  mate['distance'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text(
                mate['rating'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
