import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/ohm_logic.dart';

class OhmScreen extends StatefulWidget {
  const OhmScreen({super.key});

  @override
  State<OhmScreen> createState() => _OhmScreenState();
}

class _OhmScreenState extends State<OhmScreen> {
  final OhmLogic logic = OhmLogic();
  
  
  String targetMode = 'V'; 

  
  final Map<String, List<String>> inputFields = {
    'V': ['Arus (I) - Ampere', 'Hambatan (R) - Ohm'],
    'I': ['Tegangan (V) - Volt', 'Hambatan (R) - Ohm'],
    'R': ['Tegangan (V) - Volt', 'Arus (I) - Ampere'],
    'P': ['Tegangan (V) - Volt', 'Arus (I) - Ampere'],
  };

  
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();

  
  String result = '';
  bool hasCalculated = false;

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    super.dispose();
  }

  
  void _calculate() {
    final val1 = double.tryParse(c1.text);
    final val2 = double.tryParse(c2.text);

    // Validasi input kosong atau tidak valid
    if (val1 == null || val2 == null) {
      _setResult('Input tidak valid - masukkan angka yang benar');
      return;
    }

    // Validasi angka negatif
    if (val1 < 0 || val2 < 0) {
      _setResult('Input tidak boleh negatif');
      return;
    }

    // Validasi angka terlalu besar (overflow prevention)
    if (val1 > 1e15 || val2 > 1e15) {
      _setResult('Input terlalu besar - maksimal 10^15');
      return;
    }

    // Validasi angka terlalu kecil tapi bukan nol
    if ((val1 != 0 && val1 < 1e-10) || (val2 != 0 && val2 < 1e-10)) {
      _setResult('Input terlalu kecil - minimal 10^-10');
      return;
    }

    String calculatedResult;
    String formula;

    switch (targetMode) {
      case 'V':
        calculatedResult = logic.hitungTegangan(val1, val2);
        formula = 'V = I × R = $val1 × $val2';
        break;
      case 'I':
        if (val2 == 0) {
          _setResult('Hambatan tidak boleh nol');
          return;
        }
        calculatedResult = logic.hitungArus(val1, val2);
        formula = 'I = V ÷ R = $val1 ÷ $val2';
        break;
      case 'R':
        if (val2 == 0) {
          _setResult('Arus tidak boleh nol');
          return;
        }
        calculatedResult = logic.hitungHambatan(val1, val2);
        formula = 'R = V ÷ I = $val1 ÷ $val2';
        break;
      case 'P':
        calculatedResult = logic.hitungDaya(val1, val2);
        formula = 'P = V × I = $val1 × $val2';
        break;
      default:
        return;
    }

    _setResult('$formula\n\nHasil: $calculatedResult');
  }

  void _setResult(String value) {
    setState(() {
      result = value;
      hasCalculated = true;
    });
  }

  
  void _reset() {
    setState(() {
      c1.clear();
      c2.clear();
      result = '';
      hasCalculated = false;
    });
  }

  
  void _changeMode(String mode) {
    setState(() {
      targetMode = mode;
      c1.clear();
      c2.clear();
      result = '';
      hasCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Hukum Ohm'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const Text(
              'Pilih Mode Perhitungan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _modeButton('V', 'Tegangan')),
                const SizedBox(width: 10),
                Expanded(child: _modeButton('I', 'Arus')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _modeButton('R', 'Hambatan')),
                const SizedBox(width: 10),
                Expanded(child: _modeButton('P', 'Daya')),
              ],
            ),

            const SizedBox(height: 24),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _getModeTitle(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getModeFormula(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            
            _inputBox(inputFields[targetMode]![0], c1),
            const SizedBox(height: 16),
            _inputBox(inputFields[targetMode]![1], c2),

            const SizedBox(height: 24),

            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate, size: 20),
                    label: const Text(
                      'HITUNG',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text(
                      'RESET',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.blue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

           
            if (hasCalculated)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Hasil Perhitungan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: result));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hasil berhasil disalin ke clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Salin Hasil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  
  Widget _modeButton(String mode, String label) {
    final isSelected = targetMode == mode;
    return InkWell(
      onTap: () => _changeMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              mode,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _inputBox(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Masukkan nilai',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: Icon(Icons.edit, color: Colors.blue.shade700, size: 20),
          ),
        ),
      ],
    );
  }

  
  String _getModeTitle() {
    switch (targetMode) {
      case 'V':
        return 'Menghitung Tegangan (V)';
      case 'I':
        return 'Menghitung Arus (I)';
      case 'R':
        return 'Menghitung Hambatan (R)';
      case 'P':
        return 'Menghitung Daya (P)';
      default:
        return '';
    }
  }

  
  String _getModeFormula() {
    switch (targetMode) {
      case 'V':
        return 'Rumus: V = I × R (Volt = Ampere × Ohm)';
      case 'I':
        return 'Rumus: I = V ÷ R (Ampere = Volt ÷ Ohm)';
      case 'R':
        return 'Rumus: R = V ÷ I (Ohm = Volt ÷ Ampere)';
      case 'P':
        return 'Rumus: P = V × I (Watt = Volt × Ampere)';
      default:
        return '';
    }
  }
}
