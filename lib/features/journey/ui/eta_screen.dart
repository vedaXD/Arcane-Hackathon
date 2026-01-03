import 'package:flutter/material.dart';

// ETA screen
class EtaScreen extends StatelessWidget {
  const EtaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ETA')),
      body: const Center(child: Text('ETA Screen')),
    );
  }
}
