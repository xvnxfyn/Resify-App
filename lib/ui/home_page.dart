import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                'assets/images/resify_logo.png',   // sesuaikan dengan path logo kamu
                width: 180,
                height: 180,
              ),
              
              const SizedBox(height: 16),

              // TEXT TITLE
              const Text(
                "ResiFy",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE85A2A),  // warna oranye biar mirip di gambarmu
                ),
              ),

              const SizedBox(height: 24),

              // Tombol untuk masuk ke kalkulator resistor
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/calculator");
                },
                child: const Text(
                  "Mulai Menghitung",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
