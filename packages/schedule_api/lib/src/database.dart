// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  final _cachingPeriod;
  final _textType = 'TEXT NOT NULL';
  final _integerType = 'INTEGER NOT NULL';
  final List<String> _days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  DBHelper(this._cachingPeriod);

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("cache.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = '${await getDatabasesPath()}/$filePath';
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
      onOpen: (database) {
        _clearExpiredData(DateTime.now(), database);
      },
    );
  }

  int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  Future<List<Map<String, dynamic>>> getGroupScheduleFromDB(
    String group,
    DateTime date,
  ) async {
    final now = DateTime.now();
    final weekNumber = _weekNumber(date);
    final db = await database;
    return await db.rawQuery(
      "SELECT `group`, day, time, lesson, teacher, auditorium, type, even_week, ${now.millisecondsSinceEpoch} - date_parse as date  from cache where date < ${_cachingPeriod * 86400000} and `group` = ? and even_week = ? and day = ?",
      [group, weekNumber % 2 == 0 ? 0 : 1, _days[date.weekday - 1]],
    );
  }

// TODO : не забыть изменить even_week
  Future<List<Map<String, dynamic>>> getAuditoriumScheduleFromDB(
    String auditorium,
    DateTime date,
  ) async {
    final now = DateTime.now();
    final weekNumber = _weekNumber(now);
    final db = await database;
    return await db.rawQuery(
      "SELECT `group`, day, time, lesson, teacher, auditorium, type, even_week, ${now.millisecondsSinceEpoch} - date_parse as date  from cache where date < ${_cachingPeriod * 86400000} and auditorium = ? and even_week = ? and day = ?",
      [auditorium, weekNumber % 2 == 0 ? 0 : 1, _days[date.weekday - 1]],
    );
  }

  Future<List<Map<String, dynamic>>> getTeachersFromScheduleDB(
    String group,
  ) async {
    final db = await database;
    return await db.rawQuery(
      'SELECT DISTINCT teacher from cache WHERE group = ? ',
      [group],
    );
  }

  Future insertRecord(Map<String, dynamic> data) async {
    final db = await database;
    data['date_parse'] = DateTime.now().millisecondsSinceEpoch;
    return await db.insert('cache', data);
  }

  Future _clearExpiredData(DateTime currentDate, Database database) async {
    final now = DateTime.now();
    await database.delete(
      'cache',
      where: '(${now.millisecondsSinceEpoch} - date_parse) > ?',
      whereArgs: [_cachingPeriod * 86400000],
    );
  }

  void _createDatabaseTable(Database database) async {
    try {
      database.execute("""
      CREATE TABLE cache(
      'group' $_textType,
      day $_textType,
      time $_textType,
      lesson $_textType,
      teacher $_textType,
      auditorium $_textType,
      type $_textType,
      even_week $_integerType,
      date_parse $_integerType
      );
      """);
    } catch (_) {}
  }

  Future _createDB(Database db, int version) async {
    try {
      _createDatabaseTable(db);
    } catch (E) {
      throw Exception('Ошибка создания базы данных');
    }
  }

  void clearCachedData() async {
    final db = await database;
    await db.delete('cache');
  }
}
