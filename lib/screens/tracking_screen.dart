import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../widgets/exercise_list.dart';
import '../widgets/display_events.dart';
import '../widgets/chart.dart';

// ************************** tracking screen ************************* //
class TrackingScreen extends StatefulWidget {
  static const routeName = '/tracking_screen';

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String selectedId;
  Exercises exercises;
  int bodyIdx; // 기록으로보기: index =0 그래프로 보기: index=1

  // initState
  @override
  void initState() {
    bodyIdx = 0;
    exercises = Provider.of<Exercises>(context, listen: false);
    super.initState();
  }

  // ************ build tracking screen ************ //
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '성장기록을 확인하세요.',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            nameBox(themeData),
            buttonsRow(themeData),
            contentToShow,
          ],
        ),
      ),
    );
  }

  // ************ exercise name box ************ //
  Widget nameBox(ThemeData themeData) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: () async {
                final changedId = await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (bctx) => AlertDialog(
                    scrollable: true, //
                    title: const Text('운동선택'),
                    content:
                        ExerciseList(isForSelect: true, selectedId: selectedId),
                  ),
                );
                if (changedId == null) {
                  return;
                }
                if (changedId != selectedId) {
                  setState(() {
                    selectedId = changedId;
                  });
                }
              },
              child: selectedId == null
                  ? Text(
                      '< 운동 선택 >',
                      style: TextStyle(
                          color: themeData.primaryColor, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      '${exercises.getExercise(selectedId).name}',
                      style: TextStyle(
                          color: themeData.primaryColor, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    )),
        )
      ],
    );
  }

  // ************ tab buttons(기록 or 그래프) ************ //
  Widget buttonsRow(ThemeData themeData) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: bodyIdx == 0 ? themeData.accentColor : Colors.white),
            onPressed: () {
              setState(() {
                bodyIdx = 0;
              });
            },
            child: FittedBox(
              child: Text(
                '기록으로 보기(시간순)',
                style: TextStyle(
                    color: bodyIdx == 0 ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: bodyIdx == 1 ? themeData.accentColor : Colors.white),
            onPressed: () {
              setState(() {
                bodyIdx = 1;
              });
            },
            child: FittedBox(
              child: Text(
                '그래프로 보기',
                style: TextStyle(
                    color: bodyIdx == 1 ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ************ content to show(기록 or 그래프) ************ //
  Widget get contentToShow {
    if (selectedId == null) {
      return Expanded(
        child: const Center(
          child: const Text('운동을 선택하세요'),
        ),
      );
    } else if (bodyIdx == 0) {
      return Expanded(
        child: DisplayEvents(
          isTrackedEvents: true,
          exerciseId: selectedId,
        ),
      );
    } else {
      return Expanded(child: Chart(selectedId));
    }
  }
}
