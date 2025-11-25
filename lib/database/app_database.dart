import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('resistor.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Membuat tabel
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE resistor_colors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        color TEXT NOT NULL,
        value INTEGER,
        multiplier REAL,
        tolerance REAL,
        band_type INTEGER NOT NULL
      );
    ''');


    await _seedData(db);
  }


  Future<void> _seedData(Database db) async {

    const digitColors = [
      ['black', 0],
      ['brown', 1],
      ['red', 2],
      ['orange', 3],
      ['yellow', 4],
      ['green', 5],
      ['blue', 6],
      ['violet', 7],
      ['grey', 8],
      ['white', 9],
    ];


    const multipliers = {
      'black': 1,
      'brown': 10,
      'red': 100,
      'orange': 1000,
      'yellow': 10000,
      'green': 100000,
      'blue': 1000000,
      'gold': 0.1,
      'silver': 0.01,
    };


    const tolerances = {
      'brown': 1,
      'red': 2,
      'green': 0.5,
      'blue': 0.25,
      'violet': 0.1,
      'grey': 0.05,
      'gold': 5,
      'silver': 10,
    };


    for (var entry in digitColors) {
      await db.insert('resistor_colors', {
        'color': entry[0],
        'value': entry[1],
        'band_type': 4,
      });
    }


    for (var entry in digitColors) {
      await db.insert('resistor_colors', {
        'color': entry[0],
        'value': entry[1],
        'band_type': 5,
      });
    }


    for (var entry in multipliers.entries) {
      await db.insert('resistor_colors', {
        'color': entry.key,
        'multiplier': entry.value,
        'band_type': 4,
      });
      await db.insert('resistor_colors', {
        'color': entry.key,
        'multiplier': entry.value,
        'band_type': 5,
      });
    }


    for (var entry in tolerances.entries) {
      await db.insert('resistor_colors', {
        'color': entry.key,
        'tolerance': entry.value,
        'band_type': 4,
      });
      await db.insert('resistor_colors', {
        'color': entry.key,
        'tolerance': entry.value,
        'band_type': 5,
      });
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
