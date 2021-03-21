import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';

import '../models/routine.dart';
import '../widgets/event_field.dart';
import '../widgets/custom_floating_button.dart';
import '../providers/routines.dart';
import '../providers/events.dart';
import '../providers/calendar_state.dart';

class InsertEventsScreen extends StatefulWidget {
  final bool isRawInsert;
  final bool isForRoutine;
  // final bool isEditRoutine; // 이걸로 변경.
  final String routineId; // id로 받아서 routines에서 get?
  final List<String> exerciseIds;

  InsertEventsScreen({
    @required this.isRawInsert,
    this.isForRoutine = false,
    this.exerciseIds,
    this.routineId,
  });

  @override
  _InsertEventsScreenState createState() => _InsertEventsScreenState();
}

class _InsertEventsScreenState extends State<InsertEventsScreen> {
  final _key = GlobalKey<FormState>();
  int _itemCount;
  DateTime day;
  List<Event> events;
  List<TextEditingController> weightControllers;
  List<TextEditingController> repControllers;

  Routines routines;
  Routine routine;
  @override
  void initState() {
    routines = Provider.of<Routines>(context, listen: false);
    if (!widget.isRawInsert) {
      routine = routines.getRoutine(widget.routineId);
    } else if (widget.isForRoutine) {
      routine = Routine();
    }
    if (!widget.isForRoutine) {
      day = Provider.of<CalendarState>(context, listen: false).day;
    }
    _itemCount =
        widget.isRawInsert ? widget.exerciseIds.length : routine.items.length;
    events = List.generate(
        _itemCount,
        (i) => widget.isRawInsert
            ? Event(
                id: null,
                date: widget.isForRoutine ? null : day,
                exerciseId: widget.exerciseIds[i])
            : Event(
                id: null,
                date: widget.isForRoutine ? null : day,
                exerciseId: routine.items[i].exerciseId, // 너무 기므로 앞부분 따로 저장.
                setDetails: routine.items[i].setDetails,
                type: routine.items[i].type,
              ));

    weightControllers =
        List.generate(_itemCount, (_) => TextEditingController());
    repControllers = List.generate(_itemCount, (_) => TextEditingController());

    super.initState();
  }

  @override
  void dispose() {
    weightControllers.forEach((element) => element.dispose());
    repControllers.forEach((element) => element.dispose());

    super.dispose();
  }

  void _onSave() {
    if (!_key.currentState.validate()) {
      return;
    }
    _key.currentState.save();
    if (widget.isForRoutine) {
      if (widget.isRawInsert) {
        routines.addRoutine(routine.name, events);
      } else {
        events.forEach((e) {
          e.setDetails.forEach((s) {
            print('${s.weight}  ${s.rep}');
          });
        });

        routines.updateRoutine(
            id: widget.routineId, name: routine.name, events: events);
      }
    } else {
      Provider.of<Events>(context, listen: false).addEvents(events);
    }
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  void _onDeleteRoutine() {
    routines.deleteRoutine(routine.id);
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  // ************ routine title box ************ //
  Widget get routineTitleBox {
    return TextFormField(
      initialValue: routine.name,
      decoration: InputDecoration(hintText: '루틴의 이름'),
      onSaved: (value) {
        routine.name = value; // ?
      },
      validator: (value) {
        if (value.trim().length == 0) {
          return '이름을 입력하세요.';
        }
        return null;
      },
    );
  }

  // ************ event tiles list ************ //
  Widget get eventTilesList {
    return Expanded(
      child: ReorderableListView.builder(
        header: _itemCount > 0
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Text(
                  '타일을 길게 누르면 순서를 변경할수 있습니다.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              )
            : null,
        onReorder: (oldIdx, newIdx) {
          setState(() {
            if (newIdx > oldIdx) {
              newIdx -= 1;
            }
            final ev = events.removeAt(oldIdx);
            final wc = weightControllers.removeAt(oldIdx);
            final rc = repControllers.removeAt(oldIdx);
            weightControllers.insert(newIdx, wc);
            repControllers.insert(newIdx, rc);
            events.insert(newIdx, ev);
          });
        },
        itemCount: _itemCount,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          key: ValueKey(events[i].exerciseId),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: EventField(
              initialValue: events[i],
              isEdit: false,
              isForRoutine: widget.isForRoutine,
              onSaved: (ev) {
                events[i] = ev;
              },
              validator: (ev) => null,
              weightController: weightControllers[i],
              repController: repControllers[i],
            ),
          ),
        ),
      ),
    );
  }

  // ************ job complete buttons ************ //
  Widget get jobCompleteRow {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFloatingButton(
          name: '저장하기',
          onPressed: _onSave,
          color: Colors.teal,
        ),
        if (widget.isForRoutine && !widget.isRawInsert)
          CustomFloatingButton(
            name: '루틴삭제',
            onPressed: _onDeleteRoutine,
            color: Colors.teal,
          ),
      ],
    );
  }

  // ************ build insert events screen ************ //
  @override
  Widget build(BuildContext context) {
    print('build Insert Events Screen!');

    return Scaffold(
      appBar: AppBar(
        title: widget.isForRoutine
            ? (widget.isRawInsert ? Text('루틴을 구성하세요.') : Text('루틴을 수정하세요.'))
            : Text('추가: ${DateFormat('M월 d일').format(day)}의 운동'),
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Column(
            children: [
              if (widget.isForRoutine) routineTitleBox,
              eventTilesList,
              Divider(),
              jobCompleteRow,
            ],
          ),
        ),
      ),
    );
  }
}
