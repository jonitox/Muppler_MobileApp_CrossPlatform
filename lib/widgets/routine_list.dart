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
  // Widget get sortButtonRow {
  //   return Row(
  //     children: [
  //       ElevatedButton(onPressed: () {}, child: Text('추가순')),
  //       ElevatedButton(onPressed: () {}, child: Text('이름순')),
  //     ],
  //   );
  // }

  // Widget get routinesColumn {
  //   return Consumer<Routines>(builder: (ctx, routines, child) {
  //     final items = routines.items;
  //     print('build routines Column!');
  //     return Expanded(
  //       child: Stack(
  //         alignment: AlignmentDirectional.bottomCenter,
  //         children: [
  //           ListView.builder(
  //             itemCount: items.length,
  //             itemBuilder: (ctx, i) => GestureDetector(
  //               onTap: widget.isForinsert
  //                   ? () {
  //                       setState(() {
  //                         selectedId = items[i].id;
  //                       });
  //                     }
  //                   : null,
  //               child: RoutineTile(
  //                 isForInsert: widget.isForinsert,
  //                 isSelected: selectedId == items[i].id,
  //                 r: items[i],
  //                 key: ValueKey(items[i].id),
  //               ),
  //             ),
  //           ),
  //           if (widget.isForinsert)
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                     builder: (ctx) => InsertEventsScreen(
  //                           isRawInsert: false,
  //                           isMakeRoutine: false,
  //                           routineId: selectedId,
  //                         )));
  //               },
  //               child: Text('선택 완료'),
  //             ),
  //           if (!widget.isForinsert)
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context)
  //                     .pushNamed(PickExerciseOnlyScreen.routeName);
  //               },
  //               child: Text('루틴 추가하기'),
  //             ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // ************  floating button ************ //
  Widget floatingButton({String text, Function onPressed, IconData icon}) {
    return CustomFloatingButton(
      name: text,
      onPressed: onPressed,
      icon: icon,
    );
  }

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
                child: ListView.separated(
                  separatorBuilder: (ctx, i) => Divider(
                    height: 20,
                    thickness: 0.8,
                    color: Theme.of(context).primaryColor,
                  ),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => GestureDetector(
                    onTap: widget.isForinsert
                        ? () {
                            setState(() {
                              selectedId = items[i].id;
                            });
                          }
                        : null,
                    child: RoutineTile(
                      isForInsert: widget.isForinsert,
                      isSelected: selectedId == items[i].id,
                      r: items[i],
                      key: ValueKey(items[i].id),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  // ************ build routine list ************ //
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
            text: '항목 추가하기',
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
  RoutineTile({this.isForInsert, this.isSelected, this.r, this.key}); // named로
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

  // ************  routine title row ************ //
  Widget get routineTitleRow {
    return Row(
      children: [
        IconButton(
          icon: isHide ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          onPressed: () => setState(() {
            isHide = !isHide;
          }),
        ),
        Expanded(
            child: Text(
          widget.r.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        )),
        Text(
          '총 ${widget.r.numberOfSets}세트 ',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
        Text(
          '볼륨 ${widget.r.volume}kg',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
        ),
        if (widget.isForInsert && widget.isSelected) Icon(Icons.check_outlined),
        if (!widget.isForInsert)
          IconButton(
            icon: Icon(Icons.info_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => InsertEventsScreen(
                        isRawInsert: false,
                        isForRoutine: true,
                        routineId: widget.r.id,
                      )));
            },
          ),
      ],
    );
  }

  // ************ events column of routine ************ //
  List<Widget> get eventsBox {
    return widget.r.items.map((e) {
      Exercise exercise = exercises.getExercise(e.exerciseId);
      return Column(
        children: [
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Text('세트 수 : ${e.setDetails.length} / 볼륨: ${e.volume}' +
                  (e.type == DetailType.onlyRep ? '개' : 'kg')),
            ],
          ),
          if (!isHide)
            ListView.builder(
              shrinkWrap: true,
              itemCount: e.setDetails.length,
              itemBuilder: (ctx, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${i + 1}세트'),
                  if (e.type == DetailType.basic)
                    Text('${e.setDetails[i].weight}Kg'),
                  Text('${e.setDetails[i].rep}회'),
                ],
              ),
            ),
          Divider(
            thickness: 1,
            height: 8,
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
            Divider(
              thickness: 1.5,
            ),
            ...eventsBox,
          ],
        ),
      ),
    );
  }
}
