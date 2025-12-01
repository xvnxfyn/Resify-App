import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/resistor_logic.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';
import 'app_colors.dart';

class ResistorScreen extends StatefulWidget {
  const ResistorScreen({super.key});
  @override
  State<ResistorScreen> createState() => _ResistorScreenState();
}

class _ResistorScreenState extends State<ResistorScreen> {
  final ResistorCalculator _calculator = ResistorCalculator();
  int _bandCount = 4;
  String? color1, color2, color3, multiplier, tolerance;
  String _result = "0.00 Ω";
  bool _hasResult = false;

  Color _getBandColor(String? name) {
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

  // Remove Black from 1st Band
  List<String> _validFirstBandColors() {
    var list = ResistorCalculator.bandValues.keys.toList();
    list.remove('Hitam');
    return list;
  }

  void _calculate() async {
    if (color1 == null || color2 == null || multiplier == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih warna wajib!")));
      return;
    }

    String res = _bandCount == 4
        ? _calculator.get4BandResult(
            color1!, color2!, multiplier!, tolerance ?? 'Emas')
        : _calculator.get5BandResult(color1!, color2!, color3 ?? 'Hitam',
            multiplier!, tolerance ?? 'Emas');

    setState(() {
      _result = res;
      _hasResult = true;
    });

    await DatabaseHelper.instance.insertHistory(HistoryModel(
        type: "Resistor",
        input: "$_bandCount Gelang: $color1, $color2...",
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
      _result = "0.00 Ω";
      _hasResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Kalkulator Resistor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Visualisasi Resistor
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ]),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 260,
                    height: 70,
                    decoration: BoxDecoration(
                        color: AppColors.resistorBandBody,
                        borderRadius: BorderRadius.circular(35),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 20),
                        _bandView(_getBandColor(color1)),
                        _bandView(_getBandColor(color2)),
                        if (_bandCount == 5) _bandView(_getBandColor(color3)),
                        const SizedBox(width: 10),
                        _bandView(_getBandColor(multiplier), width: 12),
                        const SizedBox(width: 20),
                        _bandView(_getBandColor(tolerance), isTol: true),
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
                Expanded(child: _toggleButton(4, "4 Gelang")),
                Expanded(child: _toggleButton(5, "5 Gelang")),
              ]),
            ),
            const SizedBox(height: 20),

            _dropdownItem("Gelang 1", _validFirstBandColors(), color1,
                (v) => setState(() => color1 = v)),
            _dropdownItem(
                "Gelang 2",
                ResistorCalculator.bandValues.keys.toList(),
                color2,
                (v) => setState(() => color2 = v)),
            if (_bandCount == 5)
              _dropdownItem(
                  "Gelang 3",
                  ResistorCalculator.bandValues.keys.toList(),
                  color3,
                  (v) => setState(() => color3 = v)),
            _dropdownItem(
                "Pengali",
                ResistorCalculator.multipliers.keys.toList(),
                multiplier,
                (v) => setState(() => multiplier = v)),
            _dropdownItem(
                "Toleransi",
                ResistorCalculator.tolerances.keys.toList(),
                tolerance,
                (v) => setState(() => tolerance = v)),

            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: _calculate,
                      child: const Text("Hitung"))),
              const SizedBox(width: 10),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: _reset,
                      child: const Text("Reset"))),
            ]),

            const SizedBox(height: 20),
            if (_hasResult)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFC8E6C9),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Text("Nilai Resistansi:",
                      style: TextStyle(color: Colors.green[800])),
                  Text(_result,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900])),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _result));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Disalin!")));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(20)),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.copy, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text("Salin",
                            style: TextStyle(color: Colors.white, fontSize: 10))
                      ]),
                    ),
                  )
                ]),
              )
          ],
        ),
      ),
    );
  }

  Widget _bandView(Color c, {double width = 18, bool isTol = false}) =>
      Container(
          width: width,
          height: 70,
          color: c == Colors.transparent ? Colors.grey[300] : c);

  Widget _toggleButton(int b, String label) {
    bool selected = _bandCount == b;
    return GestureDetector(
      onTap: () => setState(() {
        _bandCount = b;
        _reset();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _dropdownItem(String label, List<String> items, String? val,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white),
          value: val,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Row(children: [
                    Container(width: 12, height: 12, color: _getBandColor(e)),
                    SizedBox(width: 8),
                    Text(e)
                  ])))
              .toList(),
          onChanged: onChanged),
    );
  }
}
