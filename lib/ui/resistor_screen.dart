import 'package:flutter/material.dart';
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
  String result = "Belum dihitung";
  bool hasCalculated = false;

  static const Map<String, Color> _colorMap = {
    'Hitam': Colors.black,
    'Cokelat': Color(0xFF795548),
    'Merah': Colors.red,
    'Oranye': Colors.orange,
    'Kuning': Colors.yellow,
    'Hijau': Colors.green,
    'Biru': Colors.blue,
    'Ungu': Colors.purple,
    'Abu-abu': Colors.grey,
    'Putih': Colors.white,
    'Emas': Color(0xFFFFD700),
    'Perak': Color(0xFFC0C0C0),
  };

  Color _getColor(String? colorName) => 
    colorName != null ? _colorMap[colorName] ?? Colors.transparent : Colors.transparent;

  void _calculate() async {
    final messenger = ScaffoldMessenger.of(context);
    
    if (color1 == null || color2 == null || multiplier == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Mohon pilih warna wajib!")),
      );
      return;
    }
    
    if (color1 == 'Hitam') {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Gelang 1 tidak boleh berwarna Hitam (tidak ada dalam teori resistor)"),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    final defaultTolerance = tolerance ?? 'Emas';
    final String res;
    final String inputDetail;
    
    if (bands == 4) {
      res = logic.calculate4Band(color1!, color2!, multiplier!, defaultTolerance);
      inputDetail = "4 Gelang: $color1, $color2, x$multiplier";
    } else {
      res = logic.calculate5Band(color1!, color2!, color3 ?? 'Hitam', multiplier!, defaultTolerance);
      inputDetail = "5 Gelang: $color1, $color2, $color3, x$multiplier";
    }

    setState(() {
      result = res;
      hasCalculated = true;
    });

    await DatabaseHelper.instance.insertHistory(HistoryModel(
      type: "Resistor", 
      input: inputDetail, 
      result: res, 
      timestamp: DateTime.now().toString(),
    ));
  }

  void _reset() {
    setState(() {
      color1 = color2 = color3 = multiplier = tolerance = null;
      result = "Belum dihitung";
      hasCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Resistor"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE0CB9E),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.shade400, width: 2)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  _buildResistorBand(_getColor(color1)),
                  _buildResistorBand(_getColor(color2)),
                  if (bands == 5) _buildResistorBand(_getColor(color3)),
                  const SizedBox(width: 10),
                  _buildResistorBand(_getColor(multiplier), width: 15),
                  const SizedBox(width: 20),
                  _buildResistorBand(_getColor(tolerance), isTolerance: true),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(child: Text("Visualisasi (Warna berubah sesuai pilihan)", style: TextStyle(fontSize: 12, color: Colors.grey))),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(4),
              child: Row(children: [
                Expanded(child: _bandButton(4, "4 Gelang")),
                Expanded(child: _bandButton(5, "5 Gelang")),
              ]),
            ),
            const SizedBox(height: 20),

            _dropdown("Gelang 1 (Digit)", logic.digitColors.keys.where((c) => c != 'Hitam').toList(), color1, (v) => setState(() => color1 = v)),
            _dropdown("Gelang 2 (Digit)", logic.digitColors.keys.toList(), color2, (v) => setState(() => color2 = v)),
            if (bands == 5) _dropdown("Gelang 3 (Digit)", logic.digitColors.keys.toList(), color3, (v) => setState(() => color3 = v)),
            _dropdown("Gelang Pengali", logic.multipliers.keys.toList(), multiplier, (v) => setState(() => multiplier = v)),
            _dropdown("Gelang Toleransi", logic.tolerances.keys.toList(), tolerance, (v) => setState(() => tolerance = v)),
            
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      foregroundColor: Colors.white, 
                      minimumSize: const Size.fromHeight(50)
                    ),
                    onPressed: _calculate, child: const Text("HITUNG HASIL")),
                ),
                const SizedBox(width: 12),
                 Expanded(
                  child: OutlinedButton(
                    
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: _reset, child: const Text("RESET")),
                ),
              ],
            ),
            const SizedBox(height: 24),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: hasCalculated ? 1.0 : 0.3,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: hasCalculated ? Colors.red.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: hasCalculated ? Colors.red.shade200 : Colors.grey.shade300)
                ),
                child: Column(
                  children: [
                    Text("Nilai Resistansi:", style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text(result, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: hasCalculated ? Colors.red.shade800 : Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResistorBand(Color color, {double width = 20, bool isTolerance = false}) {
    return Container(
      width: width,
      height: 100,
      decoration: BoxDecoration(
        color: color == Colors.transparent ? Colors.grey.shade300 : color,
        
        border: Border.symmetric(vertical: BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 1))
      ),
    );
  }

  Widget _bandButton(int b, String label) {
    bool isSelected = bands == b;
    return GestureDetector(
      onTap: () {
        setState(() {
          bands = b;
          _reset();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          
          boxShadow: isSelected ? [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 4)] : null
        ),
        child: Center(child: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.red : Colors.grey))),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String? val, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.white,
        ),
        initialValue: val,
        icon: Icon(Icons.arrow_drop_down_circle, color: Colors.red.shade300),
        items: items.map((e) => DropdownMenuItem(
          value: e,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getColor(e),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 10),
              Text(e),
            ],
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}