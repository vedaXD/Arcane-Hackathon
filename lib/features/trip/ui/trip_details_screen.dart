import 'package:flutter/material.dart';

// Trip details screen
class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: const Center(child: Text('Trip Details Screen')),
    );
  }
}
