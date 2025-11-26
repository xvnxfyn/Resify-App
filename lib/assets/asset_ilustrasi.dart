import 'package:flutter/material.dart';
import '../model/model_resistor.dart';

class ResistorIllustration extends StatelessWidget {
  final bool isFiveBand;
  final ResistorBand band1;
  final ResistorBand band2;
  final ResistorBand? band3;
  final ResistorBand multiplier;
  final ResistorBand tolerance;

  const ResistorIllustration({
    super.key,
    required this.isFiveBand,
    required this.band1,
    required this.band2,
    this.band3,
    required this.multiplier,
    required this.tolerance,
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran-ukuran dasar
    const double height = 70;
    const double bodyWidth = 240;
    const double totalWidth = 300;
    const double bandWidth = 14;
    final Color bodyColor = const Color.fromARGB(255, 225, 178, 108);

    return Center(
      child: SizedBox(
        height: height,
        width: totalWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Kawat (Wire) - Lapisan paling belakang
            Container(
              height: 8,
              width: totalWidth,
              color: Colors.grey.shade400,
            ),

            // 2. Badan Resistor & Gelang-gelangnya
            Container(
              height: height,
              width: bodyWidth,
              decoration: BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(color: Colors.grey.shade600, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // 3. Gelang-gelang warna
              child: Row(
                children: [
                  // Spasi awal dari kiri
                  const SizedBox(width: 25),
                  
                  // Gelang 1
                  _buildBand(band1.color, height, bandWidth),
                  const SizedBox(width: 12),

                  // Gelang 2
                  _buildBand(band2.color, height, bandWidth),
                  const SizedBox(width: 12),

                  // Gelang 3 (Hanya jika 5 gelang)
                  if (isFiveBand && band3 != null) ...[
                    _buildBand(band3!.color, height, bandWidth),
                    const SizedBox(width: 12),
                  ],

                  // Gelang Multiplier (Pengali)
                  _buildBand(multiplier.color, height, bandWidth),
                  
                  // Spacer: Mendorong gelang toleransi ke ujung kanan
                  Spacer(), 

                  // Gelang Toleransi (Terpisah agak jauh)
                  _buildBand(tolerance.color, height, bandWidth),
                  const SizedBox(width: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk menggambar satu gelang warna
  Widget _buildBand(Color color, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: (color == Colors.white || color == Colors.yellow)
            ? Border.all(color: Colors.grey.shade400, width: 0.5)
            : null,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.9),
            color,
            color.withValues(alpha: 0.9),
          ],
        ),
      ),
    );
  }
}