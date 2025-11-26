class ResistorColor {
  final int? id;
  final String color;
  final int? value;
  final double? multiplier;
  final double? tolerance;
  final int bandType;

  ResistorColor({
    this.id,
    required this.color,
    this.value,
    this.multiplier,
    this.tolerance,
    required this.bandType,
  });

  factory ResistorColor.fromMap(Map<String, dynamic> map) {
    return ResistorColor(
      id: map['id'],
      color: map['color'],
      value: map['value'],
      multiplier: map['multiplier'] != null
          ? (map['multiplier'] as num).toDouble()
          : null,
      tolerance: map['tolerance'] != null
          ? (map['tolerance'] as num).toDouble()
          : null,
      bandType: map['band_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'value': value,
      'multiplier': multiplier,
      'tolerance': tolerance,
      'band_type': bandType,
    };
  }
}
