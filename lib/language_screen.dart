import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1DD1A1),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                Container(height: 120, color: Colors.transparent),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1FCF9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFE1FCF9),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
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

            const SizedBox(height: 20),

            // Card with background image
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7F4),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/languagebg.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.2), // subtle overlay
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Select your language",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'HyperDeluxe',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options
                    RadioListTile<String>(
                      title: const Text(
                        "සිංහල",
                        style: TextStyle(fontSize: 18),
                      ),
                      value: "Sinhala",
                      groupValue: _selectedLanguage,
                      activeColor: Colors.black,
                      onChanged: (value) =>
                          setState(() => _selectedLanguage = value),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "தமிழ்",
                        style: TextStyle(fontSize: 18),
                      ),
                      value: "Tamil",
                      groupValue: _selectedLanguage,
                      activeColor: Colors.black,
                      onChanged: (value) =>
                          setState(() => _selectedLanguage = value),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "English",
                        style: TextStyle(fontSize: 18),
                      ),
                      value: "English",
                      groupValue: _selectedLanguage,
                      activeColor: Colors.black,
                      onChanged: (value) =>
                          setState(() => _selectedLanguage = value),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1DD1A1),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
