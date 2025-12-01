import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/ohm_logic.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';
import 'app_colors.dart';

class OhmScreen extends StatefulWidget {
  const OhmScreen({super.key});
  @override
  State<OhmScreen> createState() => _OhmScreenState();
}

class _OhmScreenState extends State<OhmScreen> {
  final OhmCalculator _calculator = OhmCalculator();

  // State
  String _selectedMode = "Tegangan";
  final TextEditingController _inputCtrl1 = TextEditingController();
  final TextEditingController _inputCtrl2 = TextEditingController();

  String _result = "0.00";
  String _formulaDisplay = "";
  bool _hasResult = false;

  @override
  void dispose() {
    _inputCtrl1.dispose();
    _inputCtrl2.dispose();
    super.dispose();
  }

  void _calculate() async {
    if (_inputCtrl1.text.isEmpty || _inputCtrl2.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Mohon isi kedua nilai")));
      return;
    }

    double val1 = double.tryParse(_inputCtrl1.text) ?? 0;
    double val2 = double.tryParse(_inputCtrl2.text) ?? 0;
    String res = "";

    switch (_selectedMode) {
      case "Tegangan":
        res = _calculator.hitungTegangan(arus: val1, hambatan: val2);
        _formulaDisplay = "V = I × R";
        break;
      case "Arus":
        res = _calculator.hitungArus(tegangan: val1, hambatan: val2);
        _formulaDisplay = "I = V ÷ R";
        break;
      case "Hambatan":
        res = _calculator.hitungHambatan(tegangan: val1, arus: val2);
        _formulaDisplay = "R = V ÷ I";
        break;
      case "Daya":
        res = _calculator.hitungDaya(tegangan: val1, arus: val2);
        _formulaDisplay = "P = V × I";
        break;
    }

    setState(() {
      _result = res;
      _hasResult = true;
    });

    await DatabaseHelper.instance.insertHistory(HistoryModel(
        type: "Ohm Law",
        input: "$_selectedMode ($val1, $val2)",
        result: res,
        timestamp: DateTime.now().toString()));

    if (mounted) FocusScope.of(context).unfocus();
  }

  void _reset() {
    setState(() {
      _inputCtrl1.clear();
      _inputCtrl2.clear();
      _result = "0.00";
      _hasResult = false;
    });
  }

  // Label Dinamis
  String get _label1 =>
      _selectedMode == "Tegangan" ? "Arus (I) - Ampere" : "Tegangan (V) - Volt";
  String get _label2 {
    if (_selectedMode == "Tegangan" || _selectedMode == "Arus")
      return "Hambatan (R) - Ohm";
    return "Arus (I) - Ampere";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Hukum Ohm")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Pilih Mode Perhitungan",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // Grid Menu
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildModeCard("V", "Tegangan"),
                _buildModeCard("A", "Arus"),
                _buildModeCard("Ω", "Hambatan"),
                _buildModeCard("W", "Daya"),
              ],
            ),

            const SizedBox(height: 24),
            _buildInput(_inputCtrl1, _label1),
            const SizedBox(height: 16),
            _buildInput(_inputCtrl2, _label2),

            const SizedBox(height: 32),

            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: _calculate,
                      child: const Text("Hitung",
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              const SizedBox(width: 12),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: Colors.grey)),
                      onPressed: _reset,
                      child: const Text("Reset",
                          style: TextStyle(color: Colors.grey)))),
            ]),

            const SizedBox(height: 24),

            if (_hasResult) _buildResultCard()
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(String symbol, String label) {
    final bool isSelected = _selectedMode == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedMode = label;
        _reset();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                width: 1.5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ]
                : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(symbol,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.primary)),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : AppColors.primary))
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: "0",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.edit_outlined,
                size: 18, color: AppColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary.withOpacity(0.5))),
      child: Column(children: [
        Text("Hasil Perhitungan",
            style: TextStyle(
                color: Colors.green[800], fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(_formulaDisplay,
            style: TextStyle(color: Colors.green[900], fontSize: 14)),
        const SizedBox(height: 8),
        Text(_result,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green[900])),
        const SizedBox(height: 16),
        InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: _result));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Disalin!")));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text("Salin Hasil",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ))
      ]),
    );
  }
}
