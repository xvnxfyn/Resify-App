import 'package:flutter/material.dart';

class ResistorBand {
  final String name;      // Nama warna (misal: Merah)
  final Color color;      // Warna untuk ditampilkan di UI
  final int? digit;       // Nilai angka (0-9). Null untuk Emas/Perak
  final double multiplier; // Nilai pengali (1, 10, 100, dst)
  final double? tolerance; // Nilai toleransi dalam %. Null jika tidak ada

  const ResistorBand({
    required this.name,
    required this.color,
    this.digit,
    required this.multiplier,
    this.tolerance,
  });
}