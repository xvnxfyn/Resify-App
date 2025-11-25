import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../models/resistor_color.dart';

class ResistorDao {

  Future<List<ResistorColor>> getDigitColors(int bandType) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'resistor_colors',
      where: 'value IS NOT NULL AND band_type = ?',
      whereArgs: [bandType],
      orderBy: 'value ASC',
    );

    return result.map((e) => ResistorColor.fromMap(e)).toList();
  }


  Future<List<ResistorColor>> getMultiplierColors(int bandType) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'resistor_colors',
      where: 'multiplier IS NOT NULL AND band_type = ?',
      whereArgs: [bandType],
      orderBy: 'multiplier ASC',
    );

    return result.map((e) => ResistorColor.fromMap(e)).toList();
  }


  Future<List<ResistorColor>> getToleranceColors(int bandType) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'resistor_colors',
      where: 'tolerance IS NOT NULL AND band_type = ?',
      whereArgs: [bandType],
      orderBy: 'tolerance ASC',
    );

    return result.map((e) => ResistorColor.fromMap(e)).toList();
  }


  Future<ResistorColor?> getColor(String color, int bandType) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'resistor_colors',
      where: 'color = ? AND band_type = ?',
      whereArgs: [color, bandType],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return ResistorColor.fromMap(result.first);
  }


  Future<List<ResistorColor>> getAllColors(int bandType) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'resistor_colors',
      where: 'band_type = ?',
      whereArgs: [bandType],
    );

    return result.map((e) => ResistorColor.fromMap(e)).toList();
  }
}
