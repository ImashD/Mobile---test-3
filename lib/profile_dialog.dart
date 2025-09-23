import 'package:flutter/material.dart';

class ProfileDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Photo
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF76E2C6),
                    child: Icon(Icons.person, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 12),

                  // User Name
                  const Text(
                    "John Doe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  // Role
                  const Text(
                    "Role: Farmer",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),

                  // Paddy Type
                  const Text(
                    "Paddy Type: Red Samba",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),

                  // Contact Number
                  const Text(
                    "Contact: +94 77 123 4567",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Switch Role Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009688),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    icon: const Icon(Icons.switch_account),
                    label: const Text("Switch Role"),
                    onPressed: () {
                      Navigator.pop(ctx); // close dialog
                      Navigator.pushNamed(context, "/role_selection_screen");
                    },
                  ),
                  const SizedBox(height: 10),

                  // OK Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF76E2C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx); // close dialog
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
