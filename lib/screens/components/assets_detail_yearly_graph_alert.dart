import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class AssetsDetailYearlyGraphAlert extends ConsumerStatefulWidget {
  const AssetsDetailYearlyGraphAlert({super.key, required this.dateDiffMap, required this.name});

  final Map<String, int> dateDiffMap;
  final String name;

  @override
  ConsumerState<AssetsDetailYearlyGraphAlert> createState() => _AssetsDetailYearlyGraphAlertState();

  ///
  static Map<int, Map<DateTime, int>> _groupByYearToDateMap(Map<String, int> src) {
    final Map<int, Map<DateTime, int>> out = <int, Map<DateTime, int>>{};
    src.forEach((String k, int v) {
      final DateTime? dt = _tryParseDate(k);
      if (dt == null) {
        return;
      }
      final DateTime d = DateTime(dt.year, dt.month, dt.day);
      out.putIfAbsent(dt.year, () => <DateTime, int>{})[d] = v;
    });
    return out;
  }

  ///
  static List<List<FlSpot>> _buildNormalizedSegmentsForYear({
    required int year,
    required Map<DateTime, int> dailyValueMap,
  }) {
    const int templateDays = 366;

    final List<DateTime> dates = dailyValueMap.keys.toList()..sort();
    final DateTime? firstDataDate = dates.isEmpty ? null : dates.first;

    final List<List<FlSpot>> segments = <List<FlSpot>>[];
    List<FlSpot> currentSeg = <FlSpot>[];

    int? currentValue;

    for (int x = 1; x <= templateDays; x++) {
      final DateTime md = DateTime(2024).add(Duration(days: x - 1));

      final DateTime? realDate = _toRealDateOrNull(year, md.month, md.day);

      if (realDate == null) {
        if (currentValue != null) {
          currentSeg.add(FlSpot(x.toDouble(), currentValue.toDouble()));
        }
        continue;
      }

      if (firstDataDate != null && realDate.isBefore(firstDataDate)) {
        if (currentSeg.isNotEmpty) {
          segments.add(currentSeg);
          currentSeg = <FlSpot>[];
        }
        continue;
      }

      final int? v = dailyValueMap[realDate];
      if (v != null) {
        currentValue = v;
      }

      if (currentValue != null) {
        currentSeg.add(FlSpot(x.toDouble(), currentValue.toDouble()));
      } else {
        if (currentSeg.isNotEmpty) {
          segments.add(currentSeg);
          currentSeg = <FlSpot>[];
        }
      }
    }

    if (currentSeg.isNotEmpty) {
      segments.add(currentSeg);
    }

    return segments;
  }

  ///
  static DateTime? _toRealDateOrNull(int year, int month, int day) {
    if (month == 2 && day == 29 && !_isLeapYear(year)) {
      return null;
    }
    return DateTime(year, month, day);
  }

  ///
  static DateTime? _tryParseDate(String s) {
    try {
      final List<String> parts = s.split('-');
      if (parts.length != 3) {
        return null;
      }
      final int y = int.parse(parts[0]);
      final int m = int.parse(parts[1]);
      final int d = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  ///
  static bool _isLeapYear(int year) {
    if (year % 400 == 0) {
      return true;
    }
    if (year % 100 == 0) {
      return false;
    }
    return year % 4 == 0;
  }

  ///
  static double _niceInterval(double range, {int targetTicks = 5}) {
    if (!range.isFinite || range <= 0) {
      return 1;
    }

    final double rough = range / targetTicks;
    final double pow10 = _pow10(_floorLog10(rough));
    final double scaled = rough / pow10; // 1..10

    double nice;
    if (scaled <= 1) {
      nice = 1;
    } else if (scaled <= 2) {
      nice = 2;
    } else if (scaled <= 5) {
      nice = 5;
    } else {
      nice = 10;
    }
    return nice * pow10;
  }

  ///
  static int _floorLog10(double x) {
    int p = 0;
    double v = x.abs();
    if (v < 1) {
      while (v < 1) {
        v *= 10;
        p--;
        if (p < -12) {
          break;
        }
      }
      return p;
    } else {
      while (v >= 10) {
        v /= 10;
        p++;
        if (p > 12) {
          break;
        }
      }
      return p;
    }
  }

  ///
  static double _pow10(int p) {
    double v = 1;
    if (p >= 0) {
      for (int i = 0; i < p; i++) {
        v *= 10;
      }
    } else {
      for (int i = 0; i < -p; i++) {
        v /= 10;
      }
    }
    return v;
  }
}

class _AssetsDetailYearlyGraphAlertState extends ConsumerState<AssetsDetailYearlyGraphAlert> {
  Utility utility = Utility();

  List<Color> fortyEightColor = <Color>[];

  ///
  @override
  void initState() {
    super.initState();
    fortyEightColor = utility.getFortyEightColor();
  }

  ///
  Widget _buildYAxisTitle({
    required double value,
    required TitleMeta meta,
    required double chartMinY,
    required double chartMaxY,
  }) {
    if ((value - chartMinY).abs() < 1e-9 || (value - chartMaxY).abs() < 1e-9) {
      return const SizedBox.shrink();
    }
    if (value < chartMinY - 1e-9 || value > chartMaxY + 1e-9) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(value.toInt().toString().toCurrency(), style: const TextStyle(color: Colors.white70, fontSize: 10)),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final Map<int, Map<DateTime, int>> yearlyDailyValueMap = AssetsDetailYearlyGraphAlert._groupByYearToDateMap(
      widget.dateDiffMap,
    );
    final List<int> years = yearlyDailyValueMap.keys.toList()..sort();

    if (years.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.65),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _EmptyView(title: widget.name),
              ),
            ),
          ),
        ),
      );
    }

    final List<_BarMeta> barMetas = <_BarMeta>[];
    final List<LineChartBarData> bars = <LineChartBarData>[];

    for (int i = 0; i < years.length; i++) {
      final int year = years[i];
      final Color c = fortyEightColor[i % 48];

      final List<List<FlSpot>> segments = AssetsDetailYearlyGraphAlert._buildNormalizedSegmentsForYear(
        year: year,
        dailyValueMap: yearlyDailyValueMap[year]!,
      );

      for (final List<FlSpot> seg in segments) {
        bars.add(
          LineChartBarData(
            spots: seg,
            color: c,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(),
          ),
        );
        barMetas.add(_BarMeta(year: year, color: c));
      }
    }

    final List<double> allY = <double>[];
    for (final LineChartBarData b in bars) {
      for (final FlSpot s in b.spots) {
        allY.add(s.y);
      }
    }

    if (allY.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.65),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _EmptyView(title: widget.name),
              ),
            ),
          ),
        ),
      );
    }

    final double minY = allY.reduce((double a, double b) => a < b ? a : b);
    final double maxY = allY.reduce((double a, double b) => a > b ? a : b);

    final double rawRange = (maxY - minY).abs();
    final double paddingY = (rawRange * 0.08).clamp(1, double.infinity);
    final double chartMinY = minY - paddingY;
    final double chartMaxY = maxY + paddingY;

    final double yInterval = AssetsDetailYearlyGraphAlert._niceInterval(chartMaxY - chartMinY);

    const double chartMinX = 1;
    const double chartMaxX = 366;

    final List<_LegendYear> legendYears = <_LegendYear>[];
    for (int i = 0; i < years.length; i++) {
      legendYears.add(_LegendYear(year: years[i], color: fortyEightColor[i % 48]));
    }

    const double leftReserved = 64;
    const double rightReserved = 64;

    // ---------------- 上：グラフ（←今回、縦軸も表示して検証する） ----------------
    final LineChartData graphData = LineChartData(
      minX: chartMinX,
      maxX: chartMaxX,
      minY: chartMinY,
      maxY: chartMaxY,

      gridData: FlGridData(verticalInterval: 30, horizontalInterval: yInterval),

      titlesData: const FlTitlesData(show: false),

      borderData: FlBorderData(show: true),

      lineBarsData: bars,

      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 10,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot s) {
              final int barIndex = s.barIndex;
              final int year = (barIndex >= 0 && barIndex < barMetas.length) ? barMetas[barIndex].year : 0;

              final int x = s.x.toInt();
              final DateTime md = DateTime(2024).add(Duration(days: x - 1));

              String label = '$year/${md.month.toString().padLeft(2, '0')}/${md.day.toString().padLeft(2, '0')}';
              if (!AssetsDetailYearlyGraphAlert._isLeapYear(year) && md.month == 2 && md.day == 29) {
                label = '$year/02/29 (skip)';
              }

              return LineTooltipItem(
                '$label\n${s.y.toInt().toString().toCurrency()}',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList();
          },
        ),
      ),
    );

    // ---------------- 下：判例（軸ラベルだけ） ----------------
    final LineChartData graphData2 = LineChartData(
      minX: chartMinX,
      maxX: chartMaxX,
      minY: chartMinY,
      maxY: chartMaxY,

      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),

        bottomTitles: const AxisTitles(),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: leftReserved,
            interval: yInterval,
            getTitlesWidget: (double value, TitleMeta meta) {
              return _buildYAxisTitle(value: value, meta: meta, chartMinY: chartMinY, chartMaxY: chartMaxY);
            },
          ),
        ),

        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: rightReserved,
            interval: yInterval,
            getTitlesWidget: (double value, TitleMeta meta) {
              return _buildYAxisTitle(value: value, meta: meta, chartMinY: chartMinY, chartMaxY: chartMaxY);
            },
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black.withOpacity(0.65),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.name,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: legendYears.map((_LegendYear ly) {
                      return _LegendItem(color: ly.color, label: ly.year.toString());
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  ///
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.title});

  final String title;

  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Expanded(
          child: Center(
            child: Text('No data', style: TextStyle(color: Colors.white70)),
          ),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class _LegendYear {
  const _LegendYear({required this.year, required this.color});

  final int year;
  final Color color;
}

class _BarMeta {
  const _BarMeta({required this.year, required this.color});

  final int year;
  final Color color;
}
