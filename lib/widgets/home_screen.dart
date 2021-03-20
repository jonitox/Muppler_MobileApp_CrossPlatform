import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/providers/tap_page_index.dart';

import '../models/event.dart';
import '../widgets/display_events.dart';
import '../providers/calendar_state.dart';

class HomeScreen extends StatelessWidget {
  // ************ today exercises column ************ //
  Widget todayEventsColumn(BuildContext ctx, TapPageIndex pageIdx) {
    final deviceSize = MediaQuery.of(ctx).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* today exercises title *//
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5),
                width: deviceSize.width * 0.25,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '오늘의 운동',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: deviceSize.width * 0.2,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '${DateFormat('MM/d(E)', 'ko').format(DateTime.now())}',
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: deviceSize.width * 0.17,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<CalendarState>(ctx, listen: false)
                          .setDay(DateTime.now());
                      pageIdx.movePage(1);
                    },
                    child: Row(
                      children: [
                        Text(
                          '변경하기',
                        ),
                        Icon(Icons.keyboard_arrow_right_rounded)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          //* today exercises List *//
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: deviceSize.height * 0.25,
              maxHeight: deviceSize.height * 0.5,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    // color: Theme.of(ctx).accentColor,
                    // spreadRadius: 1,
                    blurRadius: 1,
                    // offset: Offset(3, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: DisplayEvents(
                isTodayEvents: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ************ Library box ************ //
  Widget libraryBox(BuildContext ctx, TapPageIndex pageIdx) {
    final deviceSize = MediaQuery.of(ctx).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // title
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: deviceSize.width * 2 / 3,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '당신이 하고있는 운동을 관리하세요.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // button
        GestureDetector(
          onTap: () {
            pageIdx.movePage(2);
          },
          child: Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 25,
            ),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(ctx).accentColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Theme.of(ctx).accentColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '운동 라이브러리',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_right_rounded)
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ************ Setting Button ************ //
  Widget get settingButton {
    return IconButton(icon: Icon(Icons.settings), onPressed: () {});
  }

  // ************  build home screen ************ //
  @override
  Widget build(BuildContext context) {
    final pageIdx = Provider.of<TapPageIndex>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            todayEventsColumn(context, pageIdx),
            Divider(
              height: 20,
              thickness: 0.8,
              color: Theme.of(context).primaryColor, // theme
            ),
            libraryBox(context, pageIdx),
            Divider(
              height: 20,
              thickness: 0.8,
              color: Theme.of(context).primaryColor,
            ),
            settingButton,
          ],
        ),
      ),
    );
  }
}
