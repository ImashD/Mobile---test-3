import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;

  String get _enteredOtp =>
      _controllers.map((controller) => controller.text).join();

  void _mockVerifyOtp() {
    if (_enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 4-digit OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);

      // Show popup dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("✅ Verified"),
            content: const Text("Your OTP has been successfully verified."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pushReplacementNamed(context, '/roleSelection');
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  void _resendOtp() {
    setState(() => _isResending = true);

    Future.delayed(const Duration(seconds: 3), () {
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes.first.requestFocus(); // focus back to first box
      setState(() => _isResending = false);
    });
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1FCF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),

              const SizedBox(height: 30),

              // Verify button
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF1AB394))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _mockVerifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1AB394),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

              const SizedBox(height: 20),

              // Edit phone number
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Edit Phone Number",
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
              ),

              // Resend OTP
              _isResending
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                        strokeWidth: 2,
                      ),
                    )
                  : GestureDetector(
                      onTap: _resendOtp,
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
