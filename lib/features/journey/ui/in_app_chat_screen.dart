import 'package:flutter/material.dart';

// In-app chat screen
class InAppChatScreen extends StatelessWidget {
  const InAppChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('In-App Chat Screen')),
    );
  }
}
