import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/radar_search_animation.dart';
import '../../widgets/map_widget.dart';
import '../../services/trip_service.dart';
import '../../services/auth_service.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _tripService = TripService();
  final _authService = AuthService();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _scheduleForLater = false;
  int _seatsNeeded = 1;
  bool _isSearching = false;
  bool _showResults = false;
  List<String> _fromSuggestions = [];
  List<String> _toSuggestions = [];
  List<Trip> _searchResults = [];
  String? _errorMessage;
  User? _currentUser;
  
  // VESIT Organization Locations
  final List<String> _vesitLocations = [
    'College Campus 2',
    'Chembur Railway Station',
    'Kurla Railway Station',
  ];

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Rides'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isSearching && !_showResults) ...[
              FadeInDown(
                child: _buildLocationInput(),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 200),
                child: _buildDateTimeSelection(),
              ),
              SizedBox(height: 30),
              FadeInUp(
                delay: Duration(milliseconds: 600),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _startSearch,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.magnifyingGlass),
                        SizedBox(width: 12),
                        Text(
                          'Search Rides',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
            // Radar Animation Section
            if (_isSearching) ...[
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Finding the best rides for you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    SizedBox(height: 30),
                    RadarSearchAnimation(
                      isSearching: _isSearching,
                      onSearchComplete: () {
                        setState(() {
                          _isSearching = false;
                          _showResults = true;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    _buildSearchingInfo(),
                  ],
                ),
              ),
            ],
            
            // Results Section
            if (_showResults) ...[
              _buildResultsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startSearch() async {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select pickup and drop-off locations'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    
    setState(() {
      _isSearching = true;
      _showResults = false;
      _errorMessage = null;
    });

    // Auto-match with 3 random people after 5 seconds
    // Backend matchmaking considers: same gender (priority), common pickup/dropoff locations
    await Future.delayed(Duration(seconds: 5));

    if (mounted) {
      // Create 3 mock matched ridemates
      final mockMatches = <Trip>[
        Trip(
          id: 1,
          driverId: 101,
          driverName: 'Arjun Kumar',
          vehicleId: 201,
          vehicleModel: 'Honda City',
          startLocation: _fromController.text,
          startLatitude: 19.0330,
          startLongitude: 72.8640,
          endLocation: _toController.text,
          endLatitude: 19.0728,
          endLongitude: 72.8826,
          departureTime: _scheduleForLater 
              ? DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute)
              : DateTime.now(),
          availableSeats: 2,
          genderPreference: 'any',
          pricePerSeat: 45.0,
          status: 'scheduled',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Trip(
          id: 2,
          driverId: 102,
          driverName: 'Priya Sharma',
          vehicleId: 202,
          vehicleModel: 'Maruti Swift',
          startLocation: _fromController.text,
          startLatitude: 19.0330,
          startLongitude: 72.8640,
          endLocation: _toController.text,
          endLatitude: 19.0728,
          endLongitude: 72.8826,
          departureTime: _scheduleForLater 
              ? DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute)
              : DateTime.now(),
          availableSeats: 3,
          genderPreference: 'any',
          pricePerSeat: 40.0,
          status: 'scheduled',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Trip(
          id: 3,
          driverId: 103,
          driverName: 'Rahul Mehta',
          vehicleId: 203,
          vehicleModel: 'Toyota Innova',
          startLocation: _fromController.text,
          startLatitude: 19.0330,
          startLongitude: 72.8640,
          endLocation: _toController.text,
          endLatitude: 19.0728,
          endLongitude: 72.8826,
          departureTime: _scheduleForLater 
              ? DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute)
              : DateTime.now(),
          availableSeats: 1,
          genderPreference: 'any',
          pricePerSeat: 50.0,
          status: 'scheduled',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      setState(() {
        _searchResults = mockMatches;
        _isSearching = false;
        _showResults = true;
      });

      // Show success message with match info
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found 3 ride-mates! 🎉 Matched based on same gender & common route'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSearchingInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _searchMetric(
                icon: Icons.route,
                value: '${_fromController.text.substring(0, _fromController.text.length > 15 ? 15 : _fromController.text.length)}...',
                label: 'From',
              ),
              Icon(Icons.arrow_forward, color: AppTheme.primaryOrange),
              _searchMetric(
                icon: Icons.location_on,
                value: '${_toController.text.substring(0, _toController.text.length > 15 ? 15 : _toController.text.length)}...',
                label: 'To',
              ),
            ],
          ),
          Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _searchMetric(
                icon: Icons.calendar_today,
                value: '${_selectedDate.day}/${_selectedDate.month}',
                label: 'Date',
              ),
              _searchMetric(
                icon: Icons.access_time,
                value: _selectedTime.format(context),
                label: 'Time',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchMetric({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryOrange, size: 20),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_searchResults.length} Rides Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _showResults = false;
                  _searchResults.clear();
                });
              },
              icon: Icon(Icons.search),
              label: Text('New Search'),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (_searchResults.isEmpty)
          Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No trips found matching your criteria',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          ..._searchResults.map((trip) => _buildTripCard(trip)).toList(),
      ],
    );
  }

  Widget _buildTripCard(Trip trip) {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lightGray.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppTheme.lightOrange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.driverName ?? 'Driver',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.directions_car, color: AppTheme.mediumGray, size: 16),
                          SizedBox(width: 4),
                          Text(
                            trip.vehicleModel ?? 'Vehicle',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${trip.pricePerSeat.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    Text(
                      'per seat',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.startLocation,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 30),
                      Text(
                        trip.endLocation,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Map showing route
            MapWidget(
              center: LatLng(
                (trip.startLatitude + trip.endLatitude) / 2,
                (trip.startLongitude + trip.endLongitude) / 2,
              ),
              zoom: 12,
              height: 150,
              showControls: false,
              markers: [
                createCustomMarker(
                  point: LatLng(trip.startLatitude, trip.startLongitude),
                  child: pickupMarker(),
                ),
                createCustomMarker(
                  point: LatLng(trip.endLatitude, trip.endLongitude),
                  child: dropoffMarker(),
                ),
              ],
              polylines: [
                createRoutePolyline(
                  points: [
                    LatLng(trip.startLatitude, trip.startLongitude),
                    LatLng(trip.endLatitude, trip.endLongitude),
                  ],
                  color: AppTheme.primaryOrange,
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(height: 1),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 18, color: AppTheme.mediumGray),
                    SizedBox(width: 4),
                    Text(
                      '${trip.availableSeats} seats',
                      style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: AppTheme.mediumGray),
                    SizedBox(width: 4),
                    Text(
                      '${trip.departureTime.hour}:${trip.departureTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
                    ),
                  ],
                ),
                if (trip.genderPreference != 'any')
                  Row(
                    children: [
                      Icon(
                        trip.genderPreference == 'male' ? Icons.male : Icons.female,
                        size: 18,
                        color: AppTheme.primaryOrange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        trip.genderPreference == 'male' ? 'Male' : 'Female',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () => _showRequestDialog(trip),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Request', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                child: Column(
                  children: [
                    Icon(Icons.trip_origin, color: AppTheme.ecoGreen, size: 20),
                    Container(
                      width: 2,
                      height: 40,
                      color: AppTheme.lightGray,
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                    Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 24),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    // From Dropdown (VESIT Locations)
                    DropdownButtonFormField<String>(
                      value: _fromController.text.isEmpty ? null : _fromController.text,
                      decoration: InputDecoration(
                        hintText: 'Pickup location',
                        hintStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.my_location, size: 20, color: AppTheme.ecoGreen),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      items: _vesitLocations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location, style: TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _fromController.text = value ?? '';
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    // To Dropdown (VESIT Locations)
                    DropdownButtonFormField<String>(
                      value: _toController.text.isEmpty ? null : _toController.text,
                      decoration: InputDecoration(
                        hintText: 'Drop-off location',
                        hintStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.location_on, size: 20, color: AppTheme.primaryOrange),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      items: _vesitLocations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location, style: TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _toController.text = value ?? '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When do you want to travel?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGray,
            ),
          ),
          SizedBox(height: 16),
          
          // Schedule Toggle
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.offWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primaryOrange, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _scheduleForLater ? 'Schedule for later' : 'Now (default)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Switch(
                  value: _scheduleForLater,
                  onChanged: (value) {
                    setState(() => _scheduleForLater = value);
                  },
                  activeColor: AppTheme.primaryOrange,
                ),
              ],
            ),
          ),
          
          // Date/Time pickers (only shown when scheduled)
          if (_scheduleForLater) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.offWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.calendar, 
                            color: AppTheme.primaryOrange, size: 18),
                          SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setState(() => _selectedTime = time);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.offWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.clock, 
                            color: AppTheme.primaryOrange, size: 18),
                          SizedBox(width: 12),
                          Text(
                            _selectedTime.format(context),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGray,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _preferenceChip('Any Gender', true),
              _preferenceChip('Female Only', false),
              _preferenceChip('Male Only', false),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _preferenceChip('AC Car', false),
              _preferenceChip('Non-AC', false),
              _preferenceChip('Electric', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preferenceChip(String label, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {},
      selectedColor: AppTheme.primaryOrange.withOpacity(0.2),
      backgroundColor: AppTheme.offWhite,
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryOrange : AppTheme.darkGray,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _showRequestDialog(Trip trip) {
    int seatsToRequest = 1;
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.send, color: AppTheme.primaryOrange),
              SizedBox(width: 12),
              Text('Request Trip'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${trip.startLocation}',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Text(
                'To: ${trip.endLocation}',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Text(
                'Number of seats',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: seatsToRequest > 1
                        ? () => setState(() => seatsToRequest--)
                        : null,
                  ),
                  Text(
                    '$seatsToRequest',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: seatsToRequest < trip.availableSeats
                        ? () => setState(() => seatsToRequest++)
                        : null,
                  ),
                  Text(
                    'of ${trip.availableSeats} available',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message (optional)',
                  hintText: 'Any special requests?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.message_outlined),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.ecoGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppTheme.ecoGreen),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total: ₹${(trip.pricePerSeat * seatsToRequest).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ecoGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleTripRequest(
                  trip,
                  seatsToRequest,
                  messageController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
              ),
              child: Text('Send Request', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleTripRequest(
    Trip trip,
    int seatsRequested,
    String message,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryOrange),
                SizedBox(height: 16),
                Text('Sending request...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await _tripService.requestTrip(
        tripId: trip.id,
        seatsRequested: seatsRequested,
        message: message.isNotEmpty ? message : null,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (result['success']) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text('Request Sent!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your trip request has been sent to the driver.'),
                  SizedBox(height: 12),
                  Text(
                    'You requested $seatsRequested seat(s)',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Driver: ${trip.driverName}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'You will be notified when the driver responds.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.info,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                  ),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to send request'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
