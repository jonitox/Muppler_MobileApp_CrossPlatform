import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class DBHelper {
  /// create Database
  static Future<void> _createDb(Database db, int version) async {
    // batch
    const _createExercisesTable =
        'CREATE TABLE exercises (id TEXT PRIMARY KEY, name TEXT, target INTEGER)';
    const _createEventsTable =
        'CREATE TABLE events (id TEXT PRIMARY KEY, exerciseId TEXT, memo TEXT, date TEXT, type INTEGER)';
    const _createSetsTable =
        'CREATE TABLE sets (id INTEGER PRIMARY KEY, eventId TEXT, weight REAL, repetition INTEGER)';
    const _createRoutinesTable =
        'CREATE TABLE routines (id TEXT PRIMARY KEY, name TEXT)';
    const _createRoutineEventsTable =
        'CREATE TABLE routineEvents (id TEXT PRIMARY KEY, routineId TEXT, orderNumber INTEGER, exerciseId TEXT, type INTEGER)';
    const _createRoutineSetsTable =
        'CREATE TABLE routineSets (id INTEGER PRIMARY KEY, routineId TEXT, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER)';
    const _createDaySatisfaction =
        'CREATE TABLE satisfaction (date TEXT PRIMARY KEY, figure INTEGER)';

    final batch = db.batch();
    batch.execute(_createEventsTable);
    batch.execute(_createSetsTable);
    batch.execute(_createExercisesTable);
    batch.execute(_createRoutinesTable);
    batch.execute(_createRoutineEventsTable);
    batch.execute(_createRoutineSetsTable);
    batch.execute(_createDaySatisfaction);
    var uuid = Uuid();
    batch.insert('exercises', {'id': uuid.v4(), 'name': '벤치프레스', 'target': 1});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '덤벨 벤치프레스', 'target': 1});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '인클라인 벤치프레스', 'target': 1});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '딥스', 'target': 1});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '덤벨 플라이', 'target': 1});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '펙덱 플라이 머신', 'target': 1});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '체스트 프레스 머신', 'target': 1});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '풀업', 'target': 2});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '바벨 로우', 'target': 2});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '원암 덤벨 로우', 'target': 2});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '랫풀다운', 'target': 2});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '시티드 케이블 로우', 'target': 2});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '스쿼트', 'target': 3});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '레그 프레스', 'target': 3});
    batch
        .insert('exercises', {'id': uuid.v4(), 'name': '레그 익스텐션', 'target': 3});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '데드리프트', 'target': 3});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '오버헤드 프레스', 'target': 3});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '사이드 레터럴 레이즈', 'target': 4});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '덤벨 숄더 프레스', 'target': 4});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '벤트오버 레터럴 레이즈', 'target': 4});
    batch
        .insert('exercises', {'id': uuid.v4(), 'name': '프론트 레이즈', 'target': 4});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '덤벨 컬', 'target': 5});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '바벨 컬', 'target': 5});
    batch.insert('exercises', {'id': uuid.v4(), 'name': '해머 컬', 'target': 5});
    batch.insert(
        'exercises', {'id': uuid.v4(), 'name': '케이블 푸쉬 다운', 'target': 5});
    await batch.commit();
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

  // updateRoutine
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

  // insert / update Satisfaction
  static Future<void> insertOrUpdateSatisfaction(
    String date,
    Map<String, Object> satisfactionData,
  ) async {
    final db = await DBHelper.database();
    return db.transaction((txn) async {
      await txn.delete('satisfaction', where: "date = ?", whereArgs: [date]);
      await txn.insert('satisfaction', satisfactionData);
    });
  }

  // delete Satisfaction
  static Future<void> deleteSatisfaction(
    String date,
  ) async {
    final db = await DBHelper.database();
    return db.delete('satisfaction', where: "date = ?", whereArgs: [date]);
  }
}
