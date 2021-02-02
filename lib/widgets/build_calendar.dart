// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class Calendar extends StatefulWidget {
//   CalendarController _calendarController;
//   AnimationController _animationController;
//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   // onDaySelected
//   void _onDaySelected(DateTime day, List events, List holidays) {
//     setState(() {
//       _selectedEvents = events;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       locale: 'ko_KR',
//       calendarController: _calendarController,
//       events: widget._events,
//       holidays: _holidays,
//       initialCalendarFormat: CalendarFormat.month,
//       formatAnimation: FormatAnimation.slide,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       availableGestures: AvailableGestures.all,
//       availableCalendarFormats: const {
//         CalendarFormat.month: '',
//         CalendarFormat.week: '',
//       },

//       /// calendarStyle
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: true,
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//         holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//       ),

//       ///  daysOfWeekStyle
//       daysOfWeekStyle: DaysOfWeekStyle(
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//       ),

//       /// headerStyle
//       headerStyle: HeaderStyle(
//         centerHeaderTitle: true,
//         formatButtonVisible: false,
//       ),

//       /// Builder
//       builders: CalendarBuilders(
//         // selectedDay
//         selectedDayBuilder: (context, date, _) {
//           return FadeTransition(
//             opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               // decoration: BoxDecoration(border: Border.all(width: 1)),
//               margin: const EdgeInsets.all(4.0),
//               padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//               color: Colors.amber[400],
//               width: 100,
//               height: 100,
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle().copyWith(fontSize: 16.0),
//               ),
//             ),
//           );
//         },
//         // today
//         todayDayBuilder: (context, date, _) {
//           return Container(
//             margin: const EdgeInsets.all(4.0),
//             padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//             color: Colors.red[300],
//             width: 100,
//             height: 100,
//             child: Text(
//               '${date.day}',
//               style: TextStyle().copyWith(fontSize: 16.0),
//             ),
//           );
//         },
//         // event & holiday marker
//         markersBuilder: (context, date, events, holidays) {
//           final children = <Widget>[];

//           if (events.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: 1,
//                 bottom: 1,
//                 child: _buildEventsMarker(date, events),
//               ),
//             );
//           }

//           if (holidays.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: -2,
//                 top: -2,
//                 child: _buildHolidaysMarker(),
//               ),
//             );
//           }

//           return children;
//         },
//       ),
//       onDaySelected: (date, events, holidays) {
//         _onDaySelected(date, events, holidays);
//         _animationController.forward(from: 0.0);
//       },
//       // onVisibleDaysChanged: _onVisibleDaysChanged,
//       // onCalendarCreated: _onCalendarCreated,
//     );
//   }

//   // EventMarker
//   Widget _buildEventsMarker(DateTime date, List events) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _calendarController.isSelected(date)
//             ? Colors.blue[500]
//             : _calendarController.isToday(date)
//                 ? Colors.blue[300]
//                 : Colors.blue[400],
//       ),
//       width: 16.0,
//       height: 16.0,
//       child: Center(
//         child: Text(
//           '${events.length}',
//           style: TextStyle().copyWith(
//             color: Colors.white,
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHolidaysMarker() {
//     return Icon(
//       Icons.add_box,
//       size: 20.0,
//       color: Colors.blueGrey[800],
//     );
//   }
// }
