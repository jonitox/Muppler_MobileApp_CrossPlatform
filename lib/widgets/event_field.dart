import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_out_tracker/widgets/exercise_list.dart';

import '../widgets/memo_dialog.dart';

import '../providers/exercises.dart';
import '../models/event.dart';

class EventField extends FormField<Event> {
  EventField({
    Key key,
    FormFieldSetter<Event> onSaved,
    FormFieldValidator<Event> validator,
    Event initialValue,
    bool isEdit,
    bool isForRoutine = false,
    TextEditingController weightController,
    TextEditingController repController,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          // autovalidate: false, //
          builder: (FormFieldState<Event> state) {
            print('call builder!');
            return EventFieldBox(state, isEdit, isForRoutine, weightController,
                repController); // named로
          },
        );
}

// ************ today exercises column ************ //
class EventFieldBox extends StatefulWidget {
  final FormFieldState<Event> state;
  final bool isEdit;
  final bool isForRoutine;
  final TextEditingController weightController;
  final TextEditingController repController;
  EventFieldBox(this.state, this.isEdit, this.isForRoutine,
      this.weightController, this.repController);

  @override
  _EventFieldBoxState createState() => _EventFieldBoxState();
}

class _EventFieldBoxState extends State<EventFieldBox> {
  bool isHide;
  Event event;
  @override
  void initState() {
    isHide = false;
    print('init event field!');

    super.initState();
  }

  @override
  void dispose() {
    print('dispose event field!');
    super.dispose();
  }

  Future<void> onTapMemo() async {
    String memo = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (bctx) => MemoDialog(event.memo),
    );
    if (memo == null) {
      return;
    }
    // event.memo = memo; // copywith(event)로하려면 필요. // 내부적으로 뭐가 더 나은지? // 사실 copywith로 매번 다시만들어서쓰는거보다 있는 event쓰는게 더 효율적일것같긴함. // 나중에 변경
    // event.memo = 'aa';
    widget.state.didChange(event.copyWith(memo: memo));
  }

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

  Widget get nameRow {
    final exercise = Provider.of<Exercises>(context, listen: false)
        .getExercise(event.exerciseId);
    print(exercise.name);
    return Row(
      // mainAxisAlignment: MainAxis,
      children: [
        if (!widget.isEdit)
          IconButton(
            icon: isHide
                ? Icon(Icons.keyboard_arrow_right)
                : Icon(Icons.keyboard_arrow_down),
            onPressed: () => setState(() {
              isHide = !isHide;
            }),
          ),
        Expanded(
          child: Row(
            children: [
              Chip(
                label: Text(exercise.target.value),
              ),
              Text(exercise.name),
            ],
          ),
        ),
        if (widget.isEdit)
          TextButton(child: Text('변경'), onPressed: () => onTapChangeExercise()),
      ],
    );
  }

  Widget get summaryRow {
    String volume = 'volume: ${event.volume}' +
        (event.type == DetailType.basic ? 'kg' : '개');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('${event.setDetails.length}세트'),
        Text(volume),
      ],
    );
  }

  Widget get hiddenBox {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isForRoutine) memoBox,
        insertSetRow,
        insertButtonRow,
        ...setDetailsColumn,
      ],
    );
  }

  Widget get memoBox {
    return GestureDetector(
      onTap: () => onTapMemo(),
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
        )),
        child: Text('memo\n${event.memo}'),
      ),
    );
  }

  Widget get insertSetRow {
    return Row(
      children: [
        if (event.type == DetailType.basic)
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: '무게'),
              controller: widget.weightController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
          ),
        if (event.type == DetailType.basic) Text('Kg'),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: '반복수'),
            controller: widget.repController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ),
        Text('회'),
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

  Widget get insertButtonRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            event.addSet(Set(
              double.parse(widget.weightController.text),
              int.parse(widget.repController.text),
            ));
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
    print('build event field box!');
    print(event.date.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // builder등으로 분리해서 정리.
      children: [
        nameRow,
        summaryRow,
        if (!isHide) hiddenBox,
      ],
    );
  }
}
