import 'package:distribook/components/Navbar.dart';
import 'package:distribook/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distribook/screens/LoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // Initialization
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distribook',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.plusJakartaSans(color: Colors.black),
          headlineMedium: GoogleFonts.plusJakartaSans(color: Colors.black),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        useMaterial3: true,
      ),
      home: const MyAppStateful(),
    );
  }
}

class MyAppStateful extends StatefulWidget {
  const MyAppStateful({super.key});

  @override
  State<MyAppStateful> createState() => _MyAppStatefulState();
}

class _MyAppStatefulState extends State<MyAppStateful> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
