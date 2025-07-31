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
          padding: const EdgeInsets.all(20),
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
                              '${angleDeg.toStringAsFixed(1)}°',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
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
  double calcPixelY({required BoxConstraints constraints, required num intersectionY}) {
    return constraints.maxHeight -
        (intersectionY - graphMin) * (constraints.maxHeight / (graphMax.toDouble() - graphMin.toDouble()));
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];
    final List<int> list = <int>[];

    int i = 0;
    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() >= 2023) {
        _flspots.add(FlSpot(i.toDouble(), value.sum.toDouble()));
        list.add(value.sum.toInt());

        if (i == 0) {
          startPrice = value.sum.toInt();
        }
        endPrice = value.sum.toInt();

        i++;
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
        FlSpot(_flspots.length.toDouble(), startPrice.toDouble()),
      ];
      angleFlspotsB = <FlSpot>[
        FlSpot(0, startPrice.toDouble()),
        FlSpot(_flspots.length.toDouble(), endPrice.toDouble()),
      ];

      graphData = LineChartData(
        minX: 1,
        maxX: _flspots.length.toDouble(),
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: _flspots,
            color: Colors.greenAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
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
