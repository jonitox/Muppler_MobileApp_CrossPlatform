import 'package:flutter/foundation.dart';

enum DetailType {
  basic,
  onlyRep,
}

class Event {
  final String id;
  final DateTime date;
  String exerciseId;
  List<Set> setDetails;
  // List<bool> setSuccesses;
  String memo;
  DetailType type;
  Event({
    @required this.id,
    this.date,
    @required this.exerciseId,
    this.setDetails,
    this.memo = '',
    this.type = DetailType.basic,
  }) {
    if (setDetails == null) {
      setDetails = <Set>[]; // 그냥 클래스내에서 []를 명시?
    }
  }

  int get numOfSets {
    return setDetails.length;
  }

  Event copyWith({
    String id,
    DateTime date,
    String exerciseId,
    List<Set> setDetails,
    String memo,
    DetailType type,
  }) {
    return Event(
      id: id ?? this.id,
      date: date ?? this.date,
      exerciseId: exerciseId ?? this.exerciseId,
      setDetails: setDetails ?? List.from(this.setDetails),
      memo: memo ?? this.memo,
      type: type ?? this.type,
    );
  }

  void addSet(Set item) {
    setDetails.add(item);
  }

  void removeSet(int idx) {
    print('remove $idx !');
    setDetails.removeAt(idx);
  }

  void updateSet(int idx, Set updatedSet) {
    setDetails[idx] = updatedSet;
  }

  dynamic get volume {
    if (type == DetailType.basic) {
      return setDetails.fold(0.0, (sum, element) => sum += element.volume);
    } else {
      return setDetails.fold(0, (sum, element) => sum += element.rep);
    }
  }

  Map<String, dynamic> eventToMap() {
    print('call eventToMap!');
    print(id);
    // dynamic?
    // id TEXT PRIMARY KEY, exerciseId TEXT, memo TEXT, date TEXT, type INTEGER
    return {
      'id': id,
      'exerciseId': exerciseId,
      'memo': memo,
      'date': date.toIso8601String(),
      'type': type.index,
    };
  }

  List<Map<String, dynamic>> setsToList() {
    print('call setsToList!');
    print(id);
    // id INTEGER PRIMARY KEY, eventId TEXT, setNumber INTEGER, weight REAL, repetition INTEGER
    return setDetails.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      return {
        'eventId': id,
        'setNumber': i,
        'weight': s.weight,
        'repetition': s.rep,
      };
    }).toList();
  }
}

class Set {
  int rep;
  double weight;
  Set(this.weight, this.rep);

  double get volume => rep * weight;
}
