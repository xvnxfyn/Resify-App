import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/resistor_home_page.dart';  // halaman kalkulator
import 'database/app_database.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  
  final ResistorDao resistorDao = ResistorDao();
  final colors = await resistorDao.getDigitColors(4);
  print(colors);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResiFy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),

      routes: {
        "/calculator": (_) => const ResistorHomePage(),
      },
    );
  }
}
