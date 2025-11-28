import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    
    Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, '/onboarding'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 160), // Ukuran logo sedikit diperbesar
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Colors.orange),
              const SizedBox(height: 20),
               Text("Loading components...", style: TextStyle(color: Colors.grey[600], fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}