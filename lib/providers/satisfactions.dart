import 'package:flutter/foundation.dart';
import '../helpers/dbhelper.dart';

class Satisfactions with ChangeNotifier {
  Map<DateTime, int> items = {};

  Future<void> fetchAndSetSatisfactions() async {
    final fetchedSatisfactions = await DBHelper.getData('satisfaction');
    Map<DateTime, int> loadedSatisfactions = {};
    fetchedSatisfactions.forEach((sf) {
      loadedSatisfactions.addAll({DateTime.parse(sf['date']): sf['figure']});
    });
    items = loadedSatisfactions;
    notifyListeners();
    return;
  }

  int getSatisfaction(DateTime day) {
    return items.containsKey(day) ? items[day] : 0;
  }

  void changeSatisFaction(DateTime day, int sf) {
    if (items.containsKey(day) != null && items[day] == sf) {
      items.remove(day);
      DBHelper.deleteSatisfaction(day.toIso8601String());
    } else {
      items[day] = sf;
      DBHelper.insertOrUpdateSatisfaction(
          day.toIso8601String(), {'date': day.toIso8601String(), 'figure': sf});
    }
    notifyListeners();
  }
}
