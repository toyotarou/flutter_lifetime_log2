import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/toushi_shintaku_model.dart';

class _MonthData {
  _MonthData({required this.price, required this.cost});

  final int price;
  final int cost;

  int get gain => price - cost;
}

class AssetsDetailBarChartAlert extends ConsumerStatefulWidget {
  const AssetsDetailBarChartAlert({super.key});

  @override
  ConsumerState<AssetsDetailBarChartAlert> createState() => _AssetsDetailBarChartAlertState();
}

class _AssetsDetailBarChartAlertState extends ConsumerState<AssetsDetailBarChartAlert>
    with ControllersMixin<AssetsDetailBarChartAlert> {
  static const Color _costColor = Colors.white;
  static const Color _gainColor = Color(0xFFFBB6CE);
  static const Color _totalLabelColor = Colors.yellowAccent;

  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _autoScrollToRight = true;
  List<String> _sortedDates = [];
  String _currentVisibleYM = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_sortedDates.isEmpty) return;
    final int index = _currentVisibleIndex();
    final List<String> parts = _sortedDates[index].split('-');
    final String ym = '${parts[0]}年${parts[1]}月';
    if (ym != _currentVisibleYM) {
      setState(() => _currentVisibleYM = ym);
    }
  }

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

  int _currentVisibleIndex() {
    if (!_scrollController.hasClients || _sortedDates.isEmpty) return 0;
    const double leftAxis = 72.0;
    const double barW = 36.0;
    return ((_scrollController.offset - leftAxis) / barW).floor().clamp(0, _sortedDates.length - 1);
  }

  void _jumpToMonth(int targetIndex) {
    if (!_scrollController.hasClients) return;
    const double leftAxis = 72.0;
    const double barW = 36.0;
    final double targetOffset = (leftAxis + targetIndex * barW).clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(targetOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _jumpToNextMonth() {
    if (_sortedDates.isEmpty) return;
    final int currentIndex = _currentVisibleIndex();
    final String currentYM = _sortedDates[currentIndex].split('-').take(2).join('-');
    bool passed = false;
    for (int i = 0; i < _sortedDates.length; i++) {
      final String ym = _sortedDates[i].split('-').take(2).join('-');
      if (ym == currentYM) {
        passed = true;
      } else if (passed) {
        _jumpToMonth(i);
        return;
      }
    }
  }

  void _jumpToPrevMonth() {
    if (_sortedDates.isEmpty) return;
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
    if (prevYM == null) return;
    for (int i = 0; i < _sortedDates.length; i++) {
      if (_sortedDates[i].split('-').take(2).join('-') == prevYM) {
        _jumpToMonth(i);
        return;
      }
    }
  }

  String _formatMan(int amount) {
    final int man = (amount / 10000).round();
    return '$man万';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, _MonthData> dailyDataMap = _buildDailyDataMap();
    final List<String> sortedDates = dailyDataMap.keys.toList()..sort();
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

    final int maxValue = dailyDataMap.values.map((e) => e.price).reduce(max);
    final double chartMaxY = maxValue > 0 ? (maxValue * 1.35).ceilToDouble() : 1;
    const double barWidth = 36.0;

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
                Row(
                  children: <Widget>[
                    const Text('投資信託 月別時価評価額'),
                    const SizedBox(width: 16),
                    _legendChip(color: _costColor, label: 'コスト'),
                    const SizedBox(width: 8),
                    _legendChip(color: _gainColor, label: 'ゲイン'),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: max(context.screenSize.width - 80, sortedDates.length * barWidth + 92),
                          child: BarChart(
                            BarChartData(
                              maxY: chartMaxY,
                              minY: 0,
                              groupsSpace: 0,
                              barTouchData: BarTouchData(
                                enabled: false,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) => Colors.transparent,
                                  tooltipPadding: EdgeInsets.zero,
                                  tooltipMargin: 6,
                                  getTooltipItem:
                                      (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                                        if (groupIndex < 0 || groupIndex >= sortedDates.length) return null;
                                        final String key = sortedDates[groupIndex];
                                        final _MonthData? data = dailyDataMap[key];
                                        if (data == null) return null;
                                        return BarTooltipItem(
                                          _formatMan(data.price),
                                          const TextStyle(
                                            color: _totalLabelColor,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            height: 1.6,
                                          ),
                                          textAlign: TextAlign.right,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '\n${_formatMan(data.cost)}',
                                              style: const TextStyle(
                                                color: _costColor,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n${_formatMan(data.gain)}',
                                              style: const TextStyle(
                                                color: _gainColor,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(),
                                rightTitles: const AxisTitles(),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      final int index = value.toInt();
                                      if (index < 0 || index >= sortedDates.length) return const SizedBox();
                                      final List<String> parts = sortedDates[index].split('-');
                                      final String year = parts[0];
                                      final String month = parts.length > 1 ? parts[1] : '';
                                      final String day = parts.length > 2 ? parts[2] : '';
                                      final bool isFirstOfMonth =
                                          index == 0 ||
                                          sortedDates[index - 1].split('-').take(2).join('-') !=
                                              parts.take(2).join('-');
                                      return SideTitleWidget(
                                        axisSide: AxisSide.bottom,
                                        space: 4,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(day, style: const TextStyle(fontSize: 9, color: Colors.white)),
                                            if (isFirstOfMonth)
                                              Text(month, style: const TextStyle(fontSize: 8, color: Colors.white)),
                                            if (isFirstOfMonth)
                                              Text(year, style: const TextStyle(fontSize: 7, color: Colors.white)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 72,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      if (value == 0 || value == meta.max) return const SizedBox();
                                      return SideTitleWidget(
                                        axisSide: AxisSide.left,
                                        space: 4,
                                        child: Text(
                                          value.toInt().toString().toCurrency(),
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
                                final String key = sortedDates[i];
                                final _MonthData data = dailyDataMap[key]!;
                                final double costY = data.cost.toDouble().clamp(0, data.price.toDouble());
                                final double priceY = data.price.toDouble();
                                return BarChartGroupData(
                                  x: i,
                                  showingTooltipIndicators: <int>[0],
                                  barRods: <BarChartRodData>[
                                    BarChartRodData(
                                      toY: priceY,
                                      width: barWidth,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.zero,
                                      rodStackItems: <BarChartRodStackItem>[
                                        BarChartRodStackItem(0, costY, _costColor.withOpacity(0.4)),
                                        BarChartRodStackItem(costY, priceY, _gainColor.withOpacity(0.4)),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
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
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _scrollBtn(
                          label: '←',
                          active: _autoScrollTimer != null && !_autoScrollToRight,
                          onTap: () => _toggleAutoScroll(toRight: false),
                        ),
                        _scrollBtn(label: '←月', active: false, onTap: _jumpToPrevMonth),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _scrollBtn(label: '月→', active: false, onTap: _jumpToNextMonth),
                        _scrollBtn(
                          label: '→',
                          active: _autoScrollTimer != null && _autoScrollToRight,
                          onTap: () => _toggleAutoScroll(toRight: true),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _scrollBtn(
                      label: '|←',
                      active: false,
                      onTap: () {
                        if (_scrollController.hasClients) {
                          _autoScrollTimer?.cancel();
                          _autoScrollTimer = null;
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                          setState(() {});
                        }
                      },
                    ),
                    _scrollBtn(
                      label: '→|',
                      active: false,
                      onTap: () {
                        if (_scrollController.hasClients) {
                          _autoScrollTimer?.cancel();
                          _autoScrollTimer = null;
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                          setState(() {});
                        }
                      },
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

  Widget _scrollBtn({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: active ? Colors.orange : Colors.white54),
        ),
      ),
    );
  }

  Widget _legendChip({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }

  Map<String, _MonthData> _buildDailyDataMap() {
    final Map<String, _MonthData> result = <String, _MonthData>{};
    appParamState.keepToushiShintakuMap.forEach((String key, List<ToushiShintakuModel> valueList) {
      int totalPrice = 0;
      int totalCost = 0;
      for (final ToushiShintakuModel model in valueList) {
        final int? price = int.tryParse(model.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim());
        final int? cost = int.tryParse(model.shutokuSougaku.replaceAll(',', '').replaceAll('円', '').trim());
        if (price != null) totalPrice += price;
        if (cost != null) totalCost += cost;
      }
      if (totalPrice > 0) {
        result[key] = _MonthData(price: totalPrice, cost: totalCost);
      }
    });
    return result;
  }
}
