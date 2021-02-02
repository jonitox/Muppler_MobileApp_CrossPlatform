import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../widgets/event_list.dart';

class HomeScreen extends StatelessWidget {
  final Function _routeManageScreen;
  final List<Event> _events;
  HomeScreen(this._routeManageScreen, this._events);

  Widget _buildEventTile(BuildContext ctx, Event event) {
    return Card(
      elevation: 4,
      color: Colors.red[50],
      child: Container(
        // height: 20,
        // width: 100,
        decoration: BoxDecoration(
          // color: Colors.blue,
          border: Border(),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(event.exercise),
                Icon(Icons.edit),
                Icon(Icons.delete),
              ],
            ),
            ...(event.sets)
                .asMap()
                .entries
                .map(
                  (entry) => Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${entry.key + 1} 세트'),
                      Text('${entry.value.weight} Kg'),
                      Text('${entry.value.rep} 회'),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayEvents(BuildContext ctx, List _todayEvents) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 200,
      child: EventList(
        selectedEvents: _todayEvents,
        isDeleteVisible: false,
      ),
      // ListView(
      //   children:
      //       _todayEvents.map((event) => _buildEventTile(ctx, event)).toList(),
      //   scrollDirection: Axis.horizontal,
      // ),
    );
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  void _tapTodayEvents() {
    //
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final _todayEvents =
        _events.where((test) => _isSameDay(test.date, today)).toList();

    return Column(
      children: [
        Text('${DateFormat.Md().format(DateTime.now())}'),
        Row(
          children: [
            Text('오늘의 운동'),
            RaisedButton(
              onPressed: (null),
              child: Text('오늘의 계획 관리하러가기'),
            ),
          ],
        ),
        _todayEvents.length > 0
            ? _buildTodayEvents(context, _todayEvents)
            : Text('계획한 운동이 없습니다.'),
        SizedBox(height: 30),
        Text('어떤 운동을 하고 계신가요?',
            style: TextStyle(
              fontSize: 30,
            )),
        RaisedButton(
          onPressed: () {
            _routeManageScreen();
          },
          child: Text(
            '내가 하는 운동 관리!',
          ),
          color: Colors.blue,
        ),
        SizedBox(height: 50),
        RaisedButton.icon(
          icon: Icon(Icons.settings),
          label: Text('설정'),
          onPressed: null,
        ),
      ],
    );
  }
}
