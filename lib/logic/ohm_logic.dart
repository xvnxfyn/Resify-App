class OhmLogic {
  // V = I * R
  String hitungTegangan(double i, double r) => "${(i * r).toStringAsFixed(4)} V";
  
  // I = V / R
  String hitungArus(double v, double r) => "${(v / r).toStringAsFixed(4)} A";
  
  // R = V / I
  String hitungHambatan(double v, double i) => "${(v / i).toStringAsFixed(4)} Ω";
  
  // P = V * I
  String hitungDaya(double v, double i) => "${(v * i).toStringAsFixed(4)} W";
}