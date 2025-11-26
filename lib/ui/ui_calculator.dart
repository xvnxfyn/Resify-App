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
  // State: Apakah user memilih mode 5 gelang? (Default false/4 gelang)
  bool isFiveBand = false;

  // State: Pilihan Warna Saat Ini
  ResistorBand? band1;
  ResistorBand? band2;
  ResistorBand? band3; // Hanya aktif jika isFiveBand = true
  ResistorBand? multiplier;
  ResistorBand? tolerance;

  // Hasil perhitungan
  String resultText = "Pilih warna";

  @override
  void initState() {
    super.initState();
    // Set nilai default  (Coklat-Hitam-Merah-Emas / 1k Ohm)
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
      appBar: AppBar(title: Text("Kalkulator Resistor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            ResistorIllustration(
              isFiveBand: isFiveBand, // Terhubung ke state mode 4/5 gelang
              band1: band1!,           // Terhubung ke state pilihan warna
              band2: band2!,
              band3: band3,
              multiplier: multiplier!,
              tolerance: tolerance!,
              ),
              const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("4 Gelang"),
                Switch(
                  value: isFiveBand,
                  onChanged: (val) {
                    setState(() {
                      isFiveBand = val;
                      _calculate();
                    });
                  },
                ),
                Text("5 Gelang"),
              ],
            ),
            SizedBox(height: 20),

            // 2. Dropdowns
            // Gelang 1 (Angka Pertama)
            _buildDropdown("Gelang 1", band1, ResistorLogic.digitBands, (val) {
              band1 = val;
              _calculate();
            }),

            // Gelang 2 (Angka Kedua)
            _buildDropdown("Gelang 2", band2, ResistorLogic.digitBands, (val) {
              band2 = val;
              _calculate();
            }),

            // Gelang 3 (Angka Ketiga - Hanya muncul jika mode 5 gelang)
            if (isFiveBand)
              _buildDropdown("Gelang 3", band3, ResistorLogic.digitBands, (val) {
                band3 = val;
                _calculate();
              }),

            // Gelang Multiplier
            _buildDropdown("Pengali", multiplier, ResistorLogic.multiplierBands, (val) {
              multiplier = val;
              _calculate();
            }),

            // Gelang Toleransi
            _buildDropdown("Toleransi", tolerance, ResistorLogic.toleranceBands, (val) {
              tolerance = val;
              _calculate();
            }),

            Spacer(),

            // 3. Menampilkan Hasil
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text("Nilai Resistor:", style: TextStyle(fontSize: 18)),
                  Text(
                    resultText,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper agar kode tidak berulang (Reusable Widget)
  Widget _buildDropdown(
    String label, 
    ResistorBand? currentValue, 
    List<ResistorBand> items, 
    Function(ResistorBand?) onChanged
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<ResistorBand>(
              initialValue: currentValue,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              items: items.map((band) {
                return DropdownMenuItem(
                  value: band,
                  child: Row(
                    children: [
                      // Indikator Warna Kecil (Lingkaran)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: band.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 10),
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