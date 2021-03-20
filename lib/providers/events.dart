import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../helpers/dbhelper.dart';
import '../models/event.dart';
import '../models/routine.dart';

class Events with ChangeNotifier {
  List<Event> _items = [];

  List<Event> get items {
    return [..._items];
  }

  Event getEvent(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  Map<DateTime, List> getItemsForCalendar(Map<String, bool> filters) {
    Map<DateTime, List> itemsForCalendar = {};
    _items.forEach((item) {
      if (filters[item.exerciseId]) {
        if (itemsForCalendar[item.date] == null) {
          itemsForCalendar[item.date] = [];
        }
        itemsForCalendar[item.date].add(item);
      }
    });
    return itemsForCalendar;
  }

  Future<void> fetchAndSetEvents() async {
    final fetchedEvents = await DBHelper.getData('events');
    final fetchedSets = await DBHelper.getData('sets');
    List<Event> loadedEvents = [];
    // fetch routines 방식으로 변경?
    fetchedEvents.forEach((event) {
      final setsOfEvent =
          fetchedSets.where((s) => s['eventId'] == event['id']).toList();
      // ..sort((a, b) =>
      //     a['setNumber'] <
      //     b['setNumber']); // ? dart pad 실험. // 추가된순서로있으니까 불필요할지도.
      loadedEvents.add(Event(
        id: event['id'],
        date: DateTime.parse(event['date']),
        exerciseId: event['exerciseId'],
        memo: event['memo'],
        setDetails:
            setsOfEvent.map((s) => Set(s['weight'], s['repetition'])).toList(),
        type: event['type'] == 0 ? DetailType.basic : DetailType.onlyRep,
      ));
    });
    _items = loadedEvents;
    notifyListeners(); //
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Event> getTodayEvents(DateTime date, Map<String, bool> filters) {
    return _items
        .where((item) =>
            _isSameDay(item.date, date) &&
            (filters == null ? true : filters[item.exerciseId]))
        .toList(); // 추가된순서로 sort.
  }

  int getTodayEventsNum(DateTime date, Map<String, bool> filters) {
    return _items.fold(0, (sum, item) {
      if ((filters == null ? true : filters[item.exerciseId]) &&
          _isSameDay(item.date, date)) {
        return sum + 1;
      } else {
        return sum;
      }
    });
  }

  double getTodayEventsVolume(DateTime date, Map<String, bool> filters) {
    return _items.fold(0.0, (sum, item) {
      if ((filters == null ? true : filters[item.exerciseId]) &&
          _isSameDay(item.date, date)) {
        return sum + item.volume;
      } else {
        return sum;
      }
    });
  }

  List<Event> getTrackedEvents(String exerciseId) {
    return _items.where((item) => item.exerciseId == exerciseId).toList()
      ..sort((a, b) => a.date.isBefore(b.date) ? 1 : 0); // sort 혹은 밖에서.
  }

  void addEvents(List<Event> events) {
    var uuid = Uuid();
    final eventsWithId = events
        .map((e) => e.copyWith(
              id: uuid.v4(),
            ))
        .toList(); // toList삭제
    _items.addAll(eventsWithId);
    notifyListeners();
    final eventsData = eventsWithId.map((e) => e.eventToMap()).toList();
    List<Map<String, Object>> setsData = [];
    eventsWithId.forEach((e) => setsData.addAll(e.setsToList()));

    DBHelper.insertEvents(eventsData, setsData);
  }

  void deleteEvent(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    DBHelper.deleteEvent(id);
  }

  List<String> deleteEventsOfExercise(String exerciseId) {
    List<String> eventIdsOfExercise = [];
    _items.forEach((e) {
      if (e.exerciseId == exerciseId) eventIdsOfExercise.add(e.id);
    });
    _items.removeWhere((e) => e.exerciseId == exerciseId);
    notifyListeners();
    return eventIdsOfExercise;
  }

  void updateEvent(String id, Event event) {
    // shop과 비교.
    final idx = _items.indexWhere((e) => e.id == id);
    _items[idx] = event;
    notifyListeners();
    DBHelper.updateEvent(id, event.eventToMap(), event.setsToList());
  }
}
