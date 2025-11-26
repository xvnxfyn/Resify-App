import 'package:flutter/material.dart';
import '../ui/ui_splash.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resistor App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // GANTI HOME MENJADI SPLASH PAGE:
      home: const SplashPage(), 
    );
  }
}