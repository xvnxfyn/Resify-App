class History {
  final int? id;
  final String date;
  final int bandType;
  final String colors; 
  final double result;
  final String tolerance;
  final String resultString;

  History({
    this.id,
    required this.date,
    required this.bandType,
    required this.colors,
    required this.result,
    required this.tolerance,
    required this.resultString,
  });

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      date: map['date'],
      bandType: map['band_type'],
      colors: map['colors'],
      result: map['result'],
      tolerance: map['tolerance'],
      resultString: map['result_string'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'band_type': bandType,
      'colors': colors,
      'result': result,
      'tolerance': tolerance,
      'result_string': resultString,
    };
  }
}
