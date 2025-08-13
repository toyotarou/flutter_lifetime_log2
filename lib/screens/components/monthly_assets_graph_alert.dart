import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';

class MonthlyAssetsGraphAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsGraphAlert({super.key, required this.monthlyGraphAssetsMap, required this.yearmonth});

  final Map<int, int> monthlyGraphAssetsMap;
  final String yearmonth;

  @override
  ConsumerState<MonthlyAssetsGraphAlert> createState() => _MonthlyAssetsGraphAlertState();
}

class _MonthlyAssetsGraphAlertState extends ConsumerState<MonthlyAssetsGraphAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];

  int graphMin = 0;
  int graphMax = 0;

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
              const Text('monthly assets graph'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              Expanded(child: Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)])),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];
    final List<int> list = <int>[];
    final List<String> dateList = <String>[];

    widget.monthlyGraphAssetsMap.forEach((int key, int value) {
      _flspots.add(FlSpot(key.toString().toDouble(), value.toString().toDouble()));

      list.add(value);

      dateList.add('${widget.yearmonth}-${key.toString().padLeft(2, '0')}');
    });

    if (list.isNotEmpty) {
      const int warisuu = 500000;
      final int minValue = list.reduce(min);
      final int maxValue = list.reduce(max);

      graphMin = ((minValue / warisuu).floor()) * warisuu;
      graphMax = ((maxValue / warisuu).ceil()) * warisuu;

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

                final String date = dateList[element.x.toInt() - 1];

                list.add(LineTooltipItem('$date\n$price', textStyle, textAlign: TextAlign.end));
              }

              return list;
            },
          ),
        ),

        gridData: const FlGridData(verticalInterval: 1),

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
    }
  }
}
