import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/map_widget.dart';
import '../../data/popular_routes.dart';
import '../../services/trip_service.dart';
import '../../models/trip_model.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _seatsController = TextEditingController(text: '2');
  final _priceController = TextEditingController();
  final _tripService = TripService();
  bool _isCreating = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _vehicleType = 'Sedan';
  bool _acAvailable = true;
  String _genderPreference = 'any';
  List<String> _fromSuggestions = [];
  List<String> _toSuggestions = [];
    // Mock coordinates - replace with geocoding
  double _startLat = 19.1136;
  double _startLng = 72.8697;
  double _endLat = 19.0596;
  double _endLng = 72.8656;

  // New fields for community pooling
  String _tripType = 'offering'; // 'offering' or 'seeking'
  String _transportMode = 'car'; // 'car', 'bike', 'auto', 'public', 'any'

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _seatsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBeige,
      appBar: AppBar(
        title: const Text('Create Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trip Type Toggle
              FadeInDown(
                child: _buildTripTypeToggle(),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                child: _buildLocationSection(),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: _buildDateTimeSection(),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: _tripType == 'offering' ? _buildVehicleSection() : const SizedBox.shrink(),
              ),
              if (_tripType == 'offering') const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                child: _buildPricingSection(),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 350),
                child: _buildPreferencesSection(),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _buildCreateButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'Trip Route',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLocationField(
              controller: _fromController,
              label: 'Pickup Location',
              icon: Icons.trip_origin,
              suggestions: _fromSuggestions,
              onChanged: (value) {
                setState(() {
                  _fromSuggestions = CommonPickupPoints.getSuggestions(value, limit: 5);
                });
              },
            ),
            const SizedBox(height: 16),
            _buildLocationField(
              controller: _toController,
              label: 'Drop Location',
              icon: Icons.location_on,
              suggestions: _toSuggestions,
              onChanged: (value) {
                setState(() {
                  _toSuggestions = CommonPickupPoints.getSuggestions(value, limit: 5);
                });
              },
            ),
            if (_fromController.text.isNotEmpty && _toController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              MapWidget(
                center: LatLng(
                  (_startLat + _endLat) / 2,
                  (_startLng + _endLng) / 2,
                ),
                zoom: 12,
                height: 200,
                markers: [
                  createCustomMarker(
                    point: LatLng(_startLat, _startLng),
                    child: pickupMarker(),
                  ),
                  createCustomMarker(
                    point: LatLng(_endLat, _endLng),
                    child: dropoffMarker(),
                  ),
                ],
                polylines: [
                  createRoutePolyline(
                    points: [
                      LatLng(_startLat, _startLng),
                      LatLng(_endLat, _endLng),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> suggestions,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: AppTheme.primaryOrange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppTheme.offWhite,
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        if (suggestions.isNotEmpty && controller.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: suggestions.map((suggestion) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                  title: Text(suggestion, style: const TextStyle(fontSize: 13)),
                  onTap: () {
                    setState(() {
                      controller.text = suggestion;
                      if (controller == _fromController) {
                        _fromSuggestions = [];
                      } else {
                        _toSuggestions = [];
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppTheme.offWhite,
                      ),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'Vehicle Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _vehicleType,
              decoration: InputDecoration(
                labelText: 'Vehicle Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.offWhite,
              ),
              items: ['Sedan', 'SUV', 'Hatchback', 'Electric']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _vehicleType = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _seatsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Available Seats',
                prefixIcon: const Icon(Icons.airline_seat_recline_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.offWhite,
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('AC Available'),
              value: _acAvailable,
              onChanged: (value) => setState(() => _acAvailable = value),
              activeColor: AppTheme.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: AppTheme.offWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payments, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'Pricing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price per Seat (₹)',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.offWhite,
                helperText: 'Suggested: ₹50-150 based on distance',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'Passenger Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _genderPreference,
              decoration: InputDecoration(
                labelText: 'Gender Preference',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.offWhite,
              ),
              items: const [
                DropdownMenuItem(value: 'any', child: Text('No Preference')),
                DropdownMenuItem(value: 'male', child: Text('Male Only')),
                DropdownMenuItem(value: 'female', child: Text('Female Only')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _genderPreference = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeToggle() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: AppTheme.primaryOrange),
                const SizedBox(width: 8),
                const Text(
                  'What are you planning?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tripType = 'offering'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tripType == 'offering' ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.car_rental,
                              color: _tripType == 'offering' ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Offering Ride',
                              style: TextStyle(
                                color: _tripType == 'offering' ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'I have a vehicle',
                              style: TextStyle(
                                fontSize: 10,
                                color: _tripType == 'offering' ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tripType = 'seeking'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tripType == 'seeking' ? Colors.orange : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.group,
                              color: _tripType == 'seeking' ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Seeking Ride',
                              style: TextStyle(
                                color: _tripType == 'seeking' ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Find ride-mates',
                              style: TextStyle(
                                fontSize: 10,
                                color: _tripType == 'seeking' ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_tripType == 'seeking') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Perfect for auto-rickshaw or public transport pooling! Find people going the same way.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _transportMode,
                decoration: InputDecoration(
                  labelText: 'Preferred Transport Mode',
                  prefixIcon: const Icon(Icons.directions_transit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.offWhite,
                ),
                items: const [
                  DropdownMenuItem(value: 'auto', child: Text('🛺 Auto Rickshaw')),
                  DropdownMenuItem(value: 'public', child: Text('🚌 Public Transport')),
                  DropdownMenuItem(value: 'bike', child: Text('🏍️ Bike')),
                  DropdownMenuItem(value: 'any', child: Text('Any Mode')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _transportMode = value);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryOrange, AppTheme.accentOrange],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isCreating ? null : _handleCreateTrip,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isCreating
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _tripType == 'offering' ? 'Create Trip Offer' : 'Find Ride-Mates',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _handleCreateTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isCreating = true);

    try {
      // Combine date and time
      final departureDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Create trip object (without id, createdAt, updatedAt as they're generated by backend)
      final trip = Trip(
        id: 0, // Will be assigned by backend
        driverId: 0, // Will be assigned by backend from auth token
        vehicleId: 1, // TODO: Get from vehicle selection
        startLocation: _fromController.text,
        startLatitude: _startLat,
        startLongitude: _startLng,
        endLocation: _toController.text,
        endLatitude: _endLat,
        endLongitude: _endLng,
        departureTime: departureDateTime,
        availableSeats: int.parse(_seatsController.text),
        genderPreference: _genderPreference,
        pricePerSeat: double.parse(_priceController.text),
        status: 'scheduled',
        createdAt: DateTime.now(), // Will be overwritten by backend
        updatedAt: DateTime.now(), // Will be overwritten by backend
      );

      final result = await _tripService.createTrip(trip);

      if (mounted) {
        setState(() => _isCreating = false);

        if (result['success']) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text('Trip Created!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your trip has been created successfully.'),
                  const SizedBox(height: 12),
                  Text(
                    'From: ${_fromController.text}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    'To: ${_toController.text}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to home
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to create trip'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
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
