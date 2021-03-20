import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stopwatch_state.dart';

class TimerScreen extends StatelessWidget {
  static const routeName = 'timer_screen';

  Widget timeBox(StopWatchState stopwatch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${stopwatch.getTime}')
        // Text('${stopwatch.seconds ~/ 6000}'.padLeft(2, '0') +
        //     ':' +
        //     '${(stopwatch.seconds ~/ 100) % 60}'.padLeft(2, '0') +
        //     ':' +
        //     '${stopwatch.seconds % 100}'.padLeft(2, '0')),
      ],
    );
  }

  Widget lapTimeRows(StopWatchState stopwatch) {
    return Expanded(
      child: ListView.builder(
        itemCount: stopwatch.laptimes.length,
        itemBuilder: (ctx, i) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("랩${stopwatch.laptimes.length - i}"),
            Text(stopwatch.laptimes[i]),
          ],
        ),
      ),
    );
  }

  Widget timerBody(ctx) {
    final stopwatch = Provider.of<StopWatchState>(ctx);
    return Column(
      children: [
        timeBox(stopwatch),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
                backgroundColor: stopwatch.isOn ? Colors.blue : Colors.grey,
                heroTag: 'btn1',
                onPressed: stopwatch.isOn
                    ? () {
                        if (stopwatch.isRunning) {
                          stopwatch.addLap();
                        } else {
                          stopwatch.reset();
                        }
                      }
                    : null,
                child: Text(stopwatch.isRunning ? '랩타임' : '초기화')),
            FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {
                  if (stopwatch.isRunning) {
                    stopwatch.pause();
                  } else {
                    stopwatch.start();
                  }
                },
                child: Text(stopwatch.isRunning ? '중단' : '시작')),
          ],
        ),
        lapTimeRows(stopwatch),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return timerBody(context);
  }
}
