class OhmLogic {
  // V = I * R
  String hitungTegangan(double i, double r) => "${(i * r).toStringAsFixed(1)} V";
  
  // I = V / R
  String hitungArus(double v, double r) => "${(v / r).toStringAsFixed(1)} A";
  
  // R = V / I
  String hitungHambatan(double v, double i) => "${(v / i).toStringAsFixed(1)} Ω";
  
  // P = V * I
  String hitungDaya(double v, double i) => "${(v * i).toStringAsFixed(1)} W";
}