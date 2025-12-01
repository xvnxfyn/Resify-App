import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/resistor_logic.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';

class ResistorScreen extends StatefulWidget {
  const ResistorScreen({super.key});
  @override
  State<ResistorScreen> createState() => _ResistorScreenState();
}

class _ResistorScreenState extends State<ResistorScreen> {
  final ResistorLogic logic = ResistorLogic();
  int bands = 4;
  String? color1, color2, color3, multiplier, tolerance;
  String result = "0.00 Ω";
  bool hasCalculated = false;

  Color _getColor(String? name) {
    switch (name) {
      case 'Hitam':
        return Colors.black;
      case 'Cokelat':
        return const Color(0xFF795548);
      case 'Merah':
        return const Color(0xFFE53935);
      case 'Oranye':
        return Colors.orange;
      case 'Kuning':
        return const Color(0xFFFFEB3B);
      case 'Hijau':
        return const Color(0xFF43A047);
      case 'Biru':
        return const Color(0xFF1E88E5);
      case 'Ungu':
        return const Color(0xFF8E24AA);
      case 'Abu-abu':
        return Colors.grey;
      case 'Putih':
        return Colors.white;
      case 'Emas':
        return const Color(0xFFFFD700);
      case 'Perak':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }

  void _calculate() async {
    if (color1 == null || color2 == null || multiplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Pilih warna minimal untuk gelang wajib!")));
      return;
    }
    String res = bands == 4
        ? logic.calculate4Band(
            color1!, color2!, multiplier!, tolerance ?? 'Emas')
        : logic.calculate5Band(color1!, color2!, color3 ?? 'Hitam', multiplier!,
            tolerance ?? 'Emas');

    setState(() {
      result = res;
      hasCalculated = true;
    });
    await DatabaseHelper.instance.insertHistory(HistoryModel(
        type: "Resistor",
        input: "$bands Gelang: $color1, $color2...",
        result: res,
        timestamp: DateTime.now().toString()));
  }

  void _reset() {
    setState(() {
      color1 = null;
      color2 = null;
      color3 = null;
      multiplier = null;
      tolerance = null;
      result = "0.00 Ω";
      hasCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Resistor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Visualisasi
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade100, blurRadius: 10)
                  ]),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 260,
                    height: 70,
                    decoration: BoxDecoration(
                        color: const Color(0xFF81D4FA),
                        borderRadius: BorderRadius.circular(35),
                        border:
                            Border.all(color: Colors.blue.shade100, width: 2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 20),
                        _band(_getColor(color1)),
                        _band(_getColor(color2)),
                        if (bands == 5) _band(_getColor(color3)),
                        const SizedBox(width: 10),
                        _band(_getColor(multiplier)),
                        const SizedBox(width: 20),
                        _band(_getColor(tolerance), isTol: true),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                Expanded(child: _toggle(4, "4 Gelang")),
                Expanded(child: _toggle(5, "5 Gelang")),
              ]),
            ),
            const SizedBox(height: 20),

            _drop("Gelang 1", logic.digitColors.keys.toList(), color1,
                (v) => setState(() => color1 = v)),
            _drop("Gelang 2", logic.digitColors.keys.toList(), color2,
                (v) => setState(() => color2 = v)),
            if (bands == 5)
              _drop("Gelang 3", logic.digitColors.keys.toList(), color3,
                  (v) => setState(() => color3 = v)),
            _drop("Pengali", logic.multipliers.keys.toList(), multiplier,
                (v) => setState(() => multiplier = v)),
            _drop("Toleransi", logic.tolerances.keys.toList(), tolerance,
                (v) => setState(() => tolerance = v)),

            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A9FF),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: _calculate,
                      child: const Text("Hitung"))),
              const SizedBox(width: 10),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: _reset,
                      child: const Text("Reset"))),
            ]),

            const SizedBox(height: 20),
            if (hasCalculated)
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFC8E6C9),
                    borderRadius: BorderRadius.circular(16)), // Hijau Muda
                child: Column(children: [
                  Text("Nilai Resistansi:",
                      style: TextStyle(color: Colors.green[800])),
                  Text(result,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900])),
                ]),
              )
          ],
        ),
      ),
    );
  }

  Widget _band(Color c, {bool isTol = false}) => Container(
      width: 18,
      height: 70,
      color: c == Colors.transparent ? Colors.grey[300] : c);
  Widget _toggle(int b, String l) {
    bool sel = bands == b;
    return GestureDetector(
        onTap: () => setState(() {
              bands = b;
              _reset();
            }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: sel ? const Color(0xFF00A9FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(l,
                  style: TextStyle(
                      color: sel ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold))),
        ));
  }

  Widget _drop(String l, List<String> i, String? v, Function(String?) c) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: l,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white),
              value: v,
              items: i
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Row(children: [
                        Container(width: 12, height: 12, color: _getColor(e)),
                        SizedBox(width: 8),
                        Text(e)
                      ])))
                  .toList(),
              onChanged: c));
}
