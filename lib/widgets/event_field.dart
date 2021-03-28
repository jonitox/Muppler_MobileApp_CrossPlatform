import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './memo_dialog.dart';
import './exercise_list.dart';
import './set_sheet.dart';

import '../providers/exercises.dart';
import '../models/event.dart';
import '../models/exercise.dart';

// ************ custom field for event ************ //
class EventField extends FormField<Event> {
  EventField({
    FormFieldSetter<Event> onSaved,
    FormFieldValidator<Event> validator,
    Function deleteEvent,
    Event initialValue,
    bool isEdit,
    bool isForRoutine = false,
    // TextEditingController weightController,
    // TextEditingController repController,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          // autovalidate: false, //
          builder: (FormFieldState<Event> state) {
            print('call builder!');
            return EventFieldBox(
              state,
              isEdit,
              isForRoutine,
              deleteEvent,
            ); // named로
          },
        );
}

//// ******************************* event Field box ******************************* ////
class EventFieldBox extends StatefulWidget {
  final FormFieldState<Event> state;
  final bool isEdit;
  final bool isForRoutine;
  final Function deleteEvent;
  EventFieldBox(
    this.state,
    this.isEdit,
    this.isForRoutine,
    this.deleteEvent,
  );

  @override
  _EventFieldBoxState createState() => _EventFieldBoxState();
}

class _EventFieldBoxState extends State<EventFieldBox> {
  bool isHide;
  Event event;
  Exercises exercises;
  Exercise exercise;
  double weightToInsert;
  int repToInsert;
  List<int> weightPlaceHolder;
  List<int> repPlaceHolder;

  @override
  void initState() {
    event = widget.state.value;
    weightToInsert =
        event.setDetails.length == 0 ? 0.0 : event.setDetails.last.weight;
    repToInsert = event.setDetails.length == 0 ? 0 : event.setDetails.last.rep;
    exercises = Provider.of<Exercises>(context, listen: false);
    isHide = widget.isEdit ? false : true;
    print('init event field!');

    super.initState();
  }

  @override
  void dispose() {
    print('dispose event field!');
    super.dispose();
  }

  // remove fractional parts of double
  String removeDecimalZeroFormat(String n) {
    return n.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // update Set PlaceHolder
  void updateSetPlaceHolder(bool isRepVal, int digit, int val) {
    if (isRepVal) {
      repPlaceHolder[digit] = val;
    } else {
      weightPlaceHolder[digit] = val;
    }
  }

  // ************ on Tap memo Box ************ //
  Future<void> onTapMemo() async {
    String memo = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (bctx) => MemoDialog(exercise.name, event.memo),
    );
    if (memo == null) {
      return;
    }
    print('hey');
    print(memo);
    // event.memo = memo; // copywith(event)로하려면 필요. // 내부적으로 뭐가 더 나은지? // 사실 copywith로 매번 다시만들어서쓰는거보다 있는 event쓰는게 더 효율적일것같긴함. // 나중에 변경
    // event.memo = 'aa';
    widget.state.didChange(event.copyWith(memo: memo));
  }

  // ************ on Tap Change set row ************ //
  Future<void> onTapSetRow({int setNumber}) async {
    final originWeight = setNumber == 0
        ? weightToInsert
        : event.setDetails[setNumber - 1].weight;
    final originRep =
        setNumber == 0 ? repToInsert : event.setDetails[setNumber - 1].rep;
    weightPlaceHolder = List.generate(4, (i) {
      final int rounded = (originWeight * 10).round();
      if (i == 0) {
        return rounded ~/ 1000;
      } else if (i == 1) {
        return rounded ~/ 100 % 10;
      } else if (i == 2) {
        return rounded ~/ 10 % 10;
      } else {
        return rounded % 10;
      }
    }).toList();
    repPlaceHolder = List.generate(3, (i) {
      if (i == 0) {
        return originRep ~/ 100;
      } else if (i == 1) {
        return originRep ~/ 10 % 10;
      } else {
        return originRep % 10;
      }
    }).toList();

    await showModalBottomSheet(
        isScrollControlled: false,
        enableDrag: false,
        context: context,
        builder: (ctx) => SetSheet(
              weightHolder: weightPlaceHolder,
              repHolder: repPlaceHolder,
              setNumber: setNumber,
              isOnlyRep: event.type == DetailType.onlyRep,
              updateSetInfoHolders: updateSetPlaceHolder,
            ));

    final updatedWeight = event.type == DetailType.onlyRep
        ? 0.0
        : weightPlaceHolder.fold(0, (sum, x) => (10 * sum + x)) / 10;
    final updatedRep = repPlaceHolder.fold(0, (sum, x) => (10 * sum + x));

    if (setNumber == 0) {
      setState(() {
        weightToInsert = updatedWeight;
        repToInsert = updatedRep;
      });
    } else {
      event.updateSet(setNumber - 1, Set(updatedWeight, updatedRep));
      widget.state.didChange(event);
    }
  }

  // ************ on Tap Change Exercise when editing event ************ //
  Future<void> onTapChangeExercise() async {
    String exerciseId = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (bctx) => AlertDialog(
        scrollable: true, //
        title: Text('운동선택'),
        content: ExerciseList(isForSelect: true, selectedId: event.exerciseId),
      ),
    );
    if (exerciseId == null) {
      return;
    }
    widget.state.didChange(event.copyWith(exerciseId: exerciseId));
  }

/////////////////////////////// widgets builders //////////////////////////////////////////

  // ************ title Row ************ //
  Widget get titleRow {
    return Row(
      children: [
        if (!widget.isEdit)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon:
                    isHide ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
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
        Chip(
          backgroundColor: Colors.white,
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
            // style: TextStyle(color: Colors.teal),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            exercise.name,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        if (widget.isEdit)
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[300], // background
              ),
              child: Text('운동 변경'),
              onPressed: () => onTapChangeExercise()),
        if (!widget.isEdit)
          Container(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: IconButton(
                iconSize: 23,
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.deepOrange,
                ),
                onPressed: () => widget.deleteEvent(event.exerciseId),
              ),
            ),
          ),
      ],
    );
  }

// ************ event summary row ************ //
  Widget get summaryRow {
    final vol = (event.volume is double
                ? removeDecimalZeroFormat(event.volume.toStringAsFixed(1))
                : event.volume.toString())
            .toString() +
        (event.type == DetailType.onlyRep ? '개' : 'kg');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '총 세트 수 : ${event.setDetails.length}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          'Volume : $vol',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

// ************ hidden box ************ //
  Widget get hiddenBox {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          thickness: 1.5,
        ),
        if (!widget.isForRoutine) memoBox,
        insertSetRow(deviceSize),
        Divider(
          thickness: 1.5,
        ),
        // insertButtonRow,
        setDetailsColumn(deviceSize),
      ],
    );
  }

// ************ memo box ************ //
  Widget get memoBox {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onTapMemo(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              event.memo.trim().length > 0 ? event.memo : 'MEMO',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ),
        Divider(
          thickness: 1.5,
        ),
      ],
    );
  }

  // ************ insert set row ************ //
  Widget insertSetRow(Size deviceSize) {
    final themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.all(5),
          width: deviceSize.width * 0.2,
          decoration: BoxDecoration(
              color: themeData.accentColor,
              // border: Border.all(width: 1, color: themeData.accentColor),
              borderRadius: BorderRadius.circular(5)),
          child: PopupMenuButton(
            // color: themeData.accentColor,
            child: event.type == DetailType.basic
                ? Center(
                    child:
                        Text('무게, 횟수', style: TextStyle(color: Colors.white)))
                : Center(
                    child: Text('횟수', style: TextStyle(color: Colors.white))),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text(
                  '무게, 횟수',
                  softWrap: true,
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  '횟수',
                  softWrap: true,
                ),
                value: 1,
              ),
            ],
            onSelected: (value) {
              // event.type = value == 0 ? DetailType.basic : DetailType.onlyRep;
              print(value);
              widget.state.didChange(event.copyWith(
                  type: value == 0 ? DetailType.basic : DetailType.onlyRep));
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTapSetRow(setNumber: 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (event.type != DetailType.onlyRep)
                    Row(
                      children: [
                        Text(
                          '${removeDecimalZeroFormat(weightToInsert.toStringAsFixed(1))}',
                          style: TextStyle(
                            fontSize: 22,
                            // decoration: TextDecoration.underline,
                            // decorationColor: Colors.bl,
                          ),
                        ),
                        Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        '$repToInsert',
                        style: TextStyle(
                          fontSize: 22,

                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.teal,
                        ),
                      ),
                      Text(
                        '회',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 5),
          width: deviceSize.width * 0.2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: themeData.accentColor,
              padding: EdgeInsets.all(5),
            ),
            onPressed: () {
              event.addSet(Set(
                weightToInsert,
                repToInsert,
              ));
              widget.state.didChange(event); // memoy leak?
            },
            child: Text('세트 추가'),
          ),
        ),
      ],
    );
  }

  // ************ set details column  ************ //
  Widget setDetailsColumn(Size deviceSize) {
    return event.setDetails.length == 0
        ? Container(
            height: 30,
            child: Center(
              child: Text(
                '세트 없음',
                style: TextStyle(color: Colors.deepOrange[300]),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemExtent: 35,
            itemCount: event.setDetails.length,
            itemBuilder: (ctx, i) => Row(
              key: ValueKey('set#$i'),
              children: [
                // *미추가: 세트 성공 여부 기능
                // Container(
                //   width: deviceSize.width * 0.1,
                //   child: FittedBox(
                //     fit: BoxFit.fitWidth,
                //     child: OutlinedButton(
                //       onPressed: () {},
                //       child: Text('완료'),
                //     ),
                //   ),
                // ),
                Container(
                  // color: Colors.red,
                  width: deviceSize.width * 0.2,
                  child: Center(
                      child: Text(
                    '${i + 1}세트',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapSetRow(setNumber: i + 1),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: Colors.deepOrange[300]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (event.type == DetailType.basic)
                            Container(
                              width: deviceSize.width * 0.2,
                              child: Center(
                                  child: Text(
                                '${removeDecimalZeroFormat(event.setDetails[i].weight.toStringAsFixed(1))}Kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              )),
                            ),
                          Container(
                            // color: Colors.red,
                            width: deviceSize.width * 0.2,
                            child: Center(
                                child: Text(
                              '${event.setDetails[i].rep}회',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.blue,
                  width: deviceSize.width * 0.07,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      iconSize: 28,
                      icon: Icon(Icons.delete_outline_outlined),
                      onPressed: () {
                        event.removeSet(i);
                        widget.state.didChange(event);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    event = widget.state.value;
    exercise = exercises.getExercise(event.exerciseId);

    print('build event field box!');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleRow,
        Divider(
          thickness: 1.5,
        ),
        summaryRow,
        if (!isHide) hiddenBox,
      ],
    );
  }
}
