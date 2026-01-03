import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/radar_search_animation.dart';

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
                    TextField(
                      controller: _fromController,
                      decoration: InputDecoration(
                        hintText: 'Pickup location',
                        prefixIcon: Icon(Icons.my_location),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _toController,
                      decoration: InputDecoration(
                        hintText: 'Drop-off location',
                        prefixIcon: Icon(Icons.place),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                      ),
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
