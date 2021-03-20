import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';

import '../providers/events.dart';

import '../widgets/event_field.dart';

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
  final weightController = TextEditingController(); // initState에서 생성해야되나?
  final repController = TextEditingController();

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
    weightController.dispose();
    repController.dispose();
    super.dispose();
  }

  void onCompleteEdit() {
    _key.currentState.save();
    Navigator.of(context).pop();
  }

  void onDeleteEvent() {
    print(event.exerciseId);
    events.deleteEvent(event.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print('build edit event screen!');

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              EventField(
                initialValue: event.copyWith(id: '_'),
                isEdit: true,
                onSaved: (ev) {
                  events.updateEvent(event.id, ev.copyWith(id: event.id));
                },
                validator: (ev) => null,
                weightController: weightController,
                repController: repController,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: onCompleteEdit,
                    child: Text('수정 완료'),
                  ),
                  ElevatedButton(
                    onPressed: onDeleteEvent,
                    child: Text('기록 삭제'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
