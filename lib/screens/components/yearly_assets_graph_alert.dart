import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';

class YearlyAssetsGraphAlert extends StatefulWidget {
  const YearlyAssetsGraphAlert({
    super.key,
    required this.year,
    required this.totals,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 24),
  });

  final int year;
  final List<int> totals;
  final EdgeInsets padding;

  @override
  State<YearlyAssetsGraphAlert> createState() => _YearlyAssetsGraphAlertState();
}

class _YearlyAssetsGraphAlertState extends State<YearlyAssetsGraphAlert> {
  late final List<int> _plotTotals;
  late final double _minY;
  late final double _maxY;

  static const double _gridStep = 500000;

  static const double _monthBoundaryBandWidthX = 1;
  static const double _todayBandWidthX = 3;

  ///
  @override
  void initState() {
    super.initState();

    _plotTotals = _buildPlotTotals(year: widget.year, totals: widget.totals);
    if (_plotTotals.isEmpty) {
      _minY = 0;
      _maxY = 0;
      return;
    }

    final int minV = _plotTotals.reduce((int a, int b) => a < b ? a : b);
    final int maxV = _plotTotals.reduce((int a, int b) => a > b ? a : b);

    final double minRounded = (minV.toDouble() / _gridStep).floor() * _gridStep;
    final double maxRounded = (maxV.toDouble() / _gridStep).ceil() * _gridStep;

    if (minRounded == maxRounded) {
      _minY = minRounded - _gridStep;
      _maxY = maxRounded + _gridStep;
    } else {
      _minY = minRounded;
      _maxY = maxRounded;
    }
  }

  ///
  List<int> _buildPlotTotals({required int year, required List<int> totals}) {
    if (totals.isEmpty) {
      return <int>[];
    }

    final DateTime today = DateTime.now();
    if (year != today.year) {
      return totals;
    }

    final int todayIndex = (_dayOfYear(today) - 1).clamp(0, totals.length - 1);
    final int todayValue = totals[todayIndex];

    final List<int> filled = List<int>.from(totals);
    for (int i = todayIndex + 1; i < filled.length; i++) {
      filled[i] = todayValue;
    }
    return filled;
  }

  ///
  int _dayOfYear(DateTime date) => date.difference(DateTime(date.year)).inDays + 1;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: widget.padding,
          child: _plotTotals.isEmpty
              ? const Center(child: Text('データがありません'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${widget.year} 年 資産推移'),
                    Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          LineChart(makeBackgroundChart()),

                          LineChart(makeAxisChart()),

                          LineChart(makeMainChart()),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  ///
  List<FlSpot> _buildSpots() => <FlSpot>[
    for (int i = 0; i < _plotTotals.length; i++) FlSpot(i.toDouble(), _plotTotals[i].toDouble()),
  ];

  ///
  String _yLabel(double value) => value.toInt().toString();

  ///
  LineChartData makeMainChart() {
    final List<FlSpot> spots = _buildSpots();

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: _minY,
      maxY: _maxY,
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withValues(alpha: 0.25))),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 6,
          getTooltipItems: (List<LineBarSpot> touched) {
            return touched.map((LineBarSpot s) {
              final int idx = s.x.toInt().clamp(0, spots.length - 1);
              final DateTime date = DateTime(widget.year).add(Duration(days: idx));
              final String dateStr =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

              return LineTooltipItem(
                '$dateStr\n${s.y.toInt().toString().toCurrency()}',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: spots,
          color: Colors.greenAccent,
          barWidth: 1.8,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
        ),
      ],
    );
  }

  ///
  LineChartData makeAxisChart() {
    const double interval = _gridStep;
    final List<FlSpot> spots = _buildSpots();

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: _minY,
      maxY: _maxY,
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (double value) => FlLine(color: Colors.grey.withValues(alpha: 0.18), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        bottomTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            interval: interval,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value <= _minY || value >= _maxY) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 6,
                child: Text(_yLabel(value), style: TextStyle(color: Colors.grey.withValues(alpha: 0.9), fontSize: 10)),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            interval: interval,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value <= _minY || value >= _maxY) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 6,
                child: Text(_yLabel(value), style: TextStyle(color: Colors.grey.withValues(alpha: 0.9), fontSize: 10)),
              );
            },
          ),
        ),
      ),
    );
  }

  ///
  LineChartData makeBackgroundChart() {
    final List<FlSpot> spots = _buildSpots();

    final List<VerticalRangeAnnotation> ranges = <VerticalRangeAnnotation>[
      ..._buildOddMonthBands(),
      ..._buildMonthBoundaryLines(),
      ..._buildTodayLine(),
    ];

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: _minY,
      maxY: _maxY,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      lineTouchData: const LineTouchData(enabled: false),

      rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: ranges),

      lineBarsData: _buildMonthlyMomentumLines(spots),
    );
  }

  ///
  List<VerticalRangeAnnotation> _buildOddMonthBands() {
    final List<VerticalRangeAnnotation> ranges = <VerticalRangeAnnotation>[];

    for (int m = 1; m <= 12; m++) {
      if (m.isEven) {
        continue;
      }

      final DateTime start = DateTime(widget.year, m);
      final DateTime end = DateTime(widget.year, m + 1, 0);

      final int s = start.difference(DateTime(widget.year)).inDays;
      final int e = end.difference(DateTime(widget.year)).inDays;

      if (s >= _plotTotals.length) {
        continue;
      }

      ranges.add(
        VerticalRangeAnnotation(
          x1: s.toDouble(),
          x2: e.clamp(0, _plotTotals.length - 1).toDouble(),
          color: Colors.yellowAccent.withOpacity(0.10),
        ),
      );
    }

    return ranges;
  }

  ///
  List<VerticalRangeAnnotation> _buildMonthBoundaryLines() {
    final List<VerticalRangeAnnotation> ranges = <VerticalRangeAnnotation>[];

    final int maxIdx = _plotTotals.length - 1;
    if (maxIdx <= 0) {
      return ranges;
    }

    for (int m = 2; m <= 12; m++) {
      final DateTime monthStart = DateTime(widget.year, m);
      final int idx = monthStart.difference(DateTime(widget.year)).inDays;

      if (idx <= 0 || idx > maxIdx) {
        continue;
      }

      final double x = idx.toDouble();

      ranges.add(
        VerticalRangeAnnotation(
          x1: (x - (_monthBoundaryBandWidthX / 2)).clamp(0.0, maxIdx.toDouble()),
          x2: (x + (_monthBoundaryBandWidthX / 2)).clamp(0.0, maxIdx.toDouble()),
          color: Colors.white.withOpacity(0.35),
        ),
      );
    }

    return ranges;
  }

  ///
  List<VerticalRangeAnnotation> _buildTodayLine() {
    final List<VerticalRangeAnnotation> ranges = <VerticalRangeAnnotation>[];

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (widget.year != today.year) {
      return ranges;
    }

    final int maxIdx = _plotTotals.length - 1;
    if (maxIdx <= 0) {
      return ranges;
    }

    final int todayIdx = today.difference(DateTime(widget.year)).inDays.clamp(0, maxIdx);
    final double x = todayIdx.toDouble();

    ranges.add(
      VerticalRangeAnnotation(
        x1: (x - (_todayBandWidthX / 2)).clamp(0.0, maxIdx.toDouble()),
        x2: (x + (_todayBandWidthX / 2)).clamp(0.0, maxIdx.toDouble()),
        color: const Color(0xFFFBB6CE).withOpacity(0.35),
      ),
    );

    return ranges;
  }

  ///
  List<LineChartBarData> _buildMonthlyMomentumLines(List<FlSpot> spots) {
    final List<LineChartBarData> result = <LineChartBarData>[];

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (int m = 1; m <= 12; m++) {
      final DateTime start = DateTime(widget.year, m);
      DateTime end = DateTime(widget.year, m + 1, 0);

      if (widget.year == today.year && m == today.month) {
        end = today;
      }

      final int sIdx = start.difference(DateTime(widget.year)).inDays;
      final int eIdx = end.difference(DateTime(widget.year)).inDays.clamp(0, spots.length - 1);

      if (sIdx >= eIdx) {
        continue;
      }
      if (sIdx < 0 || sIdx >= spots.length) {
        continue;
      }

      result.add(
        LineChartBarData(
          spots: <FlSpot>[spots[sIdx], spots[eIdx]],
          barWidth: 10,
          color: Colors.white.withOpacity(0.20),
          dotData: const FlDotData(show: false),
          isStrokeCapRound: true,
          belowBarData: BarAreaData(),
        ),
      );
    }

    return result;
  }
}
