import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';
import '../widgets/event_list.dart';
import '../widgets/set_filter.dart';

class CalendarScreen extends StatefulWidget {
  final Function _routeAddEventScreen;
  final List<Event> _events;
  final Map<String, bool> _filters;
  final List<String> _exLists;
  final Function deleteEvent;
  CalendarScreen(this._events, this._filters, this._routeAddEventScreen,
      this._exLists, this.deleteEvent);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

// ****************** Clendar Screen ***************** // TickerProvider?
class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  List _selectedEvents;
  CalendarController _calendarController;
  AnimationController _animationController;
  Map<DateTime, List> _filteredEvents = {};

  // // Example holidays
  // final Map<DateTime, List> _holidays = {
  //   DateTime(2021, 1, 1): ['New Year\'s Day'],
  // };

  // filtering Events
  void _filteringEvents() {
    _filteredEvents.clear();
    widget._events.forEach((test) {
      if (widget._filters[test.exercise] == true) {
        if (_filteredEvents[test.date] == null) {
          _filteredEvents[test.date] = [];
        }
        _filteredEvents[test.date].add(test);
      }
    });
  }

  // tap set Filter button
  void _tapSetFilter() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (bctx) => SetFilter(widget._filters, widget._exLists),
    ).then((ret) {
      if (ret != null) {
        setState(() {
          final List<bool> newFilters = ret;
          newFilters.asMap().entries.forEach((entry) {
            final ex = widget._exLists[entry.key];
            widget._filters[ex] = entry.value;
          });
          _filteringEvents();
          _selectedEvents =
              _filteredEvents[_calendarController.selectedDay] ?? [];
        });
      }
    });
  }

  // tap add Event button
  void _tapAddEvent() {
    widget._routeAddEventScreen(_calendarController.selectedDay).then((ret) {
      if (ret != null) {
        setState(() {
          widget._events.add(ret as Event);
          _filteringEvents();
          _selectedEvents =
              _filteredEvents[_calendarController.selectedDay] ?? [];
        });
      }
    });
  }

  // delete event
  void _deleteEvent(String id) {
    setState(() {
      widget.deleteEvent(id);
      _filteringEvents();
      _selectedEvents = _filteredEvents[_calendarController.selectedDay] ?? [];
    });
  }

  //  onDaySelected
  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  // onCalendarCreated
  void _onCalendarCreated(_, __, ___) {
    // _selectedEvents = widget._events[_calendarController.selectedDay] ?? [];
  }

  // more: tabscreen이동시 _selectedDay 고정 => tab_screen에서 _selectedDay관리, 여기로 data전달
  // initState
  @override
  void initState() {
    print('init CalendarState!');
    _filteringEvents();
    final _selectedDay = DateTime.now();
    final _dayKey = _filteredEvents.keys.firstWhere(
        (test) =>
            test.year == _selectedDay.year &&
            test.month == _selectedDay.month &&
            test.day == _selectedDay.day,
        orElse: () => null);
    _selectedEvents = _dayKey != null ? _filteredEvents[_dayKey] : [];

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    super.initState();
  }

  // dispose
  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // *************** build Calendar Screen ***************** //
  @override
  Widget build(BuildContext context) {
    print('build calendarScreen!');
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildCalendar(),
        const SizedBox(height: 8.0),
        _buildButtons(),
        const SizedBox(height: 8.0),
        Expanded(
          child: EventList(
            selectedEvents: _selectedEvents,
            deleteEvent: _deleteEvent,
          ),
        ),
      ],
    );
  }

  // ************* build Calendar **************** //
  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR',
      calendarController: _calendarController,
      events: _filteredEvents,
      // holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },

      /// calendarStyle
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),

      ///  daysOfWeekStyle
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),

      /// headerStyle
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),

      /// Builder
      builders: CalendarBuilders(
        // selectedDay
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.amber[400],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        // today
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.red[300],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        // event & holiday marker
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onCalendarCreated: _onCalendarCreated,
      // onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  // EventMarker
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.blue[500]
            : _calendarController.isToday(date)
                ? Colors.blue[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  // *************  build buttons below calendar  *************** //
  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // fillter Button
        RaisedButton.icon(
          icon: Icon(Icons.filter),
          label: Text('필터'),
          onPressed: _tapSetFilter,
        ),
        // add new Event BUtton
        RaisedButton.icon(
          icon: Icon(Icons.add),
          label: Text('새로운 운동 추가하기'),
          onPressed: _tapAddEvent,
        ),
      ],
    );
  }
}
