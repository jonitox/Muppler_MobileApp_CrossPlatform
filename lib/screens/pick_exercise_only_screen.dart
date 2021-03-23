import 'package:flutter/material.dart';

import '../widgets/exercise_list.dart';

class PickExerciseOnlyScreen extends StatelessWidget {
  static const routeName = '/pick_exercise_only_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('루틴에 포함할 운동을 선택하세요.'),
      ),
      body: SafeArea(
        child: ExerciseList(
          isForRoutine: true,
        ),
      ),
    );
  }
}
