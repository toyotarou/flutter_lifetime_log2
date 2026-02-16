import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/scroll_line_chart_model.dart';
import '../../models/common/scroll_line_chart_y_axis_range_model.dart';
import '../../models/money_model.dart';
import '../../utility/functions.dart';
import '../parts/lifetime_dialog.dart';
import '../parts/scroll_line_chart.dart';
import 'money_in_possession_graph_alert.dart';

class MoneyInPossessionDisplayAlert extends ConsumerStatefulWidget {
  const MoneyInPossessionDisplayAlert({super.key});

  @override
  ConsumerState<MoneyInPossessionDisplayAlert> createState() => _MoneyInPossessionDisplayAlertState();
}

class _MoneyInPossessionDisplayAlertState extends ConsumerState<MoneyInPossessionDisplayAlert>
    with ControllersMixin<MoneyInPossessionDisplayAlert> {
  final AutoScrollController autoScrollController = AutoScrollController();

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    autoScrollController.dispose();
    super.dispose();
  }

  ///
  DateTime? _tryParseDate(String s) {
    try {
      final DateTime dt = DateTime.parse(s);
      return DateTime(dt.year, dt.month, dt.day);
    } catch (_) {
      return null;
    }
  }

  ///
  DateTime _resolveStartDateFromMoneySumList() {
    final List<ScrollLineChartModel> list = appParamState.keepMoneySumList;

    if (list.isEmpty) {
      return DateTime.now();
    }

    DateTime? minDt;

    for (final ScrollLineChartModel m in list) {
      final DateTime? dt = _tryParseDate(m.date);

      if (dt == null) {
        continue;
      }

      if (minDt == null || dt.isBefore(minDt)) {
        minDt = dt;
      }
    }

    return minDt ?? DateTime.now();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final DateTime startDate = _resolveStartDateFromMoneySumList();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('money in possession'),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            final List<int> sumList = <int>[];
                            for (final ScrollLineChartModel aaa in appParamState.keepMoneySumList) {
                              sumList.add(aaa.sum);
                            }

                            final ScrollLineChartYAxisRangeModel yAxisRange = calcYAxisRange(
                              minValue: sumList.reduce(min).toDouble(),
                              maxValue: sumList.reduce(max).toDouble(),
                            );

                            LifetimeDialog(
                              context: context,
                              widget: ScrollLineChart(
                                name: 'money',
                                startDate: startDate,
                                windowDays: 35,
                                pixelsPerDay: 16.0,
                                fixedMinY: yAxisRange.min,
                                fixedMaxY: yAxisRange.max,
                                fixedIntervalY: yAxisRange.interval,
                                seed: DateTime.now().year,
                                labelShowScaleThreshold: 3.0,
                                scrollLineChartModelList: appParamState.keepMoneySumList,
                              ),
                            );
                          },
                          child: const Icon(Icons.stacked_line_chart),
                        ),

                        const SizedBox(width: 20),

                        GestureDetector(
                          onTap: () => LifetimeDialog(context: context, widget: const MoneyInPossessionGraphAlert()),
                          child: const Icon(Icons.graphic_eq),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (_) {
                            if (appParamState.keepMoneyMap.isEmpty) {
                              return;
                            }
                            _startRepeating(() => _scrollBy(_moveAmount));
                          },
                          onTapUp: (_) => _stopRepeating(),
                          onTapCancel: _stopRepeating,
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(child: Icon(Icons.arrow_downward)),
                          ),
                        ),

                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (_) {
                            if (appParamState.keepMoneyMap.isEmpty) {
                              return;
                            }
                            _startRepeating(() => _scrollBy(-_moveAmount));
                          },
                          onTapUp: (_) => _stopRepeating(),
                          onTapCancel: _stopRepeating,
                          child: const SizedBox(width: 44, height: 44, child: Center(child: Icon(Icons.arrow_upward))),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(child: _displayPossessionMoneyList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!autoScrollController.hasClients) {
      return;
    }

    final ScrollPosition pos = autoScrollController.position;
    final double newOffset = (autoScrollController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    autoScrollController.jumpTo(newOffset);
  }

  ///
  Widget _displayPossessionMoneyList() {
    final List<Widget> list = <Widget>[];

    int lastSum = 0;
    int i = 0;
    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() >= 2023) {
        list.add(
          AutoScrollTag(
            // ignore: always_specify_types
            key: ValueKey(i),
            index: i,
            controller: autoScrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(value.sum.toCurrency()),

                      if (i == 0)
                        const SizedBox.shrink()
                      else
                        Text(
                          (lastSum - value.sum.toInt()).toString().toCurrency(),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        lastSum = value.sum.toInt();
        i++;
      }
    });

    return CustomScrollView(
      controller: autoScrollController,
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
}
