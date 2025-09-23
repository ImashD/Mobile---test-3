import 'package:flutter/material.dart';

class CultivationScreen extends StatelessWidget {
  const CultivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cultivation Info"),
        backgroundColor: const Color(0xFF1DD1A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Your Paddy Area: 2 Acres", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Paddy Type: Red Samba", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Harvest Status: Growing", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              "Next Expected Harvest: 3 months",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
