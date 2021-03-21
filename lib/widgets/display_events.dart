import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../screens/edit_event_screen.dart';

import '../providers/events.dart';
import '../providers/exercises.dart';
import '../providers/calendar_state.dart';
import '../providers/filters.dart';

import '../models/event.dart';

class DisplayEvents extends StatelessWidget {
  final bool isDailyEvents;
  final bool isTodayEvents;
  final bool isTrackedEvents;
  final String exerciseId;
  DisplayEvents({
    this.isDailyEvents = false,
    this.isTodayEvents = false,
    this.isTrackedEvents = false,
    this.exerciseId,
  });
// ************ events list to display ************ //
  @override
  Widget build(BuildContext context) {
    print('build display events!');
    final events = Provider.of<Events>(context);
    final filters = Provider.of<Filters>(context);
    List<Event> eventsToShow;
    if (isDailyEvents) {
      eventsToShow = events.getTodayEvents(
          Provider.of<CalendarState>(context).day, filters.items);
    } else if (isTodayEvents) {
      eventsToShow = events.getTodayEvents(DateTime.now(), null);
    } else {
      eventsToShow = events.getTrackedEvents(exerciseId);
    }

    return eventsToShow.length == 0
        ? Center(
            heightFactor: 3,
            child: Text(
              isDailyEvents ? '계획된 운동이 없습니다.' : '오늘은 계획된 운동이 없습니다!',
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            shrinkWrap: isDailyEvents || isTodayEvents ? true : false,
            itemCount: eventsToShow.length,
            itemBuilder: (ctx, i) => EventTile(
              event: eventsToShow[i],
              key: ValueKey(eventsToShow[i].id),
              isTracked: isTrackedEvents,
            ),
          );
  }
}

// ************ events list to display ************ //
class EventTile extends StatefulWidget {
  final Event event;
  final Key key;
  final bool isTracked;
  EventTile({this.event, this.key, this.isTracked}) : super(key: key);
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool isHide;
  Exercises exercises;
  @override
  void initState() {
    isHide = true;
    exercises = Provider.of<Exercises>(context, listen: false);
    super.initState();
  }

  // ************ title of event tile ************ //
  Widget get tileTitle {
    final exercise = exercises.getExercise(widget.event.exerciseId);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              IconButton(
                // constraints: BoxConstraints(maxHeight: 30),
                icon:
                    isHide ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                onPressed: () => setState(() {
                  isHide = !isHide;
                }),
              ),
              if (widget.isTracked)
                Expanded(
                  child: Text(
                    '${DateFormat('yyyy년 M월 dd일', 'ko').format(widget.event.date)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  exercise.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        if (!widget.isTracked)
          IconButton(
            icon: Icon(Icons.more_horiz_outlined),
            onPressed: () => Navigator.of(context)
                .pushNamed(EditEventScreen.routeName, arguments: widget.event),
          ),
      ],
    );
  }

  // ************ memo box ************ //
  Widget get memoBox {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.all(5),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            widget.event.memo.trim().length > 0 ? widget.event.memo : 'MEMO',
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Divider(
          thickness: 1.5,
        ),
      ],
    ); // 컨
  }

  // ************ event Summary ************ //
  Widget get eventSummary {
    final vol = widget.event.volume.toString() +
        (widget.event.type == DetailType.onlyRep ? '개' : 'kg');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('세트 수 : ${widget.event.setDetails.length}'),
        Text('Volume : $vol')
      ],
    );
  }

  // ************ event sets details ************ //
  Widget get eventSetDetails {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (ctx, idx) => Row(
              key: ValueKey(idx),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${idx + 1}세트'),
                if (widget.event.type == DetailType.basic)
                  Text('${widget.event.setDetails[idx].weight}Kg'),
                Text('${widget.event.setDetails[idx].rep}회'),
              ],
            ),
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: widget.event.setDetails.length);
  }

  // ************ build event tile ************ //
  @override
  Widget build(BuildContext context) {
    return Card(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tileTitle,

            Divider(
              thickness: 1.5,
            ),

            if (!isHide) memoBox,

            eventSummary,

            Divider(
              thickness: 1.5,
            ),

            if (!isHide) eventSetDetails,
            // ...widget.event.setDetails.asMap().entries.map((entry) {
            //   final idx = entry.key;
            //   final s = entry.value;
            //   return Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text('${idx + 1}세트'),
            //     if (widget.event.type == DetailType.basic)
            //       Text('${s.weight}Kg'),
            //     Text('${s.rep}회'),
            //   ],
            // );
            // }).toList(),
          ],
        ),
      ),
    );
  }
}