class OhmLogic {
  String hitungTegangan(double i, double r) =>
      "${(i * r).toStringAsFixed(2)} V";
  String hitungArus(double v, double r) => "${(v / r).toStringAsFixed(4)} A";
  String hitungHambatan(double v, double i) =>
      "${(v / i).toStringAsFixed(2)} Ω";
  String hitungDaya(double v, double i) => "${(v * i).toStringAsFixed(2)} W";
}
