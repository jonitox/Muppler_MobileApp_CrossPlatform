import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../widgets/exercise_list.dart';
import '../widgets/display_events.dart';
import '../widgets/chart.dart';

class TrackingScreen extends StatefulWidget {
  static const routeName = '/tracking_screen';

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String selectedId;
  Exercises exercises;
  int bodyIdx;

  @override
  void initState() {
    bodyIdx = 0;
    exercises = Provider.of<Exercises>(context, listen: false);
    super.initState();
  }

  Widget get nameBox {
    return Row(
      children: [
        TextButton(
            onPressed: () async {
              final changedId = await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (bctx) => AlertDialog(
                  scrollable: true, //
                  title: Text('운동선택'),
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
                ? Text('<운동 선택>')
                : Text(
                    '운동: ${exercises.getExercise(selectedId).name}',
                    overflow: TextOverflow.ellipsis,
                  ))
      ],
    );
  }

  Widget get buttonsRow {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    bodyIdx = 0;
                  });
                },
                child: Text('기록으로 보기'))),
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    bodyIdx = 1;
                  });
                },
                child: Text('그래프로 보기'))),
      ],
    );
  }

  Widget get contentToShow {
    if (bodyIdx == 0) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '성장기록을 확인하세요.',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            nameBox,
            buttonsRow,
            contentToShow,
          ],
        ),
      ),
    );
  }
}
