class ResistorLogic {
  final Map<String, int> digitColors = {
    'Hitam': 0, 'Cokelat': 1, 'Merah': 2, 'Oranye': 3, 'Kuning': 4,
    'Hijau': 5, 'Biru': 6, 'Ungu': 7, 'Abu-abu': 8, 'Putih': 9
  };

  final Map<String, double> multipliers = {
    'Hitam': 1, 'Cokelat': 10, 'Merah': 100, 'Oranye': 1000, 'Kuning': 10000,
    'Hijau': 100000, 'Biru': 1000000, 'Emas': 0.1, 'Perak': 0.01
  };

  final Map<String, String> tolerances = {
    'Cokelat': '±1%', 'Merah': '±2%', 'Hijau': '±0.5%', 'Biru': '±0.25%',
    'Ungu': '±0.1%', 'Abu-abu': '±0.05%', 'Emas': '±5%', 'Perak': '±10%'
  };

  String calculate4Band(String b1, String b2, String mul, String tol) {
    int v1 = digitColors[b1] ?? 0;
    int v2 = digitColors[b2] ?? 0;
    double m = multipliers[mul] ?? 1.0;
    String t = tolerances[tol] ?? '';
    double result = ((v1 * 10) + v2) * m;
    return "${_formatResult(result)} Ω $t";
  }

  String calculate5Band(String b1, String b2, String b3, String mul, String tol) {
    int v1 = digitColors[b1] ?? 0;
    int v2 = digitColors[b2] ?? 0;
    int v3 = digitColors[b3] ?? 0;
    double m = multipliers[mul] ?? 1.0;
    String t = tolerances[tol] ?? '';
    double result = ((v1 * 100) + (v2 * 10) + v3) * m;
    return "${_formatResult(result)} Ω $t";
  }

  String _formatResult(double val) {
    if (val >= 1000000) return "${(val / 1000000).toStringAsFixed(2)} M";
    if (val >= 1000) return "${(val / 1000).toStringAsFixed(2)} k";
    return val.toStringAsFixed(2);
  }
}