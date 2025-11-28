import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/resify_logo.png', width: 130),
              const SizedBox(height: 40),
              const Text("Pilih Fitur Kalkulator", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 24),
              
              _buildMenuButton(
                context, 
                "Hitung Resistor (Gelang)", 
                Colors.red.shade600, 
                "lib/assets/images/icon_resistor.png", 
                '/resistor'
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context, 
                "Hukum Ohm (V=I.R)", 
                Colors.blue.shade700, 
                "lib/assets/images/icon_kalkulator.png", 
                '/ohm'
              ),
              const SizedBox(height: 32),
               OutlinedButton(
                 style: OutlinedButton.styleFrom(
                   minimumSize: const Size(double.infinity, 55),
                   side: BorderSide(color: Colors.brown.shade300),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.history, color: Colors.brown.shade400), const SizedBox(width: 10), Text("Lihat Riwayat", style: TextStyle(color: Colors.brown.shade400))],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Color color, String iconPath, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 65), // Tombol lebih tinggi sedikit
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // UKURAN ICON DIPERBESAR JADI 32
          Image.asset(iconPath, width: 32, height: 32, color: Colors.white), 
          const SizedBox(width: 16), 
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}