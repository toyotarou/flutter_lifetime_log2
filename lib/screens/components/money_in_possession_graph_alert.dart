import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_model.dart';

class MoneyInPossessionGraphAlert extends ConsumerStatefulWidget {
  const MoneyInPossessionGraphAlert({super.key});

  @override
  ConsumerState<MoneyInPossessionGraphAlert> createState() => _MoneyInPossessionGraphAlertState();
}

class _MoneyInPossessionGraphAlertState extends ConsumerState<MoneyInPossessionGraphAlert>
    with ControllersMixin<MoneyInPossessionGraphAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();
  LineChartData graphData3 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];

  int graphMin = 0;
  int graphMax = 0;

  List<FlSpot> angleFlspotsA = <FlSpot>[];
  List<FlSpot> angleFlspotsB = <FlSpot>[];

  int startPrice = 0;
  int endPrice = 0;

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),
              const Text('money in possession'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double angleDeg = _calcAngleDeg(
                      lineA: angleFlspotsA,
                      lineB: angleFlspotsB,
                      chartWidth: constraints.maxWidth,
                      chartHeight: constraints.maxHeight,
                      minX: 1,
                      maxX: _flspots.length.toDouble(),
                      minY: graphMin.toDouble(),
                      maxY: graphMax.toDouble(),
                    );

                    const double intersectionX = 0.0;
                    final num intersectionY = startPrice;

                    final double pixelX = (intersectionX - 1) * (constraints.maxWidth / (_flspots.length - 1));
                    final double pixelY = calcPixelY(constraints: constraints, intersectionY: intersectionY);

                    return Stack(
                      children: <Widget>[
                        LineChart(graphData2),
                        LineChart(graphData3),
                        LineChart(graphData),
                        Positioned(
                          left: pixelX + 20,
                          top: pixelY - 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${angleDeg.toStringAsFixed(3)}°',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),

                        Positioned(bottom: 10, left: 10, child: displayGraphYearWidget()),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGraphYearWidget() {
    final List<Widget> list = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: GestureDetector(
          onTap: () {
            appParamNotifier.setSelectedGraphYear(year: 0);
          },
          child: CircleAvatar(
            backgroundColor: (appParamState.selectedGraphYear == 0)
                ? Colors.yellowAccent.withValues(alpha: 0.3)
                : Colors.blueGrey.withValues(alpha: 0.8),

            child: const Text('-', style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ),
      ),
    ];

    for (int i = 2023; i <= DateTime.now().year; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSelectedGraphYear(year: i);
            },
            child: CircleAvatar(
              backgroundColor: (appParamState.selectedGraphYear == i)
                  ? Colors.yellowAccent.withValues(alpha: 0.3)
                  : Colors.blueGrey.withValues(alpha: 0.8),

              child: Text(i.toString(), style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: list),
    );
  }

  ///
  double calcPixelY({required BoxConstraints constraints, required num intersectionY}) {
    return constraints.maxHeight -
        (intersectionY - graphMin) * (constraints.maxHeight / (graphMax.toDouble() - graphMin.toDouble()));
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];
    final List<int> list = <int>[];
    final List<String> dateList = <String>[];

    int i = 0;
    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() >= 2023) {
        if (appParamState.selectedGraphYear == 0) {
          _flspots.add(FlSpot(i.toDouble(), value.sum.toDouble()));
          list.add(value.sum.toInt());
          dateList.add(value.date);

          if (i == 0) {
            startPrice = value.sum.toInt();
          }
          endPrice = value.sum.toInt();

          i++;
        } else {
          if (appParamState.selectedGraphYear == key.split('-')[0].toInt()) {
            _flspots.add(FlSpot(i.toDouble(), value.sum.toDouble()));
            list.add(value.sum.toInt());
            dateList.add(value.date);

            if (i == 0) {
              startPrice = value.sum.toInt();
            }
            endPrice = value.sum.toInt();

            i++;
          }
        }
      }
    });

    if (list.isNotEmpty) {
      const int warisuu = 500000;
      final int minValue = list.reduce(min);
      final int maxValue = list.reduce(max);

      graphMin = ((minValue / warisuu).floor()) * warisuu;
      graphMax = ((maxValue / warisuu).ceil()) * warisuu;

      angleFlspotsA = <FlSpot>[
        FlSpot(0, startPrice.toDouble()),
        FlSpot(_flspots.length.toDouble() - 1, startPrice.toDouble()),
      ];
      angleFlspotsB = <FlSpot>[
        FlSpot(0, startPrice.toDouble()),
        FlSpot(_flspots.length.toDouble() - 1, endPrice.toDouble()),
      ];

      graphData = LineChartData(
        minX: 1,
        maxX: _flspots.length.toDouble(),

        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              final List<LineTooltipItem> list = <LineTooltipItem>[];

              for (final LineBarSpot element in touchedSpots) {
                final TextStyle textStyle = TextStyle(
                  color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );

                final String price = element.y.round().toString().split('.')[0].toCurrency();

                final String date = dateList[element.x.toInt()];

                list.add(LineTooltipItem('$date\n$price', textStyle, textAlign: TextAlign.end));
              }

              return list;
            },
          ),
        ),

        ///
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingVerticalLine: (double value) {
            if (dateList[value.toInt()].split('-')[2] == '01') {
              if (dateList[value.toInt()].split('-')[1] == '01') {
                return FlLine(color: const Color(0xFFFBB6CE).withOpacity(0.3), strokeWidth: 3);
              } else {
                return FlLine(color: Colors.yellowAccent.withValues(alpha: 0.2), strokeWidth: 1);
              }
            } else {
              return const FlLine(color: Colors.transparent, strokeWidth: 1);
            }
          },
        ),

        titlesData: const FlTitlesData(show: false),

        borderData: FlBorderData(show: false),

        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: _flspots,
            color: Colors.greenAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      );

      graphData2 = LineChartData(
        ///
        minX: 1,
        maxX: _flspots.length.toDouble(),
        //
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        borderData: FlBorderData(show: false),

        ///
        lineTouchData: const LineTouchData(enabled: false),

        ///
        gridData: const FlGridData(show: false),

        ///
        titlesData: FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: const AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: const AxisTitles(),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMin || value == graphMax) {
                  return const SizedBox();
                }

                return SideTitleWidget(
                  space: 4,
                  axisSide: AxisSide.left,
                  child: Text(value.toInt().toString().toCurrency(), style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          //-------------------------// 左側の目盛り

          //-------------------------// 右側の目盛り
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMin || value == graphMax) {
                  return const SizedBox();
                }

                return SideTitleWidget(
                  space: 4,
                  axisSide: AxisSide.right,
                  child: Text(value.toInt().toString().toCurrency(), style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          //-------------------------// 右側の目盛り
        ),

        ///
        lineBarsData: <LineChartBarData>[],
      );

      graphData3 = LineChartData(
        minX: 1,
        maxX: _flspots.length.toDouble(),

        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        lineTouchData: const LineTouchData(enabled: false),

        gridData: const FlGridData(show: false),

        titlesData: const FlTitlesData(show: false),

        borderData: FlBorderData(show: false),

        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: angleFlspotsA,
            color: Colors.white,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: angleFlspotsB,
            color: Colors.white,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      );
    }
  }

  ///
  double _calcAngleDeg({
    required List<FlSpot> lineA,
    required List<FlSpot> lineB,
    required double chartWidth,
    required double chartHeight,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
  }) {
    final double dxA = (lineA.last.x - lineA.first.x) * (chartWidth / (maxX - minX));
    final double dyA = (lineA.last.y - lineA.first.y) * (chartHeight / (maxY - minY));

    final double dxB = (lineB.last.x - lineB.first.x) * (chartWidth / (maxX - minX));
    final double dyB = (lineB.last.y - lineB.first.y) * (chartHeight / (maxY - minY));

    final double angleA = atan2(dyA, dxA);
    final double angleB = atan2(dyB, dxB);

    return (angleB - angleA).abs() * 180 / pi;
  }
}
