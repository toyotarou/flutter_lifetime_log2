import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/work_history_model.dart';
import '../../models/work_time_model.dart';
import '../../models/yearly_history_event.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'work_info_yearly_display_alert.dart';

class WorkInfoMonthlyDisplayAlert extends ConsumerStatefulWidget {
  const WorkInfoMonthlyDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<WorkInfoMonthlyDisplayAlert> createState() => _WorkInfoMonthlyDisplayAlertState();
}

class _WorkInfoMonthlyDisplayAlertState extends ConsumerState<WorkInfoMonthlyDisplayAlert>
    with ControllersMixin<WorkInfoMonthlyDisplayAlert> {
  static const int _itemCount = 100000;
  static const int _initialIndex = _itemCount ~/ 2;

  late final DateTime _baseMonth;
  int currentIndex = _initialIndex;

  Utility utility = Utility();

  ///
  @override
  void initState() {
    super.initState();

    _baseMonth = DateTime.parse('${widget.yearmonth}-01');
  }

  ///
  Widget makeMonthlyWorktimeSlide(int index) {
    final DateTime genDate = monthForIndex(index: index, baseMonth: _baseMonth);

    final bool hasData = appParamState.keepWorkTimeMap.containsKey(
      '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}',
    );

    final String startYearMonth = appParamState.keepWorkHistoryModelMap.keys.reduce(
      (String a, String b) => a.compareTo(b) < 0 ? a : b,
    );

    final int yearRange = DateTime.now().year - startYearMonth.split('-')[0].toInt() + 1;

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.2)),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${genDate.year}-${genDate.month.toString().padLeft(2, '0')}'),

                      if (hasData) ...<Widget>[
                        GestureDetector(
                          onTap: () {
                            appParamNotifier.setSelectedWorkHistoryModel();

                            LifetimeDialog(
                              context: context,
                              widget: WorkInfoYearlyDisplayAlert(
                                startYear: startYearMonth.split('-')[0].toInt(),
                                years: yearRange,
                                initialScrollYear: genDate.year,
                                workInfoList: _buildYearlyHistoryEventsFromHistory(),
                              ),
                            );
                          },
                          child: Icon(Icons.table_chart, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ] else ...<Widget>[const SizedBox.shrink()],
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  if (hasData) ...<Widget>[
                    displayGenbaName(yearmonth: '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}'),
                    const SizedBox(height: 10),
                    Expanded(
                      child: displayMonthlyWorkTimeList(
                        yearmonth: '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ] else ...<Widget>[
                    const Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('no data', style: TextStyle(color: Colors.yellowAccent)),
                              SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayGenbaName({required String yearmonth}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.5))),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('エージェント'),
                  Text(
                    (appParamState.keepWorkTimeMap[yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[yearmonth]!.agentName
                        : '',
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('現場'),
                  Text(
                    (appParamState.keepWorkTimeMap[yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[yearmonth]!.genbaName
                        : '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CarouselSlider.builder(
        itemCount: _itemCount,
        initialPage: _initialIndex,
        slideTransform: const CubeTransform(),
        onSlideChanged: (int index) => setState(() => currentIndex = index),
        slideBuilder: (int index) => makeMonthlyWorktimeSlide(index),
      ),
    );
  }

  ///
  Widget displayMonthlyWorkTimeList({required String yearmonth}) {
    final List<Widget> list = <Widget>[];

    appParamState.keepWorkTimeMap[yearmonth]?.data.forEach((WorkTimeDataModel element) {
      final List<String> exDay = element.day.split('(');
      final String date = '$yearmonth-${exDay[0]}';

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(element.day)),
              Expanded(
                child: Container(alignment: Alignment.center, child: Text(element.start)),
              ),
              Expanded(
                child: Container(alignment: Alignment.center, child: Text(element.end)),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  child: Builder(
                    builder: (_) {
                      final Duration duration = calculateWorkDuration(
                        date: date,
                        start: element.start,
                        end: element.end,
                      );

                      if (duration == Duration.zero) {
                        return const Text('-');
                      }

                      final int hours = duration.inHours;
                      final int minutes = duration.inMinutes.remainder(60);

                      return Text('$hours時間$minutes分');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Duration calculateWorkDuration({required String date, required String start, required String end}) {
    try {
      if (start.isEmpty || end.isEmpty) {
        return Duration.zero;
      }

      final DateTime startTime = DateTime.parse('$date $start:00');
      final DateTime endTime = DateTime.parse('$date $end:00');

      Duration duration = endTime.difference(startTime);

      if (duration.isNegative) {
        return Duration.zero;
      }

      duration -= const Duration(hours: 1);
      return duration.isNegative ? Duration.zero : duration;
    } catch (_) {
      return Duration.zero;
    }
  }

  ///
  DateTime _ymToDate(String ym) => DateTime.parse('${ym.trim()}-01');

  ///
  DateTime _endOfMonth(DateTime d) {
    final DateTime nextMonth = DateTime(d.year, d.month + 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  ///
  List<YearlyHistoryEvent> _buildYearlyHistoryEventsFromHistory() {
    if (appParamState.keepWorkHistoryModelMap.isEmpty) {
      return const <YearlyHistoryEvent>[];
    }

    final List<MapEntry<String, WorkHistoryModel>> entries = appParamState.keepWorkHistoryModelMap.entries.toList()
      ..sort((MapEntry<String, WorkHistoryModel> a, MapEntry<String, WorkHistoryModel> b) => a.key.compareTo(b.key));

    final List<YearlyHistoryEvent> events = <YearlyHistoryEvent>[];
    final List<Color> colors = utility.getFortyEightColor();

    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

    for (int i = 0; i < entries.length; i++) {
      final MapEntry<String, WorkHistoryModel> currentEntry = entries[i];
      final WorkHistoryModel cur = currentEntry.value;

      final String agentName = cur.workContractName;
      final String genbaName = cur.workTruthName;

      final bool isGap = agentName.trim() == '-' && genbaName.trim() == '-';

      final DateTime start = _ymToDate(currentEntry.key);

      late final DateTime end;
      if (i < entries.length - 1) {
        final MapEntry<String, WorkHistoryModel> nextEntry = entries[i + 1];
        final DateTime nextStart = _ymToDate(nextEntry.key);

        final DateTime lastMonth = addMonths(nextStart, -1);
        end = _endOfMonth(lastMonth);
      } else {
        final bool isStartedBeforeOrThisMonth =
            (start.year < currentYear) || (start.year == currentYear && start.month <= currentMonth);

        if (isStartedBeforeOrThisMonth) {
          final DateTime currentMonthStart = DateTime(currentYear, currentMonth);
          end = _endOfMonth(currentMonthStart);
        } else {
          end = _endOfMonth(start);
        }
      }

      if (isGap) {
        continue;
      }

      events.add(
        YearlyHistoryEvent(
          start: start,
          end: end,
          color: colors[events.length % colors.length],
          agentName: agentName,
          genbaName: genbaName,
        ),
      );
    }

    events.sort((YearlyHistoryEvent a, YearlyHistoryEvent b) => a.start.compareTo(b.start));

    return events;
  }
}
