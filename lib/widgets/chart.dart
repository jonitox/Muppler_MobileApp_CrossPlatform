import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../providers/events.dart';
import '../models/event.dart';

// ************ chart(그래프로 보기) ************ //
class Chart extends StatelessWidget {
  final String selectedId;
  Chart(this.selectedId);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final sortedEvents = Provider.of<Events>(context, listen: false)
        .getTrackedEvents(selectedId);
    if (sortedEvents.length == 0) {
      return const Center(
        child: const Text('기록 없음'),
      );
    }
    final seriesList = [
      charts.Series<Event, DateTime>(
        id: 'chart',
        displayName: '볼륨',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (Event ev, _) =>
            DateTime(ev.date.year, ev.date.month, ev.date.day),
        measureFn: (Event ev, _) => ev.volume,
        data: sortedEvents,
      )
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '볼륨',
            style: TextStyle(color: themeData.primaryColor),
          ),
          Expanded(
            child: charts.TimeSeriesChart(
              seriesList,
              animate: true,

              defaultRenderer: charts.BarRendererConfig<DateTime>(),

              // It is recommended that default interactions be turned off if using bar
              // renderer, because the line point highlighter is the default for time
              // series chart.
              defaultInteractions: false,
              // If default interactions were removed, optionally add select nearest
              // and the domain highlighter that are typical for bar charts.
              behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '날짜',
              style: TextStyle(color: themeData.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
