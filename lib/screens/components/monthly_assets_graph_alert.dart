import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/assets_calc.dart';
import '../parts/lifetime_dialog.dart';
import 'yearly_assets_spend_info_alert.dart';

class MonthlyAssetsGraphAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsGraphAlert({
    super.key,
    required this.monthlyGraphAssetsMap,
    required this.yearmonth,
    required this.lastMonthFinalAssets,
  });

  final Map<int, int> monthlyGraphAssetsMap;
  final String yearmonth;
  final int lastMonthFinalAssets;

  @override
  ConsumerState<MonthlyAssetsGraphAlert> createState() => _MonthlyAssetsGraphAlertState();
}

class _MonthlyAssetsGraphAlertState extends ConsumerState<MonthlyAssetsGraphAlert>
    with ControllersMixin<MonthlyAssetsGraphAlert>, SingleTickerProviderStateMixin {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();
  LineChartData graphData3 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];
  List<String> _dateList = <String>[];

  int graphMin = 0;
  int graphMax = 0;

  double? _startY;
  double? _endY;

  late int _endDay;
  late int _lastDayOfMonth;

  late final AnimationController _animationController;

  double get _arrowX => _endDay + 0.25;

  final TransformationController transformationController = TransformationController();

  bool zoomMode = false;
  bool _showPointLabels = false;

  late final DateTime _asOf;

  late final Future<_MonthlyBuiltData> _futureBuiltData;

  ///
  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    _asOf = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
    transformationController.addListener(_onTransformChanged);

    _futureBuiltData = Future<_MonthlyBuiltData>(() => _buildData(asOf: _asOf));
  }

  ///
  void _onTransformChanged() {
    if (!zoomMode) {
      return;
    }

    final double scale = transformationController.value.getMaxScaleOnAxis();
    final bool shouldShow = scale >= 5.0;

    if (shouldShow != _showPointLabels) {
      setState(() {
        _showPointLabels = shouldShow;
      });
    }
  }

  ///
  @override
  void dispose() {
    _animationController.dispose();
    transformationController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Alignment yToAlign(double y) {
      final double t = (graphMax - y) / (graphMax - graphMin);
      final double alignY = (t * 2) - 1;
      return Alignment(0.92, alignY.clamp(-1.0, 1.0));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<_MonthlyBuiltData>(
            future: _futureBuiltData,
            builder: (BuildContext context, AsyncSnapshot<_MonthlyBuiltData> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('計算中...', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('計算エラー: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
                );
              }

              final _MonthlyBuiltData built = snapshot.data!;
              _applyBuiltData(built);

              final double delta = (_startY != null && _endY != null) ? (_endY! - _startY!) : 0.0;
              final double midY = (_startY != null && _endY != null)
                  ? ((_startY! + _endY!) / 2.0)
                  : graphMin.toDouble();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: context.screenSize.width),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[const Text('monthly assets graph'), Text(widget.yearmonth)],
                      ),
                      Row(
                        children: <Widget>[
                          if (zoomMode) ...<Widget>[
                            IconButton(
                              onPressed: () => setState(() {
                                transformationController.value = Matrix4.identity();
                                _showPointLabels = false;
                              }),
                              icon: const Icon(Icons.lock_reset),
                            ),
                          ],
                          IconButton(
                            onPressed: () {
                              setState(() {
                                zoomMode = !zoomMode;
                                if (!zoomMode) {
                                  transformationController.value = Matrix4.identity();
                                  _showPointLabels = false;
                                }
                              });
                            },
                            icon: Icon(Icons.expand, color: zoomMode ? Colors.yellowAccent : Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        if (zoomMode)
                          InteractiveViewer(
                            transformationController: transformationController,
                            panEnabled: zoomMode,
                            scaleEnabled: zoomMode,
                            minScale: 1.0,
                            maxScale: 10.0,
                            child: AbsorbPointer(
                              child: Stack(
                                children: <Widget>[
                                  LineChart(graphData2),
                                  LineChart(graphData3),
                                  AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (BuildContext context, _) {
                                      final double t = Curves.easeOutCubic.transform(_animationController.value);
                                      return LineChart(_animatedData(graphData, t));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Stack(
                            children: <Widget>[
                              LineChart(graphData2),
                              LineChart(graphData3),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (BuildContext context, _) {
                                  final double t = Curves.easeOutCubic.transform(_animationController.value);
                                  return LineChart(_animatedData(graphData, t));
                                },
                              ),
                            ],
                          ),

                        if (_startY != null && _endY != null)
                          Align(
                            alignment: yToAlign(midY),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: const <BoxShadow>[BoxShadow(blurRadius: 4, spreadRadius: 1)],
                              ),
                              child: Text(
                                _formatDelta(delta),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox.shrink(),

                      ElevatedButton(
                        onPressed: () {
                          LifetimeDialog(context: context, widget: const YearlyAssetsSpendInfoAlert());
                        },

                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                        child: const Text('yearly_assets_spend_info'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ///
  _MonthlyBuiltData _buildData({required DateTime asOf}) {
    final List<String> parts = widget.yearmonth.split('-');
    final int y = parts[0].toInt();
    final int m = parts[1].toInt();

    final int lastDayOfMonth = DateTime(y, m + 1, 0).day;
    final DateTime prevMonthLast = DateTime(y, m, 0);

    final DateTime asOfDate = DateTime(asOf.year, asOf.month, asOf.day, asOf.hour, asOf.minute, asOf.second);

    final int lastMonthFinalAssets = _calcTotalAssetsAtDate(prevMonthLast);

    final Map<int, int> monthTotals = <int, int>{};
    for (int day = 1; day <= lastDayOfMonth; day++) {
      final DateTime d = DateTime(y, m, day);
      final DateTime target = d.isAfter(asOfDate) ? asOfDate : d;
      monthTotals[day] = _calcTotalAssetsAtDate(target);
    }

    return _MonthlyBuiltData(
      year: y,
      month: m,
      lastDayOfMonth: lastDayOfMonth,
      prevMonthLast: prevMonthLast,
      lastMonthFinalAssets: lastMonthFinalAssets,
      monthTotals: monthTotals,
      asOf: asOfDate,
    );
  }

  ///
  void _applyBuiltData(_MonthlyBuiltData built) {
    _flspots = <FlSpot>[];
    _dateList = <String>[];

    final List<int> monthlyAssetValueList = <int>[];

    _lastDayOfMonth = built.lastDayOfMonth;

    final String prevMonthLastStr =
        '${built.prevMonthLast.year}-${built.prevMonthLast.month.toString().padLeft(2, '0')}-${built.prevMonthLast.day.toString().padLeft(2, '0')}';

    _flspots.add(FlSpot(0.0, built.lastMonthFinalAssets.toDouble()));
    _dateList.add(prevMonthLastStr);
    monthlyAssetValueList.add(built.lastMonthFinalAssets);

    int carryTotal = built.lastMonthFinalAssets;
    for (int day = 1; day <= _lastDayOfMonth; day++) {
      final int v = built.monthTotals[day] ?? carryTotal;
      carryTotal = v;

      _flspots.add(FlSpot(day.toDouble(), carryTotal.toDouble()));
      _dateList.add('${widget.yearmonth}-${day.toString().padLeft(2, '0')}');
      monthlyAssetValueList.add(carryTotal);
    }

    const int step = 500000;
    final int minValue = monthlyAssetValueList.reduce(min);
    final int maxValue = monthlyAssetValueList.reduce(max);

    graphMin = ((minValue / step).floor()) * step;
    graphMax = ((maxValue / step).ceil()) * step;

    _startY = built.lastMonthFinalAssets.toDouble();

    final bool isCurrentMonth = built.asOf.year == built.year && built.asOf.month == built.month;
    _endDay = isCurrentMonth ? built.asOf.day.clamp(1, _lastDayOfMonth) : _lastDayOfMonth;

    _endY = built.monthTotals[_endDay]!.toDouble();

    final List<List<int>> weeks = getSplitWeeksByIndex(dateList: _dateList);
    final List<VerticalRangeAnnotation> verticalRanges = buildWeekBandsByWeeks(
      weeks: weeks,
      paintEvenWeeks: true,
      color: Colors.yellowAccent,
      opacity: 0.1,
    );

    int? todayIndex;
    if (isCurrentMonth) {
      final String todayStr = '${widget.yearmonth}-${built.asOf.day.toString().padLeft(2, '0')}';
      for (int i = 0; i < _dateList.length; i++) {
        if (_dateList[i] == todayStr) {
          todayIndex = i;
          break;
        }
      }
    }

    final List<LineChartBarData> weeklyMomentumLines = _buildWeeklyMomentumLines(
      weeks: weeks,
      spots: _flspots,
      todayIndex: todayIndex,
    );

    graphData = LineChartData(
      minX: 0,
      maxX: _lastDayOfMonth.toDouble(),
      minY: graphMin.toDouble(),
      maxY: graphMax.toDouble(),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 2,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot s) {
              if (s.barIndex != 0) {
                return null;
              }
              if (s.x.round() == 0) {
                return null;
              }

              final int idx = s.x.round().clamp(0, _dateList.length - 1);

              final Color tooltipColor = (idx == 0)
                  ? Colors.white
                  : (s.bar.gradient?.colors.first ?? s.bar.color ?? Colors.blueGrey);

              final TextStyle baseStyle = TextStyle(color: tooltipColor, fontWeight: FontWeight.bold, fontSize: 12);

              final String date = _dateList[idx];
              final int price = s.y.round();
              final String displayPrice = price.toString().toCurrency();

              final DateTime dt = DateTime.parse(date);
              final String youbi = dt.youbiStr.substring(0, 3);

              final int baseline = built.lastMonthFinalAssets;
              final int diffFromStart = price - baseline;
              final String signFromStart = diffFromStart > 0 ? '+' : (diffFromStart < 0 ? '-' : '±');
              final String diffFromStartText = '$signFromStart${diffFromStart.abs().toString().toCurrency()}';

              String diffFromPrevText = '';
              Color diffColor = Colors.white;
              if (idx > 0) {
                final int prevPrice = _flspots[idx - 1].y.round();
                final int diffFromPrev = price - prevPrice;
                final String sign = diffFromPrev > 0 ? '+' : (diffFromPrev < 0 ? '-' : '±');
                diffFromPrevText = '$sign${diffFromPrev.abs().toString().toCurrency()}';

                if (diffFromPrev > 0) {
                  diffColor = Colors.yellowAccent;
                } else if (diffFromPrev < 0) {
                  diffColor = Colors.lightBlueAccent;
                }
              }

              return LineTooltipItem(
                '$date($youbi)\n$displayPrice\n$diffFromStartText',
                baseStyle,
                textAlign: TextAlign.end,
                children: <TextSpan>[
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: diffFromPrevText,
                    style: TextStyle(color: diffColor),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        verticalInterval: 1,
        getDrawingHorizontalLine: (double value) => FlLine(
          color: (value == 0.0) ? Colors.greenAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (double value) {
          if (value < 1) {
            return const FlLine(color: Colors.transparent, strokeWidth: 1);
          }

          final String youbi = DateTime(built.year, built.month).add(Duration(days: value.toInt() - 1)).youbiStr;

          final bool isTodayLine =
              built.asOf.year == built.year && built.asOf.month == built.month && value.toInt() == built.asOf.day;

          return FlLine(
            color: isTodayLine
                ? const Color(0xFFFBB6CE).withOpacity(0.3)
                : (youbi == 'Sunday')
                ? Colors.yellowAccent.withOpacity(0.3)
                : Colors.transparent,
            strokeWidth: isTodayLine ? 3 : 1,
          );
        },
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: _flspots,
          color: Colors.greenAccent,
          barWidth: 1,
          dotData: FlDotData(
            getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
              final bool showLabel = _showPointLabels;

              if (_isFuture(spot, built.asOf)) {
                return ValueDotPainter(
                  color: Colors.greenAccent,
                  radius: 0.8,
                  textStyle: const TextStyle(fontSize: 2, color: Colors.transparent),
                  labelBuilder: (_) => '',
                );
              }

              return ValueDotPainter(
                color: Colors.greenAccent,
                radius: 0.8,
                backgroundColor: showLabel ? Colors.blue.withOpacity(0.5) : null,
                textStyle: showLabel
                    ? const TextStyle(fontSize: 1, color: Colors.white)
                    : const TextStyle(fontSize: 1, color: Colors.transparent),
                labelBuilder: showLabel ? _buildSpotLabel : (_) => '',
              );
            },
          ),
        ),
        if (_startY != null && _endY != null)
          LineChartBarData(
            barWidth: 2.5,
            color: Colors.redAccent,
            spots: <FlSpot>[FlSpot(_arrowX, _startY!), FlSpot(_arrowX, _endY!)],
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(),
            show: false,
          ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: <HorizontalLine>[
          if (_startY != null)
            HorizontalLine(
              y: _startY!,
              color: Colors.redAccent,
              dashArray: const <int>[6, 6],
              label: HorizontalLineLabel(
                show: true,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                labelResolver: (_) => ' $prevMonthLastStr ',
                padding: const EdgeInsets.only(left: 6, bottom: 2),
              ),
            ),
          if (_endY != null)
            HorizontalLine(
              y: _endY!,
              color: Colors.redAccent,
              dashArray: const <int>[6, 6],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.bottomLeft,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                labelResolver: (_) => ' ${widget.yearmonth}-${_endDay.toString().padLeft(2, '0')} ',
                padding: const EdgeInsets.only(left: 6, top: 2),
              ),
            ),
        ],
      ),
    );

    graphData2 = LineChartData(
      minX: 0,
      maxX: _lastDayOfMonth.toDouble(),
      minY: graphMin.toDouble(),
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
      ),
    );

    graphData3 = LineChartData(
      minX: 0,
      maxX: _lastDayOfMonth.toDouble(),
      minY: graphMin.toDouble(),
      maxY: graphMax.toDouble(),
      lineTouchData: const LineTouchData(enabled: false),
      rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: verticalRanges),
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: weeklyMomentumLines,
    );
  }

  ///
  int _calcTotalAssetsAtDate(DateTime date) {
    final int lastGoldSum = _findLastValidGoldValue(date);
    final int lastStockSum = _findLastValidStockSum(date);
    final int lastToushiSum = _findLastValidToushiSum(date);
    final int lastMoneySum = _findLastValidMoneySum(date);

    final int insurancePassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: date) + 102;
    final int insuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

    final int nenkinKikinPassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
    final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

    const double assetRate = 0.8;

    return lastMoneySum +
        (lastGoldSum * assetRate).toInt() +
        (lastStockSum * assetRate).toInt() +
        (lastToushiSum * assetRate).toInt() +
        insuranceSum +
        nenkinKikinSum;
  }

  ///
  int _findLastValidGoldValue(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final GoldModel? model = appParamState.keepGoldMap[key];
      if (model != null) {
        final dynamic val = model.goldValue;
        if (val != null && val.toString() != '-') {
          return val.toString().toInt();
        }
      }
    }
    return 0;
  }

  ///
  int _findLastValidStockSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<StockModel>? list = appParamState.keepStockMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcStockSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidToushiSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<ToushiShintakuModel>? list = appParamState.keepToushiShintakuMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcToushiSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidMoneySum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final String? sum = appParamState.keepMoneyMap[key]?.sum;
      if (sum != null && sum.isNotEmpty) {
        return sum.toInt();
      }
    }
    return 0;
  }

  ///
  LineChartData _animatedData(LineChartData target, double t) {
    LineChartBarData lerpBar(LineChartBarData bar) {
      final List<FlSpot> spots = <FlSpot>[
        for (final FlSpot s in bar.spots) FlSpot(s.x, graphMin + (s.y - graphMin) * t),
      ];
      return bar.copyWith(spots: spots);
    }

    return target.copyWith(
      lineBarsData: <LineChartBarData>[for (final LineChartBarData bar in target.lineBarsData) lerpBar(bar)],
    );
  }

  ///
  String _formatDelta(double d) {
    final String s = d.round().toString().toCurrency();
    return d >= 0 ? '+$s' : s;
  }

  ///
  String _buildSpotLabel(FlSpot spot) {
    final int idx = spot.x.round().clamp(0, _dateList.length - 1);
    final String date = _dateList[idx];
    final String price = spot.y.round().toString().toCurrency();
    return '$date\n$price';
  }

  ///
  bool _isFuture(FlSpot spot, DateTime asOf) {
    final int idx = spot.x.round().clamp(0, _dateList.length - 1);
    final DateTime date = DateTime.parse(_dateList[idx]);

    final DateTime today = DateTime(asOf.year, asOf.month, asOf.day);
    return date.isAfter(today);
  }

  ///
  List<List<int>> getSplitWeeksByIndex({required List<String> dateList}) {
    if (dateList.isEmpty) {
      return <List<int>>[];
    }
    final List<List<int>> result = <List<int>>[];
    final List<int> currentWeek = <int>[];
    for (int i = 0; i < dateList.length; i++) {
      final DateTime date = DateTime.parse(dateList[i]);
      if (i != 0 && date.weekday % 7 == 0) {
        result.add(List<int>.from(currentWeek));
        currentWeek.clear();
      }
      currentWeek.add(i);
    }
    if (currentWeek.isNotEmpty) {
      result.add(currentWeek);
    }
    return result;
  }

  ///
  List<VerticalRangeAnnotation> buildWeekBandsByWeeks({
    required List<List<int>> weeks,
    required bool paintEvenWeeks,
    required Color color,
    required double opacity,
  }) {
    final List<VerticalRangeAnnotation> ranges = <VerticalRangeAnnotation>[];
    for (int i = 0; i < weeks.length; i++) {
      final List<int> w = weeks[i];
      if (w.isEmpty) {
        continue;
      }

      if ((paintEvenWeeks && i.isEven) || (!paintEvenWeeks && i.isOdd)) {
        final double x1 = w.first.toDouble();
        final double x2 = (w.last + 1).toDouble();
        ranges.add(VerticalRangeAnnotation(x1: x1, x2: x2, color: color.withOpacity(opacity)));
      }
    }
    return ranges;
  }

  ///
  List<LineChartBarData> _buildWeeklyMomentumLines({
    required List<List<int>> weeks,
    required List<FlSpot> spots,
    required int? todayIndex,
  }) {
    final List<LineChartBarData> result = <LineChartBarData>[];

    int? currentWeekIndex;
    if (todayIndex != null) {
      for (int i = 0; i < weeks.length; i++) {
        if (weeks[i].contains(todayIndex)) {
          currentWeekIndex = i;
          break;
        }
      }
    }

    for (int i = 0; i < weeks.length; i++) {
      final List<int> w = weeks[i];
      if (w.isEmpty) {
        continue;
      }

      if (todayIndex != null && w.first > todayIndex) {
        continue;
      }

      final int startIndex = w.first;
      int endIndex;

      if (currentWeekIndex != null && todayIndex != null && i == currentWeekIndex) {
        endIndex = todayIndex;
      } else {
        if (i < weeks.length - 1) {
          endIndex = weeks[i + 1].first;
        } else {
          endIndex = w.last;
        }
      }

      if (todayIndex != null && endIndex > todayIndex) {
        endIndex = todayIndex;
      }

      if (endIndex <= startIndex) {
        continue;
      }

      final FlSpot start = spots[startIndex];
      final FlSpot end = spots[endIndex];

      final Color color = Colors.white.withValues(alpha: 0.2);

      result.add(
        LineChartBarData(
          spots: <FlSpot>[start, end],
          barWidth: 10,
          color: color,
          dotData: const FlDotData(show: false),
          isStrokeCapRound: true,
        ),
      );
    }

    return result;
  }
}

///
class _MonthlyBuiltData {
  const _MonthlyBuiltData({
    required this.year,
    required this.month,
    required this.lastDayOfMonth,
    required this.prevMonthLast,
    required this.lastMonthFinalAssets,
    required this.monthTotals,
    required this.asOf,
  });

  final int year;
  final int month;
  final int lastDayOfMonth;

  final DateTime prevMonthLast;
  final int lastMonthFinalAssets;

  final Map<int, int> monthTotals;
  final DateTime asOf;
}

///
class ValueDotPainter extends FlDotPainter {
  ValueDotPainter({
    required this.color,
    required this.radius,
    required this.textStyle,
    required this.labelBuilder,
    this.backgroundColor,
  });

  final Color color;
  final double radius;
  final TextStyle textStyle;
  final String Function(FlSpot spot) labelBuilder;
  final Color? backgroundColor;

  ///
  @override
  Color get mainColor => color;

  ///
  @override
  List<Object?> get props => <Object?>[color, radius, textStyle, backgroundColor];

  ///
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    if (spot.x == 0.0) {
      const double half = 4.0;
      final Paint crossPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        offsetInCanvas + const Offset(-half, -half),
        offsetInCanvas + const Offset(half, half),
        crossPaint,
      );
      canvas.drawLine(
        offsetInCanvas + const Offset(-half, half),
        offsetInCanvas + const Offset(half, -half),
        crossPaint,
      );
      return;
    }

    final Paint dotPaint = Paint()..color = color;
    canvas.drawCircle(offsetInCanvas, radius, dotPaint);

    final String label = labelBuilder(spot);
    if (label.isEmpty) {
      return;
    }

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 36);

    final Offset textOffset = offsetInCanvas - Offset(textPainter.width, textPainter.height + radius + 1);

    if (backgroundColor != null) {
      final Rect bgRect = Rect.fromLTWH(
        textOffset.dx - 1,
        textOffset.dy - 1,
        textPainter.width + 2,
        textPainter.height + 2,
      );
      final RRect rRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(2));
      final Paint bgPaint = Paint()..color = backgroundColor!;
      canvas.drawRRect(rRect, bgPaint);
    }

    textPainter.paint(canvas, textOffset);
  }

  ///
  @override
  Size getSize(FlSpot spot) => Size(max(radius * 2, 24), max(radius * 2, 24));

  ///
  @override
  bool hitTest(FlSpot spot, Offset touched, Offset center, double extraThreshold) =>
      (touched - center).distance <= radius + extraThreshold;

  ///
  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;
}
