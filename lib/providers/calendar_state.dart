import 'package:flutter/foundation.dart';

import 'package:table_calendar/table_calendar.dart' show CalendarFormat;

class CalendarState with ChangeNotifier {
  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);

  CalendarFormat _format = CalendarFormat.month;
  DateTime get day {
    return _selectedDay;
  }

  CalendarFormat get format {
    return _format;
  }

  void setDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }

  void toggleFormat() {
    _format = _format == CalendarFormat.month
        ? CalendarFormat.week
        : CalendarFormat.month;
    notifyListeners();
  }
}
