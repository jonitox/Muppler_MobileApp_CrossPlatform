import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise.dart';
import '../helpers/dbhelper.dart';

class Exercises with ChangeNotifier {
  List<Exercise> _items = [];

  List<Exercise> get items {
    return [..._items];
  }

  List<String> get getExerciseIds {
    return _items.map((ex) => ex.id).toList();
  }

  List<Exercise> getExercisesByTarget(String targetName) {
    if (targetName == Target.all) {
      return items;
    }
    return _items.where((ex) => ex.target.value == targetName).toList();
  }

  Map<String, bool> get getExercisesSelection {
    return _items.asMap().map((key, item) => MapEntry(item.id, false));
  }

  Exercise getExercise(String id) {
    return _items.firstWhere((ex) => ex.id == id);
  }

  Future<List<String>> fetchAndSetExercises() async {
    final fetchedExercises = await DBHelper.getData('exercises');
    List<Exercise> loadedExercises = [];
    fetchedExercises.forEach(
      (ex) => loadedExercises.add(
        Exercise(
          ex['id'],
          ex['name'],
          Target(Target.values[ex['target']]),
        ),
      ),
    ); // target
    _items = loadedExercises;
    notifyListeners(); //
    return getExerciseIds;
  }

  String addExercise(
    String name,
    Target target,
  ) {
    String id = Uuid().v4();
    final newExercise = Exercise(id, name, target);
    _items.add(newExercise);
    notifyListeners();
    DBHelper.insert('exercises', newExercise.exerciseToMap());
    return id;
  }

  void deleteExercise(
      String exerciseId, List<String> eventIds, List<String> routineIds) {
    _items.removeWhere((ex) => ex.id == exerciseId);
    notifyListeners();
    DBHelper.deleteExercise(exerciseId, eventIds, routineIds);
  }

  void updateExercise(String id, Exercise ex) {
    final idx = _items.indexWhere((item) => item.id == id);
    _items[idx] = ex;
    notifyListeners();
    DBHelper.update('exercises', ex.exerciseToMap(), id);
  }
}
