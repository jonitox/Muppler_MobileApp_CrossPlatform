import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/providers/tap_page_index.dart';
import 'package:work_out_tracker/screens/timer_screen.dart';

import '../providers/exercises.dart';
import './tracking_screen.dart';
import '../models/exercise.dart';
import '../models/event.dart';
import '../widgets/display_events.dart';

class FuncionsScreen extends StatelessWidget {
  // final List<Widget> _pages = [
  //   Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       trackingBox(context),
  //       Divider(),
  //       timerBox(context),
  //     ],
  //   ),
  //   TrackingScreen(),
  //   TimerScreen(),
  // ];

  Widget trackingBox(BuildContext ctx) {
    return Column(
      children: [
        Text('운동별 성장을 한 눈에 확인해보세요.'),
        TextButton.icon(
          label: Text('운동별 기록'),
          icon: Icon(Icons.hourglass_bottom),
          onPressed: () {
            Navigator.of(ctx).pushNamed(TrackingScreen.routeName);
          },
        ),
      ],
    );
  }

  Widget timerBox(BuildContext ctx) {
    return Column(
      children: [
        Text('운동 시 휴식시간을 확인하세요.'),
        TextButton.icon(
          label: Text('스탑워치'),
          icon: Icon(Icons.timer),
          onPressed: () {
            Navigator.of(ctx).pushNamed(TimerScreen.routeName);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        trackingBox(context),
        Divider(
          height: 20,
          thickness: 0.8,
          color: Theme.of(context).primaryColor, // theme
        ),
        timerBox(context),
      ],
    );
  }
}
