import 'package:flutter/material.dart';
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
  String targetMode = "Tegangan (V)"; 
  
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  String result = "0.000";
  bool hasCalculated = false;

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    super.dispose();
  }

  void _calculate() async {
    if (_input1Controller.text.isEmpty || _input2Controller.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon isi kedua nilai!")));
       return;
    }

    double val1 = double.tryParse(_input1Controller.text) ?? 0;
    double val2 = double.tryParse(_input2Controller.text) ?? 0;
    String res = "";
    String inputDetail = "";

    switch (targetMode) {
      case "Tegangan (V)":
        res = logic.hitungTegangan(val1, val2);
        inputDetail = "Cari V. Diketahui: I=$val1 A, R=$val2 Ω";
        break;
      case "Arus (I)":
        res = logic.hitungArus(val1, val2);
        inputDetail = "Cari I. Diketahui: V=$val1 V, R=$val2 Ω";
        break;
      case "Hambatan (R)":
        res = logic.hitungHambatan(val1, val2);
        inputDetail = "Cari R. Diketahui: V=$val1 V, I=$val2 A";
        break;
      case "Daya (P)":
        res = logic.hitungDaya(val1, val2);
        inputDetail = "Cari P. Diketahui: V=$val1 V, I=$val2 A";
        break;
    }

    setState(() {
      result = res;
      hasCalculated = true;
    });

    await DatabaseHelper.instance.insertHistory(HistoryModel(
      type: "Ohm Law", input: inputDetail, result: res, timestamp: DateTime.now().toString()
    ));
    
    // Cek mounted sebelum pakai context
    if (!mounted) return;
    FocusScope.of(context).unfocus(); 
  }

  void _reset() {
    setState(() {
      _input1Controller.clear();
      _input2Controller.clear();
      result = "0.000";
      hasCalculated = false;
    });
  }

  String getLabel1() {
    switch(targetMode) {
      case "Tegangan (V)": return "Arus Listrik (Ampere - I)";
      case "Arus (I)": return "Tegangan (Volt - V)";
      case "Hambatan (R)": return "Tegangan (Volt - V)";
      case "Daya (P)": return "Tegangan (Volt - V)";
      default: return "Input 1";
    }
  }

  String getLabel2() {
    switch(targetMode) {
      case "Tegangan (V)": return "Hambatan (Ohm - R)";
      case "Arus (I)": return "Hambatan (Ohm - R)";
      case "Hambatan (R)": return "Arus Listrik (Ampere - I)";
      case "Daya (P)": return "Arus Listrik (Ampere - I)";
      default: return "Input 2";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Hukum Ohm"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Apa yang ingin Anda cari?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, childAspectRatio: 2.5,
              mainAxisSpacing: 10, crossAxisSpacing: 10, physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildModeButton("Tegangan (V)", Icons.electric_bolt),
                _buildModeButton("Arus (I)", Icons.waves),
                _buildModeButton("Hambatan (R)", Icons.code),
                _buildModeButton("Daya (P)", Icons.lightbulb),
              ],
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(child: Text("Untuk mencari $targetMode, masukkan nilai berikut:", style: const TextStyle(color: Colors.blueGrey))),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildInputField(_input1Controller, getLabel1()),
            const SizedBox(height: 16),
            _buildInputField(_input2Controller, getLabel2()),

            const SizedBox(height: 24),
             Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white, 
                      minimumSize: const Size.fromHeight(50) 
                    ),
                    onPressed: _calculate, icon: const Icon(Icons.calculate), label: const Text("HITUNG")),
                ),
                const SizedBox(width: 12),
                 Expanded(
                  child: OutlinedButton.icon(
                    // PERBAIKAN: Mengganti height: 50 dengan minimumSize
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)
                    ),
                    onPressed: _reset, icon: const Icon(Icons.refresh), label: const Text("RESET")),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: hasCalculated ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: hasCalculated ? Colors.blue.shade100 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: hasCalculated ? Colors.blue : Colors.grey.shade300)
                ),
                child: Column(
                  children: [
                    Text("Hasil Perhitungan $targetMode:", style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 8),
                    Text(result, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: hasCalculated ? Colors.blue.shade800 : Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, fillColor: Colors.white,
        suffixIcon: const Icon(Icons.edit, size: 18, color: Colors.grey)
      ),
    );
  }

  Widget _buildModeButton(String label, IconData icon) {
    bool isSelected = targetMode == label;
    return InkWell(
      onTap: () {
        setState(() {
          targetMode = label;
          _reset();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.blue),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.blue.shade800, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}