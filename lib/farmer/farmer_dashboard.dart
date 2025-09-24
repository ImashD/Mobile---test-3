import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage; // Stores the user's profile photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left: Menu
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  // Center: Logo
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
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
                  // Right: Notifications + Profile
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
                          onTap: () {
                            _showProfileDialog(context);
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color.fromARGB(
                              255,
                              118,
                              226,
                              198,
                            ),
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
            // Tagline Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 118, 226, 198),
              ),
              child: const Text(
                "තිරසාර ගොවිතැනට නව සවියක්\n"
                "Smart farming Starts here\n"
                "ஸ்மார்ட் விவசாயம் இங்கே தொடங்குகிறது",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            // Feature Buttons (Grid)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _featureCard(
                    context,
                    "Market Rate",
                    "assets/market.png",
                    "/market",
                  ),
                  _featureCard(
                    context,
                    "Store Locations",
                    "assets/store.png",
                    "/stores",
                  ),
                  _featureCard(
                    context,
                    "Request Labors",
                    "assets/labors.png",
                    "/labors",
                  ),
                  _featureCard(
                    context,
                    "Request Drivers",
                    "assets/drivers.png",
                    "/drivers",
                  ),
                  _featureCard(
                    context,
                    "Cultivation Info",
                    "assets/cultivation.png",
                    "/cultivation",
                  ),
                  _featureCard(
                    context,
                    "Weather",
                    "assets/weather.png",
                    "/weather",
                  ),
                ],
              ),
            ),
            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bottomNavButton(Icons.home, "Home", () {}),
                  const SizedBox(width: 25),
                  _bottomNavButton(Icons.qr_code, "My Code", () {
                    _showQrCodeDialog(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 118, 226, 198),
            width: double.infinity,
            height: 170,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.png", height: 60),
                const SizedBox(height: 8),
                const Text(
                  "Wee Saviya",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 6,
              radius: const Radius.circular(10),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    icon: Icons.edit,
                    text: "Edit Profile",
                    onTap: () => Navigator.pushNamed(context, "/farmerForm1"),
                  ),
                  _drawerItem(
                    icon: Icons.grass,
                    text: "Product List",
                    onTap: () => Navigator.pushNamed(context, "/products"),
                  ),
                  _drawerItem(
                    icon: Icons.inventory,
                    text: "My Products",
                    onTap: () => Navigator.pushNamed(context, "/myProducts"),
                  ),
                  _drawerItem(
                    icon: Icons.bar_chart,
                    text: "Sales Reports",
                    onTap: () => Navigator.pushNamed(context, "/reports"),
                  ),
                  _drawerItem(
                    icon: Icons.campaign,
                    text: "Promotions",
                    onTap: () => Navigator.pushNamed(context, "/promotions"),
                  ),
                  _drawerItem(
                    icon: Icons.ondemand_video,
                    text: "Learn from YouTube",
                    onTap: () => Navigator.pushNamed(context, "/learn"),
                  ),
                  _drawerItem(
                    icon: Icons.contact_mail,
                    text: "Contact Us",
                    onTap: () => Navigator.pushNamed(context, "/contact"),
                  ),
                  _drawerItem(
                    icon: Icons.star_rate,
                    text: "Rate Us",
                    onTap: () => _showRateDialog(context),
                  ),
                  _drawerItem(
                    icon: Icons.info,
                    text: "Know About Us",
                    onTap: () async {
                      const url = "https://pmb.gov.lk/";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not open site")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFF009688),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pushReplacementNamed(context, "/register"),
            ),
          ),
        ],
      ),
    );
  }

  // Drawer item
  ListTile _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(text),
      onTap: onTap,
    );
  }

  // Feature card
  Widget _featureCard(
    BuildContext context,
    String title,
    String imagePath,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF009688),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 70),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom nav button
  Widget _bottomNavButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 118, 226, 198),
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

  // Profile Dialog with plus sign
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
                this.setState(() {}); // Update dashboard avatar immediately
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
                          backgroundColor: const Color(0xFF76E2C6),
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
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
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
                      "John Doe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Role: Farmer",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Paddy Type: Red Samba",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Contact: +94 77 123 4567",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009688),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.switch_account,
                        color: Colors.white,
                      ),
                      label: const Text(
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
                        backgroundColor: const Color(0xFF76E2C6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  // QR Code Dialog
  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your QR Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Image.asset("assets/sample_qr.png", height: 180, width: 180),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text(
                    "Download Here",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("QR Code downloaded!")),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF76E2C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Close",
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
  }

  // Rate Us Dialog
  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        int selectedStars = 0;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text(
              "Rate Our App",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:
                  List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedStars = index + 1),
                          child: Icon(
                            index < selectedStars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      })
                      .map(
                        (widget) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: widget,
                        ),
                      )
                      .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009688),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Thanks for rating $selectedStars stars!"),
                    ),
                  );
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
