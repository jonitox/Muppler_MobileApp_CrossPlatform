import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/exercises.dart';
import '../widgets/exercise_list.dart';
import '../widgets/display_events.dart';

class TrackingScreen extends StatefulWidget {
  static const routeName = '/tracking_screen';

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String selectedId;
  Exercises exercises;

  @override
  void initState() {
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
                ? Text('운동 선택')
                : Text('${exercises.getExercise(selectedId).name}'))
      ],
    );
  }

  Widget get functionRow {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(onPressed: () {}, child: Text('기록으로 보기'))),
        Expanded(
            child: ElevatedButton(onPressed: () {}, child: Text('그래프로 보기'))),
      ],
    );
  }

  Widget get eventsColumn {
    return Expanded(
      child: DisplayEvents(
        isTrackedEvents: true,
        exerciseId: selectedId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        nameBox,
        functionRow,
        eventsColumn,
      ],
    );
  }
}
