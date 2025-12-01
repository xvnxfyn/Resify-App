import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/app_colors.dart';
import 'ui/splash_screen.dart';
import 'ui/onboarding_screen.dart';
import 'ui/home_screen.dart';
import 'ui/resistor_screen.dart';
import 'ui/ohm_screen.dart';
import 'ui/history_screen.dart';

void main() {
  runApp(const ResifyApp());
}

class ResifyApp extends StatelessWidget {
  const ResifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.w600
          ),
        ),
        // Style default untuk TextField agar seragam
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
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