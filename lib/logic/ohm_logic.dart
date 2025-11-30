class OhmLogic {
  String hitungTegangan(double i, double r) => "${(i * r).toStringAsFixed(3)} V";
  String hitungArus(double v, double r) => "${(v / r).toStringAsFixed(3)} A";
  String hitungHambatan(double v, double i) => "${(v / i).toStringAsFixed(3)} Ω";
  String hitungDaya(double v, double i) => "${(v * i).toStringAsFixed(3)} W";
}