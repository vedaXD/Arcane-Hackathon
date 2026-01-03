import 'package:flutter/material.dart';

// Profile setup screen
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Profile')),
      body: const Center(child: Text('Profile Setup Screen')),
    );
  }
}
