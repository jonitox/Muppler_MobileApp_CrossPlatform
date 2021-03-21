import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/widgets/exercise_list.dart';

import '../widgets/memo_dialog.dart';

import '../providers/exercises.dart';
import '../models/event.dart';
import '../models/exercise.dart';

// ************ custom field for event ************ //
class EventField extends FormField<Event> {
  EventField({
    FormFieldSetter<Event> onSaved,
    FormFieldValidator<Event> validator,
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
            ); // named로
          },
        );
}

//// ******************************* event Field box ******************************* ////
///
class EventFieldBox extends StatefulWidget {
  final FormFieldState<Event> state;
  final bool isEdit;
  final bool isForRoutine;
  // final TextEditingController weightController;
  // final TextEditingController repController;
  EventFieldBox(
    this.state,
    this.isEdit,
    this.isForRoutine,
  );

  @override
  _EventFieldBoxState createState() => _EventFieldBoxState();
}

class _EventFieldBoxState extends State<EventFieldBox> {
  bool isHide;
  Event event;
  Exercises exercises;
  Exercise exercise;
  double weight = 1115;
  int repetition = 6;

  @override
  void initState() {
    exercises = Provider.of<Exercises>(context, listen: false);
    isHide = false;
    print('init event field!');

    super.initState();
  }

  @override
  void dispose() {
    print('dispose event field!');
    super.dispose();
  }

  String removeDecimalZeroFormat(double n) {
    return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
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

  void onTapSetRow({double w, int r, bool isNew, int setNumber}) async {
    // await showModalBottomSheet(context: context, builder: builder);
    print('tap!');
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
    // event.exerciseId = exerciseId;
    print(exerciseId);
    widget.state.didChange(event.copyWith(exerciseId: exerciseId));
  }

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
            style: TextStyle(color: Colors.teal),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        if (widget.isEdit)
          TextButton(child: Text('변경'), onPressed: () => onTapChangeExercise()),
      ],
    );
  }

// ************ event summary row ************ //
  Widget get summaryRow {
    final vol = event.volume is double
        ? removeDecimalZeroFormat(event.volume)
        : event.volume.toString() +
            (event.type == DetailType.onlyRep ? '개' : 'kg');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('총 세트 수 : ${event.setDetails.length}'),
        Text('Volume : $vol')
      ],
    );
  }

// ************ hidden box ************ //
  Widget get hiddenBox {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          thickness: 1.5,
        ),
        if (!widget.isForRoutine) memoBox,
        insertSetRow,
        insertButtonRow,
        ...setDetailsColumn,
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
  Widget get insertSetRow {
    return Row(
      children: [
        Text('세트 :'),
        Expanded(
          child: GestureDetector(
            onTap: onTapSetRow,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.deepOrange),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (event.type != DetailType.onlyRep)
                    Row(
                      children: [
                        Text(
                          '${removeDecimalZeroFormat(weight)}',
                          style: TextStyle(
                            fontSize: 22,
                            // decoration: TextDecoration.underline,
                            // decorationColor: Colors.bl,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        '$repetition',
                        style: TextStyle(
                          fontSize: 22,

                          // decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                          // decorationColor: Colors.teal,
                        ),
                      ),
                      Text(
                        '회',
                        style: TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
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
        // if (event.type == DetailType.basic)
        //   Expanded(
        //     child: TextField(
        //       decoration: InputDecoration(labelText: '무게'),
        //       controller: widget.weightController,
        //       keyboardType: TextInputType.number,
        //       textInputAction: TextInputAction.done,
        //     ),
        //   ),
        // if (event.type == DetailType.basic) Text('Kg'),
        // Expanded(
        //   child: TextField(
        //     decoration: InputDecoration(labelText: '반복수'),
        //     controller: widget.repController,
        //     keyboardType: TextInputType.number,
        //     textInputAction: TextInputAction.done,
        //   ),
        // ),
        // Text('회'),
        PopupMenuButton(
          child: event.type == DetailType.basic ? Text('무게,개수') : Text('개수만'),
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child: Text('무게,개수'),
              value: 0,
            ),
            PopupMenuItem(
              child: Text('개수만'),
              value: 1,
            ),
          ],
          onSelected: (value) {
            // event.type = value == 0 ? DetailType.basic : DetailType.onlyRep;
            print(value);
            widget.state.didChange(event.copyWith(
                type: value == 0 ? DetailType.basic : DetailType.onlyRep));
          },
        )
      ],
    );
  }

  // ************ insert set button ************ //
  Widget get insertButtonRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // event.addSet(Set(
            //     // double.parse(widget.weightController.text),
            //     // int.parse(widget.repController.text),
            //     ));
            widget.state.didChange(event); // memoy leak?
          },
          child: Text('세트 추가'),
        ),
        if (event.setDetails.length > 0)
          ElevatedButton(
            onPressed: () {
              // event.deleteset
              // widget.state.didChange(event); // memoy leak?
            },
            child: Text('세트 삭제'),
          ),
      ],
    );
  }

  List<Widget> get setDetailsColumn {
    // listview로? shrinkwrap =true;
    return event.setDetails.asMap().entries.map((entry) {
      final idx = entry.key;
      final s = entry.value;
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => modifySetBottomSheet,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${idx + 1}세트'),
            if (event.type == DetailType.basic) Text('${s.weight}Kg'),
            Text('${s.rep}회'),
          ],
        ),
      );
    }).toList();
  }

  Widget get modifySetBottomSheet {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    event = widget.state.value;
    exercise = exercises.getExercise(event.exerciseId);
    print('build event field box!');
    print(event.date.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // builder등으로 분리해서 정리.
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
