import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';

///
/// 年間資産の折れ線グラフ（暫定版 / fl_chart）
///
/// 改善点
/// - 「今年」の場合は、未来日付を 0 扱いで落とさず、
///   「今日の値」で最後まで水平に延ばす（横ばい）
///
/// 入力:
/// - year: 対象年（例: 2025）
/// - totals: 1/1〜12/31 の順で並んだ total のリスト想定
///
class YearlyAssetsLineGraphAlert extends StatefulWidget {
  const YearlyAssetsLineGraphAlert({
    super.key,
    required this.year,
    required this.totals,
    this.title,
    this.showDots = false,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 24),
  });

  final int year;
  final List<int> totals;
  final String? title;

  /// 点表示
  final bool showDots;

  final EdgeInsets padding;

  @override
  State<YearlyAssetsLineGraphAlert> createState() => _YearlyAssetsLineGraphAlertState();
}

class _YearlyAssetsLineGraphAlertState extends State<YearlyAssetsLineGraphAlert> {
  late final List<int> _plotTotals;

  late final double _minY;
  late final double _maxY;

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

    // fl_chart のレンジが 0 だと表示が潰れるので、少し余白を付ける
    final double pad = ((maxV - minV).abs() * 0.08).clamp(1, double.infinity).toDouble();

    _minY = minV - pad;
    _maxY = maxV + pad;

    if (_minY == _maxY) {
      // 念のため
      // ignore: join_return_with_assignment
      // ignore: avoid_redundant_argument_values
      // ignore: no_adjacent_strings_in_list
      // ignore: avoid_multiple_declarations_per_line
      // ignore: avoid_equals_and_hash_code_on_mutable_classes
      // ignore: unnecessary_lambdas
      // ignore: prefer_final_locals
      // ignore: unnecessary_statements
      // ignore: unnecessary_parenthesis
    }
  }

  /// 今年なら「未来日付」を「今日の値」で埋めて横ばいにする
  List<int> _buildPlotTotals({required int year, required List<int> totals}) {
    if (totals.isEmpty) {
      return <int>[];
    }

    final DateTime today = DateTime.now();

    // 今年以外はそのまま
    if (year != today.year) {
      return totals;
    }

    final int todayIndex0 = _dayOfYear(today) - 1; // 0-based
    final int todayIndex = todayIndex0.clamp(0, totals.length - 1);

    final int todayValue = totals[todayIndex];

    final List<int> filled = List<int>.from(totals);
    for (int i = todayIndex + 1; i < filled.length; i++) {
      filled[i] = todayValue;
    }

    return filled;
  }

  /// day-of-year（1〜365/366）
  int _dayOfYear(DateTime date) {
    final DateTime start = DateTime(date.year);
    return date.difference(start).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.title ?? '${widget.year} 年 資産推移';

    final int start = _plotTotals.isNotEmpty ? _plotTotals.first : 0;
    final int end = _plotTotals.isNotEmpty ? _plotTotals.last : 0;
    final int diff = end - start;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _summaryRow(
                start: start,
                end: end,
                diff: diff,
                last: end,
                min: _plotTotals.isEmpty ? 0 : _plotTotals.reduce((int a, int b) => a < b ? a : b),
                max: _plotTotals.isEmpty ? 0 : _plotTotals.reduce((int a, int b) => a > b ? a : b),
                pointsCount: _plotTotals.length,
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
                  child: _plotTotals.isEmpty ? const Center(child: Text('データがありません')) : LineChart(_buildChartData()),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                '※ 暫定版（今年は「今日の値」で未来日付を横ばい補完）',
                style: TextStyle(fontSize: 12, color: Colors.grey.withValues(alpha: 0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    final List<FlSpot> spots = <FlSpot>[
      for (int i = 0; i < _plotTotals.length; i++) FlSpot(i.toDouble(), _plotTotals[i].toDouble()),
    ];

    // Xは「day index (0..n-1)」なので、目盛はざっくり「月っぽい位置」を出す
    // 厳密な月境界を作るのは後でOK（暫定）
    final List<int> monthStartIndex = _approxMonthStartIndexes(widget.year, _plotTotals.length);

    return LineChartData(
      minY: _minY,
      maxY: _maxY,
      minX: 0,
      maxX: (_plotTotals.isEmpty) ? 0 : (_plotTotals.length - 1).toDouble(),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: _niceYInterval(_minY, _maxY),
        getDrawingHorizontalLine: (double value) => FlLine(color: Colors.grey.withValues(alpha: 0.18), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withValues(alpha: 0.25))),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 52,
            interval: _niceYInterval(_minY, _maxY),
            getTitlesWidget: (double value, TitleMeta meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  _compactNumber(value),
                  style: TextStyle(color: Colors.grey.withValues(alpha: 0.9), fontSize: 11),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              final int idx = value.round();
              if (!monthStartIndex.contains(idx)) {
                return const SizedBox.shrink();
              }
              final int month = monthStartIndex.indexOf(idx) + 1;
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('$month', style: TextStyle(color: Colors.grey.withValues(alpha: 0.9), fontSize: 11)),
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot s) {
              final int index = s.x.toInt();

              // x(0-based) -> yyyy-mm-dd
              final DateTime date = DateTime(widget.year).add(Duration(days: index));
              final String dateStr =
                  '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

              final String v = s.y.toInt().toString().toCurrency();

              return LineTooltipItem('$dateStr\n$v', const TextStyle(color: Colors.white, fontSize: 12));
            }).toList();
          },
        ),
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: spots,
          // “普通の折れ線”
          barWidth: 2.2,
          color: Colors.blueAccent,
          dotData: FlDotData(show: widget.showDots),
          belowBarData: BarAreaData(),
        ),
      ],
    );
  }

  /// 月の開始インデックスをざっくり作る（暫定）
  /// - totals の長さが 365/366 でなくても崩れないように、比率で算出
  List<int> _approxMonthStartIndexes(int year, int length) {
    if (length <= 1) {
      return <int>[0];
    }

    // 実日数ベースで月初の day-of-year を作る（1-based）
    final List<int> starts = <int>[];
    for (int m = 1; m <= 12; m++) {
      final DateTime first = DateTime(year, m);
      final int doy = first.difference(DateTime(year)).inDays + 1;
      starts.add(doy);
    }

    // doy(1-based) -> index(0-based) を、length に合わせて縮尺して割り当て
    final int yearDays = DateTime(year + 1).difference(DateTime(year)).inDays;
    return starts.map((int doy) {
      final double ratio = (doy - 1) / (yearDays - 1);
      return (ratio * (length - 1)).round().clamp(0, length - 1);
    }).toList();
  }

  /// Y軸の見やすい interval を作る（簡易）
  double _niceYInterval(double minY, double maxY) {
    final double range = (maxY - minY).abs();
    if (range <= 0) {
      return 1;
    }
    final double rough = range / 4; // だいたい4本くらい
    // 1,2,5,10...系に丸める
    final double pow10 = _pow10Floor(rough);
    final double n = rough / pow10;
    if (n <= 1) {
      return 1 * pow10;
    }
    if (n <= 2) {
      return 2 * pow10;
    }
    if (n <= 5) {
      return 5 * pow10;
    }
    return 10 * pow10;
  }

  double _pow10Floor(double v) {
    double p = 1;
    while (p * 10 <= v) {
      p *= 10;
    }
    return p;
  }

  String _compactNumber(double value) {
    final int v = value.round().abs();
    if (v >= 100000000) {
      // 億
      return '${(value / 100000000).toStringAsFixed(1)}億';
    }
    if (v >= 10000) {
      // 万
      return '${(value / 10000).toStringAsFixed(0)}万';
    }
    return value.toInt().toString();
  }

  Widget _summaryRow({
    required int start,
    required int end,
    required int diff,
    required int last,
    required int min,
    required int max,
    required int pointsCount,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: <Widget>[
        _pill(label: 'Points', value: pointsCount),
        _pill(label: 'Start', value: start),
        _pill(label: 'End', value: end),
        _pill(label: 'Diff', value: diff),
        _pill(label: 'Min', value: min),
        _pill(label: 'Max', value: max),
      ],
    );
  }

  Widget _pill({required String label, required int value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      child: Text('$label: $value'),
    );
  }
}
