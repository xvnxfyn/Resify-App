import 'package:flutter/material.dart';
import 'dao/history_dao.dart';
import 'models/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dao = HistoryDao();

  await dao.insertHistory(
    History(
      date: DateTime.now().toIso8601String(),
      bandType: 4,
      colors: "red, violet, yellow, gold",
      result: 47000,
      tolerance: "±5%",
      resultString: "47 kΩ ±5%",
    ),
  );

  final histories = await dao.getHistory();
  print(histories.map((e) => e.resultString).toList());

  runApp(const MaterialApp(home: Scaffold(body: Center(child: Text("DB OK")))));
}
