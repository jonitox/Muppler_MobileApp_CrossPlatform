import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

class EventList extends StatelessWidget {
  final List selectedEvents;
  final bool isDateVisible;
  final bool isDeleteVisible;
  final Function deleteEvent;

  EventList({
    @required this.selectedEvents,
    this.isDateVisible = false,
    this.deleteEvent,
    this.isDeleteVisible = true,
  });

  // build Event Tile
  Widget _buildEventTile(test) {
    final Event event = test;
    return Card(
      elevation: 4,
      color: Colors.grey,
      child: Container(
        decoration: BoxDecoration(
          border: Border(),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDateVisible) Text(DateFormat.Md().format(event.date)),
            Row(
              // mainAxisAlignment: MainAxis,
              children: [
                Expanded(child: Center(child: Text(event.exercise))),
                if (isDeleteVisible) Icon(Icons.edit),
                if (isDeleteVisible)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteEvent(event.id),
                  ),
              ],
            ),
            ...(event.sets)
                .asMap()
                .entries
                .map(
                  (entry) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${entry.key + 1} 세트'),
                      Text('${entry.value.weight} Kg'),
                      Text('${entry.value.rep} 회'),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build EventList!');
    return ListView(
      children: selectedEvents.map((event) => _buildEventTile(event)).toList(),
    );
  }
}
