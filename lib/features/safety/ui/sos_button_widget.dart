import 'package:flutter/material.dart';

// SOS button widget
class SosButtonWidget extends StatelessWidget {
  const SosButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement SOS functionality
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: const Icon(Icons.warning, size: 40, color: Colors.white),
    );
  }
}
