import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

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
      "image": "lib/assets/images/icon_thunderblue.png",
      "title": "Hitung Hukum Ohm Instan",
      "desc": "Pilih variabelnya, hasil muncul otomatis"
    },
    {
      "image": "lib/assets/images/icon_resistorblue.png",
      "title": "Baca Kode Resistor Instan",
      "desc": "Pilih warna gelang, nilai resistansi langsung ketemu."
    },
    {
      "image": "lib/assets/images/icon_bookblue.png",
      "title": "Belajar Jadi Lebih Praktis",
      "desc": "Bantu hitung dan cek rangkaian dengan cepat."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                      const SizedBox(height: 40),
                      Text(_pages[index]["title"]!,
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text(_pages[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                _pages.length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 8 : 6,
                      height: _currentPage == index ? 8 : 6,
                      decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          shape: BoxShape.circle),
                    )),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                }
              },
              child: Text(
                  _currentPage == _pages.length - 1
                      ? "Mulai Sekarang"
                      : "Berikutnya",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
