import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 140),
              const SizedBox(height: 40),
              Text("Main Menu", style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              
              _buildMenuCard(context, "Kalkulator Resistor", Colors.redAccent, "lib/assets/images/icon_resistor.png", '/resistor'),
              const SizedBox(height: 16),
              _buildMenuCard(context, "Hukum Ohm", Colors.blueAccent, "lib/assets/images/icon_kalkulator.png", '/ohm'),
              const SizedBox(height: 16),
              
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white
                ),
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: Colors.grey[700]), 
                    const SizedBox(width: 12), 
                    Text("Riwayat Perhitungan", style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, Color color, String iconPath, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 80),
        elevation: 4,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Image.asset(iconPath, width: 32, height: 32, color: Colors.white),
          ),
          const SizedBox(width: 20), 
          Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}