import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/calendar_state.dart';
import './pick_exercise_screen.dart';
import '../widgets/filters_dialog.dart';
import '../widgets/daily_title.dart';
import '../widgets/display_events.dart';
import '../widgets/calendar.dart';

// ************************** Clendar(운동 기록) Screen ************************* //
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Size deviceSize;
  // AnimationController _animationController;

  // initState //
  @override
  void initState() {
    // print('init Calendar Screen!');
    _calendarController = CalendarController();
    super.initState();
  }

  // dispose //
  @override
  void dispose() {
    // print('dispose Calendar Screen!');
    _calendarController.dispose();
    super.dispose();
  }

  // *************** build Calendar Screen ***************** //
  @override
  Widget build(BuildContext context) {
    // print('build Calendar Screen!');
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Calendar(_calendarController),
          calendarSettingsRow,
          Divider(
            height: 20,
            thickness: 1,
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

  // ************ tap filtering setting ************ //
  void _switchCalendarFormat() {
    Provider.of<CalendarState>(context, listen: false).toggleFormat();
    _calendarController.toggleCalendarFormat();
  }

  // ************ tap filtering setting ************ //
  void _setFilter() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (bctx) => FiltersDialog());
  }

  // ************ calendar settings row ************ //
  Widget get calendarSettingsRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: _setFilter,
          child: Column(
            children: [
              const Icon(
                Icons.push_pin_outlined,
                color: Colors.black,
              ),
              const Text('필터링'),
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
                    ? const Text('한 주 보기')
                    : const Text('한 달 보기'),
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
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (_) => themeData.accentColor,
        ),
        minimumSize: MaterialStateProperty.resolveWith<Size>(
            (_) => Size(deviceSize.width * 0.5, 40)),
      ),
      child: const Text(
        '운동 추가하기',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      onPressed: () =>
          Navigator.of(context).pushNamed(PickExerciseScreen.routeName),
    );
  }
}
