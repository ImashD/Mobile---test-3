import 'package:flutter/material.dart';

class DriverFormScreen extends StatelessWidget {
  const DriverFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Registration"),
        backgroundColor: const Color(0xFF1DD1A1),
      ),
      body: const Center(
        child: Text(
          "Driver Registration Form (coming soon)",
          style: TextStyle(fontSize: 18, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
