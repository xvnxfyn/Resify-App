import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('resify.db');
    return _database!;
  }

  Future<int> deleteAllHistory() async {
    Database db = await instance.database;
    return await db.delete('history');
}

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        input TEXT NOT NULL,
        result TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertHistory(HistoryModel history) async {
    final db = await instance.database;
    return await db.insert('history', history.toMap());
  }

  Future<List<HistoryModel>> getAllHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'timestamp DESC');
    return result.map((json) => HistoryModel.fromMap(json)).toList();
  }

  Future<int> deleteHistory(int id) async {
    final db = await instance.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}