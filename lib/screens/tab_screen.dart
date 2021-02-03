import 'package:flutter/material.dart';

import './add_event_screen.dart';
import '../models/event.dart';
import './calendar_screen.dart';
import './tracking_screen.dart';
import './home_screen.dart';
import './manage_screen.dart';
import './choose_ex_screen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  var _curIdx = 0;
  List<Widget> _pages;
  List<String> _exList = [];

  Map<String, bool> _filters = {'undefined': true};
  List<Event> _events = [];

  // DateTime selectedDay = DateTime.now();
  // String _selectedEx;

  // initState
  @override
  void initState() {
    _pages = [
      HomeScreen(
        routeManageScreen,
        _events,
        switchToCalendarScreen,
      ),
      CalendarScreen(
        _events,
        _filters,
        routeAddEventScreen,
        _exList,
        deleteEvent,
      ),
      TrackingScreen(_events, routeChooseExScreen, deleteEvent, _exList),
    ];
    super.initState();
  }

  // tap BottomNavigationBar
  void _onTap(idx) {
    setState(() {
      _curIdx = idx;
    });
  }

  // tap 오늘의 운동 목록관리
  void switchToCalendarScreen() {
    setState(() {
      _curIdx = 1;
    });
  }

  // tap 종목 관리 스크린
  Future routeManageScreen() {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (bctx) => ManageScreen(
        _exList,
        deleteEx,
        addEx,
      ),
    ));
  }

  // 운동종목 선택 화면 route.
  Future routeChooseExScreen(String preSelectedEx) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            ChooseExScreen(preSelectedEx, _exList, routeManageScreen)));
  }

  // 운동event 추가 화면 route 및 event 추가
  Future routeAddEventScreen({DateTime date, Event oldEvent}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AddEventScreen(
              routeChooseExScreen,
              date: date,
              oldEvent: oldEvent,
            )));
  }

  // event 삭제
  void deleteEvent(String id) {
    _events.removeWhere((test) => test.id == id);
  }

// 운동종목 추가
  void addEx(String ex) {
    _exList.add(ex);
    _filters.addAll({ex: true});
  }

// 운동종목 삭제
  void deleteEx(int exIdx, bool deleteAll) {
    _filters.remove(_exList[exIdx]);
    _exList.removeAt(exIdx);
    // 해당운동 기록 전부 삭제.
    // if (!deleteAll) {
    //   // _eventsPerEx[name].forEach((test) {
    //   //   test.exercise = 'undefined';
    //   // });
    //   _eventsPerEx['undefined'].addAll(_eventsPerEx[name] ?? []);
    // }
  }

  @override
  Widget build(BuildContext context) {
    print('build tapScreen!');
    return Scaffold(
      appBar: AppBar(
        title: Text('work out tracker'),
      ),
      body: _pages[_curIdx],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '종목',
          ),
        ],
        currentIndex: _curIdx,
        onTap: _onTap,
      ),
    );
  }
}
