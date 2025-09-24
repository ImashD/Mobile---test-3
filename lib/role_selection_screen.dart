import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1DD1A1),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80), // Space for back button
                // Title
                const Text(
                  "Choose Your Role",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Select the option that best describes you.\n",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 60, 59, 59),
                        ),
                      ),
                      const TextSpan(
                        text: "(You can switch the ROLE later)",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 60, 59, 59),
                          fontStyle: FontStyle.italic, // normal italic
                          fontWeight: FontWeight.normal, // not bold
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Role Cards
                _buildRoleCard(
                  context: context,
                  icon: Icons.agriculture,
                  backgroundColor: const Color.fromARGB(255, 248, 252, 225),
                  title: "Farmer",
                  subtitle: "Manage your crops and livestock.",
                  color: const Color(0xFF1DD1A1),
                  onTap: () => Navigator.pushNamed(context, '/farmerForm1'),
                ),
                _buildRoleCard(
                  context: context,
                  icon: Icons.work,
                  backgroundColor: const Color.fromARGB(255, 248, 252, 225),
                  title: "Labour",
                  subtitle: "Find agricultural work opportunities.",
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/labourForm'),
                ),
                _buildRoleCard(
                  context: context,
                  icon: Icons.local_shipping,
                  backgroundColor: const Color.fromARGB(255, 248, 252, 225),
                  title: "Driver",
                  subtitle: "Offer transport services.",
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/driverForm'),
                ),

                const Spacer(),

                // Bottom illustration
                SizedBox(
                  height: 160,
                  child: Image.asset(
                    "assets/agriculture.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Floating back button
          Positioned(
            top: 38,
            left: 16,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              color: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: const Color(0xFFE1FCF9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
