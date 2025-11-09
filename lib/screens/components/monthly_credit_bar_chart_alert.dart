import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class MonthlyCreditBarChartAlert extends ConsumerStatefulWidget {
  const MonthlyCreditBarChartAlert({super.key});

  @override
  ConsumerState<MonthlyCreditBarChartAlert> createState() => _MonthlyCreditBarChartAlertState();
}

class _MonthlyCreditBarChartAlertState extends ConsumerState<MonthlyCreditBarChartAlert>
    with ControllersMixin<MonthlyCreditBarChartAlert> {
  Utility utility = Utility();

  ///
  // ignore: always_specify_types
  static final List<String> months = List.generate(12, (int i) => '${i + 1}月');

  ///
  List<BarChartGroupData> _buildGroups() {
    final List<BarChartGroupData> groups = <BarChartGroupData>[];

    final List<String> creditItemList = utility.getCreditItemList();
    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    Color dim(Color c) => Color.lerp(c, Colors.white, 0.35)!;

    for (int month = 1; month <= 12; month++) {
      if (appParamState.keepCreditSummaryTotalMap[month] != null) {
        final Map<String, int> data = appParamState.keepCreditSummaryTotalMap[month]!;
        double cursor = 0;
        final List<BarChartRodStackItem> stack = <BarChartRodStackItem>[];

        for (int i = 0; i < creditItemList.length; i++) {
          final String cat = creditItemList[i];
          final double val = (data[cat] ?? 0).toDouble();
          if (val > 0) {
            final Color baseColor = dim(twentyFourColor[i % 24]);
            stack.add(BarChartRodStackItem(cursor, cursor + val, baseColor));
            cursor += val;
          }
        }

        groups.add(
          BarChartGroupData(
            x: month - 1,
            groupVertically: true,
            barRods: <BarChartRodData>[
              BarChartRodData(toY: cursor, rodStackItems: stack, borderRadius: BorderRadius.zero, width: 18),
            ],
          ),
        );
      }
    }

    return groups;
  }

  ///
  double get _maxY {
    double maxVal = 0;
    for (final Map<String, int> m in appParamState.keepCreditSummaryTotalMap.values) {
      final int total = m.values.fold(0, (int p, int v) => p + v);
      if (total > maxVal) {
        maxVal = total.toDouble();
      }
    }
    return maxVal * 1.15; // 余白
  }

  ///
  Widget _bottomTitles(double v, TitleMeta meta) {
    final int idx = v.toInt();
    if (idx < 0 || idx >= months.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      child: Text(months[idx], style: const TextStyle(fontSize: 11)),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> groups = _buildGroups();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),

            _Legend.fixed(labels: utility.getCreditItemList(), colors: utility.getTwentyFourColor()),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                child: BarChart(
                  BarChartData(
                    maxY: _maxY,
                    barGroups: groups,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (double v) =>
                          FlLine(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6), strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: _bottomTitles,
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipMargin: 8,
                        getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                          final int month = groupIndex + 1;

                          final Map<String, int> data = appParamState.keepCreditSummaryTotalMap[month]!;

                          final List<MapEntry<String, int>> nonZero = data.entries
                              .where((MapEntry<String, int> e) => e.value > 0)
                              .toList();

                          final int total = nonZero.fold(0, (int p, MapEntry<String, int> e) => p + e.value);

                          final StringBuffer buf = StringBuffer()
                            ..writeln(months[groupIndex])
                            ..writeln('────────');

                          for (final MapEntry<String, int> e in nonZero) {
                            buf.writeln('${e.key}　${e.value.toString().toCurrency()}');
                          }

                          buf.writeln('────────');
                          buf.writeln('合計: ${total.toString().toCurrency()}');

                          return BarTooltipItem(buf.toString(), const TextStyle(fontSize: 10, color: Colors.white));
                        },
                      ),
                    ),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _Legend extends StatelessWidget {
  const _Legend.fixed({required this.labels, required this.colors});

  final List<String> labels;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    Color dim(Color c) => Color.lerp(c, Colors.white, 0.35)!;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      // ignore: always_specify_types
      children: List.generate(labels.length, (int i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(width: 12, height: 12, color: dim(colors[i])),
            const SizedBox(width: 6),
            Text(labels[i], style: const TextStyle(fontSize: 10)),
          ],
        );
      }),
    );
  }
}
