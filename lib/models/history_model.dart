class HistoryModel {
  final int? id;
  final String type; // "Resistor" atau "Ohm"
  final String input; // Detail input (misal: "Merah, Merah, Coklat")
  final String result; // Hasil (misal: "220 Ohm")
  final String timestamp;

  HistoryModel({this.id, required this.type, required this.input, required this.result, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'input': input,
      'result': result,
      'timestamp': timestamp,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      type: map['type'],
      input: map['input'],
      result: map['result'],
      timestamp: map['timestamp'],
    );
  }
}