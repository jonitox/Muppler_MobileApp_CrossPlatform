import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/calendar_state.dart';
import '../providers/filters.dart';

class DailyTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build dailyTitle!');
    final events = Provider.of<Events>(context);
    final today = Provider.of<CalendarState>(context).day;
    final filters = Provider.of<Filters>(context).items;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat('MM/dd').format(today).toString()}',
            style: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${events.getTodayEventsNum(today, filters)}개의 운동',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Volume ${events.getTodayEventsVolume(today, filters)}kg',
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
