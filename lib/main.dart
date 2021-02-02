import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import './screens/manage_screen.dart';

import './screens/tab_screen.dart';
import './screens/add_event_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkOut_Tracker',
      // define theme
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // routes
      routes: {
        '/': (ctx) => TabScreen(),
        // AddEventScreen.routeName: (ctx) => AddEventScreen(),
        // ManageScreen.routeName: (ctx) => ManageScreen(),
      },
    );
  }
}
