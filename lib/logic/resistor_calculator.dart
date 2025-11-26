class ResistorCalculator {
  
  static double calculate4Band({
    required int band1,
    required int band2,
    required double multiplier,
  }) {
    final baseValue = (band1 * 10) + band2;
    return baseValue * multiplier;
  }

  
  static double calculate5Band({
    required int band1,
    required int band2,
    required int band3,
    required double multiplier,
  }) {
    final baseValue = (band1 * 100) + (band2 * 10) + band3;
    return baseValue * multiplier;
  }
}