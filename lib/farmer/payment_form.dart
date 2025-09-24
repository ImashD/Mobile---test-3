import 'package:flutter/material.dart';

class FarmerPaymentFormScreen extends StatefulWidget {
  const FarmerPaymentFormScreen({super.key});

  @override
  State<FarmerPaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<FarmerPaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _accountNumberController =
      TextEditingController();

  // Dropdown selections
  String? _selectedBank;
  String? _selectedBranch;

  final List<String> _banks = [
    "Bank of Ceylon",
    "People's Bank",
    "Sampath Bank",
    "Hatton National Bank",
    "Commercial Bank",
    "National Savings Bank",
    "DFCC Bank",
    "NTB Bank",
    "Pan Asia Bank",
    "Seylan Bank",
  ];

  final List<String> _branches = [
    "Colombo 1",
    "Colombo 2",
    "Kandy",
    "Galle",
    "Jaffna",
    "Negombo",
    "Anuradhapura",
  ];

  Widget _buildDropdown(
    String label,
    String hint,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
          decoration: InputDecoration(
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
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $label";
            }
            if (label == "Account number" && value.length < 10) {
              return "Enter a valid account number";
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
          ),
        ),
      ],
    );
  }

  void _onNext() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Wait for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return; // ensure widget still exists

      // Close spinner
      Navigator.of(context).pop();

      // Navigate to farmer dashboard
      Navigator.pushReplacementNamed(context, '/fdashboard');
    }
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
                          "Enter your Bank Details",
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
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildDropdown(
                          "Select Bank*",
                          "Choose your bank",
                          _banks,
                          _selectedBank,
                          (value) => setState(() => _selectedBank = value),
                        ),
                        const SizedBox(height: 20),
                        _buildDropdown(
                          "Select Branch*",
                          "Choose your branch",
                          _branches,
                          _selectedBranch,
                          (value) => setState(() => _selectedBranch = value),
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          "Account number*",
                          "Your Bank Account Number",
                          _accountNumberController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                4,
                                96,
                                71,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Save & REGISTER)",
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
          ],
        ),
      ),
    );
  }
}
