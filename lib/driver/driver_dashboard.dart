// driver_dashboard.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'my_trips_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _isAvailable = true;

  // Sample trip requests
  final List<Map<String, String>> _tripRequests = [
    {
      "farmer": "Sunil Perera",
      "capacity": "1500 kg",
      "pickup": "Kurunegala",
      "dropoff": "Colombo Rice Mill",
      "date": "2025-09-12",
      "time": "08:30 AM",
    },
    {
      "farmer": "Anjali Silva",
      "capacity": "800 kg",
      "pickup": "Gampaha",
      "dropoff": "Negombo",
      "date": "2025-09-13",
      "time": "02:00 PM",
    },
  ];

  // Store accepted trips
  final List<Map<String, String>> _acceptedTrips = [];

  // Accept a trip
  void _acceptRequest(int index) {
    setState(() {
      _acceptedTrips.add(_tripRequests[index]);
      _tripRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Accepted trip request from ${_acceptedTrips.last["farmer"]}",
        ),
      ),
    );
  }

  // Reject a trip
  void _rejectRequest(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Rejected trip request from ${_tripRequests[index]["farmer"]}",
        ),
      ),
    );
    setState(() {
      _tripRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center logo
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/logo.png", height: 35),
                  ),
                  // Notifications + Profile
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications, size: 26),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => _showProfileDialog(context),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFFFB74D),
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.person, color: Colors.black)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tagline
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFFB74D),
              ),
              child: const Text(
                "තිරසාර ගොවිතැනට නව සවියක්\n"
                "Smart farming Starts here\n"
                "ஸ்மார்ட் விவசாயம் இங்கே தொடங்குகிறது",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),

            // Availability switch
            SwitchListTile(
              title: const Text(
                "Available for Trips",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              value: _isAvailable,
              onChanged: (val) => setState(() => _isAvailable = val),
              activeColor: Colors.black,
              activeTrackColor: const Color(0xFFFF9800),
            ),

            const SizedBox(height: 8),

            // Trip Requests
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _tripRequests.isEmpty
                    ? const Center(
                        child: Text(
                          "No trip requests available",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tripRequests.length,
                        itemBuilder: (context, index) {
                          final req = _tripRequests[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with farmer name
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 204, 128, 1),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "🚜 Farmer: ${req["farmer"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Gradient content
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFFF3E0), Colors.white],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.scale,
                                            size: 18,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Capacity: ${req["capacity"]}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "Pickup: ${req["pickup"]}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.flag,
                                            size: 18,
                                            color: Colors.redAccent,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "Dropoff: ${req["dropoff"]}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.blueGrey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Date: ${req["date"]}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.blueGrey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Time: ${req["time"]}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                _rejectRequest(index),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              "Reject",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                _acceptRequest(index),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.check,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              "Accept",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Bottom Nav
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bottomNavButton(Icons.home, "Home", () {}),
                  const SizedBox(width: 25),
                  _bottomNavButton(Icons.list, "My Trips", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MyTripsScreen(acceptedTrips: _acceptedTrips),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            Future<void> _pickProfileImage() async {
              final pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setState(() {
                  _profileImage = File(pickedFile.path);
                });
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.orangeAccent,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB74D),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Driver Name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Vehicle: AB-1234 | Lorry",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Contact: +94 77 123 4567",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                      ),
                      child: const Text(
                        "Switch Role",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushNamed(context, "/roleSelection");
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB74D),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Bottom Nav Button
  Widget _bottomNavButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFFFB74D),
          radius: 24,
          child: IconButton(
            icon: Icon(icon, color: Colors.black),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
