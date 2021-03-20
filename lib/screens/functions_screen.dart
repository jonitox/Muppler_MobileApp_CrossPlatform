import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/providers/tap_page_index.dart';
import 'package:work_out_tracker/screens/timer_screen.dart';

import '../providers/selectedExercise.dart';
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

  Widget trackingBox(TapPageIndex pageState) {
    return Column(
      children: [
        Text('운동별 성장을 한 눈에 확인해보세요.'),
        TextButton.icon(
          label: Text('운동별 기록'),
          icon: Icon(Icons.hourglass_bottom),
          onPressed: () {
            pageState.moveFuncPage(1);
          },
        ),
      ],
    );
  }

  Widget timerBox(TapPageIndex pageState) {
    return Column(
      children: [
        Text('운동 시 휴식시간을 확인하세요.'),
        TextButton.icon(
          label: Text('스탑워치'),
          icon: Icon(Icons.timer),
          onPressed: () {
            pageState.moveFuncPage(2);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = Provider.of<TapPageIndex>(context);
    if (pageState.funcPageIdx == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          trackingBox(pageState),
          Divider(),
          timerBox(pageState),
        ],
      );
    } else if (pageState.funcPageIdx == 1) {
      return TrackingScreen();
    } else {
      return TimerScreen();
    }
  }
}
