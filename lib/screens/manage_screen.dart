import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/routine_list.dart';
import '../widgets/exercise_list.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  var curIdx = 0;

  // ************ tab buttons ************ //
  Widget exerciseOrRoutineTab(int i) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (_) => BorderSide(
                  color: curIdx == i ? Colors.deepOrange : Colors.white,
                  width: 1),
            ),
          ),
          child: Text(
            i == 0 ? '운동' : '루틴',
            style: TextStyle(
                // fontSize: curIdx == i ? 15 : 14,
                fontWeight: curIdx == i ? FontWeight.bold : FontWeight.normal,
                color: curIdx == i ? Colors.deepOrange : Colors.black),
          ),
          onPressed: () {
            setState(() {
              curIdx = i;
            });
          },
        ),
      ),
    );
  }

  // ************ build manage screen ************ //
  @override
  Widget build(BuildContext context) {
    print('build ManageScreen!');
    return Column(
      children: [
        Row(
          children: [
            exerciseOrRoutineTab(0),
            exerciseOrRoutineTab(1),
          ],
        ),
        if (curIdx == 0)
          Expanded(
              child: ExerciseList(
            isForManage: true,
          )),
        if (curIdx == 1) Expanded(child: RoutineList()),
      ],
    );
  }
}
