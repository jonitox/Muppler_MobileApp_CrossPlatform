import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/screens/insert_events_screen.dart';

import '../screens/pick_exercise_only_screen.dart';

import '../providers/exercises.dart';
import '../providers/routines.dart';
import '../models/event.dart';
import '../models/exercise.dart';
import '../models/routine.dart';

import './custom_floating_button.dart';

class RoutineList extends StatefulWidget {
  final bool isForinsert;
  RoutineList({this.isForinsert = false});
  @override
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  Routines routines;
  String selectedId;

  // ************  floating button ************ //
  Widget floatingButton({String text, Function onPressed, IconData icon}) {
    return CustomFloatingButton(
      name: text,
      onPressed: onPressed,
      icon: icon,
    );
  }

  // ************  routine tiles list ************ //
  Widget get routineTilesList {
    return Consumer<Routines>(builder: (ctx, routines, child) {
      final items = routines.items;
      return Expanded(
        child: items.length == 0
            ? Center(
                child: Text(
                '저장된 루틴이 없습니다.',
                softWrap: true,
                style: TextStyle(fontSize: 18),
              ))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => GestureDetector(
                    key: ValueKey(items[i].id),
                    onTap: widget.isForinsert
                        ? () {
                            setState(() {
                              selectedId = items[i].id;
                            });
                          }
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => InsertEventsScreen(
                                      isRawInsert: false,
                                      isForRoutine: true,
                                      routineId: items[i].id,
                                    )));
                          },
                    child: RoutineTile(
                      isForInsert: widget.isForinsert,
                      isSelected: selectedId == items[i].id,
                      r: items[i],
                      key: ValueKey('id:${items[i].id}'),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  // ************ build routine list with buttons ************ //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        routineTilesList,
        Divider(),
        if (widget.isForinsert)
          floatingButton(
            text: '선택 완료',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => InsertEventsScreen(
                        isRawInsert: false,
                        isForRoutine: false,
                        routineId: selectedId,
                      )));
            },
          ),
        if (!widget.isForinsert)
          floatingButton(
            text: '루틴 추가하기',
            onPressed: () => Navigator.of(context)
                .pushNamed(PickExerciseOnlyScreen.routeName),
            icon: Icons.add,
          ),
      ],
    );
  }
}

// ************  routine tile ************ //
class RoutineTile extends StatefulWidget {
  final bool isForInsert;
  final bool isSelected;
  final Routine r;
  final Key key;
  RoutineTile({this.isForInsert, this.isSelected, this.r, this.key})
      : super(key: key); // named로
  @override
  _RoutineTileState createState() => _RoutineTileState();
}

class _RoutineTileState extends State<RoutineTile> {
  bool isHide = true;
  Exercises exercises;

  @override
  void initState() {
    exercises = Provider.of<Exercises>(context, listen: false);
    super.initState();
  }

  // remove fractional parts of double
  String removeDecimalZeroFormat(String n) {
    return n.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // ************  routine title row ************ //
  Widget get routineTitleRow {
    final themeData = Theme.of(context);
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: isHide ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
              onPressed: () => setState(() {
                isHide = !isHide;
              }),
            ),
            Positioned(
                bottom: 1,
                child: Text(
                  isHide ? '펼치기' : '숨기기',
                  style: TextStyle(fontSize: 12),
                )),
          ],
        ),
        Expanded(
            child: Text(
          widget.r.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        )),
        Text(
          '총 ${widget.r.items.length}개의 운동 ',
          style: TextStyle(
            color: themeData.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '총 ${widget.r.numberOfSets}세트 ',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '볼륨 ${removeDecimalZeroFormat(widget.r.volume.toStringAsFixed(1))}kg',
          style: TextStyle(
            color: themeData.accentColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (widget.isForInsert)
          Icon(widget.isSelected ? Icons.check_outlined : null),
      ],
    );
  }

  // ************ events column of routine ************ //
  List<Widget> get eventsBox {
    return widget.r.items.map((e) {
      Exercise exercise = exercises.getExercise(e.exerciseId);
      return Column(
        children: [
          Divider(
            thickness: 1.5,
          ),
          Row(
            children: [
              Chip(
                backgroundColor:
                    widget.isSelected ? Colors.amber[200] : Colors.white,
                padding: const EdgeInsets.all(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                label: Text(
                  exercise.target.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Text(
                    exercise.name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(
                  '세트 수: ${e.setDetails.length}  볼륨: ${e.type == DetailType.basic ? removeDecimalZeroFormat(e.volume.toStringAsFixed(1)) : e.volume}' +
                      (e.type == DetailType.onlyRep ? '개' : 'kg')),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: e.setDetails.length,
            itemBuilder: (ctx, i) => Row(
              key: ValueKey('${e.id} #$i'),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${i + 1}세트'),
                if (e.type == DetailType.basic)
                  Text(
                      '${removeDecimalZeroFormat(e.setDetails[i].weight.toStringAsFixed(1))}Kg'),
                Text('${e.setDetails[i].rep}회'),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  // ************  build routine tile ************ //
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.black87,
          width: 0.5,
        ),
      ),
      color: widget.isSelected ? Colors.amber[200] : null,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            routineTitleRow,
            if (!isHide) ...eventsBox,
          ],
        ),
      ),
    );
  }
}
