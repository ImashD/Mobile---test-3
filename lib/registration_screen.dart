import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String phoneNumber = "";
  bool isSending = false;

  void _goToOtpScreen() {
    if (phoneNumber.isEmpty || !phoneNumber.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid phone number with country code"),
        ),
      );
      return;
    }

    setState(() => isSending = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isSending = false);
      // Directly navigate to OTP screen (mock flow)
      Navigator.pushNamed(context, '/otp');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1FCF9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back button + logo
              Stack(
                children: [
                  Container(height: 120, color: Colors.transparent),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF1DD1A1),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 46,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1FCF9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset('assets/logo.png', height: 50),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Registration",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              Image.asset("assets/farmer.png", height: 180),
              const SizedBox(height: 20),
              const Text(
                "Enter your Mobile Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "We will send you a 4-digit verification code",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 15),

              // Phone input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialCountryCode: 'LK', // Sri Lanka 🇱🇰
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Get OTP button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1AB394),
                  minimumSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: isSending ? null : _goToOtpScreen,
                child: isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Generate OTP",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
