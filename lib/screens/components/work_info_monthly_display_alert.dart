import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/work_history_model.dart';
import '../../models/salary_model.dart';
import '../../models/work_time_model.dart';
import '../../models/yearly_history_event.dart';
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
  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    final String startYearMonth = appParamState.keepWorkHistoryModelMap.keys.reduce(
      (String a, String b) => a.compareTo(b) < 0 ? a : b,
    );

    final int yearRange = DateTime.now().year - startYearMonth.split('-')[0].toInt() + 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.yearmonth),
                    GestureDetector(
                      onTap: () {
                        appParamNotifier.setSelectedWorkHistoryModel();

                        LifetimeDialog(
                          context: context,
                          widget: WorkInfoYearlyDisplayAlert(
                            startYear: startYearMonth.split('-')[0].toInt(),
                            years: yearRange,
                            initialScrollYear: widget.yearmonth.split('-')[0].toInt(),
                            workInfoList: _buildYearlyHistoryEventsFromHistory(),
                          ),
                        );
                      },
                      child: Icon(Icons.table_chart, color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                displayGenbaName(),

                const SizedBox(height: 10),

                Expanded(child: displayMonthlyWorkTimeList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Builder(
                      builder: (_) {
                        int salary = 0;
                        appParamState.keepSalaryMap.forEach((String key, List<SalaryModel> value) {
                          if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
                            for (final SalaryModel element in value) {
                              salary += element.salary;
                            }
                          }
                        });

                        return (salary == 0)
                            ? const SizedBox.shrink()
                            : Text(
                                '収入：${salary.toString().toCurrency()}',
                                style: const TextStyle(color: Colors.yellowAccent),
                              );
                      },
                    ),
                    buildTotalWorkDurationText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGenbaName() {
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
                    (appParamState.keepWorkTimeMap[widget.yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[widget.yearmonth]!.agentName
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
                    (appParamState.keepWorkTimeMap[widget.yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[widget.yearmonth]!.genbaName
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
  Widget displayMonthlyWorkTimeList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepWorkTimeMap[widget.yearmonth]?.data.forEach((WorkTimeDataModel element) {
      final List<String> exDay = element.day.split('(');
      final String date = '${widget.yearmonth}-${exDay[0]}';

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
  Widget buildTotalWorkDurationText() {
    final List<WorkTimeDataModel> data = appParamState.keepWorkTimeMap[widget.yearmonth]?.data ?? <WorkTimeDataModel>[];

    Duration totalDuration = Duration.zero;

    for (final WorkTimeDataModel element in data) {
      final List<String> exDay = element.day.split('(');
      final String date = '${widget.yearmonth}-${exDay[0]}';

      final Duration duration = calculateWorkDuration(date: date, start: element.start, end: element.end);

      totalDuration += duration;
    }

    final int hours = totalDuration.inHours;
    final int minutes = totalDuration.inMinutes.remainder(60);

    return Text('合計 $hours時間$minutes分');
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
  DateTime _addMonths(DateTime d, int months) => DateTime(d.year, d.month + months);

  ///
  List<YearlyHistoryEvent> _buildYearlyHistoryEventsFromHistory() {
    if (appParamState.keepWorkHistoryModelMap.isEmpty) {
      return const <YearlyHistoryEvent>[];
    }

    final List<MapEntry<String, WorkHistoryModel>> entries = appParamState.keepWorkHistoryModelMap.entries.toList()
      ..sort((MapEntry<String, WorkHistoryModel> a, MapEntry<String, WorkHistoryModel> b) => a.key.compareTo(b.key));

    final List<YearlyHistoryEvent> events = <YearlyHistoryEvent>[];
    final List<Color> colors = utility.getTwentyFourColor();

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

        final DateTime lastMonth = _addMonths(nextStart, -1);
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
