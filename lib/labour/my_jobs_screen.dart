// my_jobs_screen.dart
import 'package:flutter/material.dart';

class MyJobsScreen extends StatelessWidget {
  final List<Map<String, String>> acceptedJobs;

  const MyJobsScreen({super.key, required this.acceptedJobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Jobs", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF00BCD4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: acceptedJobs.isEmpty
          ? const Center(
              child: Text(
                "No accepted jobs yet",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.work,
                        size: 80,
                        color: Color(0xFF00ACC1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Job Details
                    Text(
                      "🚜 Farmer: ${acceptedJobs[0]["farmer"]}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          size: 20,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Job: ${acceptedJobs[0]["jobType"]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Location: ${acceptedJobs[0]["location"]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Duration: ${acceptedJobs[0]["duration"]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date & Time as two-line labels
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                acceptedJobs[0]["date"]!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Time:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                acceptedJobs[0]["time"]!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Track Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Open Map for tracking"),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Track Job Location",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00ACC1),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
