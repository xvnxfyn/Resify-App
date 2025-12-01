class OhmCalculator {
  String hitungTegangan({required double arus, required double hambatan}) {
    return "${(arus * hambatan).toStringAsFixed(2)} V";
  }

  String hitungArus({required double tegangan, required double hambatan}) {
    if (hambatan == 0) return "Error";
    return "${(tegangan / hambatan).toStringAsFixed(2)} A";
  }

  String hitungHambatan({required double tegangan, required double arus}) {
    if (arus == 0) return "Error";
    return "${(tegangan / arus).toStringAsFixed(2)} Ω";
  }

  String hitungDaya({required double tegangan, required double arus}) {
    return "${(tegangan * arus).toStringAsFixed(2)} W";
  }
}
