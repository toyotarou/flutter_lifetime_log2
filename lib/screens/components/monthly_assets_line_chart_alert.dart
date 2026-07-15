import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/monthly_assets_data.dart';
import '../../models/gold_model.dart';
import '../../models/money_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/assets_calc.dart';

class MonthlyAssetsLineChartAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsLineChartAlert({super.key, required this.monthlyChartData, required this.taxAdjusted});

  final Map<String, MonthlyAssetsData> monthlyChartData;
  final bool taxAdjusted;

  @override
  ConsumerState<MonthlyAssetsLineChartAlert> createState() => _MonthlyAssetsLineChartAlertState();
}

class _MonthlyAssetsLineChartAlertState extends ConsumerState<MonthlyAssetsLineChartAlert>
    with ControllersMixin<MonthlyAssetsLineChartAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  // 表示月リスト（1要素=単月, 2要素=2枚重ね）
  List<String> _displayedMonths = <String>['2023-01'];
  bool _hasData = false;
  String _selectedBaseMonth = '2023-01';
  late FixedExtentScrollController _monthWheelController;

  // 太線（新しい月）と細線（古い月）の末端値比較
  bool? _moneyUp, _shintakuUp, _stockUp, _goldUp, _insuranceUp, _nenkinUp;

  static const String _startMonth = '2023-01';

  ///
  String get _currentYearMonth {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  ///
  String _addMonths(String ym, int delta) {
    final List<String> parts = ym.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]) + delta;
    while (month > 12) {
      month -= 12;
      year++;
    }
    while (month < 1) {
      month += 12;
      year--;
    }
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  ///
  bool get _canGoForward {
    final String checkTop = _displayedMonths.length == 1
        ? _addMonths(_displayedMonths[0], 1)
        : _addMonths(_displayedMonths[1], 1);
    return checkTop.compareTo(_currentYearMonth) <= 0;
  }

  ///
  @override
  void initState() {
    super.initState();
    final List<String> months = _buildMonthList();
    final int idx = months.indexOf(_selectedBaseMonth);
    _monthWheelController = FixedExtentScrollController(initialItem: idx >= 0 ? idx : months.length - 1);
  }

  ///
  @override
  void dispose() {
    _monthWheelController.dispose();
    super.dispose();
  }

  bool get _canGoBackward => _displayedMonths.length > 1;

  static const int _graphMin = 0;
  static const int _graphMax = 15000000;

  static const Color _colorMoney = Colors.white;
  static const Color _colorShintaku = Colors.yellowAccent;
  static const Color _colorStock = Colors.greenAccent;
  static const Color _colorGold = Colors.lightBlueAccent;
  static const Color _colorInsurance = Color(0xFFEA80FC);
  static const Color _colorNenkin = Colors.orangeAccent;

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    final String headerLabel = _displayedMonths.length == 1
        ? _displayedMonths[0]
        : '${_displayedMonths[0]} 〜 ${_displayedMonths[1]}';

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
                  Text(headerLabel),

                  Row(
                    children: <Widget>[
                      Material(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          splashColor: Colors.white54,
                          highlightColor: Colors.white24,
                          onTap: _canGoBackward ? _goBackward : null,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back, color: _canGoBackward ? Colors.white : Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          splashColor: Colors.white54,
                          highlightColor: Colors.white24,
                          onTap: _canGoForward ? _goForward : null,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.arrow_forward, color: _canGoForward ? Colors.white : Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(color: Colors.white.withValues(alpha: 0.5), thickness: 5),

              Row(
                children: <Widget>[
                  const Text('基準月', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 72,
                    width: 110,
                    child: Stack(
                      children: <Widget>[
                        // 選択ハイライト帯
                        Center(
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[600],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        ListWheelScrollView.useDelegate(
                          controller: _monthWheelController,
                          itemExtent: 24,
                          // perspective: 0.003 (default)
                          diameterRatio: 1.8,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (int i) {
                            final List<String> months = _buildMonthList();
                            if (i < months.length) {
                              setState(() {
                                _selectedBaseMonth = months[i];
                              });
                            }
                          },
                          childDelegate: ListWheelChildListDelegate(
                            children: _buildMonthList()
                                .map(
                                  (String m) => Center(
                                    child: Text(m, style: const TextStyle(fontSize: 12, color: Colors.white)),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () => setState(() => _displayedMonths = <String>[_selectedBaseMonth]),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600],
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('変更'),
                    ),
                  ),
                ],
              ),

              Divider(color: Colors.white.withValues(alpha: 0.5)),

              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (!_hasData) {
                      return const Center(child: Text('No data'));
                    }

                    return Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]);
                  },
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 11),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'money',
                      style: TextStyle(color: _colorMoney),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'shintaku',
                      style: TextStyle(color: _colorShintaku),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'stock',
                      style: TextStyle(color: _colorStock),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'gold',
                      style: TextStyle(color: _colorGold),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'insurance',
                      style: TextStyle(color: _colorInsurance),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'nenkin',
                      style: TextStyle(color: _colorNenkin),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _goForward() {
    if (!_canGoForward) {
      return;
    }
    setState(() {
      if (_displayedMonths.length == 1) {
        _displayedMonths = <String>[_displayedMonths[0], _addMonths(_displayedMonths[0], 1)];
      } else {
        _displayedMonths = <String>[_displayedMonths[1], _addMonths(_displayedMonths[1], 1)];
      }
      _selectedBaseMonth = _displayedMonths[0];
    });
    _animateWheelTo(_displayedMonths[0]);
  }

  ///
  void _goBackward() {
    if (!_canGoBackward) {
      return;
    }
    setState(() {
      if (_displayedMonths[0].compareTo(_startMonth) <= 0) {
        _displayedMonths = <String>[_displayedMonths[0]];
      } else {
        _displayedMonths = <String>[_addMonths(_displayedMonths[0], -1), _displayedMonths[0]];
      }
      _selectedBaseMonth = _displayedMonths[0];
    });
    _animateWheelTo(_displayedMonths[0]);
  }

  ///
  void _animateWheelTo(String ym) {
    final int idx = _buildMonthList().indexOf(ym);
    if (idx >= 0) {
      _monthWheelController.animateToItem(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  ///
  List<String> _buildMonthList() {
    final List<String> list = <String>[];
    String m = _startMonth;
    while (m.compareTo(_currentYearMonth) <= 0) {
      list.add(m);
      m = _addMonths(m, 1);
    }
    return list;
  }

  ///
  void _setChartData() {
    _hasData = false;
    _moneyUp = null;
    _shintakuUp = null;
    _stockUp = null;
    _goldUp = null;
    _insuranceUp = null;
    _nenkinUp = null;

    double? thinMoneyLast, thinShintakuLast, thinStockLast, thinGoldLast, thinInsuranceLast, thinNenkinLast;

    final List<LineChartBarData> allBars = <LineChartBarData>[];

    for (int monthIdx = 0; monthIdx < _displayedMonths.length; monthIdx++) {
      final String monthStr = _displayedMonths[monthIdx];
      final double barW = monthIdx == _displayedMonths.length - 1 && _displayedMonths.length > 1 ? 5 : 1;
      final bool isThick = barW > 1;
      // --- money ---
      final List<FlSpot> moneySpots = <FlSpot>[];
      final List<String> dateList = <String>[];

      appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
        if (!key.startsWith(monthStr)) {
          return;
        }
        final int day = key.split('-')[2].toInt();
        moneySpots.add(FlSpot(day.toDouble(), value.sum.toDouble()));
        dateList.add(key);
      });

      if (moneySpots.isEmpty) {
        continue;
      }
      _hasData = true;

      // --- 投資信託: carry-forward ---
      final List<FlSpot> shintakuSpots = <FlSpot>[];
      int prevShintaku = 0;
      for (final String date in dateList) {
        final int day = date.split('-')[2].toInt();
        final List<ToushiShintakuModel>? list = appParamState.keepToushiShintakuMap[date];
        if (list != null && list.isNotEmpty) {
          prevShintaku = list.fold(0, (int acc, ToushiShintakuModel m) {
            if (m.jikaHyoukagaku == '-') {
              return acc;
            }
            return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          });
        }
        if (prevShintaku > 0) {
          shintakuSpots.add(FlSpot(day.toDouble(), prevShintaku.toDouble()));
        }
      }

      // --- 株: carry-forward ---
      final List<FlSpot> stockSpots = <FlSpot>[];
      int prevStock = 0;
      for (final String date in dateList) {
        final int day = date.split('-')[2].toInt();
        final List<StockModel>? list = appParamState.keepStockMap[date];
        if (list != null && list.isNotEmpty) {
          prevStock = list.fold(0, (int acc, StockModel m) {
            if (m.jikaHyoukagaku == '-') {
              return acc;
            }
            return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          });
        }
        if (prevStock > 0) {
          stockSpots.add(FlSpot(day.toDouble(), prevStock.toDouble()));
        }
      }

      // --- ゴールド: carry-forward（生値）---
      final List<FlSpot> goldSpots = <FlSpot>[];
      int prevGold = 0;
      for (final String date in dateList) {
        final int day = date.split('-')[2].toInt();
        final GoldModel? model = appParamState.keepGoldMap[date];
        if (model != null) {
          final String val = model.goldValue.toString();
          if (val != '-' && val.isNotEmpty) {
            prevGold = val.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          }
        }
        if (prevGold > 0) {
          goldSpots.add(FlSpot(day.toDouble(), prevGold.toDouble()));
        }
      }

      // --- 保険・年金（生値）---
      final List<FlSpot> insuranceSpots = <FlSpot>[];
      final List<FlSpot> nenkinSpots = <FlSpot>[];
      for (final String date in dateList) {
        final int day = date.split('-')[2].toInt();
        final DateTime d = DateTime.parse(date);
        final int insPassed = AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: d) + 102;
        final int nenkinPassed = AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: d) + 32;
        insuranceSpots.add(FlSpot(day.toDouble(), (insPassed * 55880).toDouble()));
        nenkinSpots.add(
          FlSpot(day.toDouble(), d.isBefore(DateTime(2026, 6, 15)) ? (nenkinPassed * 26625).toDouble() : 0),
        );
      }

      // --- 税引後調整 ---
      List<FlSpot> finalShintaku = shintakuSpots;
      List<FlSpot> finalStock = stockSpots;
      List<FlSpot> finalGold = goldSpots;
      List<FlSpot> finalInsurance = insuranceSpots;
      List<FlSpot> finalNenkin = nenkinSpots;
      if (widget.taxAdjusted) {
        finalShintaku = shintakuSpots.map((FlSpot s) => FlSpot(s.x, (s.y * 0.80).toInt().toDouble())).toList();
        finalStock = stockSpots.map((FlSpot s) => FlSpot(s.x, (s.y * 0.80).toInt().toDouble())).toList();
        finalGold = goldSpots.map((FlSpot s) => FlSpot(s.x, (s.y * 0.80).toInt().toDouble())).toList();
        finalInsurance = insuranceSpots.map((FlSpot s) => FlSpot(s.x, (s.y * 0.70).toInt().toDouble())).toList();
        finalNenkin = nenkinSpots.map((FlSpot s) => FlSpot(s.x, (s.y * 0.70).toInt().toDouble())).toList();
      }

      // 先月末との比較（細線→太線の順で処理されるので thin の値を先に保存）
      if (!isThick) {
        thinMoneyLast = moneySpots.isEmpty ? null : moneySpots.last.y;
        thinShintakuLast = finalShintaku.isEmpty ? null : finalShintaku.last.y;
        thinStockLast = finalStock.isEmpty ? null : finalStock.last.y;
        thinGoldLast = finalGold.isEmpty ? null : finalGold.last.y;
        thinInsuranceLast = finalInsurance.isEmpty ? null : finalInsurance.last.y;
        thinNenkinLast = finalNenkin.isEmpty ? null : finalNenkin.last.y;
      } else {
        final double? tm = moneySpots.isEmpty ? null : moneySpots.last.y;
        final double? ts = finalShintaku.isEmpty ? null : finalShintaku.last.y;
        final double? tst = finalStock.isEmpty ? null : finalStock.last.y;
        final double? tg = finalGold.isEmpty ? null : finalGold.last.y;
        final double? ti = finalInsurance.isEmpty ? null : finalInsurance.last.y;
        final double? tn = finalNenkin.isEmpty ? null : finalNenkin.last.y;
        if (tm != null && thinMoneyLast != null) {
          _moneyUp = tm > thinMoneyLast;
        }
        if (ts != null && thinShintakuLast != null) {
          _shintakuUp = ts > thinShintakuLast;
        }
        if (tst != null && thinStockLast != null) {
          _stockUp = tst > thinStockLast;
        }
        if (tg != null && thinGoldLast != null) {
          _goldUp = tg > thinGoldLast;
        }
        if (ti != null && thinInsuranceLast != null) {
          _insuranceUp = ti > thinInsuranceLast;
        }
        if (tn != null && thinNenkinLast != null) {
          _nenkinUp = tn > thinNenkinLast;
        }
      }

      // クロージャが後から null になる問題を防ぐためローカル変数に固定
      final bool moneyUp = _moneyUp ?? true;
      final bool shintakuUp = _shintakuUp ?? true;
      final bool stockUp = _stockUp ?? true;
      final bool goldUp = _goldUp ?? true;
      final bool insuranceUp = _insuranceUp ?? true;
      final bool nenkinUp = _nenkinUp ?? true;

      // barIndex: monthIdx*6 + (0=money,1=shintaku,2=stock,3=gold,4=insurance,5=nenkin)
      allBars
        ..add(
          LineChartBarData(
            spots: moneySpots,
            color: isThick ? _colorMoney.withValues(alpha: 0.6) : _colorMoney,
            dotData: isThick && _moneyUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorMoney, isUp: moneyUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        )
        ..add(
          LineChartBarData(
            spots: finalShintaku,
            color: isThick ? _colorShintaku.withValues(alpha: 0.6) : _colorShintaku,
            dotData: isThick && _shintakuUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorShintaku, isUp: shintakuUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        )
        ..add(
          LineChartBarData(
            spots: finalStock,
            color: isThick ? _colorStock.withValues(alpha: 0.6) : _colorStock,
            dotData: isThick && _stockUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorStock, isUp: stockUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        )
        ..add(
          LineChartBarData(
            spots: finalGold,
            color: isThick ? _colorGold.withValues(alpha: 0.6) : _colorGold,
            dotData: isThick && _goldUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorGold, isUp: goldUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        )
        ..add(
          LineChartBarData(
            spots: finalInsurance,
            color: isThick ? _colorInsurance.withValues(alpha: 0.6) : _colorInsurance,
            dotData: isThick && _insuranceUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorInsurance, isUp: insuranceUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        )
        ..add(
          LineChartBarData(
            spots: finalNenkin,
            color: isThick ? _colorNenkin.withValues(alpha: 0.6) : _colorNenkin,
            dotData: isThick && _nenkinUp != null
                ? FlDotData(
                    checkToShowDot: (FlSpot spot, LineChartBarData barData) => spot.x == barData.spots.last.x,
                    getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) =>
                        _ArrowDotPainter(color: _colorNenkin, isUp: nenkinUp),
                  )
                : const FlDotData(show: false),
            barWidth: barW,
          ),
        );
    }

    if (!_hasData) {
      return;
    }

    // ツールチップ: barIndex % 6 == 0（各月のmoney線）のみ表示
    final List<String> months = List<String>.from(_displayedMonths);

    graphData = LineChartData(
      minX: 1,
      maxX: 31,
      minY: _graphMin.toDouble(),
      maxY: _graphMax.toDouble(),

      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 2,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot s) {
              if (s.barIndex % 6 != 0) {
                return null;
              }
              final int monthIdx = s.barIndex ~/ 6;
              if (monthIdx >= months.length) {
                return null;
              }

              final String monthStr = months[monthIdx];
              final int day = s.x.toInt();
              final String date = '$monthStr-${day.toString().padLeft(2, '0')}';

              int moneyVal = 0, shintakuVal = 0, stockVal = 0, goldVal = 0, insuranceVal = 0, nenkinVal = 0;
              for (final LineBarSpot ts in touchedSpots) {
                if (ts.barIndex ~/ 6 != monthIdx) {
                  continue;
                }
                switch (ts.barIndex % 6) {
                  case 0:
                    moneyVal = ts.y.round();
                  case 1:
                    shintakuVal = ts.y.round();
                  case 2:
                    stockVal = ts.y.round();
                  case 3:
                    goldVal = ts.y.round();
                  case 4:
                    insuranceVal = ts.y.round();
                  case 5:
                    nenkinVal = ts.y.round();
                }
              }

              final int total = moneyVal + shintakuVal + stockVal + goldVal + insuranceVal + nenkinVal;

              return LineTooltipItem(
                '$date\n',
                const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                children: <TextSpan>[
                  const TextSpan(
                    text: '──────────\n',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: '${moneyVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorMoney),
                  ),
                  TextSpan(
                    text: '${shintakuVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorShintaku),
                  ),
                  TextSpan(
                    text: '${goldVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorGold),
                  ),
                  TextSpan(
                    text: '${stockVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorStock),
                  ),
                  TextSpan(
                    text: '${insuranceVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorInsurance),
                  ),
                  TextSpan(
                    text: '${nenkinVal.toString().toCurrency()}\n',
                    style: const TextStyle(color: _colorNenkin),
                  ),
                  const TextSpan(
                    text: '──────────\n',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: total.toString().toCurrency(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),

      gridData: FlGridData(
        verticalInterval: 1,
        getDrawingVerticalLine: (double value) {
          final int day = value.toInt();
          if (day % 5 == 0) {
            return FlLine(color: Colors.white.withValues(alpha: 0.15), strokeWidth: 1);
          }
          return const FlLine(color: Colors.transparent, strokeWidth: 1);
        },
      ),

      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: allBars,
    );

    graphData2 = LineChartData(
      minX: 1,
      maxX: 31,
      minY: _graphMin.toDouble(),
      maxY: _graphMax.toDouble(),
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
              if (value == _graphMax) {
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
              if (value == _graphMax) {
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
      lineBarsData: <LineChartBarData>[],
    );
  }
}

class _ArrowDotPainter extends FlDotPainter {
  const _ArrowDotPainter({required this.color, required this.isUp});

  final Color color;
  final bool isUp;

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final IconData icon = isUp ? Icons.arrow_upward : Icons.arrow_downward;
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(color: color, fontSize: 40, fontFamily: icon.fontFamily, package: icon.fontPackage, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final Offset pos = offsetInCanvas + Offset(-tp.width / 2, isUp ? -(tp.height + 4) : 4);
    tp.paint(canvas, pos);
  }

  @override
  Size getSize(FlSpot spot) => const Size(44, 52);

  @override
  Color get mainColor => color;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => b;

  @override
  List<Object?> get props => <Object?>[color, isUp];
}
