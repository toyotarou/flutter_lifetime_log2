import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/weekly_history_badge_model.dart';
import '../../models/weekly_history_event_model.dart';
import '../../utility/functions.dart';
import '../parts/icon_toolchip_display_overlay.dart';
import '../parts/lifetime_dialog.dart';
import 'lifetime_geoloc_map_display_alert.dart';
import 'lifetime_input_alert.dart';
import 'stamp_rally_date_alert.dart';

// import 'stamp_rally_metro_20_anniversary_alert.dart';
// import 'stamp_rally_metro_all_station_alert.dart';
//
//
//

/////////////////////////////////////////////////////////////////////////////////////////

class WeeklyHistoryAlert extends ConsumerStatefulWidget {
  const WeeklyHistoryAlert({
    super.key,
    required this.weeklyHistoryEvent,
    required this.weeklyHistoryBadge,
    required this.isNeedGeolocMapDisplayHeight,
    required this.isNeedStationStampDisplayHeight,
  });

  final List<WeeklyHistoryEventModel> weeklyHistoryEvent;
  final List<WeeklyHistoryBadgeModel> weeklyHistoryBadge;
  final bool isNeedGeolocMapDisplayHeight;
  final bool isNeedStationStampDisplayHeight;

  @override
  ConsumerState<WeeklyHistoryAlert> createState() => _WeeklyHistoryAlertState();
}

class _WeeklyHistoryAlertState extends ConsumerState<WeeklyHistoryAlert> with ControllersMixin<WeeklyHistoryAlert> {
  int weeklyHistoryStartTime = 0;

  int endHour = 24;

  double pxPerMinute = 1.0;

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
    gridWidth = context.screenSize.width / 11;

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
                  width: appParamState.gutterWidth + 7 * gridWidth,
                  child: WeeklyScheduleView(
                    startHour: weeklyHistoryStartTime,
                    endHour: endHour,
                    pxPerMinute: pxPerMinute,
                    events: widget.weeklyHistoryEvent,
                    badges: widget.weeklyHistoryBadge,
                    isNeedGeolocMapDisplayHeight: widget.isNeedGeolocMapDisplayHeight,
                    isNeedStationStampDisplayHeight: widget.isNeedStationStampDisplayHeight,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              top:
                  appParamState.weeklyHistoryHeaderHeight +
                  (widget.isNeedGeolocMapDisplayHeight ? 30 : 0) +
                  (widget.isNeedStationStampDisplayHeight ? 30 : 0),
              bottom: 0,
              width: appParamState.gutterWidth,
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
    this.badges = const <WeeklyHistoryBadgeModel>[],
    required this.isNeedGeolocMapDisplayHeight,
    required this.isNeedStationStampDisplayHeight,
  });

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  final List<WeeklyHistoryEventModel> events;

  final List<WeeklyHistoryBadgeModel> badges;

  final bool isNeedGeolocMapDisplayHeight;

  final bool isNeedStationStampDisplayHeight;

  @override
  ConsumerState<WeeklyScheduleView> createState() => _WeeklyScheduleViewState();
}

class _WeeklyScheduleViewState extends ConsumerState<WeeklyScheduleView> with ControllersMixin<WeeklyScheduleView> {
  int weeklyHistoryStartTime = 0;

  List<GlobalKey> globalKeyList = <GlobalKey>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    globalKeyList = List.generate(1000, (int index) => GlobalKey());
  }

  ///
  @override
  Widget build(BuildContext context) {
    final int totalMinutes = (widget.endHour - widget.startHour) * 60;

    final double gridHeight = totalMinutes * widget.pxPerMinute;

    return Column(
      children: <Widget>[
        SizedBox(
          height:
              appParamState.weeklyHistoryHeaderHeight +
              (widget.isNeedGeolocMapDisplayHeight ? 25 : 0) +
              (widget.isNeedStationStampDisplayHeight ? 25 : 0),
          child: Row(
            children: <Widget>[
              SizedBox(width: appParamState.gutterWidth),

              Expanded(
                child: WeekHeader(
                  date: appParamState.weeklyHistorySelectedDate,
                  isNeedGeolocMapDisplayHeight: widget.isNeedGeolocMapDisplayHeight,
                  isNeedStationStampDisplayHeight: widget.isNeedStationStampDisplayHeight,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: gridHeight,
              child: Row(
                children: <Widget>[
                  SizedBox(width: appParamState.gutterWidth),

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

                            ...displayWeeklyHistoryBadge(
                              timeGutterWidth: appParamState.gutterWidth,

                              gridHeight: gridHeight,
                              colW: colW,
                            ).map((Widget e) => e),

                            NowIndicatorLine(startHour: weeklyHistoryStartTime, endHour: 24, pxPerMinute: 1),
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

  ///
  List<Widget> displayWeeklyHistoryBadge({
    required double timeGutterWidth,

    required double gridHeight,
    required double colW,
  }) {
    final List<Widget> list = <Widget>[];

    const double size = 20.0;

    for (int i = 0; i < widget.badges.length; i++) {
      final double top = (widget.badges[i].minutesOfDay - widget.startHour * 60) * widget.pxPerMinute - size / 2;

      final double left = widget.badges[i].dayIndex * colW + (colW - size) / 2;

      list.add(
        Positioned(
          key: globalKeyList[i],

          top: top.clamp(0, gridHeight - size),
          left: left,
          width: size,
          height: size,
          child: Tooltip(
            message: widget.badges[i].tooltip ?? 'badge',

            child: GestureDetector(
              onTap: () {
                iconToolChipDisplayOverlay(
                  type: 'weekly_history_alert_badge',
                  context: context,
                  buttonKey: globalKeyList[i],
                  message: widget.badges[i].tooltip ?? 'badge',
                  displayDuration: const Duration(seconds: 2),

                  dayIndex: widget.badges[i].dayIndex,
                  timeGutterWidth: timeGutterWidth,
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[BoxShadow(blurRadius: 3, color: Color(0x33000000))],
                ),

                alignment: Alignment.center,

                child: Icon(widget.badges[i].icon, size: 14, color: widget.badges[i].color),
              ),
            ),
          ),
        ),
      );
    }

    return list;
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

class WeekHeader extends ConsumerStatefulWidget {
  const WeekHeader({
    super.key,
    required this.date,
    required this.isNeedGeolocMapDisplayHeight,
    required this.isNeedStationStampDisplayHeight,
  });

  final String date;
  final bool isNeedGeolocMapDisplayHeight;
  final bool isNeedStationStampDisplayHeight;

  @override
  ConsumerState<WeekHeader> createState() => _WeekHeaderState();
}

class _WeekHeaderState extends ConsumerState<WeekHeader> with ControllersMixin<WeekHeader> {
  Map<String, String> weeklyHistoryDisplayWeekDate = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    weeklyHistoryDisplayWeekDate = getWeeklyHistoryDisplayWeekDate(date: widget.date);
  }

  ///
  @override
  Widget build(BuildContext context) {
    final String displayWeekDayStr = '${widget.date} / ${weeklyHistoryDisplayWeekDate.entries.last.value}';

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

                String date = '';

                if (weeklyHistoryDisplayWeekDate[youbi] != null) {
                  year = weeklyHistoryDisplayWeekDate[youbi]!.split('-')[0];
                  monthDay =
                      '${weeklyHistoryDisplayWeekDate[youbi]!.split('-')[1]}-${weeklyHistoryDisplayWeekDate[youbi]!.split('-')[2]}';

                  date = '$year-$monthDay';
                }

                return Container(
                  alignment: Alignment.center,
                  width: colW,

                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          LifetimeDialog(
                            context: context,
                            widget: LifetimeInputAlert(
                              date: weeklyHistoryDisplayWeekDate[youbi]!,
                              dateLifetime: appParamState.keepLifetimeMap[weeklyHistoryDisplayWeekDate[youbi]],
                              isReloadHomeScreen: false,
                            ),
                          );
                        },

                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
                          padding: const EdgeInsets.all(2),

                          child: DefaultTextStyle(
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 10),

                            child: Column(children: <Widget>[Text(year), Text(monthDay), Text(youbi.substring(0, 3))]),
                          ),
                        ),
                      ),

                      if (widget.isNeedGeolocMapDisplayHeight) ...<Widget>[
                        SizedBox(
                          height: 30,
                          child: (appParamState.keepGeolocMap[date] != null)
                              ? GestureDetector(
                                  child: Icon(
                                    Icons.map,
                                    size: 20,
                                    color: (appParamState.weeklyHistorySelectedDate == date)
                                        ? Colors.yellowAccent.withValues(alpha: 0.4)
                                        : Colors.white.withValues(alpha: 0.4),
                                  ),
                                  onTap: () {
                                    appParamNotifier.setWeeklyHistorySelectedDate(date: date);

                                    appParamNotifier.setSelectedGeolocTime(time: '');

                                    LifetimeDialog(
                                      context: context,
                                      widget: LifetimeGeolocMapDisplayAlert(
                                        date: date,
                                        geolocList: appParamState.keepGeolocMap[date],
                                        temple: appParamState.keepTempleMap[date],
                                        transportation: appParamState.keepTransportationMap[date],
                                      ),

                                      executeFunctionWhenDialogClose: true,
                                      from: 'WeeklyHistoryAlert',
                                      ref: ref,
                                    );
                                  },
                                )
                              : null,
                        ),
                      ],

                      if (widget.isNeedStationStampDisplayHeight) ...<Widget>[
                        SizedBox(
                          height: 30,
                          child:
                              (appParamState.keepStampRallyMetroAllStationMap[date] != null ||
                                  appParamState.keepStampRallyMetro20AnniversaryMap[date] != null)
                              ? GestureDetector(
                                  child: Icon(
                                    FontAwesomeIcons.stamp,
                                    size: 15,
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                  onTap: () {
                                    LifetimeDialog(
                                      context: context,
                                      widget: (appParamState.keepStampRallyMetroAllStationMap[date] != null)
                                          ? StampRallyDateAlert(date: date, kind: StampRallyAlertKind.metroAllStation)
                                          : StampRallyDateAlert(
                                              date: date,
                                              kind: StampRallyAlertKind.metro20Anniversary,
                                            ),
                                    );
                                  },
                                )
                              : null,
                        ),
                      ],
                    ],
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

  //////////

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
