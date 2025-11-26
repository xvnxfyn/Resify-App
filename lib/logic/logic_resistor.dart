import '../model/model_resistor.dart';
import '../data/data_resistor.dart';

class ResistorLogic {
  static List<ResistorBand> get digitBands {
    return ResistorData.bands.where((band) => band.digit != null).toList();
  }

  
  static List<ResistorBand> get multiplierBands {
    return ResistorData.bands;
  }

  
  static List<ResistorBand> get toleranceBands {
    return ResistorData.bands.where((band) => band.tolerance != null).toList();
  }

  // FUNGSI HITUNG (Support 4 & 5 Gelang)
  static String calculate({
    required int bandCount, // 4 atau 5
    required ResistorBand band1,
    required ResistorBand band2,
    ResistorBand? band3, // Nullable karena resistor 4 gelang tidak punya band 3 (angka)
    required ResistorBand multiplier,
    required ResistorBand tolerance,
  }) {
    double result = 0;

    if (bandCount == 4) {
      // Rumus 4 Gelang: (Digit1 Digit2) * Multiplier
      int baseValue = (band1.digit! * 10) + band2.digit!;
      result = baseValue * multiplier.multiplier;
    } else if (bandCount == 5) {
      // Rumus 5 Gelang: (Digit1 Digit2 Digit3) * Multiplier
      int digit3 = band3?.digit ?? 0; 
      int baseValue = (band1.digit! * 100) + (band2.digit! * 10) + digit3;
      result = baseValue * multiplier.multiplier;
    }

    return formatResult(result) + " Ω ±${tolerance.tolerance}%";
  }

  // Memformat angka (1000 ke 1K)
  static String formatResult(double value) {
    if (value >= 1e9) return "${(value / 1e9).toStringAsFixed(2)} G";
    if (value >= 1e6) return "${(value / 1e6).toStringAsFixed(2)} M";
    if (value >= 1e3) return "${(value / 1e3).toStringAsFixed(2)} k";
    return value.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""); // Hapus .00 berlebih
  }
}