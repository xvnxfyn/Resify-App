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
  String mode = "Tegangan"; 
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();
  String result = "0.00";
  bool done = false;

  void _calc() async {
    if (c1.text.isEmpty || c2.text.isEmpty) return;
    double v1 = double.tryParse(c1.text) ?? 0;
    double v2 = double.tryParse(c2.text) ?? 0;
    String res = "";
    if (mode == "Tegangan") res = logic.hitungTegangan(v1, v2);
    else if (mode == "Arus") res = logic.hitungArus(v1, v2);
    else if (mode == "Hambatan") res = logic.hitungHambatan(v1, v2);
    else res = logic.hitungDaya(v1, v2);

    setState(() { result = res; done = true; });
    await DatabaseHelper.instance.insertHistory(HistoryModel(type: "Ohm Law", input: "Mode: $mode", result: res, timestamp: DateTime.now().toString()));
    FocusScope.of(context).unfocus();
  }

  void _reset() { setState(() { c1.clear(); c2.clear(); result="0.00"; done=false; }); }

  String _lbl1() => mode == "Tegangan" ? "Arus (I)" : "Tegangan (V)";
  String _lbl2() => (mode == "Tegangan" || mode == "Arus") ? "Hambatan (R)" : "Arus (I)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Hukum Ohm")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: ["Tegangan", "Arus", "Hambatan", "Daya"].map((m)=>_chip(m)).toList()),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: Text("Menghitung $mode...", style: TextStyle(color: Colors.blue[800]))),
            const SizedBox(height: 20),
            _inp(c1, _lbl1()), const SizedBox(height: 12), _inp(c2, _lbl2()),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A9FF), foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), onPressed: _calc, child: const Text("Hitung"))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), onPressed: _reset, child: const Text("Reset"))),
            ]),
            const SizedBox(height: 20),
            if(done) Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFC8E6C9), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Text("Hasil Perhitungan:", style: TextStyle(color: Colors.green[800])),
                Text(result, style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green[900])),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _chip(String m) {
    bool sel = mode == m;
    return ChoiceChip(
      label: Text(m), selected: sel, onSelected: (v)=>setState((){mode=m;_reset();}),
      selectedColor: const Color(0xFF00A9FF), labelStyle: TextStyle(color: sel?Colors.white:Colors.black),
      backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: sel?Colors.transparent:Colors.grey.shade300))
    );
  }
  Widget _inp(TextEditingController c, String l) => TextField(controller: c, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.edit, size: 18)));
}