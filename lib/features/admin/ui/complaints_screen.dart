import 'package:flutter/material.dart';

// Complaints screen
class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaints')),
      body: const Center(child: Text('Complaints Screen')),
    );
  }
}
