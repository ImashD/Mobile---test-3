import 'package:flutter/material.dart';

class LabourDashboard extends StatelessWidget {
  const LabourDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wee Saviya Dashboard"),
        backgroundColor: const Color(0xFF2196F3), // blue theme
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
