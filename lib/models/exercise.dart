import 'package:flutter/foundation.dart';

class Target {
  String value;
  Target(this.value);

  static const String all = '전체';
  static const String chest = '가슴';
  static const String back = '등';
  static const String leg = '하체';
  static const String shoulder = '어깨';
  static const String arm = '팔';
  static const String others = '기타';

  int get index {
    if (value == Target.all) {
      return 0;
    } else if (value == Target.chest) {
      return 1;
    } else if (value == Target.back) {
      return 2;
    } else if (value == Target.leg) {
      return 3;
    } else if (value == Target.shoulder) {
      return 4;
    } else if (value == Target.arm) {
      return 5;
    } else {
      return 6;
    }
  }

  static const List<String> values = ['전체', '가슴', '등', '하체', '어깨', '팔', '기타'];
  static const List<String> valuesExceptAll = [
    '가슴',
    '등',
    '하체',
    '어깨',
    '팔',
    '기타'
  ];
}

class Exercise {
  Exercise(this.id, this.name, this.target);
  final String id;
  String name;
  Target target;

  Map<String, dynamic> exerciseToMap() {
    // 'CREATE TABLE exercises(id TEXT PRIMARY KEY, name TEXT, target INTEGER)';
    return {
      'id': id,
      'name': name,
      'target': target.index,
    };
  }
}
