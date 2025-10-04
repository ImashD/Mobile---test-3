import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // ✅ Added

class LabourFormScreen extends StatefulWidget {
  const LabourFormScreen({super.key});

  @override
  State<LabourFormScreen> createState() => _LabourFormScreenState();
}

class _LabourFormScreenState extends State<LabourFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _customSkillController = TextEditingController();

  String? _selectedSkill;
  File? _idImageFile;

  final List<String> _skills = [
    "Harvesting",
    "Planting",
    "Transporting",
    "Other",
  ];

  Future<void> _pickIdImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _idImageFile = File(pickedFile.path);
      });
    }
  }

  /// ✅ Save registration
  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_idImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload your ID image")),
        );
        return;
      }

      // ✅ save role

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Labour registered successfully!")),
      );

      Navigator.pushReplacementNamed(context, "/ldashboard");
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter $label";
              }
              if (label == "N.I.C" && value.length != 12) {
                return "NIC must be exactly 12 characters";
              }
              if (label == "Phone Number" && value.length < 10) {
                return "Enter a valid phone number";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFBBDEFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
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
      backgroundColor: const Color(0xFF2196F3), // Blue theme
      body: SafeArea(
        child: Column(
          children: [
            // Top header
            Stack(
              children: [
                Container(height: 160, color: const Color(0xFF2196F3)),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    color: Colors.transparent,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFE3F2FD),
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
                            color: const Color(0xFFE3F2FD),
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
                          "Labour Registration",
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

            // Bottom container
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: "Name",
                            hint: "Your full name",
                            controller: _nameController,
                          ),
                          _buildTextField(
                            label: "N.I.C",
                            hint: "Your NIC number",
                            controller: _nicController,
                          ),
                          _buildTextField(
                            label: "Phone Number",
                            hint: "Your phone number",
                            controller: _phoneController,
                            inputType: TextInputType.phone,
                          ),
                          _buildTextField(
                            label: "Age",
                            hint: "Your age",
                            controller: _ageController,
                            inputType: TextInputType.number,
                          ),
                          _buildTextField(
                            label: "Address",
                            hint: "Your home address",
                            controller: _addressController,
                          ),

                          // Skill type dropdown
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Skill*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedSkill,
                            items: _skills
                                .map(
                                  (skill) => DropdownMenuItem(
                                    value: skill,
                                    child: Text(skill),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSkill = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Please select a skill" : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFBBDEFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (_selectedSkill == "Other")
                            _buildTextField(
                              label: "Custom Skill",
                              hint: "Enter your skill",
                              controller: _customSkillController,
                            ),

                          _buildTextField(
                            label: "Experience (years)",
                            hint: "e.g. 3",
                            controller: _experienceController,
                            inputType: TextInputType.number,
                          ),

                          // ID upload
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Upload NIC/Work ID*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _pickIdImage,
                            child: Container(
                              width: 320,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBDEFB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _idImageFile == null
                                  ? const Icon(
                                      Icons.upload_file,
                                      size: 40,
                                      color: Colors.black54,
                                    )
                                  : Image.file(
                                      _idImageFile!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Submit button
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Save & REGISTER",
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
