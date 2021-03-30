import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/satisfactions.dart';
import '../providers/events.dart';
import '../providers/calendar_state.dart';
import '../providers/filters.dart';

// ************ daily title of calendar screen ************ //
class DailyTitle extends StatelessWidget {
  // remove fractional parts of double
  String removeDecimalZeroFormat(double n) {
    return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // ************ build daily title  (month/day, events summary, satsifaction) ************ //
  @override
  Widget build(BuildContext context) {
    print('build dailyTitle!');
    final events = Provider.of<Events>(context);
    final today = Provider.of<CalendarState>(context).day;
    final filters = Provider.of<Filters>(context).items;
    final deviceWidth = MediaQuery.of(context).size.width;
    final satisfactions = Provider.of<Satisfactions>(context);
    final satisfactionVal = satisfactions.getSatisfaction(today);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // month/day, events summary
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('MM/dd').format(today).toString()}',
                style: const TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500),
                softWrap: true,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${events.getTodayEventsNum(today, filters)}개의 운동',
                    style: const TextStyle(
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
        ),
        // satisfaction
        Container(
          width: deviceWidth * 0.52,
          height: deviceWidth * 0.12,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: deviceWidth * 0.1,
                  child: const FittedBox(child: const Text('만족도 '))),
              GestureDetector(
                onTap: () {
                  satisfactions.changeSatisFaction(today, 1);
                },
                child: Container(
                  width: satisfactionVal == 1
                      ? deviceWidth * 0.1
                      : deviceWidth * 0.07,
                  child: Image.asset(
                    'assets/images/highlyUnsatisfied.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  satisfactions.changeSatisFaction(today, 2);
                },
                child: Container(
                  width: satisfactionVal == 2
                      ? deviceWidth * 0.1
                      : deviceWidth * 0.07,
                  child: Image.asset(
                    'assets/images/unsatisfied.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  satisfactions.changeSatisFaction(today, 3);
                },
                child: Container(
                  width: satisfactionVal == 3
                      ? deviceWidth * 0.1
                      : deviceWidth * 0.07,
                  child: Image.asset(
                    'assets/images/moderate.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  satisfactions.changeSatisFaction(today, 4);
                },
                child: Container(
                  width: satisfactionVal == 4
                      ? deviceWidth * 0.1
                      : deviceWidth * 0.07,
                  child: Image.asset(
                    'assets/images/satisfied.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  satisfactions.changeSatisFaction(today, 5);
                },
                child: Container(
                  width: satisfactionVal == 5
                      ? deviceWidth * 0.1
                      : deviceWidth * 0.07,
                  child: Image.asset(
                    'assets/images/highlySatisfied.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
