import 'package:flutter/material.dart';

///
/// 年間資産の折れ線グラフ（暫定版 / Alert）
///
/// 改善点（今回）
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
    this.showPoints = false,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 24),
  });

  final int year;
  final List<int> totals;
  final String? title;

  final bool showPoints;
  final EdgeInsets padding;

  @override
  State<YearlyAssetsLineGraphAlert> createState() => _YearlyAssetsLineGraphAlertState();
}

class _YearlyAssetsLineGraphAlertState extends State<YearlyAssetsLineGraphAlert> {
  late List<int> _plotTotals;

  late int _min;
  late int _max;

  @override
  void initState() {
    super.initState();

    _plotTotals = _buildPlotTotals(year: widget.year, totals: widget.totals);

    if (_plotTotals.isEmpty) {
      _min = 0;
      _max = 0;
      return;
    }

    _min = _plotTotals.reduce((int a, int b) => a < b ? a : b);
    _max = _plotTotals.reduce((int a, int b) => a > b ? a : b);

    if (_min == _max) {
      _min = _min - 1;
      _max = _max + 1;
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

    // 今年の場合:
    // 1/1〜今日 までは元データ、今日以降は「今日の値」で埋める
    final int todayIndex0 = _dayOfYear(today) - 1; // 0-based
    if (todayIndex0 < 0) {
      return totals;
    }

    // totals が 365/366 想定でも、念のため範囲を丸める
    final int todayIndex = todayIndex0.clamp(0, totals.length - 1);

    final int todayValue = totals[todayIndex];

    // コピーして未来を埋める
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
    final int last = _plotTotals.isNotEmpty ? _plotTotals.last : 0;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _summaryRow(last: last, min: _min, max: _max, pointsCount: _plotTotals.length),
              const SizedBox(height: 12),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _plotTotals.isEmpty
                      ? const Center(child: Text('データがありません'))
                      : CustomPaint(
                          painter: _SimpleLineChartPainter(
                            values: _plotTotals,
                            minValue: _min,
                            maxValue: _max,
                            showPoints: widget.showPoints,
                          ),
                          child: const SizedBox.expand(),
                        ),
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

  Widget _summaryRow({required int last, required int min, required int max, required int pointsCount}) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: <Widget>[
        _pill(label: 'Points', value: pointsCount),
        _pill(label: 'Last', value: last),
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

class _SimpleLineChartPainter extends CustomPainter {
  _SimpleLineChartPainter({
    required this.values,
    required this.minValue,
    required this.maxValue,
    required this.showPoints,
  });

  final List<int> values;
  final int minValue;
  final int maxValue;
  final bool showPoints;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.grey.withValues(alpha: 0.18);

    for (int i = 1; i <= 3; i++) {
      final double y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.blueAccent;

    final Path path = Path();

    final int n = values.length;
    final double dx = n <= 1 ? 0 : (size.width / (n - 1));
    final double range = (maxValue - minValue).toDouble();

    Offset toPoint(int index) {
      final double x = dx * index;
      final double norm = ((values[index] - minValue).toDouble()) / (range == 0 ? 1 : range);
      final double y = size.height * (1 - norm);
      return Offset(x, y);
    }

    final Offset p0 = toPoint(0);
    path.moveTo(p0.dx, p0.dy);

    for (int i = 1; i < n; i++) {
      final Offset p = toPoint(i);
      path.lineTo(p.dx, p.dy);
    }

    canvas.drawPath(path, linePaint);

    if (showPoints) {
      final Paint pointPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.blueAccent;

      for (int i = 0; i < n; i++) {
        final Offset p = toPoint(i);
        canvas.drawCircle(p, 2.8, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SimpleLineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.showPoints != showPoints;
  }
}
