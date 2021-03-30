import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/events.dart';
import '../providers/filters.dart';
import '../providers/calendar_state.dart';

// ************ calendar ************ //
class Calendar extends StatelessWidget {
  final CalendarController calendarController;

  Calendar(this.calendarController);

  @override
  Widget build(BuildContext context) {
    print('build Calendar!');
    final themeData = Theme.of(context);
    final events = Provider.of<Events>(context);
    final filter = Provider.of<Filters>(context);
    final currentState = Provider.of<CalendarState>(context);
    print(events.getItemsForCalendar(filter.items));
    return TableCalendar(
      locale: 'ko_KR',
      calendarController: calendarController,
      events: events.getItemsForCalendar(filter.items),
      initialSelectedDay: currentState.day,
      initialCalendarFormat: currentState.format,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
      },

      /// calendarStyle
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle().copyWith(
          color: const Color(4288585374),
        ),
        selectedColor: themeData.accentColor,
        todayColor: themeData.primaryColor.withOpacity(0.7),
        weekendStyle: TextStyle().copyWith(color: const Color(4288585374)),
      ),

      ///  daysOfWeekStyle
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: themeData.accentColor),
      ),

      /// headerStyle
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),

      /// Builder
      builders: CalendarBuilders(
        // selectedDay
        // selectedDayBuilder: (context, date, _) {
        //   // return FadeTransition(
        //   //   opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
        //   //   child:
        //   return Container(
        //     // decoration: BoxDecoration(border: Border.all(width: 1)),
        //     margin: const EdgeInsets.all(4.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     color: Colors.amber[400],
        //     width: 100,
        //     height: 100,
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0),
        //     ),
        //   );
        // },

        // today
        // todayDayBuilder: (context, date, _) {
        //   return Container(
        //     margin: const EdgeInsets.all(4.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         border: Border.all(width: 1, color: Colors.teal)),
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0),
        //     ),
        //   );
        // },

        // event & holiday marker
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              _buildEventsMarker(date, events),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, _, __) {
        currentState.setDay(date);
        // _animationController.forward(from: 0.0);
      },
    );
  }

  // ************ events marker ************ //
  Widget _buildEventsMarker(DateTime date, List events) {
    print('$events');
    print('${date.toString()}');
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.blue),
        shape: BoxShape.circle,
        color: calendarController.isSelected(date) ? Colors.blue : Colors.white,
      ),
      width: 16.0,
      height: 16.0,
      child: FittedBox(
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle().copyWith(
              color: calendarController.isSelected(date)
                  ? Colors.white
                  : Colors.black,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
