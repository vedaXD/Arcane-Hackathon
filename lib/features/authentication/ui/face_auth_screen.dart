import 'package:flutter/material.dart';

// Face authentication screen
class FaceAuthScreen extends StatelessWidget {
  const FaceAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Authentication')),
      body: const Center(child: Text('Face Auth Screen')),
    );
  }
}
