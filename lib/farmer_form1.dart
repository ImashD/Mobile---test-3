import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerFormScreen1 extends StatefulWidget {
  const FarmerFormScreen1({super.key});

  @override
  State<FarmerFormScreen1> createState() => _FarmerFormScreen1State();
}

class _FarmerFormScreen1State extends State<FarmerFormScreen1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/farmerForm2');
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label*",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 320,
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            readOnly: readOnly,
            onTap: onTap,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter $label";
              }
              if (label == "Email") {
                if (!RegExp(r'^[^@]+@gmail\.com$').hasMatch(value)) {
                  return "Email must be valid";
                }
              }
              if (label == "N.I.C") {
                if (value.length != 12) {
                  return "NIC must be exactly 12 characters";
                }
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color.fromARGB(255, 118, 226, 198),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1DD1A1),
      body: SafeArea(
        child: Column(
          children: [
            // Top header container
            Stack(
              children: [
                Container(height: 160, color: const Color(0xFF1DD1A1)),
                Positioned(
                  top: 16,
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
                Positioned(
                  top: 46,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
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
                        const SizedBox(height: 8),
                        const Text(
                          "Enter your details",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom container with rounded top corners
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                label: "Name",
                                hint: "Your first name",
                                controller: _nameController,
                              ),
                              _buildTextField(
                                label: "Surname",
                                hint: "Your surname",
                                controller: _surnameController,
                              ),
                              _buildTextField(
                                label: "Email",
                                hint: "Your email",
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                              ),
                              _buildTextField(
                                label: "Date of Birth",
                                hint: "YYYY / MM / DD",
                                controller: _dobController,
                                readOnly: true,
                                onTap: _pickDate,
                                inputType: TextInputType.datetime,
                                suffixIcon: const Icon(Icons.calendar_month),
                              ),
                              _buildTextField(
                                label: "N.I.C",
                                hint: "Your NIC number",
                                controller: _nicController,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: _onNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1DD1A1),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
