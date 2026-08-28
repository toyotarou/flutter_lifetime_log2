import 'dart:async';
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

///
class _DayData {
  _DayData({
    required this.money,
    required this.toushiShintaku,
    required this.gold,
    required this.stock,
    required this.insurance,
    required this.nenkinKikin,
  });

  final int money;
  final int toushiShintaku;
  final int gold;
  final int stock;
  final int insurance;
  final int nenkinKikin;

  int get total => money + toushiShintaku + gold + stock + insurance + nenkinKikin;
}

// ─────────────────────────────────────────────
// 各カラーセグメントにパーセントを描画する CustomPainter
// ─────────────────────────────────────────────
class _SegmentPercentPainter extends CustomPainter {
  _SegmentPercentPainter({
    required this.sortedDates,
    required this.dataMap,
    required this.maxY,
    required this.scrollOffset,
    required this.barWidth,
  });

  final List<String> sortedDates;
  final Map<String, _DayData> dataMap;
  final double maxY;
  final double scrollOffset;
  final double barWidth;

  static const double _leftAxis = 72.0;
  static const double _bottomReserved = 48.0;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    if (sortedDates.isEmpty || maxY <= 0) {
      return;
    }

    final double chartAreaHeight = size.height - _bottomReserved;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(_leftAxis, 0, size.width - _leftAxis, chartAreaHeight));

    for (int i = 0; i < sortedDates.length; i++) {
      final double xCenter = _leftAxis + i * barWidth + barWidth / 2 - scrollOffset;

      // 画面外はスキップ
      if (xCenter < _leftAxis - barWidth || xCenter > size.width + barWidth) {
        continue;
      }

      final _DayData? d = dataMap[sortedDates[i]];
      if (d == null || d.total == 0) {
        continue;
      }

      final List<int> values = <int>[d.money, d.toushiShintaku, d.gold, d.stock, d.insurance, d.nenkinKikin];

      double cumulative = 0;
      for (int j = 0; j < values.length; j++) {
        final int val = values[j];
        if (val == 0) {
          cumulative += val;
          continue;
        }

        final double segBottom = cumulative;
        final double segTop = cumulative + val;

        final double yTop = chartAreaHeight * (1 - segTop / maxY);
        final double yBottom = chartAreaHeight * (1 - segBottom / maxY);
        final double yCtr = (yTop + yBottom) / 2;
        final double segH = yBottom - yTop;

        // セグメントが狭すぎる場合はスキップ
        if (segH < 11) {
          cumulative += val;
          continue;
        }

        final double pct = val / d.total * 100;
        final String label = '${pct.toStringAsFixed(1)}%';

        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth);

        // セグメント内の万ラベル
        final int segMan = (val / 10000).round();
        final TextPainter manTp = TextPainter(
          text: TextSpan(
            text: '$segMan万',
            style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth);

        final double totalTextH = manTp.height + 2 + tp.height;
        if (segH >= totalTextH + 4) {
          // 両方表示：万ラベル上、%下
          final double topY = yCtr - totalTextH / 2;
          manTp.paint(canvas, Offset(xCenter - manTp.width / 2, topY));
          tp.paint(canvas, Offset(xCenter - tp.width / 2, topY + manTp.height + 2));
        } else {
          // %のみ
          tp.paint(canvas, Offset(xCenter - tp.width / 2, yCtr - tp.height / 2));
        }

        cumulative += val;
      }

      // ── 棒の上に合計金額を表示 ──
      if (d.total > 0) {
        final int man = (d.total / 10000).round();
        final String totalLabel = '$man万';
        final double barTopY = chartAreaHeight * (1 - d.total / maxY);

        // 「XX万」白ラベル
        final TextPainter totalTp = TextPainter(
          text: TextSpan(
            text: totalLabel,
            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth);

        final double ty = barTopY - totalTp.height - 2;
        totalTp.paint(canvas, Offset(xCenter - totalTp.width / 2, ty));

        // カンマ前の数字（緑色）
        final String s = d.total.toString();
        final int firstGroupLen = s.length % 3 == 0 ? 3 : s.length % 3;
        final String firstSegment = s.substring(0, firstGroupLen);

        final TextPainter greenTp = TextPainter(
          text: TextSpan(
            text: firstSegment,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth);

        greenTp.paint(canvas, Offset(xCenter - greenTp.width / 2, ty - greenTp.height - 1));
      }
    }

    canvas.restore();
  }

  ///
  @override
  bool shouldRepaint(_SegmentPercentPainter old) =>
      old.scrollOffset != scrollOffset || old.maxY != maxY || old.barWidth != barWidth;
}

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────
///
class MonthlyAssetsBarChartAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsBarChartAlert({super.key});

  @override
  ConsumerState<MonthlyAssetsBarChartAlert> createState() => _MonthlyAssetsBarChartAlertState();
}

class _MonthlyAssetsBarChartAlertState extends ConsumerState<MonthlyAssetsBarChartAlert>
    with ControllersMixin<MonthlyAssetsBarChartAlert> {
  // yearly_assets_line_chart_alert.dart に倣った色
  static final Color _colorMoney = Colors.white.withValues(alpha: 0.1);
  static final Color _colorToushi = Colors.yellowAccent.withValues(alpha: 0.1);
  static final Color _colorGold = Colors.lightBlueAccent.withValues(alpha: 0.1);
  static final Color _colorStock = Colors.greenAccent.withValues(alpha: 0.1);
  static final Color _colorInsurance = const Color(0xFFEA80FC).withValues(alpha: 0.1);
  static final Color _colorNenkinKikin = Colors.orangeAccent.withValues(alpha: 0.1);

  // スイッチON時の棒幅
  static const double _barWidthFull = 40.0;
  static const double _leftAxisWidth = 72.0;
  static const double _bottomReserved = 48.0;

  // スクロール位置計算に使う有効棒幅（build 時に更新）
  double _effectiveBarWidth = _barWidthFull;

  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _autoScrollToRight = true;
  List<String> _sortedDates = <String>[];
  String _currentVisibleYM = '';

  ///
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  ///
  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  ///
  void _onScroll() {
    if (_sortedDates.isEmpty) {
      return;
    }
    final int index = _currentVisibleIndex();
    final List<String> parts = _sortedDates[index].split('-');
    final String ym = '${parts[0]}年${parts[1]}月';
    if (ym != _currentVisibleYM) {
      setState(() => _currentVisibleYM = ym);
    }
  }

  ///
  int _currentVisibleIndex() {
    if (!_scrollController.hasClients || _sortedDates.isEmpty) {
      return 0;
    }
    final double bw = _effectiveBarWidth > 0 ? _effectiveBarWidth : _barWidthFull;
    return (_scrollController.offset / bw).floor().clamp(0, _sortedDates.length - 1);
  }

  ///
  void _jumpToDate(int targetIndex) {
    if (!_scrollController.hasClients) {
      return;
    }
    final double bw = _effectiveBarWidth > 0 ? _effectiveBarWidth : _barWidthFull;
    final double targetOffset = (targetIndex * bw).clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(targetOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  ///
  void _jumpToNextMonth() {
    if (_sortedDates.isEmpty) {
      return;
    }
    final int currentIndex = _currentVisibleIndex();
    final String currentYM = _sortedDates[currentIndex].split('-').take(2).join('-');
    bool passed = false;
    for (int i = 0; i < _sortedDates.length; i++) {
      final String ym = _sortedDates[i].split('-').take(2).join('-');
      if (ym == currentYM) {
        passed = true;
      } else if (passed) {
        _jumpToDate(i);
        return;
      }
    }
  }

  ///
  void _jumpToPrevMonth() {
    if (_sortedDates.isEmpty) {
      return;
    }
    final int currentIndex = _currentVisibleIndex();
    final String currentYM = _sortedDates[currentIndex].split('-').take(2).join('-');
    String? prevYM;
    for (int i = currentIndex - 1; i >= 0; i--) {
      final String ym = _sortedDates[i].split('-').take(2).join('-');
      if (ym != currentYM) {
        prevYM = ym;
        break;
      }
    }
    if (prevYM == null) {
      return;
    }
    for (int i = 0; i < _sortedDates.length; i++) {
      if (_sortedDates[i].split('-').take(2).join('-') == prevYM) {
        _jumpToDate(i);
        return;
      }
    }
  }

  ///
  void _jumpToPrevYear() {
    if (_sortedDates.isEmpty) {
      return;
    }
    final int currentIndex = _currentVisibleIndex();
    final String currentYear = _sortedDates[currentIndex].split('-')[0];
    String? prevYear;
    for (int i = currentIndex - 1; i >= 0; i--) {
      final String year = _sortedDates[i].split('-')[0];
      if (year != currentYear) {
        prevYear = year;
        break;
      }
    }
    if (prevYear == null) {
      return;
    }
    for (int i = 0; i < _sortedDates.length; i++) {
      if (_sortedDates[i].split('-')[0] == prevYear) {
        _jumpToDate(i);
        return;
      }
    }
  }

  ///
  void _jumpToNextYear() {
    if (_sortedDates.isEmpty) {
      return;
    }
    final int currentIndex = _currentVisibleIndex();
    final String currentYear = _sortedDates[currentIndex].split('-')[0];
    bool passed = false;
    for (int i = 0; i < _sortedDates.length; i++) {
      final String year = _sortedDates[i].split('-')[0];
      if (year == currentYear) {
        passed = true;
      } else if (passed) {
        _jumpToDate(i);
        return;
      }
    }
  }

  ///
  void _toggleAutoScroll({required bool toRight}) {
    if (_autoScrollTimer != null && _autoScrollToRight == toRight) {
      _autoScrollTimer!.cancel();
      _autoScrollTimer = null;
      setState(() {});
      return;
    }
    _autoScrollTimer?.cancel();
    _autoScrollToRight = toRight;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_scrollController.hasClients) {
        _autoScrollTimer?.cancel();
        _autoScrollTimer = null;
        return;
      }
      final double maxExtent = _scrollController.position.maxScrollExtent;
      final double current = _scrollController.offset;
      if (toRight) {
        if (current >= maxExtent) {
          _scrollController.jumpTo(maxExtent);
          _autoScrollTimer?.cancel();
          _autoScrollTimer = null;
          setState(() {});
          return;
        }
        _scrollController.jumpTo((current + 12.0).clamp(0, maxExtent));
      } else {
        if (current <= 0) {
          _scrollController.jumpTo(0);
          _autoScrollTimer?.cancel();
          _autoScrollTimer = null;
          setState(() {});
          return;
        }
        _scrollController.jumpTo((current - 12.0).clamp(0, maxExtent));
      }
    });
    setState(() {});
  }

  ///
  String _formatMan(int amount) {
    final int man = (amount / 10000).round();
    return '$man万';
  }

  ///
  int _toIntSafe(String s) => int.tryParse(s.replaceAll(',', '').replaceAll('円', '').trim()) ?? 0;

  ///
  Map<String, _DayData> _buildDailyDataMap() {
    final Map<String, _DayData> result = <String, _DayData>{};

    final DateTime startDate = DateTime(2024);
    final DateTime endDate = DateTime.now();
    final int days = endDate.difference(startDate).inDays + 1;

    int lastMoneySum = 0;
    int lastGoldSum = 0;
    int lastStockSum = 0;
    int lastToushiSum = 0;

    for (int i = 0; i < days; i++) {
      final DateTime date = startDate.add(Duration(days: i));
      final String key = date.yyyymmdd;

      final String? moneyStr = appParamState.keepMoneyMap[key]?.sum;
      if (moneyStr != null && moneyStr.isNotEmpty) {
        lastMoneySum = _toIntSafe(moneyStr);
      }

      final GoldModel? gold = appParamState.keepGoldMap[key];
      if (gold != null && gold.goldValue.toString() != '-') {
        lastGoldSum = _toIntSafe(gold.goldValue.toString());
      }

      final List<StockModel>? stockList = appParamState.keepStockMap[key];
      if (stockList != null && stockList.isNotEmpty) {
        lastStockSum = AssetsCalc.calcStockSum(stockList);
      }

      final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
      if (toushiList != null && toushiList.isNotEmpty) {
        lastToushiSum = AssetsCalc.calcToushiSum(toushiList);
      }

      final int insurancePassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: date) + 102;
      final int insuranceSum = (insurancePassedMonths * 55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
      final int nenkinKikinSum = date.isBefore(DateTime(2026, 6, 15))
          ? (nenkinKikinPassedMonths * 26625 * 0.7).toInt()
          : 0;

      const double assetRate = 0.8;

      result[key] = _DayData(
        money: lastMoneySum,
        toushiShintaku: (lastToushiSum * assetRate).toInt(),
        gold: (lastGoldSum * assetRate).toInt(),
        stock: (lastStockSum * assetRate).toInt(),
        insurance: insuranceSum,
        nenkinKikin: nenkinKikinSum,
      );
    }

    return result;
  }

  ///
  @override
  Widget build(BuildContext context) {
    final bool showMidashi = appParamState.isShowBarChartMidashi;
    final double barWidth = showMidashi ? _barWidthFull : 1.0;
    _effectiveBarWidth = barWidth;

    final Map<String, _DayData> dataMap = _buildDailyDataMap();
    final List<String> sortedDates = dataMap.keys.toList()..sort();
    _sortedDates = sortedDates;

    if (_currentVisibleYM.isEmpty && sortedDates.isNotEmpty) {
      final List<String> parts = sortedDates[0].split('-');
      _currentVisibleYM = '${parts[0]}年${parts[1]}月';
    }

    if (sortedDates.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('データなし', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final int maxTotal = dataMap.values.map((_DayData d) => d.total).reduce(max);
    final double chartMaxY = maxTotal > 0 ? (maxTotal * 1.2).ceilToDouble() : 1.0;

    final double totalWidth = max(context.screenSize.width - 40, sortedDates.length * barWidth + _leftAxisWidth);

    // 凡例ウィジェット（ボタン上段に表示）
    final Widget legend = Wrap(
      spacing: 8,
      runSpacing: 4,
      children: <Widget>[
        _legendChip(color: Colors.white, label: 'money'),
        _legendChip(color: Colors.yellowAccent, label: 'toushi'),
        _legendChip(color: Colors.lightBlueAccent, label: 'gold'),
        _legendChip(color: Colors.greenAccent, label: 'stock'),
        _legendChip(color: const Color(0xFFEA80FC), label: 'insurance'),
        _legendChip(color: Colors.orangeAccent, label: 'nenkin'),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ──── タイトル ────
                const Text('資産推移', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // ──── グラフ本体 ────
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: totalWidth,
                          child: BarChart(
                            BarChartData(
                              maxY: chartMaxY,
                              minY: 0,
                              groupsSpace: 0,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(),
                                rightTitles: const AxisTitles(),
                                bottomTitles: showMidashi
                                    ? AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: _bottomReserved,
                                          getTitlesWidget: (double value, TitleMeta meta) {
                                            final int index = value.toInt();
                                            if (index < 0 || index >= sortedDates.length) {
                                              return const SizedBox();
                                            }
                                            final List<String> parts = sortedDates[index].split('-');
                                            final String month = parts[1];
                                            final String day = parts[2];
                                            final bool isFirst = day == '01';

                                            return SideTitleWidget(
                                              axisSide: AxisSide.bottom,
                                              space: 2,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  // 月初めのみ年/月を追加表示
                                                  Text(
                                                    isFirst ? parts[0] : '',
                                                    style: const TextStyle(
                                                      fontSize: 7,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  // 全バーに MM/DD
                                                  Text(
                                                    '$month/$day',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.white,
                                                      fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const AxisTitles(),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: _leftAxisWidth,
                                    interval: 1000000,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      if (value == 0 || value == meta.max) {
                                        return const SizedBox();
                                      }
                                      return SideTitleWidget(
                                        axisSide: AxisSide.left,
                                        space: 4,
                                        child: Text(
                                          _formatMan(value.toInt()),
                                          style: const TextStyle(fontSize: 9, color: Colors.white70),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              gridData: FlGridData(
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (double value) =>
                                    FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: List<BarChartGroupData>.generate(sortedDates.length, (int i) {
                                final _DayData d = dataMap[sortedDates[i]]!;

                                final double m = d.money.toDouble();
                                final double t = m + d.toushiShintaku.toDouble();
                                final double g = t + d.gold.toDouble();
                                final double s = g + d.stock.toDouble();
                                final double ins = s + d.insurance.toDouble();
                                final double nen = ins + d.nenkinKikin.toDouble();

                                return BarChartGroupData(
                                  x: i,
                                  barRods: <BarChartRodData>[
                                    BarChartRodData(
                                      toY: nen,
                                      width: showMidashi ? barWidth - 2 : 1,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.zero,
                                      rodStackItems: <BarChartRodStackItem>[
                                        BarChartRodStackItem(0, m, _colorMoney.withOpacity(0.85)),
                                        BarChartRodStackItem(m, t, _colorToushi.withOpacity(0.85)),
                                        BarChartRodStackItem(t, g, _colorGold.withOpacity(0.85)),
                                        BarChartRodStackItem(g, s, _colorStock.withOpacity(0.85)),
                                        BarChartRodStackItem(s, ins, _colorInsurance.withOpacity(0.85)),
                                        BarChartRodStackItem(ins, nen, _colorNenkinKikin.withOpacity(0.85)),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),

                      // ──── セグメントごとのパーセント描画（スイッチON時のみ）────
                      if (showMidashi)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _scrollController,
                              builder: (BuildContext context, Widget? child) {
                                return CustomPaint(
                                  painter: _SegmentPercentPainter(
                                    sortedDates: sortedDates,
                                    dataMap: dataMap,
                                    maxY: chartMaxY,
                                    scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0,
                                    barWidth: barWidth,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      // ──── 現在表示中の年月バッジ（スイッチON時のみ）────
                      if (showMidashi)
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _currentVisibleYM.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _currentVisibleYM,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                        ),

                      // ──── スイッチ（右上）────
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Switch(
                          value: showMidashi,
                          activeColor: Colors.orangeAccent,
                          onChanged: (bool value) {
                            appParamNotifier.setIsShowBarChartMidashi(flag: value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // ──── 凡例（ナビボタンの上）────
                legend,
                const SizedBox(height: 6),

                // ──── 月・年ジャンプボタン ────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _pillBtn(label: '←月', onTap: _jumpToPrevMonth),
                        const SizedBox(width: 6),
                        _pillBtn(label: '←年', onTap: _jumpToPrevYear),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _pillBtn(label: '年→', onTap: _jumpToNextYear),
                        const SizedBox(width: 6),
                        _pillBtn(label: '月→', onTap: _jumpToNextMonth),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // ──── 端・自動スクロールボタン ────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _pillBtn(
                          label: '|←',
                          onTap: () {
                            _autoScrollTimer?.cancel();
                            _autoScrollTimer = null;
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                              );
                            }
                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 6),
                        _pillBtn(
                          label: '←',
                          active: _autoScrollTimer != null && !_autoScrollToRight,
                          onTap: () => _toggleAutoScroll(toRight: false),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _pillBtn(
                          label: '→',
                          active: _autoScrollTimer != null && _autoScrollToRight,
                          onTap: () => _toggleAutoScroll(toRight: true),
                        ),
                        const SizedBox(width: 6),
                        _pillBtn(
                          label: '→|',
                          onTap: () {
                            _autoScrollTimer?.cancel();
                            _autoScrollTimer = null;
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                              );
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _legendChip({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }

  ///
  Widget _pillBtn({required String label, required VoidCallback onTap, bool active = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: active ? Colors.orange : Colors.white38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: active ? Colors.orange : Colors.white70),
        ),
      ),
    );
  }
}
