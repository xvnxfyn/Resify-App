import 'package:flutter/material.dart';
import '../model/model_resistor.dart';
import '../logic/logic_resistor.dart';
import '../assets/asset_ilustrasi.dart';

class ResistorCalculatorPage extends StatefulWidget {
  const ResistorCalculatorPage({super.key});

  @override
  State<ResistorCalculatorPage> createState() => _ResistorCalculatorPageState();
}

class _ResistorCalculatorPageState extends State<ResistorCalculatorPage> {
  bool isFiveBand = false;

  ResistorBand? band1;
  ResistorBand? band2;
  ResistorBand? band3;
  ResistorBand? multiplier;
  ResistorBand? tolerance;

  String resultText = "Pilih warna";

  @override
  void initState() {
    super.initState();

    band1 = ResistorLogic.digitBands.firstWhere((b) => b.name == 'Cokelat');
    band2 = ResistorLogic.digitBands.firstWhere((b) => b.name == 'Hitam');
    band3 = ResistorLogic.digitBands.firstWhere((b) => b.name == 'Hitam');
    multiplier = ResistorLogic.multiplierBands.firstWhere((b) => b.name == 'Merah');
    tolerance = ResistorLogic.toleranceBands.firstWhere((b) => b.name == 'Emas');

    _calculate();
  }

  void _calculate() {
    setState(() {
      resultText = ResistorLogic.calculate(
        bandCount: isFiveBand ? 5 : 4,
        band1: band1!,
        band2: band2!,
        band3: isFiveBand ? band3 : null,
        multiplier: multiplier!,
        tolerance: tolerance!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Kalkulator Resistor")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // RESISTOR
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isFiveBand ? 140 : 200,
                height: isFiveBand ? 55 : 75,
                child: ResistorIllustration(
                  isFiveBand: isFiveBand,
                  band1: band1!,
                  band2: band2!,
                  band3: band3,
                  multiplier: multiplier!,
                  tolerance: tolerance!,
                ),
              ),

              const SizedBox(height: 10),

              // SWITCH
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("4 Gelang"),
                  Switch(
                    value: isFiveBand,
                    onChanged: (val) {
                      setState(() {
                        isFiveBand = val;
                        _calculate();
                      });
                    },
                  ),
                  const Text("5 Gelang"),
                ],
              ),

              const SizedBox(height: 10),

              // DROPDOWN WRAPPER
              _buildDropdown("Gelang 1", band1, ResistorLogic.digitBands, (val) {
                band1 = val;
                _calculate();
              }),
              _buildDropdown("Gelang 2", band2, ResistorLogic.digitBands, (val) {
                band2 = val;
                _calculate();
              }),
              if (isFiveBand)
                _buildDropdown("Gelang 3", band3, ResistorLogic.digitBands, (val) {
                  band3 = val;
                  _calculate();
                }),
              _buildDropdown("Pengali", multiplier, ResistorLogic.multiplierBands, (val) {
                multiplier = val;
                _calculate();
              }),
              _buildDropdown("Toleransi", tolerance, ResistorLogic.toleranceBands, (val) {
                tolerance = val;
                _calculate();
              }),

              const SizedBox(height: 12),

              // HASIL
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Nilai Resistor:",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resultText,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        )
    );
  }

  Widget _buildDropdown(
      String label,
      ResistorBand? currentValue,
      List<ResistorBand> items,
      Function(ResistorBand?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<ResistorBand>(
              initialValue: currentValue,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              items: items.map((band) {
                return DropdownMenuItem(
                  value: band,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: band.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(band.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
                  