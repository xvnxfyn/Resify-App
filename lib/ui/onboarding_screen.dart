import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": "lib/assets/images/maskot_1.png",
      "title": "Hitung Hukum Ohm Lebih Cepat",
      "desc": "Tinggal pilih variabel, masukkan nilai, langsung dapat hasil."
    },
    {
      "image": "lib/assets/images/maskot_2.png",
      "title": "Baca Kode Resistor Seketika",
      "desc": "Visualisasi gelang warna yang memudahkan pembacaan resistor."
    },
    {
      "image": "lib/assets/images/maskot_3.png",
      "title": "Praktis untuk Belajar",
      "desc": "Teman setia mahasiswa teknik untuk tugas dan praktikum."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(_pages[index]["image"]!, height: 250),
                      const SizedBox(height: 32),
                      Text(_pages[index]["title"]!, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(_pages[index]["desc"]!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800], 
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                }
              },
              child: Text(_currentPage == _pages.length - 1 ? "Mulai Sekarang" : "Lanjut"),
            ),
          )
        ],
      ),
    );
  }
}