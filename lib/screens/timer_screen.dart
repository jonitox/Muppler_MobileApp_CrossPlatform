import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stopwatch_state.dart';
import '../providers/lap_times.dart';

// ************************** timer screen ************************* //
class TimerScreen extends StatelessWidget {
  static const routeName = 'timer_screen';
  // ************ build timer screen ************ //
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '스탑워치',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<StopWatchState>(
        builder: (ctx, stopwatch, ch) => stopwatch.isOnOverlay
            ? Center(
                child: const Text(
                  '이제 타이머를 다른 화면에서 사용할수 있습니다!',
                  style: const TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              )
            : Column(
                children: [
                  if (!stopwatch.isOnOverlay)
                    defaultTimerBox(context, stopwatch, deviceWidth, themeData),
                  ch,
                ],
              ),
        child: lapTimeRows(deviceWidth),
      ),
    );
  }

  // ************ on add overlay  ************ //
  static void swtichToOverlay(BuildContext ctx) {
    final deviceSize = MediaQuery.of(ctx).size;
    final themeData = Theme.of(ctx);
    final laptimes = Provider.of<LapTimes>(ctx, listen: false);
    OverlayEntry timerColumnForOverlay;
    timerColumnForOverlay = OverlayEntry(
      builder: (bctx) => Positioned(
        bottom: deviceSize.height * 0.15,
        right: 5,
        child: Consumer<StopWatchState>(
          builder: (bctx, stopwatch, _) {
            // widget(entry) to overlayed
            return Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  timeBox(deviceSize.width, stopwatch, themeData),
                  startAndPauseButton(stopwatch),
                  const SizedBox(
                    height: 3,
                  ),
                  resetAndShutOverlayButton(
                      laptimes, stopwatch, timerColumnForOverlay),
                ],
              ),
            );
          },
        ),
      ),
    );
    Overlay.of(ctx).insert(timerColumnForOverlay);
  }

// ************ time Box  ************ //
  static Widget timeBox(
      double deviceWidth, StopWatchState stopwatch, ThemeData themeData) {
    final timeSegs = stopwatch.getTime;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: stopwatch.isOnOverlay ? 5 : 50,
          horizontal: stopwatch.isOnOverlay ? 2 : 0),
      width: stopwatch.isOnOverlay ? deviceWidth * 0.15 : deviceWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Center(
              child: Text(
                timeSegs['min'],
                style: themeData.textTheme.headline3
                    .copyWith(fontSize: stopwatch.isOnOverlay ? 18 : 50),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Center(
              child: Text(
                ':',
                style: themeData.textTheme.headline3
                    .copyWith(fontSize: stopwatch.isOnOverlay ? 18 : 50),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Center(
              child: Text(
                timeSegs['sec'],
                style: themeData.textTheme.headline3
                    .copyWith(fontSize: stopwatch.isOnOverlay ? 18 : 50),
              ),
            ),
          ),
          if (!stopwatch.isOnOverlay)
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Center(
                child: Text(
                  '.',
                  style: themeData.textTheme.headline3.copyWith(fontSize: 50),
                ),
              ),
            ),
          if (!stopwatch.isOnOverlay)
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Center(
                child: Text(
                  timeSegs['msec'],
                  style: themeData.textTheme.headline3.copyWith(fontSize: 50),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ************  reset/addLap button ************ //
  Widget resetAndRecordButton(StopWatchState stopwatch, LapTimes laptimes) {
    return FloatingActionButton(
      backgroundColor: stopwatch.isOn
          ? (stopwatch.isRunning ? Colors.lime[900] : Colors.red[400])
          : Colors.grey,
      heroTag: 'btn1',
      onPressed: stopwatch.isOn
          ? () {
              if (stopwatch.isRunning) {
                laptimes.addLap(stopwatch.getTime);
              } else {
                laptimes.clearLaps();
                stopwatch.reset();
              }
            }
          : null,
      child: Text(stopwatch.isRunning ? '랩타임' : '초기화'),
    );
  }

  // ************  reset/shutdownOverlay button ************ //
  static Widget resetAndShutOverlayButton(
      LapTimes lapTimes, StopWatchState stopwatch, OverlayEntry entry) {
    return FloatingActionButton(
        backgroundColor: stopwatch.isRunning
            ? Colors.grey
            : (stopwatch.isOn ? Colors.red[300] : Colors.teal),
        heroTag: 'btn3',
        onPressed: stopwatch.isRunning
            ? null
            : () {
                if (stopwatch.isOn) {
                  lapTimes.clearLaps();
                  stopwatch.reset();
                } else {
                  stopwatch.switchOverlay();
                  entry.remove();
                }
              },
        child: FittedBox(child: Text(stopwatch.isOn ? '초기화' : '종료')));
  }

  // ************ start/pause button ************ //
  static Widget startAndPauseButton(StopWatchState stopwatch) {
    return FloatingActionButton(
        backgroundColor: stopwatch.isRunning ? Colors.orange : Colors.blue[400],
        heroTag: 'btn2',
        onPressed: () {
          if (stopwatch.isRunning) {
            stopwatch.pause();
          } else {
            stopwatch.start();
          }
        },
        child: Text(stopwatch.isRunning ? '중단' : '시작'));
  }

  // ************  separate to overlay button ************ //
  Widget separateToOverlayButton(BuildContext ctx, StopWatchState stopwatch) {
    return FloatingActionButton(
      heroTag: 'btn0',
      backgroundColor: Colors.teal,
      onPressed: () {
        stopwatch.switchOverlay();
        swtichToOverlay(ctx);
      },
      child: Text('분리'),
    );
  }

  // ************  default stop watch box, that is not on overlay ************ //
  Widget defaultTimerBox(BuildContext ctx, StopWatchState stopwatch,
      double deviceWidth, ThemeData themeData) {
    final laptimes = Provider.of<LapTimes>(ctx, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        timeBox(deviceWidth, stopwatch, themeData),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            resetAndRecordButton(stopwatch, laptimes),
            startAndPauseButton(stopwatch),
            separateToOverlayButton(ctx, stopwatch),
          ],
        ),
        const Divider(
          height: 80,
          thickness: 2,
        ),
      ],
    );
  }

  // ************  lap times records ************ //
  Widget lapTimeRows(double deviceWidth) {
    return Consumer<LapTimes>(
      builder: (ctx, laptimes, _) {
        final itemCnt = laptimes.length();
        final items = laptimes.items;
        return Expanded(
          child: ListView.separated(
            itemCount: itemCnt,
            separatorBuilder: (ctx, i) => const Divider(),
            itemBuilder: (ctx, i) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              key: ValueKey('랩#$i'),
              children: [
                Container(
                  width: deviceWidth * 0.3,
                  child: Text(
                    '랩${itemCnt - i}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  width: deviceWidth * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Center(
                          child: Text(
                            items[i]['min'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Center(
                          child: Text(
                            ':',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Center(
                          child: Text(
                            items[i]['sec'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Center(
                          child: Text(
                            '.',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Center(
                          child: Text(
                            items[i]['msec'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
