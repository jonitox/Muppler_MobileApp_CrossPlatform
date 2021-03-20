import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work_out_tracker/widgets/filters_dialog.dart';

import '../providers/calendar_state.dart';

import './pick_exercise_screen.dart';

import '../widgets/daily_title.dart';
import '../widgets/display_events.dart';
import '../widgets/calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

// ****************** Clendar Screen ***************** // TickerProvider?
class _CalendarScreenState extends State<CalendarScreen> {
  // with TickerProviderStateMixin {
  CalendarController _calendarController;
  Size deviceSize;
  // AnimationController _animationController;

  // // Example holidays
  // final Map<DateTime, List> _holidays = {
  //   DateTime(2021, 1, 1): ['New Year\'s Day'],
  // };

  void _switchCalendarFormat() {
    Provider.of<CalendarState>(context, listen: false).toggleFormat();
    _calendarController.toggleCalendarFormat();
  }

  // ************ tap filtering setting************ //
  void _setFilter() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (bctx) => FiltersDialog());
  }

  // initState
  @override
  void initState() {
    print('init Calendar Screen!');
    _calendarController = CalendarController();
    // _calendarController.setCalendarFormat(CalendarFormat.month);
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 400),
    // );
    // _animationController.forward();

    super.initState();
  }

  // dispose
  @override
  void dispose() {
    print('dispose Calendar Screen!');
    // _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // ************ calendar settings row ************ //
  Widget get calendarSettingsRow {
    final deviceSize = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: _setFilter,
          child: Column(
            children: [
              Icon(
                Icons.push_pin_outlined,
                color: Colors.black,
              ),
              Text('필터링'),
            ],
          ),
        ),
        Consumer<CalendarState>(
          builder: (ctx, currentState, _) => GestureDetector(
            onTap: _switchCalendarFormat,
            child: Column(
              children: [
                Icon(Icons.remove_red_eye_outlined),
                currentState.format == CalendarFormat.month
                    ? Text('한 주 보기')
                    : Text('한 달 보기'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ************ add event  button ************ //
  Widget get addEventButton {
    final deviceSize = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return OutlinedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.resolveWith<Size>(
            (_) => Size(deviceSize.width * 0.5, 40)),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (_) => BorderSide(color: themeData.accentColor, width: 0.8),
        ),
      ),
      child: Text(
        '운동 추가하기',
        style: TextStyle(
          fontSize: 18,
          color: themeData.accentColor,
        ),
      ),
      onPressed: () =>
          Navigator.of(context).pushNamed(PickExerciseScreen.routeName),
    );
  }

  // *************** build Calendar Screen ***************** //
  @override
  Widget build(BuildContext context) {
    print('build Calendar Screen!');
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Calendar(_calendarController),
          calendarSettingsRow,
          Divider(
            height: 20,
            thickness: 0.8,
            color: Theme.of(context).primaryColor,
          ),
          DailyTitle(),
          addEventButton,
          Container(
            padding: const EdgeInsets.all(10),
            child: DisplayEvents(isDailyEvents: true),
          ),
        ],
      ),
    );
  }
}
