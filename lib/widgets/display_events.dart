import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/exercises.dart';
import '../providers/calendar_state.dart';
import '../providers/filters.dart';
import '../screens/edit_event_screen.dart';
import '../models/event.dart';

// ************ events list to display ************ //
class DisplayEvents extends StatelessWidget {
  final bool isDailyEvents; // in home screen
  final bool isTodayEvents; // in calendar screen
  final bool isTrackedEvents; // in tracking screen
  final String exerciseId;
  DisplayEvents({
    this.isDailyEvents = false,
    this.isTodayEvents = false,
    this.isTrackedEvents = false,
    this.exerciseId,
  });
// ************ build event list ************ //
  @override
  Widget build(BuildContext context) {
    // print('build display events!');
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
              isDailyEvents
                  ? '기록한 운동이 없습니다.'
                  : (isTodayEvents ? '오늘은 계획된 운동이 없습니다!' : '기록 없음'),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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

// ************ events tile ************ //
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
  // init state
  @override
  void initState() {
    isHide = true;
    exercises = Provider.of<Exercises>(context, listen: false);
    super.initState();
  }

  // ************ build event tile ************ //
  @override
  Widget build(BuildContext context) {
    return Card(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tileTitle,
            const Divider(
              thickness: 1.5,
            ),
            eventSummary,
            const Divider(
              thickness: 1.5,
            ),
            if (!isHide) eventSetDetails,
            if (!isHide) memoBox,
          ],
        ),
      ),
    );
  }

  // remove fractional parts of double
  String removeDecimalZeroFormat(String n) {
    return n.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  // ************ title of event tile ************ //
  Widget get tileTitle {
    final exercise = exercises.getExercise(widget.event.exerciseId);
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              // hide/reveal button
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: isHide
                        ? Icon(Icons.expand_more)
                        : Icon(Icons.expand_less),
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
              // date info when tracking
              if (widget.isTracked)
                Expanded(
                  child: Text(
                    '${DateFormat('yyyy년\n M월 dd일', 'ko').format(widget.event.date)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Chip(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                label: Text(
                  exercise.target.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: themeData.primaryColor),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: deviceSize.width * 0.4,
                child: Text(
                  exercise.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        // edit button
        if (!widget.isTracked)
          IconButton(
            icon: const Icon(Icons.edit),
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
        const Divider(
          thickness: 1.5,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.all(5),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            widget.event.memo.trim().length > 0
                ? widget.event.memo
                : 'MEMO (없음)',
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ); // 컨
  }

  // ************ event Summary ************ //
  Widget get eventSummary {
    final vol = widget.event.volume;
    final volText = (vol is double
            ? removeDecimalZeroFormat(vol.toStringAsFixed(1))
            : vol.toString()) +
        (vol is double ? 'kg' : '개');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '총 세트 수 : ${widget.event.setDetails.length}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        Text(
          'Volume : $volText',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
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
                  Text(
                      '${removeDecimalZeroFormat(widget.event.setDetails[idx].weight.toStringAsFixed(1))}Kg'),
                Text('${widget.event.setDetails[idx].rep}회'),
              ],
            ),
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: widget.event.setDetails.length);
  }
}
