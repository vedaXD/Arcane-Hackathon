import 'package:flutter/material.dart';

// Vehicle details screen
class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: const Center(child: Text('Vehicle Details Screen')),
    );
  }
}
