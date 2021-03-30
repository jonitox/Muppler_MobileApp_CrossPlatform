import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tap_page_index.dart';
import '../providers/calendar_state.dart';
import '../widgets/display_events.dart';

// ************************** home(홈) screen ************************* //
class HomeScreen extends StatelessWidget {
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
            const Divider(
              height: 20,
              thickness: 0.8,
            ),
            guideBox(
              context,
              '운동을 계획하고 기록하세요.',
              '운동 기록',
              () {
                pageIdx.movePage(1);
              },
            ),
            const Divider(
              height: 20,
              thickness: 0.8,
            ),
            guideBox(
              context,
              '당신이 하고있는 운동을 관리하세요.',
              '라이브러리',
              () {
                pageIdx.movePage(2);
              },
            ),
            const Divider(
              height: 20,
              thickness: 0.8,
            ),
            guideBox(
              context,
              '다양한 기능들을 사용해보세요.',
              '기능',
              () {
                pageIdx.movePage(3);
              },
            ),
            // settingButton,
          ],
        ),
      ),
    );
  }

  // ************ today exercises column ************ //
  Widget todayEventsColumn(BuildContext ctx, TapPageIndex pageIdx) {
    final deviceSize = MediaQuery.of(ctx).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // today exercises title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5),
                width: deviceSize.width * 0.25,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: const Text(
                    '오늘의 운동',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                        const Text(
                          '변경하기',
                        ),
                        const Icon(Icons.keyboard_arrow_right_rounded)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // today exercises List
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: deviceSize.height * 0.2,
              maxHeight: deviceSize.height * 0.5,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 1,
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

  // ************ guide box ************ //
  Widget guideBox(
      BuildContext ctx, String guide, String buttonName, Function onTap) {
    final deviceSize = MediaQuery.of(ctx).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // title
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            guide,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            softWrap: true,
            maxLines: 3,
          ),
        ),
        // button (move to another screen)
        GestureDetector(
          onTap: onTap,
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
                  buttonName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ************ Setting Button ************ //
  Widget get settingButton {
    return IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {});
  }
}
