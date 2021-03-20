import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../helpers/dbhelper.dart';

import '../models/routine.dart';
import '../models/event.dart';

class Routines with ChangeNotifier {
  List<Routine> _items = [];

  List<Routine> get items {
    return [..._items];
  }

  Routine getRoutine(String id) {
    return _items.firstWhere((r) => r.id == id);
  }

// const _createRoutinesTable =
//         'CREATE TABLE routines(id TEXT PRIMARY KEY, name TEXT)'; // eventNumber?
//     const _createRoutineEventsTable =
//         'CREATE TABLE routineEvents(id TEXT PRIMARY KEY, routineId TEXT, orderNumber INTEGER, exerciseId TEXT, type INTEGER)'; // eventNumber?
//     const _createRoutineSetsTable =
//         'CREATE TABLE routineSets(id INTEGER PRIMARY KEY AUTO INCREMENT, routineId TEXT, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER)';
  Future<void> fetchAndSetRotuines() async {
    final fetchedRoutines = await DBHelper.getData('routines');
    final fetchedEvents = await DBHelper.getData('routineEvents');
    final fetchedSets = await DBHelper.getData('routineSets');

    Map<String, Map<int, Set>> setsPerEvent = {};
    fetchedSets.forEach(
      (s) {
        if (setsPerEvent[s['eventId']] == null) {
          setsPerEvent[s['eventId']] = {};
        }
        setsPerEvent[s['eventId']].addAll(
          {
            s['setNumber']: Set(s['weight'], s['repetition']),
          },
        );
      },
    );

    Map<String, Map<int, Event>> eventsPerRoutine = {};
    fetchedEvents.forEach(
      (e) {
        if (eventsPerRoutine[e['routineId']] == null) {
          eventsPerRoutine[e['routineId']] = {};
        }
        eventsPerRoutine[e['routineId']].addAll(
          {
            e['orderNumber']: Event(
              id: e['id'],
              exerciseId: e['exerciseId'],
              setDetails: List.generate(
                  setsPerEvent.containsKey(e['id'])
                      ? setsPerEvent[e['id']].length
                      : 0,
                  (i) => setsPerEvent[e['id']][i]),
              type: e['type'] == 0 ? DetailType.basic : DetailType.onlyRep,
            )
          },
        );
      },
    );

    List<Routine> loadedRoutines = [];
    fetchedRoutines.forEach(
      (r) {
        loadedRoutines.add(
          Routine(
            id: r['id'],
            name: r['name'],
            items: List.generate(eventsPerRoutine[r['id']].length,
                (i) => eventsPerRoutine[r['id']][i]),
          ),
        );
      },
    );

    _items = loadedRoutines;
    print(_items);
    notifyListeners(); //
  }

  void addRoutine(String name, List<Event> items) {
    var uuid = Uuid();
    final newRoutine = Routine(
        id: DateTime.now().toIso8601String(),
        name: name,
        items: items.map((e) => e.copyWith(id: uuid.v4())).toList());
    print(_items);
    _items.add(newRoutine);
    notifyListeners();
    DBHelper.insertRoutine(newRoutine.routineToMap(), newRoutine.eventsToList(),
        newRoutine.setsToList());
  }

  void deleteRoutine(String id) {
    _items.removeWhere((r) => r.id == id);
    notifyListeners();
    DBHelper.deleteRoutine(id);
  }

  List<String> deleteRoutinesOfExercise(String exerciseId) {
    List<String> routineIdsOfExercise = [];
    _items.forEach((r) {
      if (r.containExercise(exerciseId)) routineIdsOfExercise.add(r.id);
    });
    _items.removeWhere((r) => r.containExercise(exerciseId));
    notifyListeners();
    return routineIdsOfExercise;
  }

  void updateRoutine({String id, String name, List<Event> events}) {
    var uuid = Uuid();
    final modifiedRoutine = Routine(
      id: id,
      name: name,
      items: events.map((e) => e.copyWith(id: uuid.v4())).toList(),
    );
    final idx = _items.indexWhere((r) => id == id);
    _items[idx] = modifiedRoutine;
    notifyListeners();
    DBHelper.updateRoutine(id, modifiedRoutine.routineToMap(),
        modifiedRoutine.eventsToList(), modifiedRoutine.setsToList());
  }
}
