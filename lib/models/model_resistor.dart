import 'package:flutter/material.dart';

class ResistorBand {
  final String name;
  final Color color;
  final int? digit;
  final double multiplier;
  final double? tolerance;

  const ResistorBand({
    required this.name,
    required this.color,
    required this.digit,
    required this.multiplier,
    required this.tolerance,
  });
}
