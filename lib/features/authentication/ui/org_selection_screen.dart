import 'package:flutter/material.dart';

// Organization selection screen
class OrgSelectionScreen extends StatelessWidget {
  const OrgSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Organization')),
      body: const Center(child: Text('Organization Selection Screen')),
    );
  }
}
