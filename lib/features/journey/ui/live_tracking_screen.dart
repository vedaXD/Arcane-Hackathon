import 'package:flutter/material.dart';

// Live tracking screen
class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: const Center(child: Text('Live Tracking Screen')),
    );
  }
}
