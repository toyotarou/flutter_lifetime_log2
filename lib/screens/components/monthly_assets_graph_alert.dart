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

class _MonthlyAssetsGraphAlertState extends ConsumerState<MonthlyAssetsGraphAlert> with SingleTickerProviderStateMixin {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

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

  ///
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();

    transformationController.addListener(_onTransformChanged);
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
    _setChartData();

    Alignment yToAlign(double y) {
      final double t = (graphMax - y) / (graphMax - graphMin);
      final double alignY = (t * 2) - 1;
      return Alignment(0.92, alignY.clamp(-1.0, 1.0));
    }

    final double delta = (_startY != null && _endY != null) ? (_endY! - _startY!) : 0.0;
    final double midY = (_startY != null && _endY != null) ? ((_startY! + _endY!) / 2.0) : graphMin.toDouble();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('monthly assets graph'),
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
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];
    _dateList = <String>[];

    final List<int> monthlyAssetValueList = <int>[];

    int lastTotal = 0;

    final List<int> sortedKeys = widget.monthlyGraphAssetsMap.keys.toList()..sort();

    for (final int key in sortedKeys) {
      final int value = widget.monthlyGraphAssetsMap[key]!;
      _flspots.add(FlSpot(key.toDouble(), value.toDouble()));
      monthlyAssetValueList.add(value);
      _dateList.add('${widget.yearmonth}-${key.toString().padLeft(2, '0')}');
      if (value > 0) {
        lastTotal = value;
      }
    }

    final List<String> parts = widget.yearmonth.split('-');
    final int y = parts[0].toInt();
    final int m = parts[1].toInt();

    _lastDayOfMonth = DateTime(y, m + 1, 0).day;

    if (monthlyAssetValueList.isNotEmpty) {
      for (int d = (sortedKeys.isEmpty ? 1 : (sortedKeys.last + 1)); d <= _lastDayOfMonth; d++) {
        _flspots.add(FlSpot(d.toDouble(), lastTotal.toDouble()));
        _dateList.add('${widget.yearmonth}-${d.toString().padLeft(2, '0')}');
      }
    }

    if (monthlyAssetValueList.isNotEmpty) {
      const int step = 500000;
      final int minValue = monthlyAssetValueList.reduce(min);
      final int maxValue = monthlyAssetValueList.reduce(max);

      graphMin = ((minValue / step).floor()) * step;
      graphMax = ((maxValue / step).ceil()) * step;

      double? startY = widget.monthlyGraphAssetsMap[1]?.toDouble();
      if (startY == null) {
        for (int d = 2; d <= _lastDayOfMonth; d++) {
          final int? v = widget.monthlyGraphAssetsMap[d];
          if (v != null) {
            startY = v.toDouble();
            break;
          }
        }
      }

      final bool isCurrentMonth =
          widget.yearmonth == '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
      _endDay = isCurrentMonth ? DateTime.now().day.clamp(1, _lastDayOfMonth) : _lastDayOfMonth;

      double? endY = widget.monthlyGraphAssetsMap[_endDay]?.toDouble();
      if (endY == null) {
        for (int d = _endDay - 1; d >= 1; d--) {
          final int? v = widget.monthlyGraphAssetsMap[d];
          if (v != null) {
            endY = v.toDouble();
            break;
          }
        }
        endY ??= lastTotal.toDouble();
      }

      _startY = startY;
      _endY = endY;

      final List<List<int>> weeks = getSplitWeeksByIndex(dateList: _dateList);
      final List<VerticalRangeAnnotation> verticalRanges = buildWeekBandsByWeeks(
        weeks: weeks,
        paintEvenWeeks: true,
        color: Colors.yellowAccent,
        opacity: 0.1,
      );

      int? todayIndex;
      if (isCurrentMonth) {
        final String todayStr = '${widget.yearmonth}-${DateTime.now().day.toString().padLeft(2, '0')}';
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
        minX: 1,
        maxX: _lastDayOfMonth.toDouble(),
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot s) {
                final TextStyle baseStyle = TextStyle(
                  color: s.bar.gradient?.colors.first ?? s.bar.color ?? Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );

                final int price = s.y.round();
                final String displayPrice = price.toString().toCurrency();

                final int day = s.x.toInt().clamp(1, _lastDayOfMonth);
                final String date = '${widget.yearmonth}-${day.toString().padLeft(2, '0')}';
                final String youbi = DateTime(
                  date.split('-')[0].toInt(),
                  date.split('-')[1].toInt(),
                  date.split('-')[2].toInt(),
                ).youbiStr.substring(0, 3);

                final int diffFromStart = monthlyAssetValueList.first - price;
                final String kigouFromStart = (diffFromStart > 0) ? '-' : '+';
                final String diffFromStartText = '$kigouFromStart${diffFromStart.abs().toString().toCurrency()}';

                int? prevPrice;
                if (day > 1) {
                  for (int d = day - 1; d >= 1; d--) {
                    final int? v = widget.monthlyGraphAssetsMap[d];
                    if (v != null) {
                      prevPrice = v;
                      break;
                    }
                  }
                }

                String diffFromPrevText = '';
                Color diffColor = Colors.white;

                if (prevPrice != null) {
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
        rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: verticalRanges),
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingHorizontalLine: (double value) => FlLine(
            color: (value == 0.0) ? Colors.greenAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (double value) {
            final String youbi = DateTime(
              widget.yearmonth.split('-')[0].toInt(),
              widget.yearmonth.split('-')[1].toInt(),
            ).add(Duration(days: value.toInt() - 1)).youbiStr;

            final bool isTodayLine =
                widget.yearmonth.split('-')[0] == DateTime.now().year.toString() &&
                widget.yearmonth.split('-')[1] == DateTime.now().month.toString().padLeft(2, '0') &&
                value.toInt() == DateTime.now().day;

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
              show: _showPointLabels,
              getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
                if (_isFuture(spot)) {
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
          ),
          ...weeklyMomentumLines,
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
                  labelResolver: (_) => ' ${widget.yearmonth}-01 ',
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
        minX: 1,
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
    }
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
    final int day = spot.x.toInt().clamp(1, _lastDayOfMonth);
    final String date = '${widget.yearmonth}-${day.toString().padLeft(2, '0')}';
    final String price = spot.y.round().toString().toCurrency();
    return '$date\n$price';
  }

  ///
  bool _isFuture(FlSpot spot) {
    final List<String> parts = widget.yearmonth.split('-');
    final int year = parts[0].toInt();
    final int month = parts[1].toInt();
    final int day = spot.x.toInt().clamp(1, _lastDayOfMonth);

    final DateTime date = DateTime(year, month, day);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

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
        final double x1 = w.first + 1.0;
        final double x2 = w.last + 2.0;
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
