import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/invest_model.dart';
import '../../utility/utility.dart';

class AssetsDetailDisplayAlert extends ConsumerStatefulWidget {
  const AssetsDetailDisplayAlert({super.key, required this.date, required this.title});

  final String date;
  final String title;

  @override
  ConsumerState<AssetsDetailDisplayAlert> createState() => _AssetsDetailDisplayAlertState();
}

class _AssetsDetailDisplayAlertState extends ConsumerState<AssetsDetailDisplayAlert>
    with ControllersMixin<AssetsDetailDisplayAlert> {
  List<List<FlSpot>> flspotsList = <List<FlSpot>>[];

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  int graphMin = 0;
  int graphMax = 0;

  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

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
                  children: <Widget>[Text(widget.date), Text(widget.title)],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayAssetsNameList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                SizedBox(
                  height: (widget.title == 'stock') ? 540 : 400,
                  child: Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void setChartData() {
    flspotsList.clear();

    String roopTitle = widget.title;
    if (widget.title == 'toushiShintaku') {
      roopTitle = 'shintaku';
    }

    List<String> dateList = <String>[];

    appParamState.keepInvestNamesMap[roopTitle]
      ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
      ..sort((InvestNameModel a, InvestNameModel b) => a.relationalId.compareTo(b.relationalId))
      ..forEach((InvestNameModel element) {
        appParamState.keepInvestRecordMap[element.relationalId]?.forEach((InvestRecordModel element2) {
          dateList.add(element2.date);
        });
      });

    dateList = dateList.toSet().toList();
    dateList.sort();

    final List<String> eachMonthStartDateList = <String>[];

    String keepYearmonth = '';
    for (final String element in dateList) {
      if (keepYearmonth != '${element.split('-')[0]}-${element.split('-')[1]}') {
        eachMonthStartDateList.add(element);
      }

      keepYearmonth = '${element.split('-')[0]}-${element.split('-')[1]}';
    }

    final List<int> list = <int>[];

    appParamState.keepInvestNamesMap[roopTitle]
      ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
      ..sort((InvestNameModel a, InvestNameModel b) => a.relationalId.compareTo(b.relationalId))
      ..forEach((InvestNameModel element) {
        final List<FlSpot> flspots = <FlSpot>[];
        appParamState.keepInvestRecordMap[element.relationalId]?.forEach((InvestRecordModel element2) {
          flspots.add(
            FlSpot(
              dateList.indexWhere((String element) => element == element2.date).toDouble(),
              element2.price.toDouble(),
            ),
          );

          list.add(element2.price);
        });

        flspotsList.add(flspots);
      });

    if (list.isNotEmpty) {
      final int warisuu = (widget.title == 'stock') ? 10000 : 500000;

      final int minValue = list.reduce(min);
      final int maxValue = list.reduce(max);

      graphMin = ((minValue / warisuu).floor()) * warisuu;
      graphMax = ((maxValue / warisuu).ceil()) * warisuu;

      final List<Color> twelveColor = utility.getTwelveColor();

      graphData = LineChartData(
        ///
        minX: 1,
        maxX: dateList.length.toDouble(),
        //
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        ///
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

                final String date = dateList[element.x.toInt()];

                final String price = element.y.round().toString().split('.')[0].toCurrency();

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
            final String date = dateList[value.toInt()];

            return FlLine(
              color: (eachMonthStartDateList.contains(date))
                  ? Colors.yellowAccent.withOpacity(0.1)
                  : Colors.transparent,
            );
          },
        ),

        ///
        titlesData: const FlTitlesData(show: false),

        ///
        borderData: FlBorderData(show: false),

        ///
        lineBarsData: <LineChartBarData>[
          for (int i = 0; i < flspotsList.length; i++)
            LineChartBarData(
              spots: flspotsList[i],
              barWidth: 1,
              isStrokeCapRound: true,
              color: twelveColor[i % 12],

              dotData: const FlDotData(show: false),
            ),
        ],
      );

      graphData2 = LineChartData(
        ///
        minX: 1,
        maxX: dateList.length.toDouble(),
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

  ///
  Widget displayAssetsNameList() {
    final List<Widget> list = <Widget>[];

    String roopTitle = widget.title;
    if (widget.title == 'toushiShintaku') {
      roopTitle = 'shintaku';
    }

    appParamState.keepInvestNamesMap[roopTitle]
      ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
      ..sort((InvestNameModel a, InvestNameModel b) => a.relationalId.compareTo(b.relationalId))
      ..forEach((InvestNameModel element) {
        list.add(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(element.frame), Text(element.name)],
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
}
