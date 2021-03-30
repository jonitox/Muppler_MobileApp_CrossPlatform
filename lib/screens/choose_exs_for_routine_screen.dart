import 'package:flutter/material.dart';

import '../widgets/exercise_list.dart';

// ************************** choose exercises for making routine screen ************************* //
class ChooseExsForRoutineScreen extends StatelessWidget {
  static const routeName = '/choose_exs_for_routine_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '루틴의 운동을 선택하세요.',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ExerciseList(
          isForRoutine: true,
        ),
      ),
    );
  }
}
