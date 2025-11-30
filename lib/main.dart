import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/splash_screen.dart';
import 'ui/onboarding_screen.dart';
import 'ui/home_screen.dart';
import 'ui/resistor_screen.dart';
import 'ui/ohm_screen.dart';
import 'ui/history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/resistor': (context) => const ResistorScreen(),
        '/ohm': (context) => const OhmScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}