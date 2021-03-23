import 'package:flutter/material.dart';

import './event.dart';
import 'package:uuid/uuid.dart';

class Routine {
  Routine({this.id, this.name = '', this.items});
  final String id;
  String name;
  List<Event> items = [];

  void add(Event event) {
    items.add(event);
  }

  int get numberOfSets {
    return items.fold(0, (sum, e) => sum + e.setDetails.length);
  }

  double get volume {
    return items.fold(0.0, (sum, e) => sum + e.volume);
  }

  List<Event> get getRoutineToAdd {
    var uuid = Uuid();
    return items
        .map(
          (e) => Event(
              id: uuid.v4(), // 매번 다른지 확인.
              exerciseId: e.exerciseId,
              date: DateTime.now(),
              setDetails: e.setDetails,
              type: e.type),
        )
        .toList();
  }

  bool containExercise(String exerciseId) {
    bool tag = false;
    items.forEach((e) {
      if (e.exerciseId == exerciseId) {
        tag = true;
      }
    });
    return tag;
  }

// const _createRoutinesTable =
//         'CREATE TABLE routines(id TEXT PRIMARY KEY, name TEXT)'; // eventNumber?
//     const _createRoutineEventsTable =
//         'CREATE TABLE routineEvents(id TEXT PRIMARY KEY, routineId TEXT, orderNumber INTEGER, exerciseId TEXT, type INTEGER)'; // eventNumber?
//     const _createRoutineSetsTable =
//         'CREATE TABLE routineSets(id INTEGER PRIMARY KEY AUTO INCREMENT, routineId TEXT, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER)';

  Map<String, dynamic> routineToMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  List<Map<String, dynamic>> eventsToList() {
    return items.asMap().entries.map((entry) {
      final idx = entry.key;
      final e = entry.value;
      return {
        'id': e.id,
        'routineId': id,
        'orderNumber': idx,
        'exerciseId': e.exerciseId,
        'type': e.type.index,
      };
    }).toList();
  }

  List<Map<String, dynamic>> setsToList() {
    List<Map<String, dynamic>> sets = [];
    items.forEach((e) {
      e.setDetails.asMap().entries.forEach((entry) {
        final idx = entry.key;
        final s = entry.value;
        sets.add({
          'routineId': id,
          'eventId': e.id,
          'setNumber': idx,
          'weight': s.weight,
          'repetition': s.rep,
        });
      });
    });
    return sets;
  }

  Routine copyWith({String id, String name, List<Event> items}) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? List.from(this.items),
    );
  }
}
