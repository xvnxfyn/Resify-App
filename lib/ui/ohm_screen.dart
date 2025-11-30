import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/ohm_logic.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';

class OhmScreen extends StatefulWidget {
  const OhmScreen({super.key});
  @override
  State<OhmScreen> createState() => _OhmScreenState();
}

class _OhmScreenState extends State<OhmScreen> {
  final OhmLogic logic = OhmLogic();
  String targetMode = "Tegangan"; 
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();
  String result = "0.00";
  bool hasCalculated = false;

  void _calculate() async {
    if (_c1.text.isEmpty || _c2.text.isEmpty) return;
    double v1 = double.tryParse(_c1.text) ?? 0;
    double v2 = double.tryParse(_c2.text) ?? 0;
    String res = "", detail = "";

    switch (targetMode) {
      case "Tegangan": res = logic.hitungTegangan(v1, v2); detail = "I=$v1, R=$v2"; break;
      case "Arus": res = logic.hitungArus(v1, v2); detail = "V=$v1, R=$v2"; break;
      case "Hambatan": res = logic.hitungHambatan(v1, v2); detail = "V=$v1, I=$v2"; break;
      case "Daya": res = logic.hitungDaya(v1, v2); detail = "V=$v1, I=$v2"; break;
    }

    setState(() { result = res; hasCalculated = true; });
    await DatabaseHelper.instance.insertHistory(HistoryModel(type: "Ohm Law", input: detail, result: res, timestamp: DateTime.now().toString()));
    if (!mounted) return;
    FocusScope.of(context).unfocus();
  }

  void _reset() { setState(() { _c1.clear(); _c2.clear(); result = "0.00"; hasCalculated = false; }); }

  String _getLabel1() => targetMode == "Tegangan" ? "Arus (I)" : "Tegangan (V)";
  String _getLabel2() {
    if (targetMode == "Tegangan" || targetMode == "Arus") return "Hambatan (R)";
    return "Arus (I)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: Text("Kalkulator Hukum Ohm", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Wrap(
              spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
              children: ["Tegangan", "Arus", "Hambatan", "Daya"].map((mode) => _buildChip(mode)).toList(),
            ),
            const SizedBox(height: 30),
            _inputField(_c1, _getLabel1()),
            const SizedBox(height: 16),
            _inputField(_c2, _getLabel2()),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _calculate, icon: const Icon(Icons.calculate), label: const Text("HITUNG"))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _reset, icon: const Icon(Icons.refresh), label: const Text("RESET"))),
            ]),
            const SizedBox(height: 30),
            if(hasCalculated)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade800]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0,5))]),
              child: Column(children: [
                const Text("Hasil Perhitungan", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 5),
                Text(result, style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    bool selected = targetMode == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (val) => setState(() { targetMode = label; _reset(); }),
      selectedColor: Colors.blueAccent,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      backgroundColor: Colors.white,
    );
  }

  Widget _inputField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
    );
  }
}