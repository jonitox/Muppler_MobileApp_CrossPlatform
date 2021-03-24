import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../providers/filters.dart';
import '../providers/events.dart';
import '../providers/routines.dart';

import '../models/exercise.dart';

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
  @override
  void initState() {
    // dialog인데 dispose되는지? // 그냥 sate내 변수(위)에 직접
    selectedTargetName =
        widget.targetName == '전체' ? Target.chest : widget.targetName;
    exercises = Provider.of<Exercises>(context, listen: false);
    filters = Provider.of<Filters>(context, listen: false);
    if (!widget.isInsert) {
      exercise = exercises.getExercise(widget.id);
    }
    super.initState();
  }

  // ************ save/update exercise ************ //
  void _onSave(String name) {
    if (widget.isInsert) {
      String id = exercises.addExercise(name, Target(selectedTargetName));
      filters.addFilter(id);
    } else {
      exercises.updateExercise(
          widget.id, Exercise(widget.id, name, Target(selectedTargetName)));
    }
  }

  // ************ delete exercise ************ //
  Future<void> _onDelete() async {
    final isSure = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(
                '운동을 삭제하시겠습니까?\n해당 운동의 기록 및 운동을 포함하는 루틴이 모두 삭제됩니다.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('아니오')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('예')),
              ],
            ));
    if (!isSure) {
      return;
    }
    final eventIds = Provider.of<Events>(context, listen: false)
        .deleteEventsOfExercise(widget.id);
    final routineIds = Provider.of<Routines>(context, listen: false)
        .deleteRoutinesOfExercise(widget.id);
    print(routineIds.length);
    exercises.deleteExercise(widget.id, eventIds, routineIds);
    filters.deleteFilter(widget.id);
    Navigator.of(context).pop();
  }

  // ************ category chips ************ //
  Widget get categoryChips {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: Target.valuesExceptAll
            .map(
              (t) => GestureDetector(
                // border, clip
                child: Chip(
                  backgroundColor: selectedTargetName == t
                      ? Colors.deepOrange
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
  Widget get jobCompleteRow {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
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
              onPressed: _onDelete,
              child: Text('운동 삭제'),
            ),
        ],
      ),
    );
  }

  // build exercise dialog ************ //
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Text(
            widget.isInsert ? '새로운 운동 추가' : '운동의 정보',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
          Divider(
            height: 20,
            thickness: 0.8,
            color: Theme.of(context).primaryColor, // theme
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '카테고리 선택',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            categoryChips,
            Divider(
              color: Colors.black,
            ),
            nameBox,
            jobCompleteRow,
          ],
        ),
      ),
    );
  }
}
