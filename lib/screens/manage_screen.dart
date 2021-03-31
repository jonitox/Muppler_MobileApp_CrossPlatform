import 'package:flutter/material.dart';

import '../widgets/routine_list.dart';
import '../widgets/exercise_list.dart';

// ************************** Manage(라이브러리) screen ************************* //
class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  var curIdx = 0; // 운동: index=0 루틴: index=1

  // ************ build manage screen ************ //
  @override
  Widget build(BuildContext context) {
    // print('build ManageScreen!');
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

  // ************ tab buttons (운동 or 루틴) ************ //
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
                fontSize: curIdx == i ? 15 : 14,
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
}
