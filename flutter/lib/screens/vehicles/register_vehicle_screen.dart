import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/vehicle_service.dart';
import '../../models/vehicle_model.dart';

class RegisterVehicleScreen extends StatefulWidget {
  const RegisterVehicleScreen({super.key});

  @override
  State<RegisterVehicleScreen> createState() => _RegisterVehicleScreenState();
}

class _RegisterVehicleScreenState extends State<RegisterVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleService = VehicleService();
  
  final _modelController = TextEditingController();
  final _registrationController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();
  final _capacityController = TextEditingController();
  
  String _selectedVehicleType = 'sedan';
  String _selectedFuelType = 'petrol';
  bool _isLoading = false;

  final List<String> _vehicleTypes = ['sedan', 'suv', 'hatchback', 'minivan'];
  final List<String> _fuelTypes = ['petrol', 'diesel', 'electric', 'hybrid'];

  @override
  void dispose() {
    _modelController.dispose();
    _registrationController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterVehicle() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final vehicle = Vehicle(
          id: 0,
          driverId: 0,
          vehicleType: _selectedVehicleType,
          model: _modelController.text.trim(),
          registrationNumber: _registrationController.text.trim().toUpperCase(),
          fuelType: _selectedFuelType,
          capacity: int.parse(_capacityController.text),
          color: _colorController.text.trim(),
          year: int.parse(_yearController.text),
          isVerified: false,
          createdAt: DateTime.now(),
        );

        final result = await _vehicleService.createVehicle(vehicle);

        if (mounted) {
          setState(() => _isLoading = false);

          if (result['success']) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text('Vehicle Registered!'),
                  ],
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your vehicle has been registered successfully.'),
                    SizedBox(height: 12),
                    Text(
                      'You can now create trips!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Failed to register vehicle'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBeige,
      appBar: AppBar(
        title: const Text('Register Your Vehicle'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 80,
                  color: AppTheme.primaryOrange,
                ),
                const SizedBox(height: 16),
                Text(
                  'Add Your Vehicle Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register your vehicle to start offering rides',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Vehicle Type Dropdown
                _buildDropdownField(
                  label: 'Vehicle Type',
                  value: _selectedVehicleType,
                  items: _vehicleTypes,
                  onChanged: (value) => setState(() => _selectedVehicleType = value!),
                ),
                const SizedBox(height: 16),

                // Model
                _buildTextField(
                  controller: _modelController,
                  label: 'Vehicle Model',
                  hint: 'e.g., Honda City, Maruti Swift',
                  icon: Icons.car_rental,
                ),
                const SizedBox(height: 16),

                // Registration Number
                _buildTextField(
                  controller: _registrationController,
                  label: 'Registration Number',
                  hint: 'MH01AB1234',
                  icon: Icons.badge,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),

                // Fuel Type Dropdown
                _buildDropdownField(
                  label: 'Fuel Type',
                  value: _selectedFuelType,
                  items: _fuelTypes,
                  onChanged: (value) => setState(() => _selectedFuelType = value!),
                ),
                const SizedBox(height: 16),

                // Color
                _buildTextField(
                  controller: _colorController,
                  label: 'Color',
                  hint: 'e.g., White, Black, Red',
                  icon: Icons.palette,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    // Year
                    Expanded(
                      child: _buildTextField(
                        controller: _yearController,
                        label: 'Year',
                        hint: '2020',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Capacity
                    Expanded(
                      child: _buildTextField(
                        controller: _capacityController,
                        label: 'Seats',
                        hint: '4',
                        icon: Icons.event_seat,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Register Button
                Container(
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
                    onPressed: _isLoading ? null : _handleRegisterVehicle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Register Vehicle',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter $label' : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryOrange),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toUpperCase()),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
