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

  Color _getColor(String? colorName) {
    switch (colorName) {
      case 'Hitam': return Colors.black;
      case 'Cokelat': return const Color(0xFF795548);
      case 'Merah': return Colors.red;
      case 'Oranye': return Colors.orange;
      case 'Kuning': return const Color(0xFFFFEB3B);
      case 'Hijau': return Colors.green;
      case 'Biru': return Colors.blue;
      case 'Ungu': return Colors.purple;
      case 'Abu-abu': return Colors.grey;
      case 'Putih': return Colors.white;
      case 'Emas': return const Color(0xFFFFD700);
      case 'Perak': return const Color(0xFFC0C0C0);
      default: return Colors.transparent;
    }
  }

  void _calculate() async {
    if (color1 == null || color2 == null || multiplier == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih warna minimal untuk gelang wajib!")));
        return;
    }
    
    String res = "";
    String inputDetail = "";
    
    if (bands == 4) {
      res = logic.calculate4Band(color1!, color2!, multiplier!, tolerance ?? 'Emas');
      inputDetail = "4 Gelang: $color1, $color2, x$multiplier";
    } else {
      res = logic.calculate5Band(color1!, color2!, color3 ?? 'Hitam', multiplier!, tolerance ?? 'Emas');
      inputDetail = "5 Gelang: $color1, $color2, $color3, x$multiplier";
    }

    setState(() {
      result = res;
      hasCalculated = true;
    });

    await DatabaseHelper.instance.insertHistory(HistoryModel(
      type: "Resistor", input: inputDetail, result: res, timestamp: DateTime.now().toString()
    ));
  }

  void _reset() {
    setState(() {
      color1 = color2 = color3 = multiplier = tolerance = null;
      result = "0.00 Ω";
      hasCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: Text("Kalkulator Resistor", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Visualisasi Resistor
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
              ),
              child: Center(
                child: Container(
                  width: 250, height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0CB9E), // Warna badan resistor
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade400, width: 2)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20),
                      _bandView(_getColor(color1)),
                      _bandView(_getColor(color2)),
                      if (bands == 5) _bandView(_getColor(color3)),
                      const SizedBox(width: 10),
                      _bandView(_getColor(multiplier), width: 12),
                      const SizedBox(width: 20),
                      _bandView(_getColor(tolerance), isTolerance: true),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Visualisasi Warna", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),

            // Toggle Gelang
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Row(children: [
                Expanded(child: _toggleButton(4, "4 Gelang")),
                Expanded(child: _toggleButton(5, "5 Gelang")),
              ]),
            ),
            const SizedBox(height: 20),

            // Dropdowns
            _dropdownItem("Gelang 1 (Digit)", logic.digitColors.keys.toList(), color1, (v) => setState(() => color1 = v)),
            _dropdownItem("Gelang 2 (Digit)", logic.digitColors.keys.toList(), color2, (v) => setState(() => color2 = v)),
            if (bands == 5) _dropdownItem("Gelang 3 (Digit)", logic.digitColors.keys.toList(), color3, (v) => setState(() => color3 = v)),
            _dropdownItem("Pengali", logic.multipliers.keys.toList(), multiplier, (v) => setState(() => multiplier = v)),
            _dropdownItem("Toleransi", logic.tolerances.keys.toList(), tolerance, (v) => setState(() => tolerance = v)),

            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _calculate, child: const Text("HITUNG")),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _reset, child: const Text("RESET")),
                ),
              ],
            ),

            const SizedBox(height: 20),
            
            // Result
            if (hasCalculated)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade100)),
              child: Column(
                children: [
                  const Text("Nilai Resistansi", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(result, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bandView(Color color, {double width = 18, bool isTolerance = false}) {
    return Container(width: width, height: 60, color: color == Colors.transparent ? Colors.grey[300] : color);
  }

  Widget _toggleButton(int b, String label) {
    bool selected = bands == b;
    return GestureDetector(
      onTap: () => setState(() { bands = b; _reset(); }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: selected ? Colors.redAccent : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _dropdownItem(String label, List<String> items, String? val, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
        value: val,
        items: items.map((e) => DropdownMenuItem(
          value: e, 
          child: Row(children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: _getColor(e), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300))),
            const SizedBox(width: 10), Text(e)
          ])
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}