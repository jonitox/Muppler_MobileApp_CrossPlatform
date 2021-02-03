import 'package:flutter/foundation.dart';

class Event {
  String exercise;
  DateTime date;
  String id;
  // example Sets
  List<Set> sets;

  Event({
    this.date,
    @required this.id,
    this.exercise,
    this.sets,
  }) {
    if (sets == null) sets = <Set>[];
  }
  int get numOfSets {
    return sets.length;
  }

  void addSet(Set item) {
    sets.add(item);
  }

  void removeSet() {
    if (numOfSets > 0) sets.removeLast();
  }
}

class Set {
  int _rep;
  double _weight;
  Set(this._weight, this._rep);

  double get weight => _weight;
  int get rep => _rep;

  set weight(double newWeight) => _weight = newWeight;
  set rep(int newRep) => _rep = newRep;

  double get volume => _rep * _weight;
}
