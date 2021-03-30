import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/exercises.dart';
import '../providers/routines.dart';
import '../providers/filters.dart';
import '../providers/satisfactions.dart';
import '../providers/tap_page_index.dart';

import './manage_screen.dart';
import './calendar_screen.dart';
import './functions_screen.dart';
import './home_screen.dart';

// ************************** tab(app's default) screen ************************* //
class TabScreen extends StatelessWidget {
  final List<Map<String, Object>> _pages = [
    {'title': 'MUPPLER', 'page': HomeScreen()},
    {'title': '운동 기록', 'page': CalendarScreen()},
    {'title': '운동 / 루틴 라이브러리', 'page': ManageScreen()},
    {'title': '성장 기록 / 스탑워치', 'page': FuncionsScreen()},
  ];
  // fetch and set datas when app starts
  Future<void> fetchAndSetDatas(BuildContext ctx) async {
    await Provider.of<Events>(ctx, listen: false).fetchAndSetEvents();
    await Provider.of<Routines>(ctx, listen: false).fetchAndSetRotuines();
    final ids =
        await Provider.of<Exercises>(ctx, listen: false).fetchAndSetExercises();
    Provider.of<Filters>(ctx, listen: false).addFilters(ids);
    await Provider.of<Satisfactions>(ctx, listen: false)
        .fetchAndSetSatisfactions();
  }

  // ************ build tab screen ************ //
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    print('build tapScreen!');
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TapPageIndex>(
          builder: (ctx, pageIdx, _) => Center(
            child: Text(
              _pages[pageIdx.curIdx]['title'],
              style: themeData.appBarTheme.titleTextStyle.copyWith(
                  fontSize: pageIdx.curIdx == 0 ? 34 : 24,
                  color: pageIdx.curIdx == 0
                      ? Colors.deepOrange[600]
                      : Colors.white,
                  fontWeight:
                      pageIdx.curIdx == 0 ? FontWeight.w900 : FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: themeData.primaryColor,
            height: 2,
          ),
          preferredSize: const Size.fromHeight(2),
        ),
      ),

      // show progressIndicator before get all datas
      body: FutureBuilder(
        future: fetchAndSetDatas(context),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<TapPageIndex>(
                  builder: (ctx, pageIdx, _) => _pages[pageIdx.curIdx]['page'],
                );
        },
      ),
      bottomNavigationBar: Consumer<TapPageIndex>(
        builder: (ctx, pageIdx, _) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: '홈',
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              label: '운동 기록',
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center_outlined),
              label: '라이브러리',
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.architecture_outlined),
              label: '기능',
            ),
          ],
          currentIndex: pageIdx.curIdx,
          onTap: (idx) {
            pageIdx.movePage(idx);
          },
        ),
      ),
    );
  }
}
