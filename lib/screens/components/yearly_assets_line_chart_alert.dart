import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/money_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/assets_calc.dart';

class YearlyAssetsLineChartAlert extends ConsumerStatefulWidget {
  const YearlyAssetsLineChartAlert({super.key, required this.year});

  final int year;

  @override
  ConsumerState<YearlyAssetsLineChartAlert> createState() => _YearlyAssetsLineChartAlertState();
}

class _YearlyAssetsLineChartAlertState extends ConsumerState<YearlyAssetsLineChartAlert>
    with ControllersMixin<YearlyAssetsLineChartAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();
  LineChartData graphData3 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];
  List<FlSpot> _shintakuFlspots = <FlSpot>[];
  List<FlSpot> _stockFlspots = <FlSpot>[];
  List<FlSpot> _goldFlspots = <FlSpot>[];
  List<FlSpot> _insuranceFlspots = <FlSpot>[];
  List<FlSpot> _nenkinFlspots = <FlSpot>[];

  int graphMin = 0;
  int graphMax = 0;

  int startPrice = 0;
  int endPrice = 0;

  late int _selectedYear;

  List<String> _dateList = <String>[];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.year;
  }

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

              const Text('Evolution of Assets'),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (_flspots.isEmpty) {
                      return const Center(child: Text('No data'));
                    }

                    return Stack(
                      children: <Widget>[
                        LineChart(graphData3),
                        LineChart(graphData2),
                        LineChart(graphData),
                        Positioned(top: 8, left: 8, child: _yearSelectorWidget()),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 11),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'money',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'shintaku',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'stock',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'gold',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'insurance',
                      style: TextStyle(color: Color(0xFFEA80FC)),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'nenkin',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _yearSelectorWidget() {
    final List<Widget> items = <Widget>[];

    for (int y = 2023; y <= DateTime.now().year; y++) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => setState(() => _selectedYear = _selectedYear == y ? 0 : y),
            child: CircleAvatar(
              backgroundColor: _selectedYear == y
                  ? Colors.yellowAccent.withValues(alpha: 0.3)
                  : Colors.blueGrey.withValues(alpha: 0.8),
              child: Text(y.toString(), style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: items),
    );
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];
    _dateList = <String>[];
    final List<int> list = <int>[];

    int i = 0;
    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() < 2023) {
        return;
      }

      _flspots.add(FlSpot(i.toDouble(), value.sum.toDouble()));
      list.add(value.sum.toInt());
      _dateList.add(value.date);

      if (i == 0) {
        startPrice = value.sum.toInt();
      }
      endPrice = value.sum.toInt();

      i++;
    });

    // 投資信託: 2023-01-01〜今日まで日付ループ、土日祝は前日キャリーフォワード
    _shintakuFlspots = <FlSpot>[];
    if (_dateList.isNotEmpty) {
      int prevShintakuSum = 0;
      for (int idx = 0; idx < _dateList.length; idx++) {
        final String date = _dateList[idx];
        final List<ToushiShintakuModel>? dayList = appParamState.keepToushiShintakuMap[date];
        if (dayList != null && dayList.isNotEmpty) {
          prevShintakuSum = dayList.fold(0, (int acc, ToushiShintakuModel m) {
            if (m.jikaHyoukagaku == '-') {
              return acc;
            }
            return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          });
        }
        _shintakuFlspots.add(FlSpot(idx.toDouble(), prevShintakuSum.toDouble()));
      }
    }

    // 株: 同様に日付ループ、土日祝は前日キャリーフォワード
    _stockFlspots = <FlSpot>[];
    if (_dateList.isNotEmpty) {
      int prevStockSum = 0;
      for (int idx = 0; idx < _dateList.length; idx++) {
        final String date = _dateList[idx];
        final List<StockModel>? dayList = appParamState.keepStockMap[date];
        if (dayList != null && dayList.isNotEmpty) {
          prevStockSum = dayList.fold(0, (int acc, StockModel m) {
            if (m.jikaHyoukagaku == '-') {
              return acc;
            }
            return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          });
        }
        _stockFlspots.add(FlSpot(idx.toDouble(), prevStockSum.toDouble()));
      }
    }

    // ゴールド: リストではなく Map<String, GoldModel>、土日祝は前日キャリーフォワード
    _goldFlspots = <FlSpot>[];
    if (_dateList.isNotEmpty) {
      int prevGoldValue = 0;
      for (int idx = 0; idx < _dateList.length; idx++) {
        final String date = _dateList[idx];
        final GoldModel? model = appParamState.keepGoldMap[date];
        if (model != null) {
          final String val = model.goldValue.toString();
          if (val != '-' && val.isNotEmpty) {
            prevGoldValue = val.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          }
        }
        _goldFlspots.add(FlSpot(idx.toDouble(), prevGoldValue.toDouble()));
      }
    }

    // 保険・年金基金: 日付ごとに countPaidUpTo で計算
    _insuranceFlspots = <FlSpot>[];
    _nenkinFlspots = <FlSpot>[];
    for (int idx = 0; idx < _dateList.length; idx++) {
      final DateTime d = DateTime.parse(_dateList[idx]);

      final int insurancePassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: d) + 102;
      final int insuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: d) + 32;
      final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

      _insuranceFlspots.add(FlSpot(idx.toDouble(), insuranceSum.toDouble()));
      _nenkinFlspots.add(FlSpot(idx.toDouble(), nenkinKikinSum.toDouble()));
    }

    if (list.isNotEmpty) {
      graphMax = 15000000;

      graphData = LineChartData(
        minX: 0,
        maxX: _flspots.length.toDouble() - 1,

        minY: 0,
        maxY: graphMax.toDouble(),

        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              // 全線の値を収集
              String date = '';
              int moneyVal = 0, shintakuVal = 0, stockVal = 0, goldVal = 0, insuranceVal = 0, nenkinVal = 0;

              for (final LineBarSpot s in touchedSpots) {
                final int x = s.x.toInt();
                if (x >= 0 && x < _dateList.length) {
                  date = _dateList[x];
                }
                switch (s.barIndex) {
                  case 0:
                    moneyVal = s.y.round();
                  case 1:
                    shintakuVal = s.y.round();
                  case 2:
                    stockVal = s.y.round();
                  case 3:
                    goldVal = s.y.round();
                  case 4:
                    insuranceVal = s.y.round();
                  case 5:
                    nenkinVal = s.y.round();
                }
              }

              final int total = moneyVal + shintakuVal + stockVal + goldVal + insuranceVal + nenkinVal;

              return touchedSpots.map((LineBarSpot s) {
                if (s.barIndex != 0) {
                  return null;
                }

                return LineTooltipItem(
                  '$date\n',
                  const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  children: <TextSpan>[
                    TextSpan(
                      text: '${moneyVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '${shintakuVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                    TextSpan(
                      text: '${goldVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.lightBlueAccent),
                    ),
                    TextSpan(
                      text: '${stockVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: '${insuranceVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Color(0xFFEA80FC)),
                    ),
                    TextSpan(
                      text: '${nenkinVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                    TextSpan(
                      text: total.toString().toCurrency(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),

        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingVerticalLine: (double value) {
            final int idx = value.toInt();
            if (idx < 0 || idx >= _dateList.length) {
              return const FlLine(color: Colors.transparent, strokeWidth: 1);
            }
            if (_dateList[idx].split('-')[2] == '01') {
              if (_dateList[idx].split('-')[1] == '01') {
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
          LineChartBarData(spots: _flspots, color: Colors.white, dotData: const FlDotData(show: false), barWidth: 1),
          LineChartBarData(
            spots: _shintakuFlspots,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _stockFlspots,
            color: Colors.greenAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _goldFlspots,
            color: Colors.lightBlueAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _insuranceFlspots,
            color: const Color(0xFFEA80FC),
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _nenkinFlspots,
            color: Colors.orangeAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      );

      graphData2 = LineChartData(
        minX: 0,
        maxX: _flspots.length.toDouble() - 1,

        minY: 0,
        maxY: graphMax.toDouble(),

        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          bottomTitles: const AxisTitles(),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMax) {
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

          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMax) {
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
        ),

        lineBarsData: <LineChartBarData>[],
      );

      // ハイライト専用レイヤー（タイトルなし = graphDataと同じplot幅）
      graphData3 = LineChartData(
        minX: 0,
        maxX: _flspots.length.toDouble() - 1,
        minY: 0,
        maxY: graphMax.toDouble(),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: _buildYearHighlight()),
        lineBarsData: <LineChartBarData>[],
      );
    }
  }

  ///
  List<VerticalRangeAnnotation> _buildYearHighlight() {
    if (_selectedYear == 0 || _dateList.isEmpty) {
      return <VerticalRangeAnnotation>[];
    }

    int? startIdx;
    int? endIdx;

    for (int i = 0; i < _dateList.length; i++) {
      if (_dateList[i].split('-')[0].toInt() == _selectedYear) {
        startIdx ??= i;
        endIdx = i;
      }
    }

    if (startIdx == null || endIdx == null) {
      return <VerticalRangeAnnotation>[];
    }

    return <VerticalRangeAnnotation>[
      VerticalRangeAnnotation(
        x1: startIdx.toDouble(),
        x2: endIdx.toDouble(),
        color: Colors.white.withValues(alpha: 0.08),
      ),
    ];
  }
}
