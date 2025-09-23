import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather Forecast",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF009688),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/weather.png",
              height: 100,
            ), // weather icon placeholder
            const SizedBox(height: 16),
            const Text(
              "Current Weather: Sunny",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text("Temperature: 30°C", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text("Rain Chance: 10%", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
