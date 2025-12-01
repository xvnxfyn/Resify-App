import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Timer(const Duration(seconds: 3),
        () => Navigator.pushReplacementNamed(context, '/onboarding'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 350),
              const SizedBox(height: 24),
              Text("ResiFy",
                  style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
