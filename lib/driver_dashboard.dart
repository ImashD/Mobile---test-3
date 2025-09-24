import 'package:flutter/material.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wee Saviya Dashboard"),
        backgroundColor: const Color(0xFFFF9800), // Orange theme
      ),
      body: const Center(
        child: Text(
          "Welcome to Wee Saviya Dashboard 🎉",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
