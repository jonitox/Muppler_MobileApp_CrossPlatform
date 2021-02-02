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

  void addSet(Set item) {
    sets.add(item);
  }

  void removeSet(int idx) {
    // ..
  }
}

class Set {
  final int rep;
  final double weight;
  Set(this.weight, this.rep);

  double get volume {
    return rep * weight;
  }
}
