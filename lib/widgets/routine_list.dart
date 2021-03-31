import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercises.dart';
import '../providers/routines.dart';
import '../screens/choose_exs_for_routine_screen.dart';
import '../screens/insert_events_screen.dart';
import './custom_floating_button.dart';
import '../models/event.dart';
import '../models/exercise.dart';
import '../models/routine.dart';

// ************ routine list  ************ //
class RoutineList extends StatefulWidget {
  final bool isForinsert;
  RoutineList({this.isForinsert = false});
  @override
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  Routines routines;
  String selectedId;

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
              color: selectedId == null ? Colors.grey : Colors.deepOrange,
              onPressed: selectedId == null
                  ? null
                  : () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => InsertEventsScreen(
                                isRawInsert: false,
                                isForRoutine: false,
                                routineId: selectedId,
                              )));
                    }),
        if (!widget.isForinsert)
          floatingButton(
            text: '루틴 추가하기',
            onPressed: () => Navigator.of(context)
                .pushNamed(ChooseExsForRoutineScreen.routeName),
            icon: Icons.add,
          ),
      ],
    );
  }

  // ************  floating button ************ //
  Widget floatingButton(
      {String text, Function onPressed, IconData icon, Color color}) {
    return CustomFloatingButton(
      color: color ?? Colors.deepOrange,
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
            ? const Center(
                child: const Text(
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

  // ************  build routine tile ************ //
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
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

  // remove fractional parts of double
  String removeDecimalZeroFormat(String n) {
    return n.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // ************  routine title row ************ //
  Widget get routineTitleRow {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            // hide/reveal button
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: isHide
                      ? Icon(Icons.expand_more)
                      : Icon(Icons.expand_less),
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
            // routine name
            Expanded(
                child: Text(
              widget.r.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            )),
            if (widget.isForInsert)
              Icon(widget.isSelected ? Icons.check_outlined : null),
          ],
        ),
        const Divider(
          thickness: 1.5,
        ),
        // routine summary row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '총 ${widget.r.items.length}개의 운동 ',
              style: TextStyle(
                color: themeData.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '총 세트 수 ${widget.r.numberOfSets} ',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '총 볼륨 ${removeDecimalZeroFormat(widget.r.volume.toStringAsFixed(1))}kg',
              style: TextStyle(
                color: themeData.accentColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }

  // ************ events column of routine ************ //
  List<Widget> get eventsBox {
    // generate events box of routine
    return widget.r.items.map((e) {
      Exercise exercise = exercises.getExercise(e.exerciseId);
      return Column(
        children: [
          const Divider(
            thickness: 1.5,
          ),
          Row(
            children: [
              // target chip
              Chip(
                backgroundColor:
                    widget.isSelected ? Colors.amber[200] : Colors.white,
                padding: const EdgeInsets.all(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
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
              // exercise name
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
              // event summary
              Text(
                  '세트 수 ${e.setDetails.length}  볼륨 ${e.type == DetailType.basic ? removeDecimalZeroFormat(e.volume.toStringAsFixed(1)) : e.volume}' +
                      (e.type == DetailType.onlyRep ? '개' : 'kg')),
            ],
          ),
          // set details
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
}
