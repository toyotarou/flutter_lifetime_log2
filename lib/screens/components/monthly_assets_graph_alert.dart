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

    int lastTotal = 0;

    widget.monthlyGraphAssetsMap.forEach((int key, int value) {
      _flspots.add(FlSpot(key.toString().toDouble(), value.toString().toDouble()));

      list.add(value);

      dateList.add('${widget.yearmonth}-${key.toString().padLeft(2, '0')}');

      if (value > 0) {
        lastTotal = value;
      }
    });

    final List<String> exLastDate = dateList.last.split('-');
    final int lastDateMonthLastDay = DateTime(exLastDate[0].toInt(), exLastDate[1].toInt() + 1, 0).day;
    for (int i = list.length + 1; i <= (lastDateMonthLastDay - exLastDate[2].toInt()) + list.length; i++) {
      _flspots.add(FlSpot(i.toDouble(), lastTotal.toDouble()));

      dateList.add('${widget.yearmonth}-${i.toString().padLeft(2, '0')}');
    }

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

                final String youbi = DateTime(
                  date.split('-')[0].toInt(),
                  date.split('-')[1].toInt(),
                  date.split('-')[2].toInt(),
                ).youbiStr.substring(0, 3);

                list.add(LineTooltipItem('$date($youbi)\n$price', textStyle, textAlign: TextAlign.end));
              }

              return list;
            },
          ),
        ),

        ///
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingHorizontalLine: (double value) {
            return FlLine(
              color: (value == 0.0) ? Colors.greenAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (double value) {
            final String youbi = DateTime(
              widget.yearmonth.split('-')[0].toInt(),
              widget.yearmonth.split('-')[1].toInt(),
            ).add(Duration(days: value.toInt() - 1)).youbiStr;

            return FlLine(
              color:
                  (widget.yearmonth.split('-')[0] == DateTime.now().year.toString() &&
                      widget.yearmonth.split('-')[1] == DateTime.now().month.toString().padLeft(2, '0') &&
                      value.toInt() == DateTime.now().day)
                  ? const Color(0xFFFBB6CE).withOpacity(0.3)
                  : (youbi == 'Sunday')
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.transparent,
              strokeWidth: (value.toInt() == DateTime.now().day) ? 3 : 1,
            );
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
    }
  }
}
