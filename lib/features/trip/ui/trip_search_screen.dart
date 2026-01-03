import 'package:flutter/material.dart';

// Trip search screen
class TripSearchScreen extends StatelessWidget {
  const TripSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Trips')),
      body: const Center(child: Text('Trip Search Screen')),
    );
  }
}
