import 'package:flutter/material.dart';

class OhmCalculatorPage extends StatefulWidget {
  const OhmCalculatorPage({super.key});

  @override
  State<OhmCalculatorPage> createState() => _OhmCalculatorPageState();
}

class _OhmCalculatorPageState extends State<OhmCalculatorPage> {

  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();


  String _mode = 'voltage';

  String _result = '';

  @override
  void dispose() {
    _voltageController.dispose();
    _currentController.dispose();
    _resistanceController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  void _calculate() {
    try {
      setState(() {
        switch (_mode) {
          case 'voltage':

            final current = double.tryParse(_currentController.text);
            final resistance = double.tryParse(_resistanceController.text);
            final power = double.tryParse(_powerController.text);

            if (current != null && resistance != null) {
              _result = 'Tegangan: ${(current * resistance).toStringAsFixed(2)} V';
            } else if (power != null && resistance != null) {
              _result = 'Tegangan: ${(Math.sqrt(power * resistance)).toStringAsFixed(2)} V';
            } else if (power != null && current != null && current != 0) {
              _result = 'Tegangan: ${(power / current).toStringAsFixed(2)} V';
            } else {
              _result = 'Masukkan minimal 2 nilai (I & R, atau P & R, atau P & I)';
            }
            break;

          case 'current':

            final voltage = double.tryParse(_voltageController.text);
            final resistance = double.tryParse(_resistanceController.text);
            final power = double.tryParse(_powerController.text);

            if (voltage != null && resistance != null && resistance != 0) {
              _result = 'Arus: ${(voltage / resistance).toStringAsFixed(2)} A';
            } else if (power != null && voltage != null && voltage != 0) {
              _result = 'Arus: ${(power / voltage).toStringAsFixed(2)} A';
            } else if (power != null && resistance != null && resistance != 0) {
              _result = 'Arus: ${(Math.sqrt(power / resistance)).toStringAsFixed(2)} A';
            } else {
              _result = 'Masukkan minimal 2 nilai (V & R, atau P & V, atau P & R)';
            }
            break;

          case 'resistance':

            final voltage = double.tryParse(_voltageController.text);
            final current = double.tryParse(_currentController.text);
            final power = double.tryParse(_powerController.text);

            if (voltage != null && current != null && current != 0) {
              _result = 'Resistansi: ${(voltage / current).toStringAsFixed(2)} Ω';
            } else if (voltage != null && power != null && power != 0) {
              _result = 'Resistansi: ${((voltage * voltage) / power).toStringAsFixed(2)} Ω';
            } else if (power != null && current != null && current != 0) {
              _result = 'Resistansi: ${(power / (current * current)).toStringAsFixed(2)} Ω';
            } else {
              _result = 'Masukkan minimal 2 nilai (V & I, atau V² & P, atau P & I²)';
            }
            break;

          case 'power':

            final voltage = double.tryParse(_voltageController.text);
            final current = double.tryParse(_currentController.text);
            final resistance = double.tryParse(_resistanceController.text);

            if (voltage != null && current != null) {
              _result = 'Daya: ${(voltage * current).toStringAsFixed(2)} W';
            } else if (voltage != null && resistance != null && resistance != 0) {
              _result = 'Daya: ${((voltage * voltage) / resistance).toStringAsFixed(2)} W';
            } else if (current != null && resistance != null) {
              _result = 'Daya: ${(current * current * resistance).toStringAsFixed(2)} W';
            } else {
              _result = 'Masukkan minimal 2 nilai (V & I, atau V² & R, atau I² & R)';
            }
            break;
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: Input tidak valid';
      });
    }
  }

  void _reset() {
    setState(() {
      _voltageController.clear();
      _currentController.clear();
      _resistanceController.clear();
      _powerController.clear();
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Hukum Ohm"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Row(
              children: [
                Expanded(
                  child: _buildModeButton('Tegangan', 'voltage'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeButton('Arus', 'current'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildModeButton('Resistansi', 'resistance'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModeButton('Daya', 'power'),
                ),
              ],
            ),

            const SizedBox(height: 20),


            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getModeTitle(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getModeInstruction(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            _buildInputField(
              'Arus(I) - Ampere',
              _currentController,
              enabled: _mode != 'current',
            ),
            const SizedBox(height: 12),
            _buildInputField(
              'Resistansi(R) - ohm',
              _resistanceController,
              enabled: _mode != 'resistance',
            ),
            const SizedBox(height: 12),
            _buildInputField(
              'Daya(P) - Watt',
              _powerController,
              enabled: _mode != 'power',
            ),

            if (_mode == 'voltage') ...[
              const SizedBox(height: 12),
              _buildInputField(
                'Tegangan(V) - Volt (opsional)',
                _voltageController,
                enabled: false,
              ),
            ],

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hitung',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, String mode) {
    final isSelected = _mode == mode;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _mode = mode;
          _result = '';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        side: const BorderSide(color: Colors.blue, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: enabled ? 'input ${label.split('(')[0].trim()}' : 'Hasil akan ditampilkan',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  String _getModeTitle() {
    switch (_mode) {
      case 'voltage':
        return 'Hitung Tegangan (V)';
      case 'current':
        return 'Hitung Arus (I)';
      case 'resistance':
        return 'Hitung Resistansi (R)';
      case 'power':
        return 'Hitung Daya (P)';
      default:
        return '';
    }
  }

  String _getModeInstruction() {
    switch (_mode) {
      case 'voltage':
        return 'Masukkan 2 nilai dari: I, R, atau P';
      case 'current':
        return 'Masukkan 2 nilai dari: V, R, atau P';
      case 'resistance':
        return 'Masukkan 2 nilai dari: V, I, atau P';
      case 'power':
        return 'Masukkan 2 nilai dari: V, I, atau R';
      default:
        return '';
    }
  }
}

class Math {
  static double sqrt(double value) {
    if (value < 0) return double.nan;
    return value == 0 ? 0 : _sqrtNewtonRaphson(value, value / 2);
  }

  static double _sqrtNewtonRaphson(double n, double x) {
    double root = ((n / x) + x) / 2;
    if ((root - x).abs() < 0.0001) return root;
    return _sqrtNewtonRaphson(n, root);
  }
}
