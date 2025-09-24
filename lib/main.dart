import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'welcome_screen.dart';
import 'language_screen.dart';
import 'registration_screen.dart';
import 'otp_screen.dart';
import 'role_selection_screen.dart';
import 'farmer/farmer_form1.dart';
import 'farmer/farmer_form2.dart' show FarmerFormScreen;
import 'farmer/payment_form.dart';
import 'labour/labour_form.dart';
import 'driver/driver_form.dart';
import 'farmer/farmer_dashboard.dart';
import 'farmer/feature/market.dart';
import 'farmer/feature/stores.dart';
import 'farmer/feature/labors.dart';
import 'farmer/feature/drivers.dart';
import 'farmer/feature/cultivation.dart';
import 'farmer/feature/weather.dart';
import 'farmer/drawer/my_products.dart';
import 'farmer/drawer/reports.dart';
import 'farmer/drawer/promotions.dart';
import 'farmer/drawer/contact.dart';
import 'farmer/drawer/products.dart';
import 'farmer/drawer/learn.dart';
import 'driver/driver_dashboard.dart';
import 'labour/labour_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Sample products list (can later be managed dynamically)
  static final List<Map<String, dynamic>> myProductsList = [
    {
      "name": "Samba",
      "quantity": "120",
      "price": "120",
      "area": "2 acres",
      "harvestDate": "15-Aug-2025",
      "status": "Growing",
      "image": "assets/samba.png",
      "isAsset": true,
    },
    {
      "name": "Naadu (Red)",
      "quantity": "80",
      "price": "100",
      "area": "3 acres",
      "harvestDate": "05-Jul-2025",
      "status": "Sold Out",
      "image": "assets/red_naadu.png",
      "isAsset": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wee Saviya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1DD1A1),
        scaffoldBackgroundColor: const Color(0xFFE1FCF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1DD1A1),
          centerTitle: true,
        ),
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const WelcomeScreen()
          : const DashboardScreen(),

      initialRoute: '/ddashboard',
      routes: {
        '/language': (context) => const LanguageScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/otp': (context) => const OtpScreen(),
        '/roleSelection': (context) => const RoleSelectionScreen(),
        '/farmerForm1': (context) => const FarmerFormScreen1(),
        '/farmerForm2': (context) => const FarmerFormScreen(),
        '/paymentForm': (context) => const FarmerPaymentFormScreen(),
        '/labourForm': (context) => const LabourFormScreen(),
        '/driverForm': (context) => const DriverFormScreen(),
        '/fdashboard': (context) => const DashboardScreen(),
        '/market': (context) => const MarketScreen(),
        '/stores': (context) => const StoresScreen(),
        '/labors': (context) => const LaborsScreen(),
        '/drivers': (context) => const DriversScreen(),
        '/ddashboard': (context) => const DriverDashboard(),
        '/ldashboard': (context) => const LabourDashboard(),

        // Pass products list to cultivation
        '/cultivation': (context) =>
            CultivationScreen(products: myProductsList),

        '/weather': (context) => const WeatherScreen(),
        '/products': (context) => const ProductsScreen(),
        '/myProducts': (context) => const MyProductsScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/promotions': (context) => const PromotionsScreen(),
        '/learn': (context) => const LearnScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}
