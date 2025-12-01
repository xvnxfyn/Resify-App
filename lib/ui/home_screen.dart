import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 150),
              const SizedBox(height: 40),
              Text("Pilih Fitur Kalkulator",
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 20),
              _buildMenuButton(
                  context,
                  "Kalkulator Resistor",
                  AppColors.secondary,
                  "lib/assets/images/icon_resistor.png",
                  '/resistor'),
              const SizedBox(height: 16),
              _buildMenuButton(context, "Kalkulator Hukum Ohm",
                  AppColors.primary, "lib/assets/images/icon_ohm.png", '/ohm'),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: Text("Lihat Riwayat",
                    style: GoogleFonts.poppins(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
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
