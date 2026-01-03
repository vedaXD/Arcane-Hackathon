import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_background.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../rides/search_rides_screen.dart';
import '../search/ridemate_search_screen.dart';
import '../trips/create_trip_screen.dart';
import '../trips/my_trips_screen.dart';
import '../vehicles/register_vehicle_screen.dart';
import '../messages/messages_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  bool get _isDriver => _currentUser?.role == 'driver';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryOrange),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildGreeting(),
                const SizedBox(height: 30),
                _buildCarbonSavedCard(),
                const SizedBox(height: 40),
                _buildMainActions(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _isDriver ? _buildFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.route_rounded, color: AppTheme.primaryOrange, size: 28),
          const SizedBox(width: 8),
          const Text('EcoPool', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        // Diamond balance display
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryOrange.withOpacity(0.2), AppTheme.accentOrange.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryOrange, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.diamond, color: AppTheme.primaryOrange, size: 20),
              SizedBox(width: 6),
              Text(
                '1250',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: CircleAvatar(
              backgroundColor: AppTheme.lightOrange,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return FadeInDown(
      duration: Duration(milliseconds: 400),
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            _quickAccessItem(
              icon: FontAwesomeIcons.car,
              label: 'Find Ride',
              color: AppTheme.primaryOrange,
              onTap: () {
                _showModeSelectionDialog();
              },
            ),
            if (_isDriver) _quickAccessItem(
              icon: FontAwesomeIcons.plus,
              label: 'Create Trip',
              color: AppTheme.ecoGreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTripScreen()),
                );
              },
            ),
            if (_isDriver) _quickAccessItem(
              icon: FontAwesomeIcons.carRear,
              label: 'Add Vehicle',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterVehicleScreen()),
                );
              },
            ),
            _quickAccessItem(
              icon: FontAwesomeIcons.clockRotateLeft,
              label: 'My Trips',
              color: AppTheme.info,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyTripsScreen()),
                );
              },
            ),
            _quickAccessItem(
              icon: FontAwesomeIcons.solidMessage,
              label: 'Messages',
              color: AppTheme.warning,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesScreen()),
                );
              },
            ),
            _quickAccessItem(
              icon: FontAwesomeIcons.wallet,
              label: 'Payments',
              color: AppTheme.success,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payments feature coming soon!')),
                );
              },
            ),
            _quickAccessItem(
              icon: FontAwesomeIcons.trophy,
              label: 'Rewards',
              color: AppTheme.accentOrange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rewards feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarbonSavedCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 220,
        child: PageView(
          children: [
            // Slide 1: Carbon Saved
            _buildCarouselCard(
              icon: Icons.eco,
              title: 'Carbon Saved',
              mainValue: '12.5 kg',
              subtitle: 'CO₂ this month',
              tagline: 'Every ride counts! 🌍',
              gradient: [AppTheme.ecoGreen, AppTheme.ecoGreen.withOpacity(0.7)],
            ),
            // Slide 2: Trees Saved
            _buildCarouselCard(
              icon: Icons.park,
              title: 'Trees Saved',
              mainValue: '23',
              subtitle: 'equivalent trees planted',
              tagline: 'You\'re a forest hero! 🌳',
              gradient: [Colors.green[700]!, Colors.green[500]!],
            ),
            // Slide 3: AQI Improvement
            _buildCarouselCard(
              icon: Icons.air,
              title: 'AQI Impact',
              mainValue: '15%',
              subtitle: 'local air quality improved',
              tagline: 'Breathing better together! 💨',
              gradient: [Colors.cyan[600]!, Colors.cyan[400]!],
            ),
            // Slide 4: Community Contribution
            _buildCarouselCard(
              icon: Icons.people,
              title: 'Community Impact',
              mainValue: '47',
              subtitle: 'rides shared this month',
              tagline: 'Squad goals unlocked! 🚗',
              gradient: [AppTheme.primaryOrange, AppTheme.accentOrange],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselCard({
    required IconData icon,
    required String title,
    required String mainValue,
    required String subtitle,
    required String tagline,
    required List<Color> gradient,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            mainValue,
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tagline,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActions() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          _buildActionCard(
            icon: Icons.group,
            title: 'Search Ridemates',
            subtitle: 'Find colleagues going your way',
            gradient: LinearGradient(
              colors: [AppTheme.primaryOrange, AppTheme.accentOrange],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchRidesScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.car_rental,
            title: 'Offer a Ride',
            subtitle: 'Share your car/auto with colleagues',
            gradient: LinearGradient(
              colors: [AppTheme.info, AppTheme.info.withOpacity(0.7)],
            ),
            onTap: () {
              if (_isDriver) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTripScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Only drivers can offer rides')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGray,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTripScreen()),
        );
      },
      backgroundColor: AppTheme.primaryOrange,
      child: const Icon(Icons.add, color: Colors.white, size: 32),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTripsScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MessagesScreen()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryOrange,
      unselectedItemColor: AppTheme.mediumGray,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_rounded),
          label: 'My Carpools',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded),
          label: 'Messages',
        ),
      ],
    );
  }

  void _showModeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car,
                color: AppTheme.primaryOrange,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Choose Your Ride',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'How do you want to travel?',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              // Auto-rickshaw option
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideMateSearchScreen(initialMode: 'auto'),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryOrange.withOpacity(0.1), AppTheme.accentOrange.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryOrange, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('🛺', style: TextStyle(fontSize: 32)),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto Pooling',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Squad up & save money 🛺',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppTheme.primaryOrange),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Carpooling option
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideMateSearchScreen(initialMode: 'carpooling'),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.ecoGreen.withOpacity(0.1), Colors.green[400]!.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.ecoGreen, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.ecoGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('🚗', style: TextStyle(fontSize: 32)),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Carpooling',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Slay the commute, split the bills 💅',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppTheme.ecoGreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
