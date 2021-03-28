import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';

import '../providers/events.dart';

import '../widgets/event_field.dart';
import '../widgets/custom_floating_button.dart';

class EditEventScreen extends StatefulWidget {
  static const routeName = '/edit_event_screen';

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  Event event;
  Events events;
  bool isInit = true;
  final _key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (isInit) {
      event = ModalRoute.of(context).settings.arguments as Event;
      events = Provider.of<Events>(context, listen: false);
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('dispose edit event screen!');
    super.dispose();
  }

  // ************ complete edition ************ //
  void onCompleteEdit() {
    _key.currentState.save();
    Navigator.of(context).pop();
  }

  // ************  delete event ************ //
  Future<void> onDeleteEvent() async {
    final completeEvents = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(
                '기록을 삭제하시겠습니까?',
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
    events.deleteEvent(event.id);
    Navigator.of(context).pop();
  }

  // ************ event tile to edit ************ //
  Widget get eventInfo {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: EventField(
            initialValue: event.copyWith(id: '_'),
            isEdit: true,
            onSaved: (ev) {
              events.updateEvent(event.id, ev.copyWith(id: event.id));
            },
            validator: (ev) => null,
          ),
        ),
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
          name: '수정완료',
          onPressed: onCompleteEdit,
          color: Colors.teal,
        ),
        CustomFloatingButton(
          name: '기록삭제',
          onPressed: onDeleteEvent,
          color: Colors.teal,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build edit event screen!');

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('운동기록 수정'),
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Column(
            children: [
              eventInfo,
              Divider(
                color: Colors.black,
              ),
              jobCompleteRow,
            ],
          ),
        ),
      ),
    );
  }
}
