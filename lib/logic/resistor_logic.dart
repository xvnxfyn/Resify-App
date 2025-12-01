class ResistorCalculator {
  // Data warna sebagai konstanta statis
  static const Map<String, int> bandValues = {
    'Hitam': 0,
    'Cokelat': 1,
    'Merah': 2,
    'Oranye': 3,
    'Kuning': 4,
    'Hijau': 5,
    'Biru': 6,
    'Ungu': 7,
    'Abu-abu': 8,
    'Putih': 9
  };

  static const Map<String, double> multipliers = {
    'Hitam': 1,
    'Cokelat': 10,
    'Merah': 100,
    'Oranye': 1000,
    'Kuning': 10000,
    'Hijau': 100000,
    'Biru': 1000000,
    'Emas': 0.1,
    'Perak': 0.01
  };

  static const Map<String, String> tolerances = {
    'Cokelat': '±1%',
    'Merah': '±2%',
    'Hijau': '±0.5%',
    'Biru': '±0.25%',
    'Ungu': '±0.1%',
    'Abu-abu': '±0.05%',
    'Emas': '±5%',
    'Perak': '±10%'
  };

  String get4BandResult(String b1, String b2, String mul, String tol) {
    int val1 = bandValues[b1] ?? 0;
    int val2 = bandValues[b2] ?? 0;
    double m = multipliers[mul] ?? 1.0;
    String t = tolerances[tol] ?? '';

    double totalResistance = ((val1 * 10) + val2) * m;
    return "${_formatValue(totalResistance)} Ω $t";
  }

  String get5BandResult(
      String b1, String b2, String b3, String mul, String tol) {
    int val1 = bandValues[b1] ?? 0;
    int val2 = bandValues[b2] ?? 0;
    int val3 = bandValues[b3] ?? 0;
    double m = multipliers[mul] ?? 1.0;
    String t = tolerances[tol] ?? '';

    double totalResistance = ((val1 * 100) + (val2 * 10) + val3) * m;
    return "${_formatValue(totalResistance)} Ω $t";
  }

  String _formatValue(double val) {
    if (val >= 1e6) return "${(val / 1e6).toStringAsFixed(2)} M";
    if (val >= 1e3) return "${(val / 1e3).toStringAsFixed(2)} k";
    return val.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }
}
