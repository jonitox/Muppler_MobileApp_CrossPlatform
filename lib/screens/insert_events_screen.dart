import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/stopwatch_state.dart';
import '../providers/routines.dart';
import '../providers/events.dart';
import '../providers/calendar_state.dart';
import './timer_screen.dart';
import '../widgets/event_field.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/exercise_list.dart';
import '../models/event.dart';
import '../models/routine.dart';

// ************************** Insert event screen ************************* //
class InsertEventsScreen extends StatefulWidget {
  final bool
      isRawInsert; // isRawInsert: 운동목록 직접 선택해 get(true) / 루틴으로부터 목록 get(false)
  final bool isForRoutine; // isForRoutine: 루틴 생성 혹은 수정(true) / 운동 기록 추가(false)
  final String routineId;
  final List<String> exerciseIds;

  InsertEventsScreen({
    this.isRawInsert = false,
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

  // init state
  @override
  void initState() {
    routines = Provider.of<Routines>(context, listen: false);
    if (!widget.isRawInsert) {
      routine = routines.getRoutine(widget.routineId); // 운동 목록 get from routine
    } else if (widget.isForRoutine) {
      routine = Routine(); // 루틴 생성 + 목록 직접 선택
    }
    if (!widget.isForRoutine) {
      day = Provider.of<CalendarState>(context, listen: false)
          .day; // 운동 기록 추가시 get selectedDay
    }
    _itemCount =
        widget.isRawInsert ? widget.exerciseIds.length : routine.items.length;
    // 목록 타일 generate
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

  // dispose
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ******************** build insert events screen ******************** //
  @override
  Widget build(BuildContext context) {
    // print('build Insert Events Screen!');
    final stopwatch = Provider.of<StopWatchState>(context);
    final themeData = Theme.of(context);
    // appBar of Insert Event screen
    final _appBar = AppBar(
      title: widget.isForRoutine
          ? (widget.isRawInsert
              ? FittedBox(
                  child: Text(
                    '루틴을 구성하세요',
                    style: themeData.appBarTheme.titleTextStyle,
                  ),
                )
              : FittedBox(
                  child: Text(
                    '루틴을 수정하세요',
                    style: themeData.appBarTheme.titleTextStyle,
                  ),
                ))
          : FittedBox(
              child: Text(
              '추가: ${DateFormat('M월 d일').format(day)}의 운동',
              style: themeData.appBarTheme.titleTextStyle,
            )),
      // dismiss leading button
      automaticallyImplyLeading:
          widget.isForRoutine && !widget.isRawInsert ? false : true,
      // buttons for stopwatch & add extra Exs
      actions: [
        if (!widget.isForRoutine)
          IconButton(
              color: Colors.white,
              icon: const Icon(Icons.timer_outlined),
              onPressed: stopwatch.isOnOverlay
                  ? null
                  : () {
                      stopwatch.switchOverlay();
                      TimerScreen.swtichToOverlay(context);
                    }),
        // add extra event
        GestureDetector(
          onTap: _onAddExtra,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: const Icon(
              Icons.add,
              color: Colors.white,
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
                const Divider(
                  color: Colors.black,
                ),
                if (events.length > 1) reorderTipBox,
                jobCompleteRow(themeData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ************ on choose extra exercises ************ //
  Future<void> _onAddExtra() async {
    final selectedExtras = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (bctx) => AlertDialog(
        scrollable: true,
        title: const Text('종목 추가하기'),
        content: ExerciseList(
          isForAddExtra: true,
          alreadySelected:
              events.map((e) => e.exerciseId).toList(), // already included
        ),
      ),
    ) as Map<String, bool>;
    if (selectedExtras == null) {
      return;
    }
    setState(() {
      selectedExtras.forEach((key, value) {
        if (value == true) {
          events.add(Event(
              id: null,
              date: widget.isForRoutine ? null : day,
              exerciseId: key));
        }
      });
    });
  }

  // ************ save events or complete making Routine ************ //
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
        routines.updateRoutine(
            id: widget.routineId, name: routine.name, events: events);
      }
    } else {
      // insert events(운동 종료)
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
              content: const Text(
                '루틴을 삭제하시겠습니까?',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          const Text(
            '루틴 ',
            style: const TextStyle(
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
                    decoration: InputDecoration(hintText: '이름을 입력하세요.'),
                    onSaved: (value) {
                      routine.name = value;
                    },
                    validator: (value) {
                      if (value.trim().length == 0) {
                        return '이름이 없습니다.'; // hint for validate fail
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
    return ReorderableList(
      controller: _scrollController,
      shrinkWrap: true,
      // reorder logic
      onReorder: (oldIdx, newIdx) {
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
            side: const BorderSide(
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
              // validator: (ev) => null, // no need to validate..
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
          const Text(
            '타일을 길게 눌러 운동 순서를 변경할수 있습니다.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const Divider(),
        ],
      ),
    );
  }

  // ************ job complete buttons ************ //
  Widget jobCompleteRow(ThemeData themeData) {
    // print('create jobcomplete row!');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFloatingButton(
          name: !widget.isForRoutine
              ? '운동기록 저장'
              : (widget.isRawInsert ? '루틴 저장하기' : '수정완료'),
          onPressed: _onSave,
          color: themeData.primaryColor,
        ),
        if (widget.isForRoutine && !widget.isRawInsert)
          CustomFloatingButton(
            name: '루틴삭제',
            onPressed: _onDeleteRoutine,
            color: themeData.primaryColor,
          ),
      ],
    );
  }
}
