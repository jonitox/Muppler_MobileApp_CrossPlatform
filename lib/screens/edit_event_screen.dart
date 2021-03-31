import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../widgets/event_field.dart';
import '../widgets/custom_floating_button.dart';
import '../models/event.dart';

// ************************** Edit event screen ************************* //
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

  // init data
  @override
  void didChangeDependencies() {
    if (isInit) {
      event = ModalRoute.of(context).settings.arguments as Event;
      events = Provider.of<Events>(context, listen: false);
    }
    isInit = false;
    super.didChangeDependencies();
  }

  // ************ build edit event screen ************ //
  @override
  Widget build(BuildContext context) {
    // print('build edit event screen!');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '운동기록 수정',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Column(
            children: [
              eventInfoTile,
              const Divider(
                color: Colors.black,
              ),
              jobCompleteRow,
            ],
          ),
        ),
      ),
    );
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
              content: const Text(
                '기록을 삭제하시겠습니까?',
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
    if (!completeEvents) {
      return;
    }
    events.deleteEvent(event.id);
    Navigator.of(context).pop();
  }

  // ************ event tile to edit ************ //
  Widget get eventInfoTile {
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
            // validator: (ev) => null, // no need to validate..
          ),
        ),
      ),
    );
  }

  // ************ job complete buttons ************ //
  Widget get jobCompleteRow {
    final themeData = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFloatingButton(
          name: '수정완료',
          onPressed: onCompleteEdit,
          color: themeData.primaryColor,
        ),
        CustomFloatingButton(
          name: '기록삭제',
          onPressed: onDeleteEvent,
          color: themeData.primaryColor,
        ),
      ],
    );
  }
}
