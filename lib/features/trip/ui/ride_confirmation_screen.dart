import 'package:flutter/material.dart';

// Ride confirmation screen
class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Ride')),
      body: const Center(child: Text('Ride Confirmation Screen')),
    );
  }
}
