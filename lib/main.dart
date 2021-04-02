import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import './providers/tap_page_index.dart';
import './providers/filters.dart';
import './providers/events.dart';
import './providers/exercises.dart';
import './providers/calendar_state.dart';
import './providers/routines.dart';
import './providers/stopwatch_state.dart';
import './providers/lap_times.dart';
import './providers/satisfactions.dart';
import './screens/timer_screen.dart';
import './screens/tracking_screen.dart';
import './screens/choose_exs_for_routine_screen.dart';
import './screens/edit_event_screen.dart';
import './screens/tab_screen.dart';
import './screens/pick_exercise_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Events(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Exercises(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Filters(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CalendarState(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Satisfactions(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Routines(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TapPageIndex(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => StopWatchState(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LapTimes(),
        ),
      ],
      builder: (ctx, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'muppler',
        //* Theme *//
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.teal,
          ),
          primaryColor: Colors.teal[300],
          accentColor: Colors.deepOrange[300],
          // AppBar theme
          appBarTheme: AppBarTheme(
            color: Colors.teal[200],
            titleTextStyle: TextStyle(color: Colors.white),
            elevation: 5,
            shadowColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline3: TextStyle(color: Colors.black),
              ),
        ),
        //* routes table *//
        routes: {
          '/': (ctx) => TabScreen(),
          PickExerciseScreen.routeName: (ctx) => PickExerciseScreen(),
          ChooseExsForRoutineScreen.routeName: (ctx) =>
              ChooseExsForRoutineScreen(),
          EditEventScreen.routeName: (ctx) => EditEventScreen(),
          TrackingScreen.routeName: (ctx) => TrackingScreen(),
          TimerScreen.routeName: (ctx) => TimerScreen(),
        },
      ),
    );
  }
}
