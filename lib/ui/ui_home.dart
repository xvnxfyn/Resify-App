import 'package:flutter/material.dart';
import '../ui/ui_calculator.dart';
import '../ui/ui_ohm_calc.dart';
import '../ui/ui_splash.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              'lib/assets/images/resify_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),

            const Text(
              'Pilih Fitur Kalkulator',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            

            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/images/icon_resistor.png', 
                height: 84,
                width: 84,
              ),

              label: const Text("Kalkulator Resistor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResistorCalculatorPage()),
                );
              },
            ),
            const SizedBox(height: 15),

            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/images/icon_kalkulator.png',
                height: 74,
                width: 74,
                ),
                
                label: const Text("Kalkulator Ohm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 2),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OhmCalculatorPage()),
                  );
                },
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/images/icon_kalkulator.png',
                height: 74,
                width: 74,
                ),
                
                label: const Text("Debug Ohm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SplashPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}