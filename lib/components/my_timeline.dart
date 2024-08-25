import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'event_card.dart';

class MyTimeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final Widget eventContent;

  MyTimeline(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.eventContent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.3,
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: LineStyle(
            color: isPast ? Colors.purple : Colors.blue,
            thickness: 6,
          ),
          indicatorStyle: IndicatorStyle(
            width: 40,
            color: isPast ? Colors.purple : Colors.grey,
            padding: EdgeInsets.all(8),
            iconStyle: IconStyle(
              color: Colors.white,
              iconData: Icons.done,
            ),
          ),
          endChild: EventCard(
            isPast: isPast,
            child: eventContent,
          ),
        ));
  }
}
