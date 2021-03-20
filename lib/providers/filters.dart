import 'package:flutter/foundation.dart';

class Filters with ChangeNotifier {
  Map<String, bool> _items = {};

  Map<String, bool> get items {
    return {..._items};
  }

  void switchItem(String id) {
    _items[id] = !_items[id];
    notifyListeners();
  }

  void turnOnAll() {
    _items.updateAll((key, value) => true);
    notifyListeners();
  }

  void turnOffAll() {
    _items.updateAll((key, value) => false);
    notifyListeners();
  }

  void addFilter(String id) {
    _items.addAll({id: true});
    notifyListeners();
  }

  void addFilters(List<String> ids) {
    _items.addAll(ids.asMap().map((_, id) => MapEntry(id, true)));
    notifyListeners();
  }

  void deleteFilter(String id) {
    _items.remove(id);
    notifyListeners();
  }
}
