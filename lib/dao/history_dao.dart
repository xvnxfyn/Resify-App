import '../database/app_database.dart';
import '../models/history.dart';

class HistoryDao {
  Future<int> insertHistory(History history) async {
    final db = await AppDatabase.instance.database;
    return await db.insert("history", history.toMap());
  }

  Future<List<History>> getHistory() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("history", orderBy: "id DESC");

    return result.map((e) => History.fromMap(e)).toList();
  }

  Future<void> clearHistory() async {
    final db = await AppDatabase.instance.database;
    await db.delete("history");
  }

  Future<int> deleteHistory(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete("history", where: "id = ?", whereArgs: [id]);
  }
}
