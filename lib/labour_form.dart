import 'package:flutter/material.dart';

class LabourFormScreen extends StatelessWidget {
  const LabourFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Labour Registration"),
        backgroundColor: const Color(0xFF1DD1A1),
      ),
      body: const Center(
        child: Text(
          "Labour Registration Form (coming soon)",
          style: TextStyle(fontSize: 18, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
