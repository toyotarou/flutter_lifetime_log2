import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';

class YearlyAssetsGraphAlert extends StatefulWidget {
  const YearlyAssetsGraphAlert({
    super.key,
    required this.year,
    required this.totals,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 24),
    required this.lastTotal,
  });

  final int year;
  final List<int> totals;
  final EdgeInsets padding;

  final int lastTotal;

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

  final TransformationController transformationController = TransformationController();
  bool zoomMode = false;
  bool _showPointLabels = false;

  int? _todayIndex;

  DateTime get _baseDate => DateTime(widget.year).subtract(const Duration(days: 1));

  ///
  @override
  void initState() {
    super.initState();

    _plotTotals = _buildPlotTotals(year: widget.year, totals: widget.totals, lastTotal: widget.lastTotal);

    if (_plotTotals.isEmpty) {
      _minY = 0;
      _maxY = 0;
      _todayIndex = null;
      transformationController.addListener(_onTransformChanged);
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

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    if (widget.year == today.year) {
      final int idx = _dayOfYear(today).clamp(0, _plotTotals.length - 1);
      _todayIndex = idx;
    } else {
      _todayIndex = null;
    }

    transformationController.addListener(_onTransformChanged);
  }

  ///
  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
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
  List<int> _buildPlotTotals({required int year, required List<int> totals, required int lastTotal}) {
    if (totals.isEmpty) {
      return <int>[];
    }

    final DateTime today = DateTime.now();
    final List<int> filled;

    if (year != today.year) {
      filled = List<int>.from(totals);
    } else {
      final int todayIndexInTotals = (_dayOfYear(today) - 1).clamp(0, totals.length - 1);
      final int todayValue = totals[todayIndexInTotals];

      filled = List<int>.from(totals);
      for (int i = todayIndexInTotals + 1; i < filled.length; i++) {
        filled[i] = todayValue;
      }
    }

    return <int>[lastTotal, ...filled];
  }

  ///
  int _dayOfYear(DateTime date) => date.difference(DateTime(date.year)).inDays + 1;

  ///
  bool _isFutureIndex(int idx) {
    if (_todayIndex == null) {
      return false;
    }
    return idx > _todayIndex!;
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (_plotTotals.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: widget.padding,
            child: const Center(child: Text('データがありません')),
          ),
        ),
      );
    }

    final Widget chartStack = Stack(
      children: <Widget>[
        LineChart(makeBackgroundChart()),
        LineChart(makeAxisChart()),
        LineChart(makeMainChart(zoomMode: zoomMode, showPointLabels: _showPointLabels)),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${widget.year} 年 資産推移'),
                  Row(
                    children: <Widget>[
                      if (zoomMode)
                        IconButton(
                          onPressed: () => setState(() {
                            transformationController.value = Matrix4.identity();
                            _showPointLabels = false;
                          }),
                          icon: const Icon(Icons.lock_reset),
                        ),
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
                child: zoomMode
                    ? InteractiveViewer(
                        transformationController: transformationController,
                        minScale: 1.0,
                        maxScale: 10.0,
                        child: AbsorbPointer(child: chartStack),
                      )
                    : chartStack,
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
  String _yLabel(double value) => value.toInt().toString().toCurrency();

  ///
  String _buildSpotLabel(FlSpot spot) {
    final List<FlSpot> spots = _buildSpots();
    final int idx = spot.x.round().clamp(0, spots.length - 1);

    final DateTime date = _baseDate.add(Duration(days: idx));

    final String dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final String price = spot.y.round().toString().toCurrency();
    return '$dateStr\n$price';
  }

  ///
  LineChartData makeMainChart({required bool zoomMode, required bool showPointLabels}) {
    final List<FlSpot> spots = _buildSpots();

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: _minY,
      maxY: _maxY,
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withValues(alpha: 0.25))),
      lineTouchData: zoomMode
          ? const LineTouchData(enabled: false)
          : LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 6,
                getTooltipItems: (List<LineBarSpot> touched) {
                  return touched.map((LineBarSpot s) {
                    final int idx = s.spotIndex.clamp(0, spots.length - 1);

                    if (_isFutureIndex(idx)) {
                      return null;
                    }

                    final DateTime date = _baseDate.add(Duration(days: idx));
                    final String dateStr =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                    final TextStyle style = TextStyle(color: (idx == 0) ? Colors.white : Colors.white, fontSize: 12);

                    return LineTooltipItem('$dateStr\n${s.y.toInt().toString().toCurrency()}', style);
                  }).toList();
                },
              ),
            ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: spots,
          color: Colors.greenAccent,
          barWidth: 1,
          dotData: FlDotData(
            show: showPointLabels,
            getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
              final int idx = index.clamp(0, spots.length - 1);
              if (_isFutureIndex(idx)) {
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
                backgroundColor: Colors.blue.withOpacity(0.5),
                textStyle: const TextStyle(fontSize: 1, color: Colors.white),
                labelBuilder: _buildSpotLabel,
              );
            },
          ),
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
                child: Text(_yLabel(value), style: const TextStyle(fontSize: 10)),
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
                child: Text(_yLabel(value), style: const TextStyle(fontSize: 10)),
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

      final int s = start.difference(DateTime(widget.year)).inDays + 1;
      final int e = end.difference(DateTime(widget.year)).inDays + 1;

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
      final int idx = monthStart.difference(DateTime(widget.year)).inDays + 1;

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

    final int todayIdx = (today.difference(DateTime(widget.year)).inDays + 1).clamp(0, maxIdx);
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

      final int sIdx = start.difference(DateTime(widget.year)).inDays + 1;
      final int eIdx = (end.difference(DateTime(widget.year)).inDays + 1).clamp(0, spots.length - 1);

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

  @override
  Color get mainColor => color;

  @override
  List<Object?> get props => <Object?>[color, radius, textStyle, backgroundColor];

  ///
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
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
  Size getSize(FlSpot spot) => Size(radius * 2, radius * 2);

  ///
  @override
  bool hitTest(FlSpot spot, Offset touched, Offset center, double extraThreshold) =>
      (touched - center).distance <= radius + extraThreshold;

  ///
  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;
}
