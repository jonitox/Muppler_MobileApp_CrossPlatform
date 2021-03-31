import 'package:flutter/material.dart';

import '../widgets/routine_list.dart';
import '../widgets/exercise_list.dart';

// ************************** pick exercises screen ************************* //
class PickExerciseScreen extends StatelessWidget {
  static const routeName = '/pick_screen';

  @override
  Widget build(BuildContext context) {
    // print('build ChooseExScreen!');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '운동을 선택하세요.',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[500],
            tabs: [
              const Tab(
                child: const Text(
                  '운동',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Tab(
                child: const Text(
                  '루틴',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ExerciseList(
                isForInsert: true,
              ),
              RoutineList(
                isForinsert: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
