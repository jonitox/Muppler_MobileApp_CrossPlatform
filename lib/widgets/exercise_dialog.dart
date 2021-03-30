import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../providers/filters.dart';
import '../providers/events.dart';
import '../providers/routines.dart';

import '../models/exercise.dart';

// ************ exercise dialog ************ //
class ExerciseDialog extends StatefulWidget {
  final String id;
  final bool isInsert;
  final String targetName;
  ExerciseDialog(this.isInsert, this.targetName, {this.id});

  @override
  _ExerciseDialogState createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  String selectedTargetName;
  Exercises exercises;
  Exercise exercise;
  Filters filters;
  // init state
  @override
  void initState() {
    selectedTargetName =
        widget.targetName == '전체' ? Target.chest : widget.targetName;
    exercises = Provider.of<Exercises>(context, listen: false);
    filters = Provider.of<Filters>(context, listen: false);
    if (!widget.isInsert) {
      exercise = exercises.getExercise(widget.id);
    }
    super.initState();
  }

  // ************ build exercise dialog ************ //
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Text(
            widget.isInsert ? '새로운 운동 추가' : '운동 정보 수정',
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
          Divider(
            height: 20,
            thickness: 0.8,
            color: themeData.primaryColor, // theme
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '카테고리 선택',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            categoryChips(themeData),
            const Divider(
              color: Colors.black,
            ),
            nameBox,
            jobCompleteRow(themeData),
          ],
        ),
      ),
    );
  }

  // ************ save/update exercise ************ //
  void _onSave(String name) {
    if (widget.isInsert) {
      // add new exercise
      String id = exercises.addExercise(name, Target(selectedTargetName));
      filters.addFilter(id);
    } else {
      // update exercise
      exercises.updateExercise(
          widget.id, Exercise(widget.id, name, Target(selectedTargetName)));
    }
  }

  // ************ delete exercise ************ //
  Future<void> _onDelete() async {
    final isSure = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: const Text(
                '운동을 삭제하시겠습니까?\n이 운동의 기록 및 운동을 포함하는 루틴이 모두 삭제됩니다.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('아니오')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('예')),
              ],
            ));
    if (!isSure) {
      return;
    }
    final eventIds = Provider.of<Events>(context, listen: false)
        .deleteEventsOfExercise(widget.id);
    final routineIds = Provider.of<Routines>(context, listen: false)
        .deleteRoutinesOfExercise(widget.id);
    exercises.deleteExercise(widget.id, eventIds, routineIds);
    filters.deleteFilter(widget.id);
    Navigator.of(context).pop();
  }

  // ************ category chips ************ //
  Widget categoryChips(ThemeData themeData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: Target.valuesExceptAll
            .map(
              (t) => GestureDetector(
                // border, clip
                child: Chip(
                  backgroundColor: selectedTargetName == t
                      ? themeData.accentColor
                      : Colors.grey[300],
                  label: Text(
                    t,
                    style: TextStyle(
                        color: selectedTargetName == t
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedTargetName = t;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

// ************ exercise nameBox(TextField) ************ //
  Widget get nameBox {
    return TextFormField(
      initialValue: widget.isInsert ? null : exercise.name,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: '종목의 이름을 입력하세요',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '이름이 입력되지 않았습니다.';
        }
        return null;
      },
      onSaved: _onSave,
    );
  }

  // ************ JobCompleteRow ************ //
  Widget jobCompleteRow(ThemeData themeData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: themeData.primaryColor, // background
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pop();
              }
            },
            child: Text(widget.isInsert ? '운동 추가하기' : '저장하기'),
          ),
          if (!widget.isInsert)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: themeData.primaryColor, // background
              ),
              onPressed: _onDelete,
              child: const Text('운동 삭제'),
            ),
        ],
      ),
    );
  }
}
