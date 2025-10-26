import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

///
int toMinutes(int h, int m) => h * 60 + m;

/////////////////////////////////////////////////////////////////////////////////////////

class WeeklyHistoryAlert extends ConsumerStatefulWidget {
  const WeeklyHistoryAlert({super.key});

  @override
  ConsumerState<WeeklyHistoryAlert> createState() => _WeeklyHistoryAlertState();
}

class _WeeklyHistoryAlertState extends ConsumerState<WeeklyHistoryAlert> with ControllersMixin<WeeklyHistoryAlert> {
  List<ScheduleEventModel> events = <ScheduleEventModel>[];

  int startHour = 3;
  int endHour = 24;
  double pxPerMinute = 1.0;
  double gutter = 56;
  double gridWidth = 40;
  double gridHeight = 0;

  ScrollController gutterVertical = ScrollController();

  double headerHeight = 80;

  ///
  @override
  void initState() {
    super.initState();

    gridHeight = (endHour - startHour) * 60 * pxPerMinute;
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////

    events = <ScheduleEventModel>[
      ScheduleEventModel(dayIndex: 0, startMinutes: toMinutes(8, 0), endMinutes: toMinutes(10, 0), title: '病院'),
      ScheduleEventModel(
        dayIndex: 0,
        startMinutes: toMinutes(10, 0),
        endMinutes: toMinutes(15, 30),
        title: '買い物',
        color: const Color(0xFF26A69A),
      ),

      ScheduleEventModel(dayIndex: 2, startMinutes: toMinutes(10, 0), endMinutes: toMinutes(12, 0), title: '通院'),

      // ScheduleEventModel(
      //   dayIndex: 2,
      //   startMinutes: toMinutes(10, 30),
      //   endMinutes: toMinutes(12, 30),
      //   title: 'オンライン',
      //   color: const Color(0xFF8E24AA),
      // ),
      // ScheduleEventModel(
      //   dayIndex: 2,
      //   startMinutes: toMinutes(11, 0),
      //   endMinutes: toMinutes(12, 0),
      //   title: 'MTG',
      //   color: const Color(0xFFFFA726),
      // ),
      ScheduleEventModel(
        dayIndex: 4,
        startMinutes: toMinutes(13, 15),
        endMinutes: toMinutes(16, 45),
        title: '検診',
        color: const Color(0xFF1E88E5),
      ),
    ];

    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////

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
                    startHour: startHour,
                    endHour: endHour,
                    pxPerMinute: pxPerMinute,
                    events: events,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: headerHeight,
              bottom: 0,
              width: gutter,
              child: IgnorePointer(
                child: SingleChildScrollView(
                  controller: gutterVertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: gridHeight,
                    child: TimeLabels(startHour: startHour, endHour: endHour, pxPerMinute: pxPerMinute),
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

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.pxPerMinute,
    this.events = const <ScheduleEventModel>[],
  });

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  final List<ScheduleEventModel> events;

  // ignore: avoid_field_initializers_in_const_classes
  final double headerHeight = 80;

  ///
  @override
  Widget build(BuildContext context) {
    final int totalMinutes = (endHour - startHour) * 60;

    final double gridHeight = totalMinutes * pxPerMinute;

    const double timeGutterWidth = 56.0;

    return Column(
      children: <Widget>[
        SizedBox(
          height: headerHeight,
          child: const Row(
            children: <Widget>[
              SizedBox(width: timeGutterWidth),

              Expanded(child: WeekHeader()),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: gridHeight,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: timeGutterWidth, child: TimeLabels(startHour: 3, endHour: 24, pxPerMinute: 1)),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final double colW = constraints.maxWidth / 7;

                        final List<PlacedItemModel> placed = _placeWeekly(events, colW);

                        return Stack(
                          children: <Widget>[
                            CustomPaint(
                              size: Size(constraints.maxWidth, gridHeight),
                              painter: TimeTableGrid(
                                startHour: startHour,
                                endHour: endHour,
                                pxPerMinute: pxPerMinute,
                                columnWidth: colW,
                              ),
                            ),

                            ...placed.map((PlacedItemModel placedItemModel) {
                              final ScheduleEventModel e = placedItemModel.event;

                              final double perWidth = colW / placedItemModel.columnCount;

                              const double gap = 2.0;

                              final double top = (e.startMinutes - startHour * 60) * pxPerMinute;

                              final double left = e.dayIndex * colW + placedItemModel.columnIndex * perWidth;

                              final double width = perWidth - gap * 2;

                              final double height = (e.endMinutes - e.startMinutes) * pxPerMinute;

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

class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double colW = constraints.maxWidth / 7;

        return Column(
          children: <Widget>[
            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('xxxxxxxxxxxxx'), SizedBox.shrink()],
            ),

            const SizedBox(height: 5),

            Row(
              // ignore: always_specify_types
              children: List.generate(7, (int i) {
                return Container(
                  alignment: Alignment.center,
                  width: colW,

                  child: DefaultTextStyle(
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),

                    child: Column(children: <Widget>[Text(_dayLabels[i].substring(0, 3)), const Text('99')]),
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

  final ScheduleEventModel event;

  ///
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),

      child: Material(
        color: event.color.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          child: Text(event.title, maxLines: 1, overflow: TextOverflow.clip),
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

  final ScheduleEventModel event;

  final int columnIndex, columnCount;
}

List<PlacedItemModel> _placeWeekly(List<ScheduleEventModel> events, double columnWidth) {
  final Map<int, List<ScheduleEventModel>> byDay = <int, List<ScheduleEventModel>>{};

  for (final ScheduleEventModel e in events) {
    byDay.putIfAbsent(e.dayIndex, () => <ScheduleEventModel>[]).add(e);
  }

  final List<PlacedItemModel> placedAll = <PlacedItemModel>[];

  for (final MapEntry<int, List<ScheduleEventModel>> entry in byDay.entries) {
    final List<ScheduleEventModel> dayEvents = <ScheduleEventModel>[...entry.value]
      ..sort((ScheduleEventModel a, ScheduleEventModel b) => a.startMinutes.compareTo(b.startMinutes));

    placedAll.addAll(_placeForOneDay(dayEvents));
  }

  return placedAll;
}

///
List<PlacedItemModel> _placeForOneDay(List<ScheduleEventModel> events) {
  final List<PlacedItemModel> result = <PlacedItemModel>[];

  int i = 0;

  while (i < events.length) {
    final List<ScheduleEventModel> cluster = <ScheduleEventModel>[];

    final List<ScheduleEventModel> active = <ScheduleEventModel>[];

    int j = i;

    while (j < events.length) {
      final ScheduleEventModel e = events[j];

      active.removeWhere((ScheduleEventModel a) => a.endMinutes <= e.startMinutes);

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
List<PlacedItemModel> _assignColumns(List<ScheduleEventModel> cluster) {
  final List<ScheduleEventModel> sorted = <ScheduleEventModel>[...cluster]
    ..sort((ScheduleEventModel a, ScheduleEventModel b) {
      final int c = a.startMinutes.compareTo(b.startMinutes);
      if (c != 0) {
        return c;
      }
      return a.endMinutes.compareTo(b.endMinutes);
    });

  final List<PlacedItemModel> placed = <PlacedItemModel>[];

  final Map<int, ScheduleEventModel> active = <int, ScheduleEventModel>{};

  for (final ScheduleEventModel e in sorted) {
    final List<int> toRemove = <int>[];

    active.forEach((int col, ScheduleEventModel ev) {
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

/////////////////////////////////////////////////////////////////////////////////////////

class ScheduleEventModel {
  ScheduleEventModel({
    required this.dayIndex,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.color = const Color(0xFF42A5F5),
  });

  final int dayIndex;
  final int startMinutes;
  final int endMinutes;
  final String title;
  final Color color;
}
