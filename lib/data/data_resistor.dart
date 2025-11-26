import 'package:flutter/material.dart';
import '../model/model_resistor.dart';

class ResistorData {
  static const List<ResistorBand> bands = [
    ResistorBand(
      name: 'Hitam',
      color: Colors.black,
      digit: 0,
      multiplier: 1,
      tolerance: null,
    ),
    ResistorBand(
      name: 'Cokelat',
      color: Color(0xFF795548),
      digit: 1,
      multiplier: 10,
      tolerance: 1.0,
    ),
    ResistorBand(
      name: 'Merah',
      color: Colors.red,
      digit: 2,
      multiplier: 100,
      tolerance: 2.0,
    ),
    ResistorBand(
      name: 'Oranye',
      color: Colors.orange,
      digit: 3,
      multiplier: 1000, // 1K
      tolerance: 0.05, 
    ),
    ResistorBand(
      name: 'Kuning',
      color: Colors.yellow,
      digit: 4,
      multiplier: 10000, // 10K
      tolerance: 0.02,
    ),
    ResistorBand(
      name: 'Hijau',
      color: Colors.green,
      digit: 5,
      multiplier: 100000, // 100K
      tolerance: 0.5,
    ),
    ResistorBand(
      name: 'Biru',
      color: Colors.blue,
      digit: 6,
      multiplier: 1000000, // 1M
      tolerance: 0.25,
    ),
    ResistorBand(
      name: 'Ungu',
      color: Colors.purple,
      digit: 7,
      multiplier: 10000000, // 10M
      tolerance: 0.1,
    ),
    ResistorBand(
      name: 'Abu-abu',
      color: Colors.grey,
      digit: 8,
      multiplier: 100000000, // 100M
      tolerance: 0.05,
    ),
    ResistorBand(
      name: 'Putih',
      color: Colors.white, 
      digit: 9,
      multiplier: 1000000000, // 1G
      tolerance: null,
    ),
    ResistorBand(
      name: 'Emas',
      color: Color(0xFFFFD700),
      digit: null, // Emas tidak dipakai untuk gelang 1, 2, atau 3
      multiplier: 0.1,
      tolerance: 5.0,
    ),
    ResistorBand(
      name: 'Perak',
      color: Color(0xFFC0C0C0),
      digit: null, // Perak tidak dipakai untuk gelang 1, 2, atau 3
      multiplier: 0.01,
      tolerance: 10.0,
    ),
  ];
}