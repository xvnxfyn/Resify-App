import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import semua halaman yang sudah kita buat di folder UI
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
      title: 'Resify', // Nama Aplikasi 
      debugShowCheckedModeBanner: false,
      
      // --- TEMA APLIKASI ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white, 
        
        
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        
        // Gaya AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Warna teks judul hitam
          elevation: 0, // Tidak ada bayangan
          centerTitle: true,
        ),
      ),

      // --- PENGATURAN RUTE (NAVIGASI) ---
      // Aplikasi dimulai dari Splash Screen ('/')
      initialRoute: '/',
      
      // Daftar alamat halaman aplikasi kita
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