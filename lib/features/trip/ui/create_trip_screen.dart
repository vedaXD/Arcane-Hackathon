import 'package:flutter/material.dart';

// Create trip screen
class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: const Center(child: Text('Create Trip Screen')),
    );
  }
}
