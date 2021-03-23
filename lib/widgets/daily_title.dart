import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/calendar_state.dart';
import '../providers/filters.dart';

class DailyTitle extends StatelessWidget {
  // remove fractional parts of double
  String removeDecimalZeroFormat(double n) {
    return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // ************ build daily title line (month/day, num of exercises, total volume of day) ************ //
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
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Volume ${removeDecimalZeroFormat(events.getTodayEventsVolume(today, filters))}kg',
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
