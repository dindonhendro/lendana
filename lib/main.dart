import 'package:flutter/material.dart';
import 'package:lendana5/pages/landing_page.dart';
import 'package:lendana5/pages/register_page.dart';
import 'package:lendana5/splash_screen.dart'; // Import the splash screen
import 'package:lendana5/repository/api_repository.dart';
import 'package:lendana5/themes/light_mode.dart';
import 'package:lendana5/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is logged in
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ??
      false; // Use a boolean to track login status

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => const LoginPage(),
        // Add more routes as needed
      },
      title: 'Flutter Demo',
      theme: lightMode,
      home: isLoggedIn
          ? LandingPage()
          : SplashScreen(), // Choose the initial page based on login status
    );
  }
}
