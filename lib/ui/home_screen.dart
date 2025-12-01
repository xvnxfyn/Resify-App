import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 140),
              const SizedBox(height: 40),
              Text("Pilih Fitur Kalkulator",
                  style: GoogleFonts.poppins(
                      color: Colors.grey[500], fontSize: 14)),
              const SizedBox(height: 20),

              // Tombol Resistor (Hijau)
              _buildMenuButton(
                  context,
                  "Kalkulator Resistor",
                  const Color(0xFF4CAF50),
                  "lib/assets/images/icon_resistor.png",
                  '/resistor'),
              const SizedBox(height: 16),

              // Tombol Ohm (Biru)
              _buildMenuButton(
                  context,
                  "Kalkulator Hukum Ohm",
                  const Color(0xFF00A9FF),
                  "lib/assets/images/icon_ohm.png",
                  '/ohm'),
              const SizedBox(height: 16),

              // Tombol Riwayat (Putih Outline)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: Text("Lihat Riwayat",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF00A9FF),
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Color color,
      String iconPath, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 65),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Menggunakan Image asset untuk icon
          Image.asset(iconPath, width: 24, height: 24, color: Colors.white),
          const SizedBox(width: 12),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
