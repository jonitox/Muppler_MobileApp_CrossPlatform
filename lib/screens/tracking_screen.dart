import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/event_list.dart';

class TrackingScreen extends StatefulWidget {
  final List<Event> _events;
  final Function _routeChooseExScreen;
  final Function deleteEvent;
  final List<String> _exList;
  // final String selectedEx;
  TrackingScreen(
    // this.selectedEx,
    this._events,
    this._routeChooseExScreen,
    this.deleteEvent,
    this._exList,
  );
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String _selectedEx;
  List<Event> _selectedEvents = [];

  // tap Choose Exercise button
  void _tapChooseEx() {
    widget._routeChooseExScreen(_selectedEx).then((ret) {
      if (ret != null && ret != _selectedEx) {
        setState(() {
          _selectedEx = ret as String;
          _selectedEvents = widget._events
              .where((test) => test.exercise == _selectedEx)
              .toList();
          _selectedEvents.sort((a, b) => b.date.compareTo(a.date));
        });
      } else if (!widget._exList.contains(_selectedEx)) {
        setState(() {
          _selectedEx = null;
        });
      }
    });
  }

  // delete Event
  void _deleteEvent(String id) {
    setState(() {
      widget.deleteEvent(id);
      _selectedEvents.removeWhere((test) => test.id == id);
    });
  }

  // build exercise Selection Button
  Widget get _exSelectionButton {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            child: _selectedEx == null
                ? Text('선택된 운동이 없습니다.')
                : Text('선택된 운동: $_selectedEx'),
            onPressed: _tapChooseEx,
          ),
        ),
        Text('기간:'),
        Container(
          child: RaisedButton(
            child: Text('-'),
            onPressed: null,
          ),
          width: 30,
        ),
        Container(
          child: RaisedButton(
            child: Text('-'),
            onPressed: null,
          ),
          width: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '특정 운동의 종목을 선택하세요.',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        _exSelectionButton,
        Expanded(
            child: EventList(
          selectedEvents: _selectedEvents,
          isDateVisible: true,
          deleteEvent: _deleteEvent,
        )),
      ],
    );
  }
}
