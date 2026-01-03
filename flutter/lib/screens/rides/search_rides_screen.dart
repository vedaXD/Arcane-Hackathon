import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/radar_search_animation.dart';
import '../../data/popular_routes.dart';

class SearchRidesScreen extends StatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSearching = false;
  bool _showResults = false;
  List<String> _fromSuggestions = [];
  List<String> _toSuggestions = [];
  bool _showPopularRoutes = true;

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
              // Popular Routes Section
              if (_showPopularRoutes && _fromController.text.isEmpty && _toController.text.isEmpty)
                FadeInDown(
                  child: _buildPopularRoutesSection(),
                ),
              if (_showPopularRoutes && _fromController.text.isEmpty && _toController.text.isEmpty)
                SizedBox(height: 24),
              FadeInDown(
                child: _buildLocationInput(),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 200),
                child: _buildDateTimeSelection(),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 400),
                child: _buildPreferences(),
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

  void _startSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter pickup and drop-off locations'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    
    setState(() {
      _isSearching = true;
      _showResults = false;
    });
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
              '4 Rides Found',
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
                });
              },
              icon: Icon(Icons.search),
              label: Text('New Search'),
            ),
          ],
        ),
        SizedBox(height: 16),
        ..._buildMockResults(),
      ],
    );
  }

  List<Widget> _buildMockResults() {
    final rides = [
      {
        'driver': 'Sarah Johnson',
        'rating': 4.9,
        'time': '8:30 AM',
        'price': '₹120',
        'car': 'Honda City',
        'seats': 2,
        'matched': 95,
      },
      {
        'driver': 'Mike Wilson',
        'rating': 4.7,
        'time': '8:45 AM',
        'price': '₹100',
        'car': 'Toyota Innova',
        'seats': 3,
        'matched': 88,
      },
      {
        'driver': 'Priya Sharma',
        'rating': 4.8,
        'time': '9:00 AM',
        'price': '₹110',
        'car': 'Maruti Swift',
        'seats': 1,
        'matched': 92,
      },
      {
        'driver': 'Rahul Kumar',
        'rating': 4.6,
        'time': '9:15 AM',
        'price': '₹95',
        'car': 'Hyundai i20',
        'seats': 2,
        'matched': 85,
      },
    ];

    return rides.map((ride) {
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
                          ride['driver'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppTheme.warning, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${ride['rating']}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkGray,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              ride['car'] as String,
                              style: TextStyle(
                                fontSize: 12,
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
                        ride['price'] as String,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                      Text(
                        'per seat',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _rideDetail(Icons.access_time, ride['time'] as String),
                  _rideDetail(Icons.airline_seat_recline_normal, '${ride['seats']} seats'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.ecoGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${ride['matched']}% match',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ecoGreen,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text('Book'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _rideDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.mediumGray),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mediumGray,
          ),
        ),
      ],
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
                    // From Field with Autocomplete
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _fromController,
                          onChanged: (value) {
                            setState(() {
                              _fromSuggestions = CommonPickupPoints.getSuggestions(value, limit: 5);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Pickup location',
                            hintStyle: TextStyle(fontSize: 14),
                            prefixIcon: Icon(Icons.my_location, size: 20),
                            filled: true,
                            fillColor: AppTheme.offWhite,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        if (_fromSuggestions.isNotEmpty && _fromController.text.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: _fromSuggestions.map((suggestion) {
                                return ListTile(
                                  dense: true,
                                  leading: Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                                  title: Text(
                                    suggestion,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _fromController.text = suggestion;
                                      _fromSuggestions = [];
                                      _showPopularRoutes = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // To Field with Autocomplete
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _toController,
                          onChanged: (value) {
                            setState(() {
                              _toSuggestions = CommonPickupPoints.getSuggestions(value, limit: 5);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Drop-off location',
                            hintStyle: TextStyle(fontSize: 14),
                            prefixIcon: Icon(Icons.place, size: 20),
                            filled: true,
                            fillColor: AppTheme.offWhite,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        if (_toSuggestions.isNotEmpty && _toController.text.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: _toSuggestions.map((suggestion) {
                                return ListTile(
                                  dense: true,
                                  leading: Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                                  title: Text(
                                    suggestion,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _toController.text = suggestion;
                                      _toSuggestions = [];
                                      _showPopularRoutes = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
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

  Widget _buildPopularRoutesSection() {
    final topRoutes = PopularRoutesData.getTopRoutes(limit: 6);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppTheme.primaryBeige],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Popular Routes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Tap to auto-fill your journey',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: topRoutes.map((route) => _buildPopularRouteChip(route)).toList(),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _showAllPopularRoutes,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View All Routes',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: AppTheme.primaryOrange,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRouteChip(PopularRoute route) {
    return InkWell(
      onTap: () {
        setState(() {
          _fromController.text = route.pickupPoint;
          _toController.text = route.dropPoint;
          _showPopularRoutes = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(route.icon, size: 16, color: AppTheme.primaryOrange),
                SizedBox(width: 6),
                Text(
                  route.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: 12, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '${route.avgRiders} riders',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.eco, size: 12, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  '${route.co2SavedPerRide}kg',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAllPopularRoutes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBeige,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.route, color: AppTheme.primaryOrange),
                      SizedBox(width: 8),
                      Text(
                        'All Popular Routes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: PopularRoutesData.routes.length,
                    itemBuilder: (context, index) {
                      final route = PopularRoutesData.routes[index];
                      return _buildRouteCard(route);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteCard(PopularRoute route) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          setState(() {
            _fromController.text = route.pickupPoint;
            _toController.text = route.dropPoint;
            _showPopularRoutes = false;
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(route.icon, color: AppTheme.primaryOrange),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${route.estimatedKm} km · ${route.estimatedMinutes} min',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildRoutePoints(route.pickupPoint, route.dropPoint),
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRouteInfo(Icons.access_time, route.peakTimings),
                  _buildRouteInfo(Icons.people, '${route.avgRiders} riders'),
                  _buildRouteInfo(Icons.eco, '${route.co2SavedPerRide}kg CO₂'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutePoints(String from, String to) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 20,
              color: Colors.grey[300],
            ),
            Container(
              width: 10,
              height: 10,
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
                from,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20),
              Text(
                to,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
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
}
