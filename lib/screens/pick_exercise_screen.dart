import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/routine_list.dart';
import '../widgets/exercise_list.dart';
import '../providers/exercises.dart';

class PickExerciseScreen extends StatelessWidget {
  static const routeName = '/pick_screen';

  @override
  Widget build(BuildContext context) {
    print('build ChooseExScreen!');
    // 혹은 custom tab(버튼 등)으로 변경
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '운동을 선택하세요.',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[500],
            // indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  '운동',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
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
