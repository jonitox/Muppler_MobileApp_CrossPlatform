import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../models/event.dart';

class DBHelper {
  /// create Database
  static Future<void> _createDb(Database db, int version) async {
    // batch
    const _createExercisesTable =
        'CREATE TABLE exercises (id TEXT PRIMARY KEY, name TEXT, target INTEGER)';
    const _createEventsTable =
        'CREATE TABLE events (id TEXT PRIMARY KEY, exerciseId TEXT, memo TEXT, date TEXT, type INTEGER)';
    const _createSetsTable =
        'CREATE TABLE sets (id INTEGER PRIMARY KEY, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER)'; // auto increment? // setNumber
    const _createRoutinesTable =
        'CREATE TABLE routines (id TEXT PRIMARY KEY, name TEXT)'; // eventNumber?
    const _createRoutineEventsTable =
        'CREATE TABLE routineEvents (id TEXT PRIMARY KEY, routineId TEXT, orderNumber INTEGER, exerciseId TEXT, type INTEGER)'; // orderNumber,
    const _createRoutineSetsTable =
        'CREATE TABLE routineSets (id INTEGER PRIMARY KEY, routineId TEXT, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER)'; // setNumber안씀?
    const _createDayMemosTable =
        'CREATE TABLE memos (date TEXT PRIMARY KEY, dayMemo TEXT)';
    await db.execute(_createEventsTable);
    await db.execute(_createSetsTable);
    await db.execute(_createExercisesTable);
    await db.execute(_createRoutinesTable);
    await db.execute(_createRoutineEventsTable);
    await db.execute(_createRoutineSetsTable);
    await db.execute(_createDayMemosTable);

    // 기본 제공 운동들 입력하기.
  }

  /// get database
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'tracker.db'),
      onCreate: _createDb,
      version: 1,
    );
  }

  /// insert data to table
  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database(); // static이므로 접근 시 class이름 필요.
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, //
    );
  }

  /// insert event with its sets
  static Future<void> insertEvent(
    Map<String, Object> eventData,
    List<Map<String, Object>> setsData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.insert('events', eventData);
      final batch = txn.batch(); // batch? // 어차피 transaction이니까 따로따로 해도됨?
      setsData.forEach((s) {
        batch.insert('sets', s);
      });
      await batch.commit();
    });
  }

  /// insert events of routine
  // static Future<void> insertEventsOfRoutine(

  // insert events
  static Future<void> insertEvents(
    List<Map<String, Object>> eventsData,
    List<Map<String, Object>> setsData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      final batch = txn.batch(); // batch?
      eventsData.forEach((e) {
        batch.insert('events', e);
      });
      setsData.forEach((s) {
        batch.insert('sets', s);
      });
      await batch.commit();
    });
  }

  // insert Routine
  static Future<void> insertRoutine(
    Map<String, Object> routineData,
    List<Map<String, Object>> routineEventsData,
    List<Map<String, Object>> routineSetsData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.insert('routines', routineData);
      final batch = txn.batch();
      if (routineEventsData != null) {
        routineEventsData.forEach((e) {
          batch.insert('routineEvents', e);
        });
      }
      if (routineSetsData != null) {
        routineSetsData.forEach((s) {
          batch.insert('routineSets', s);
        });
      }
      await batch.commit();
    });
  }

  /// get data from table
  static Future<List<Map<String, dynamic>>> getData(
    String table, {
    String where,
    List<Object> whereargs,
  }) async {
    final db = await DBHelper.database();
    return db.query(table, where: where, whereArgs: whereargs);
  }

  /// delete data from table
  static Future<int> delete(String table, String id) async {
    final db = await DBHelper.database();
    return db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  // delete event with its sets
  static Future<void> deleteEvent(String id) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.delete('events', where: 'id = ?', whereArgs: [id]);
      await txn.delete('sets', where: 'eventId = ?', whereArgs: [id]);
    });
  }

  /// delete exercise with events and routines of it
  static Future<void> deleteExercise(
    String exerciseId,
    List<String> eventIds,
    List<String> routineIds,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.delete('exercises', where: "id = ?", whereArgs: [exerciseId]);
      await txn
          .delete('events', where: "exerciseId = ?", whereArgs: [exerciseId]);
      await txn.delete('sets',
          where: "eventId = ?", whereArgs: eventIds); // 리스트로 목록입력하는게 맞나?
      await txn.delete('routines', where: "id = ?", whereArgs: routineIds);
      await txn.delete('routineEvents',
          where: "routineId = ?", whereArgs: routineIds);
      await txn.delete('routineSets',
          where: "routineId = ?", whereArgs: routineIds);
    });
  }

  // delete Routine with its contents
  static Future<void> deleteRoutine(String id) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.delete('routines', where: 'id = ?', whereArgs: [id]);
      await txn
          .delete('routineEvents', where: 'routineId = ?', whereArgs: [id]);
      await txn.delete('routineSets', where: 'routineId = ?', whereArgs: [id]);
    });
  }

  /// update data
  static Future<int> update(
      String table, Map<String, Object> data, String id) async {
    final db = await DBHelper.database();
    return db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // updateEvent
  static Future<void> updateEvent(
    String eventId,
    Map<String, Object> eventData,
    List<Map<String, Object>> setsData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn
          .update('events', eventData, where: "id = ?", whereArgs: [eventId]);
      await txn.delete('sets', where: "eventId = ?", whereArgs: [eventId]);
      final batch = txn.batch(); // batch?
      // batch.delete('sets', where: 'id = ?', whereArgs: [eventId]);
      setsData.forEach((s) {
        batch.insert('sets', s);
      });
      await batch.commit();
    });
  }

  static Future<void> updateRoutine(
    String routineId,
    Map<String, Object> routineData,
    List<Map<String, Object>> routineEventsData,
    List<Map<String, Object>> routineSetsData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.update('routines', routineData,
          where: "id = ?", whereArgs: [routineId]);
      final batch = txn.batch();
      batch.delete('routineEvents',
          where: 'routineId = ?', whereArgs: [routineId]);
      batch.delete('routineSets',
          where: 'routineId = ?', whereArgs: [routineId]);
      routineEventsData.forEach((e) {
        batch.insert('routineEvents', e);
      });
      routineSetsData.forEach((s) {
        batch.insert('routineSets', s);
      });
      await batch.commit();
    });
  }
}
