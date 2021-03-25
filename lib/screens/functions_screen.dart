import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/providers/tap_page_index.dart';
import 'package:work_out_tracker/screens/timer_screen.dart';

import '../providers/exercises.dart';
import './tracking_screen.dart';
import '../models/exercise.dart';
import '../models/event.dart';
import '../widgets/display_events.dart';

class FuncionsScreen extends StatelessWidget {
  // ************ service box ************ //
  Widget serviceBox(
      {ThemeData themeData,
      String guidline,
      String buttonInfo,
      IconData buttonIcon,
      Function onPressed}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // title
          Text(
            guidline,
            softWrap: true,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),

          // button
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: themeData.accentColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    buttonInfo,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: themeData.accentColor,
                    ),
                  ),
                  Icon(
                    buttonIcon,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        serviceBox(
          themeData: themeData,
          guidline: '운동별 성장을 한 눈에 확인하세요.',
          buttonInfo: '종목별 기록',
          buttonIcon: Icons.trending_up,
          onPressed: () {
            Navigator.of(context).pushNamed(TrackingScreen.routeName);
          },
        ),
        Divider(
          height: 20,
          thickness: 0.8,
          color: Theme.of(context).primaryColor, // theme
        ),
        serviceBox(
          themeData: themeData,
          guidline: '운동 시 스탑워치를 사용해보세요.',
          buttonInfo: '스탑워치',
          buttonIcon: Icons.timer,
          onPressed: () {
            Navigator.of(context).pushNamed(TimerScreen.routeName);
          },
        ),
      ],
    );
  }
}
