import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';

import '../models/routine.dart';
import '../widgets/event_field.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/exercise_list.dart';
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
  Routines routines;
  Routine routine;
  ScrollController _scrollController;

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
              exerciseId: routine.items[i].exerciseId,
              setDetails: routine.items[i].setDetails,
              type: routine.items[i].type,
            ),
    ).toList();
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ************ choose extra exercises to add ************ //
  Future<void> _onAddExtra() async {
    final selectedExtras = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (bctx) => AlertDialog(
        scrollable: true, //
        title: Text('운동 추가하기'),
        content: ExerciseList(
          isForAddExtra: true,
          alreadySelected: events.map((e) => e.exerciseId).toList(),
        ),
      ),
    ) as Map<String, bool>;
    if (selectedExtras == null) {
      return;
    }
    setState(() {
      selectedExtras.forEach((key, value) {
        if (value == true) {
          print('hey');
          events.add(Event(
              id: null,
              date: widget.isForRoutine ? null : day,
              exerciseId: key));
        }
      });
    });
  }

  // ************ save events or Routine ************ //
  Future<void> _onSave() async {
    if (!_key.currentState.validate()) {
      return;
    }
    _key.currentState.save();
    if (widget.isForRoutine) {
      // make new routine
      if (widget.isRawInsert) {
        routines.addRoutine(routine.name, events);
      } else {
        // edit routine
        //  events.forEach((e) {
        //   e.setDetails.forEach((s) {
        //     print('${s.weight}  ${s.rep}');
        //   });
        // });
        routines.updateRoutine(
            id: widget.routineId, name: routine.name, events: events);
      }
    } else {
      final completeEvents = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(
                  '운동을 마치겠습니까?',
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
      if (!completeEvents) {
        return;
      }
      // if it's routine that is added, ask for updating routine
      if (!widget.isRawInsert) {
        final ret = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text(
                    '기존 루틴(${routine.name})도 이 루틴으로 업데이트하시겠습니까?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        '괜찮습니다',
                        textAlign: TextAlign.end,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        '예',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ));
        if (ret == null) {
          return;
        }
        if (ret) {
          routines.updateRoutine(
              id: widget.routineId, name: routine.name, events: events);
        }
      }
      Provider.of<Events>(context, listen: false).addEvents(events);
    }
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

// ************ delete event ************ //
  void _onDeleteEvent(String exerciseId) {
    setState(() {
      events.removeWhere((e) => e.exerciseId == exerciseId);
    });
  }

  // ************ delete routine ************ //
  Future<void> _onDeleteRoutine() async {
    final isSure = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(
                '루틴을 삭제하시겠습니까?',
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

    routines.deleteRoutine(routine.id);
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  // ************ routine title box ************ //
  Widget get routineTitleBox {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        children: [
          Text(
            '루틴 ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Expanded(
            child: widget.isForRoutine
                ? TextFormField(
                    initialValue: routine.name,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // textInputAction: TextInputAction.done,
                    decoration: InputDecoration(hintText: '이름을 입력하세요.'),
                    onSaved: (value) {
                      routine.name = value; // ?
                    },
                    validator: (value) {
                      if (value.trim().length == 0) {
                        return '이름이 없습니다.';
                      }
                      return null;
                    },
                  )
                : Text(
                    '${routine.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  // ************ event tiles list ************ //
  Widget get eventTilesList {
    print('build reorderalbe!');
    return ReorderableList(
      controller: _scrollController,
      shrinkWrap: true,
      onReorder: (oldIdx, newIdx) {
        print('call reorder!');
        setState(() {
          if (newIdx > oldIdx) {
            newIdx -= 1;
          }
          final ev = events.removeAt(oldIdx);
          events.insert(newIdx, ev);
        });
      },
      itemCount: events.length,
      itemBuilder: (ctx, i) => ReorderableDelayedDragStartListener(
        index: i,
        key: ValueKey(events[i].exerciseId),
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
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
              deleteEvent: _onDeleteEvent,
              onSaved: (ev) {
                events[i] = ev;
              },
              validator: (ev) => null,
            ),
          ),
        ),
      ),
    );
  }

  // ************ tip box ************ //
  Widget get reorderTipBox {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '타일을 길게 누르면 운동 순서를 변경할수 있습니다.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          Divider(),
        ],
      ),
    );
  }

  // ************ job complete buttons ************ //
  Widget get jobCompleteRow {
    print('create jobcomplete row!');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFloatingButton(
          name: !widget.isForRoutine
              ? '운동기록 저장'
              : (widget.isRawInsert ? '루틴 저장하기' : '수정완료'),
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
    final _appBar = AppBar(
      title: widget.isForRoutine
          ? (widget.isRawInsert ? Text('루틴을 구성하세요.') : Text('루틴을 수정하세요.'))
          : Text('추가: ${DateFormat('M월 d일').format(day)}의 운동'),
      leading: widget.isForRoutine && !widget.isRawInsert ? Container() : null,
      actions: [
        GestureDetector(
          onTap: _onAddExtra,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                // size: 30,
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (Platform.isIOS) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                print('hey');
                FocusManager.instance.primaryFocus.unfocus();
              }
            }
          },
          child: Form(
            key: _key,
            child: Column(
              children: [
                if (widget.isForRoutine || !widget.isRawInsert) routineTitleBox,
                Expanded(child: eventTilesList),
                Divider(
                  color: Colors.black,
                ),
                if (events.length > 1) reorderTipBox,
                jobCompleteRow,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
