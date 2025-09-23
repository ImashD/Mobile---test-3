// stores.dart

import 'package:flutter/material.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Mock store data
  final List<Map<String, dynamic>> stores = [
    {
      "name": "Kurunegala Central Store",
      "owner": "Mr. Perera",
      "address": "No. 12, Main Road, Kurunegala",
      "capacity": "500 MT",
      "status": "Active",
    },
    {
      "name": "Anuradhapura Paddy Store",
      "owner": "Mr. Silva",
      "address": "New Town, Anuradhapura",
      "capacity": "300 MT",
      "status": "Under Maintenance",
    },
    {
      "name": "Polonnaruwa Main Store",
      "owner": "Ms. Kumari",
      "address": "Market Road, Polonnaruwa",
      "capacity": "450 MT",
      "status": "Active",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter stores by search query
    final filteredStores = stores
        .where(
          (store) =>
              store["name"].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Store Locations",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF009688),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔍 Search bar with clear button
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search store by name...",
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => searchQuery = "");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          // 🗺 Mock Map with pins
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    "assets/map_mock.png", // placeholder SL map image
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // 📍 Mock pins overlay
                ...filteredStores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final store = entry.value;
                  return Positioned(
                    left: 100.0 + (index * 50), // mock X pos
                    top: 150.0 + (index * 60), // mock Y pos
                    child: GestureDetector(
                      onTap: () => _showStoreDetails(context, store),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Attractive popup store details
  void _showStoreDetails(BuildContext context, Map<String, dynamic> store) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.store, size: 40, color: Colors.black),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      store["name"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.teal, height: 20),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    "Owner: ${store["owner"]}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Address: ${store["address"]}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.storage, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    "Capacity: ${store["capacity"]}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: store["status"] == "Active"
                        ? Colors.greenAccent
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Status: ${store["status"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: store["status"] == "Active"
                          ? Colors.greenAccent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text("Close"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
