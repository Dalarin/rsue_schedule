import 'dart:async';

import 'package:rsue_schedule/models/homework.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  final _textType = 'TEXT NOT NULL';
  final _integerType = 'INTEGER NOT NULL';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("schedule.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = '${await getDatabasesPath()}/$filePath';
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute("""
    CREATE TABLE homework(
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'group' $_textType,
    'lesson' $_textType,
    'title' $_textType,
    'description' $_textType,
    'confirm_by' $_integerType,
    'created_at' $_integerType,
    'is_completed' $_integerType);
    """);
  }

  Future<List<Homework>> getRecords(
    String lesson,
    String group,
    DateTime dateTime,
  ) async {
    final db = await database;
    final response = await db.query(
      'homework',
      where: "lesson = ? and `group` = ? and confirm_by > ? and created_at < ?",
      whereArgs: [
        lesson,
        group,
        dateTime.millisecondsSinceEpoch,
        dateTime.millisecondsSinceEpoch
      ],
    );
    return response.map((e) => Homework.fromMap(e)).toList();
  }

  Future<bool> deleteRecord(int id) async {
    final db = await database;
    final response = await db.delete(
      'homework',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response > 0;
  }

  Future<Homework?> updateRecord(Homework homework) async {
    final db = await database;
    final response = await db.update('homework', homework.toMap());
    return response > 0 ? homework : null;
  }

  Future<Homework?> insertRecord(Homework homework) async {
    final db = await database;
    final id = await db.insert('homework', homework.toMap());
    return homework.copyWith(id: id);
  }
}
