import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/weekly_history_event_model.dart';

/////////////////////////////////////////////////////////////////////////////////////////

class WeeklyHistoryAlert extends ConsumerStatefulWidget {
  const WeeklyHistoryAlert({super.key, required this.weeklyHistoryEvent});

  final List<WeeklyHistoryEventModel> weeklyHistoryEvent;

  @override
  ConsumerState<WeeklyHistoryAlert> createState() => _WeeklyHistoryAlertState();
}

class _WeeklyHistoryAlertState extends ConsumerState<WeeklyHistoryAlert> with ControllersMixin<WeeklyHistoryAlert> {
  int weeklyHistoryStartTime = 5;
  int endHour = 24;

  double pxPerMinute = 1.0;

  double gutter = 56;

  ScrollController gutterVertical = ScrollController();

  double gridWidth = 0;

  double gridHeight = 0;

  ///
  @override
  void initState() {
    super.initState();

    gridHeight = (endHour - weeklyHistoryStartTime) * 60 * pxPerMinute;
  }

  ///
  @override
  Widget build(BuildContext context) {
    gridWidth = context.screenSize.width / 10;

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.maxFinite,

        padding: const EdgeInsets.only(bottom: 20),

        child: Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification n) {
                if (n.metrics.axis == Axis.vertical) {
                  final double target = n.metrics.pixels;
                  if (gutterVertical.hasClients) {
                    gutterVertical.jumpTo(target.clamp(0.0, gutterVertical.position.maxScrollExtent));
                  }
                }
                return false;
              },

              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: gutter + 7 * gridWidth,
                  child: WeeklyScheduleView(
                    startHour: weeklyHistoryStartTime,
                    endHour: endHour,
                    pxPerMinute: pxPerMinute,
                    events: widget.weeklyHistoryEvent,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: appParamState.weeklyHistoryHeaderHeight,
              bottom: 0,
              width: gutter,
              child: IgnorePointer(
                child: SingleChildScrollView(
                  controller: gutterVertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: gridHeight,
                    child: TimeLabels(startHour: weeklyHistoryStartTime, endHour: endHour, pxPerMinute: pxPerMinute),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////

class WeeklyScheduleView extends ConsumerStatefulWidget {
  const WeeklyScheduleView({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.pxPerMinute,
    this.events = const <WeeklyHistoryEventModel>[],
  });

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  final List<WeeklyHistoryEventModel> events;

  @override
  ConsumerState<WeeklyScheduleView> createState() => _WeeklyScheduleViewState();
}

class _WeeklyScheduleViewState extends ConsumerState<WeeklyScheduleView> with ControllersMixin<WeeklyScheduleView> {
  int weeklyHistoryStartTime = 5;

  ///
  @override
  Widget build(BuildContext context) {
    final int totalMinutes = (widget.endHour - widget.startHour) * 60;

    final double gridHeight = totalMinutes * widget.pxPerMinute;

    const double timeGutterWidth = 56.0;

    return Column(
      children: <Widget>[
        SizedBox(
          height: appParamState.weeklyHistoryHeaderHeight,
          child: Row(
            children: <Widget>[
              const SizedBox(width: timeGutterWidth),

              Expanded(child: WeekHeader(date: appParamState.weeklyHistorySelectedDate)),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: gridHeight,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: timeGutterWidth,
                    child: TimeLabels(startHour: weeklyHistoryStartTime, endHour: 24, pxPerMinute: 1),
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final double colW = constraints.maxWidth / 7;

                        final List<PlacedItemModel> placed = _placeWeekly(widget.events, colW);

                        return Stack(
                          children: <Widget>[
                            CustomPaint(
                              size: Size(constraints.maxWidth, gridHeight),
                              painter: TimeTableGrid(
                                startHour: widget.startHour,
                                endHour: widget.endHour,
                                pxPerMinute: widget.pxPerMinute,
                                columnWidth: colW,
                              ),
                            ),

                            ...placed.map((PlacedItemModel placedItemModel) {
                              final WeeklyHistoryEventModel e = placedItemModel.event;

                              final double perWidth = colW / placedItemModel.columnCount;

                              const double gap = 2.0;

                              final double top = (e.startMinutes - widget.startHour * 60) * widget.pxPerMinute;

                              final double left = e.dayIndex * colW + placedItemModel.columnIndex * perWidth;

                              final double width = perWidth - gap * 2;

                              final double height = (e.endMinutes - e.startMinutes) * widget.pxPerMinute;

                              return Positioned(
                                top: top.clamp(0, gridHeight - 1),
                                left: left + gap,
                                width: width,
                                height: height,

                                child: DisplayHistoryItem(event: e),
                              );
                            }),
                            const NowIndicatorLine(startHour: 3, endHour: 24, pxPerMinute: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////

class TimeTableGrid extends CustomPainter {
  TimeTableGrid({required this.startHour, required this.endHour, required this.pxPerMinute, required this.columnWidth});

  final int startHour, endHour;
  final double pxPerMinute, columnWidth;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final Paint hour = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1;

    final Paint major = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.4)
      ..strokeWidth = 1.2;

    for (int h = startHour; h <= endHour; h++) {
      final double y = (h - startHour) * 60 * pxPerMinute;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), (h % 3 == 0) ? major : hour);
    }

    final Paint v = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1;

    for (int i = 0; i <= 7; i++) {
      final double x = i * columnWidth;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), v);
    }

    final Paint weekend = Paint()..color = Colors.white.withValues(alpha: 0.1);

    canvas.drawRect(Rect.fromLTWH(0, 0, columnWidth, size.height), weekend);

    canvas.drawRect(Rect.fromLTWH(6 * columnWidth, 0, columnWidth, size.height), weekend);
  }

  ///
  @override
  bool shouldRepaint(covariant TimeTableGrid old) =>
      old.startHour != startHour ||
      old.endHour != endHour ||
      old.pxPerMinute != pxPerMinute ||
      old.columnWidth != columnWidth;
}

/////////////////////////////////////////////////////////////////////////////////////////

class NowIndicatorLine extends StatelessWidget {
  const NowIndicatorLine({super.key, required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour, endHour;

  final double pxPerMinute;

  ///
  @override
  Widget build(BuildContext context) {
    final TimeOfDay now = TimeOfDay.now();

    final int nowMinutes = now.hour * 60 + now.minute;

    final int s = startHour * 60, e = endHour * 60;

    if (nowMinutes < s || nowMinutes > e) {
      return const SizedBox.shrink();
    }

    final double top = (nowMinutes - s) * pxPerMinute;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: IgnorePointer(child: Container(height: 2, color: Colors.redAccent.withValues(alpha: 0.4))),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////

class WeekHeader extends StatefulWidget {
  const WeekHeader({super.key, required this.date});

  final String date;

  @override
  State<WeekHeader> createState() => _WeekHeaderState();
}

class _WeekHeaderState extends State<WeekHeader> {
  Map<String, String> weekDateMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      final String youbi = DateTime.parse(widget.date).add(Duration(days: i)).youbiStr;
      final String ymd = DateTime.parse(widget.date).add(Duration(days: i)).yyyymmdd;

      weekDateMap[youbi] = ymd;
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final String displayWeekDayStr = '${widget.date} / ${weekDateMap.entries.last.value}';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double colW = constraints.maxWidth / 7;

        return Column(
          children: <Widget>[
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(displayWeekDayStr), const SizedBox.shrink()],
            ),

            const SizedBox(height: 5),

            Row(
              // ignore: always_specify_types
              children: List.generate(7, (int i) {
                final String youbi = _dayLabels[i];

                String year = '';
                String monthDay = '';

                if (weekDateMap[youbi] != null) {
                  year = weekDateMap[youbi]!.split('-')[0];
                  monthDay = '${weekDateMap[youbi]!.split('-')[1]}-${weekDateMap[youbi]!.split('-')[2]}';
                }

                return Container(
                  alignment: Alignment.center,
                  width: colW,

                  child: DefaultTextStyle(
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),

                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 10),
                      child: Column(children: <Widget>[Text(year), Text(monthDay), Text(youbi.substring(0, 3))]),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

///
const List<String> _dayLabels = <String>['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

/////////////////////////////////////////////////////////////////////////////////////////

class DisplayHistoryItem extends StatelessWidget {
  const DisplayHistoryItem({super.key, required this.event});

  final WeeklyHistoryEventModel event;

  ///
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),

      child: Material(
        color: event.color.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          child: Text(event.title, maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////

class TimeLabels extends StatelessWidget {
  const TimeLabels({super.key, required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  ///
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    for (int h = startHour; h <= endHour; h++) {
      final double top = (h - startHour) * 60 * pxPerMinute;

      children.add(
        Positioned(
          top: top - 8,
          left: 4,
          child: Text('${h.toString().padLeft(2, '0')}:00', style: const TextStyle(fontSize: 11, color: Colors.white)),
        ),
      );
    }

    return Stack(children: children);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////

class PlacedItemModel {
  const PlacedItemModel({required this.event, required this.columnIndex, required this.columnCount});

  final WeeklyHistoryEventModel event;

  final int columnIndex, columnCount;
}

List<PlacedItemModel> _placeWeekly(List<WeeklyHistoryEventModel> events, double columnWidth) {
  final Map<int, List<WeeklyHistoryEventModel>> byDay = <int, List<WeeklyHistoryEventModel>>{};

  for (final WeeklyHistoryEventModel e in events) {
    byDay.putIfAbsent(e.dayIndex, () => <WeeklyHistoryEventModel>[]).add(e);
  }

  final List<PlacedItemModel> placedAll = <PlacedItemModel>[];

  for (final MapEntry<int, List<WeeklyHistoryEventModel>> entry in byDay.entries) {
    final List<WeeklyHistoryEventModel> dayEvents = <WeeklyHistoryEventModel>[...entry.value]
      ..sort((WeeklyHistoryEventModel a, WeeklyHistoryEventModel b) => a.startMinutes.compareTo(b.startMinutes));

    placedAll.addAll(_placeForOneDay(dayEvents));
  }

  return placedAll;
}

///
List<PlacedItemModel> _placeForOneDay(List<WeeklyHistoryEventModel> events) {
  final List<PlacedItemModel> result = <PlacedItemModel>[];

  int i = 0;

  while (i < events.length) {
    final List<WeeklyHistoryEventModel> cluster = <WeeklyHistoryEventModel>[];

    final List<WeeklyHistoryEventModel> active = <WeeklyHistoryEventModel>[];

    int j = i;

    while (j < events.length) {
      final WeeklyHistoryEventModel e = events[j];

      active.removeWhere((WeeklyHistoryEventModel a) => a.endMinutes <= e.startMinutes);

      if (active.isEmpty && cluster.isNotEmpty) {
        break;
      }

      active.add(e);
      cluster.add(e);
      j++;
    }

    result.addAll(_assignColumns(cluster));

    i = j;
  }
  return result;
}

///
List<PlacedItemModel> _assignColumns(List<WeeklyHistoryEventModel> cluster) {
  final List<WeeklyHistoryEventModel> sorted = <WeeklyHistoryEventModel>[...cluster]
    ..sort((WeeklyHistoryEventModel a, WeeklyHistoryEventModel b) {
      final int c = a.startMinutes.compareTo(b.startMinutes);
      if (c != 0) {
        return c;
      }
      return a.endMinutes.compareTo(b.endMinutes);
    });

  final List<PlacedItemModel> placed = <PlacedItemModel>[];

  final Map<int, WeeklyHistoryEventModel> active = <int, WeeklyHistoryEventModel>{};

  for (final WeeklyHistoryEventModel e in sorted) {
    final List<int> toRemove = <int>[];

    active.forEach((int col, WeeklyHistoryEventModel ev) {
      if (ev.endMinutes <= e.startMinutes) {
        toRemove.add(col);
      }
    });

    // ignore: prefer_foreach
    for (final int col in toRemove) {
      active.remove(col);
    }

    int colIndex = 0;
    while (active.containsKey(colIndex)) {
      colIndex++;
    }

    active[colIndex] = e;

    placed.add(PlacedItemModel(event: e, columnIndex: colIndex, columnCount: 0));
  }

  final int cc = placed.fold<int>(0, (int m, PlacedItemModel p) => (p.columnIndex + 1 > m) ? p.columnIndex + 1 : m);

  return placed
      .map((PlacedItemModel p) => PlacedItemModel(event: p.event, columnIndex: p.columnIndex, columnCount: cc))
      .toList();
}
