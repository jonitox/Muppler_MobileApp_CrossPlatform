import 'package:flutter/foundation.dart';

class LapTimes with ChangeNotifier {
  List<Map<String, String>> _items = [];
  List<Map<String, String>> get items => [..._items];

  void clearLaps() {
    _items.forEach((item) {
      item.clear();
    });
    _items.clear();
    notifyListeners();
  }

  int length() {
    return _items.length;
  }

  void addLap(Map<String, String> lapInfo) {
    _items.insert(
      0,
      lapInfo,
    );
    notifyListeners();
  }
}
