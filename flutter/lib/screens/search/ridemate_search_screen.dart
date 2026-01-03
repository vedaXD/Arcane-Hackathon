import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class RideMateSearchScreen extends StatefulWidget {
  const RideMateSearchScreen({Key? key}) : super(key: key);

  @override
  State<RideMateSearchScreen> createState() => _RideMateSearchScreenState();
}

class _RideMateSearchScreenState extends State<RideMateSearchScreen>
    with TickerProviderStateMixin {
  String? _selectedMode;
  String? _selectedPickup;
  String? _selectedDropoff;
  bool _scheduleForLater = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  late AnimationController _radialController;
  late AnimationController _pulseController;
  bool _isSearching = false;
  List<Map<String, dynamic>> _foundRidemates = [];
  
  // VESIT Organization Locations
  final List<String> _vesitLocations = [
    'College Campus 2',
    'Chembur Railway Station',
    'Kurla Railway Station',
  ];

  @override
  void initState() {
    super.initState();
    _radialController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _radialController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startSearch(String mode) {
    if (_selectedPickup == null || _selectedDropoff == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select pickup and drop-off locations'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _selectedMode = mode;
      _isSearching = true;
      _foundRidemates = [];
    });

    // Start animations
    _radialController.repeat();
    _pulseController.repeat(reverse: true);

    if (mode == 'auto') {
      // AUTO-RICKSHAW POOLING: Match with 3 people going to SAME destination
      // Backend matchmaking: same gender (priority) + exact same route
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Arjun K.',
              'rating': 4.8,
              'distance': '500m away',
              'avatar': 'A',
              'gender': 'Male',
              'location': '$_selectedPickup → $_selectedDropoff',
            });
          });
        }
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Priya S.',
              'rating': 4.9,
              'distance': '1.2km away',
              'avatar': 'P',
              'gender': 'Female',
              'location': '$_selectedPickup → $_selectedDropoff',
            });
          });
        }
      });

      Future.delayed(const Duration(milliseconds: 5000), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Rahul M.',
              'rating': 4.7,
              'distance': '800m away',
              'avatar': 'R',
              'gender': 'Male',
              'location': '$_selectedPickup → $_selectedDropoff',
            });
          });
          _radialController.stop();
          _pulseController.stop();
          _isSearching = false;
          
          // Show chat room option for AUTO pooling
          _showChatRoomDialog();
        }
      });
    } else {
      // CARPOOLING: Match with people who are BETWEEN start and destination path
      // Backend matchmaking: same gender (priority) + people along the route
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Neha D.',
              'rating': 4.9,
              'distance': '300m from pickup',
              'avatar': 'N',
              'gender': 'Female',
              'location': 'Near $_selectedPickup',
              'pickupPoint': 'Waiting near $_selectedPickup',
            });
          });
        }
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Vikram S.',
              'rating': 4.8,
              'distance': 'Along route',
              'avatar': 'V',
              'gender': 'Male',
              'location': 'Midway point',
              'pickupPoint': 'On path between locations',
            });
          });
        }
      });

      Future.delayed(const Duration(milliseconds: 5000), () {
        if (mounted) {
          setState(() {
            _foundRidemates.add({
              'name': 'Anjali P.',
              'rating': 4.7,
              'distance': '600m from route',
              'avatar': 'A',
              'gender': 'Female',
              'location': 'Near $_selectedDropoff',
              'pickupPoint': 'Close to destination',
            });
          });
          _radialController.stop();
          _pulseController.stop();
          _isSearching = false;
          
          // Show chat room option for carpooling too
          _showChatRoomDialog();
        }
      });
    }
  }
            'gender': 'Male',
          });
        });
        _radialController.stop();
        _pulseController.stop();
        _isSearching = false;
        
        // Show chat room option for AUTO pooling
        _showChatRoomDialog();
      }
    });
  }
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _foundRidemates.add({
            'name': 'Arjun K.',
            'rating': 4.8,
            'distance': '500m away',
            'avatar': 'A',
          });
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _foundRidemates.add({
            'name': 'Priya S.',
            'rating': 4.9,
            'distance': '1.2km away',
            'avatar': 'P',
          });
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _foundRidemates.add({
            'name': 'Rahul M.',
            'rating': 4.7,
            'distance': '800m away',
            'avatar': 'R',
          });
        });
        _radialController.stop();
        _pulseController.stop();
        _isSearching = false;
        
        // Show chat room option
        _showChatRoomDialog();
      }
    });
  }

  void _showChatRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeInUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('Match Found!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Found ${_foundRidemates.length} ride-mates going your way!',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.chat_bubble, color: Colors.green, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      '24-Hour Chat Room',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coordinate with your ride-mates!',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to chat room
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening chat room...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Open Chat'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Ride-Mates',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isSearching ? _buildSearchingView() : _buildSelectionView(),
    );
  }

  Widget _buildSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: const Text(
              'Choose Your Vibe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Pick how you wanna roll today',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Location Selection Card
          FadeInDown(
            delay: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Where are you going?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPickup,
                    decoration: InputDecoration(
                      labelText: 'Pickup Location',
                      prefixIcon: const Icon(Icons.my_location, color: Colors.green),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _vesitLocations.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedPickup = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedDropoff,
                    decoration: InputDecoration(
                      labelText: 'Drop-off Location',
                      prefixIcon: const Icon(Icons.location_on, color: Colors.orange),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _vesitLocations.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedDropoff = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Schedule Time Option Card
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.orange.shade700, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _scheduleForLater ? 'Scheduled' : 'Now (default)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Switch(
                    value: _scheduleForLater,
                    onChanged: (value) async {
                      if (value) {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (time != null) {
                            setState(() {
                              _scheduleForLater = true;
                              _selectedDate = date;
                              _selectedTime = time;
                            });
                          }
                        }
                      } else {
                        setState(() => _scheduleForLater = false);
                      }
                    },
                    activeColor: Colors.orange.shade700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Mode Selection Title
          FadeInDown(
            delay: const Duration(milliseconds: 250),
            child: const Text(
              'Choose Your Vibe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 300),
            child: Text(
              'Pick how you wanna roll today',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Carpooling Option
          FadeInLeft(
            delay: const Duration(milliseconds: 200),
            child: _buildRideOption(
              mode: 'carpooling',
              icon: Icons.directions_car,
              title: 'Carpooling',
              tagline: 'Slay the commute, split the bills 💅',
              gradient: [Colors.green.shade400, Colors.green.shade600],
              emoji: '🚗',
            ),
          ),
          const SizedBox(height: 24),

          // Auto-Rickshaw Option
          FadeInRight(
            delay: const Duration(milliseconds: 300),
            child: _buildRideOption(
              mode: 'auto',
              icon: Icons.local_taxi,
              title: 'Auto Pooling',
              tagline: 'Squad up & save that drip money 🛺',
              gradient: [Colors.orange.shade400, Colors.deepOrange.shade600],
              emoji: '🛺',
            ),
          ),
          const SizedBox(height: 40),

          // Info Card
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Tip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Auto pooling is perfect when you don\'t have a car but still wanna save & go green! 🌱',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
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

  Widget _buildRideOption({
    required String mode,
    required IconData icon,
    required String title,
    required String tagline,
    required List<Color> gradient,
    required String emoji,
  }) {
    return GestureDetector(
      onTap: () => _startSearch(mode),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.2,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'FAST MATCH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tagline,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Let\'s Go',
                                style: TextStyle(
                                  color: gradient[1],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: gradient[1]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchingView() {
    return Stack(
      children: [
        // Radial Search Animation (like Ola)
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _radialController,
            builder: (context, child) {
              return CustomPaint(
                painter: RadialSearchPainter(
                  progress: _radialController.value,
                  color: _selectedMode == 'auto' ? Colors.orange : Colors.green,
                ),
              );
            },
          ),
        ),

        Column(
          children: [
            const SizedBox(height: 60),
            
            // Center Icon with Pulse
            FadeIn(
              child: ScaleTransition(
                scale: _pulseController.drive(
                  Tween<double>(begin: 0.95, end: 1.05).chain(
                    CurveTween(curve: Curves.easeInOut),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedMode == 'auto' ? Colors.orange : Colors.green)
                            .withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    _selectedMode == 'auto' ? Icons.local_taxi : Icons.directions_car,
                    size: 60,
                    color: _selectedMode == 'auto' ? Colors.orange : Colors.green,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            FadeIn(
              delay: const Duration(milliseconds: 300),
              child: Text(
                _isSearching ? 'Finding ride-mates...' : 'Match Found!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            FadeIn(
              delay: const Duration(milliseconds: 400),
              child: Text(
                _selectedMode == 'auto' 
                    ? 'Searching for auto poolers nearby'
                    : 'Looking for carpoolers in your area',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Found Ridemates List
            if (_foundRidemates.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _foundRidemates.length,
                  itemBuilder: (context, index) {
                    final mate = _foundRidemates[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: _selectedMode == 'auto' 
                                  ? Colors.orange.shade100
                                  : Colors.green.shade100,
                              child: Text(
                                mate['avatar'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedMode == 'auto' 
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mate['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, 
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${mate['rating']}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.location_on, 
                                          color: Colors.grey, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        mate['distance'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle, 
                                color: Colors.green, size: 28),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// Custom Painter for Radial Search Animation (like Ola)
class RadialSearchPainter extends CustomPainter {
  final double progress;
  final Color color;

  RadialSearchPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 150);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.3;
      final animProgress = ((progress + delay) % 1.0);
      final radius = 50 + (animProgress * 150);
      final opacity = 1.0 - animProgress;

      paint.color = color.withOpacity(opacity * 0.4);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RadialSearchPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
