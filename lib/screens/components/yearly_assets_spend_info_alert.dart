import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/assets_calc.dart';
import '../../utility/utility.dart';

class YearlyAssetsSpendInfoAlert extends ConsumerStatefulWidget {
  const YearlyAssetsSpendInfoAlert({super.key});

  @override
  ConsumerState<YearlyAssetsSpendInfoAlert> createState() => _YearlyAssetsSpendInfoAlertState();
}

class _YearlyAssetsSpendInfoAlertState extends ConsumerState<YearlyAssetsSpendInfoAlert>
    with ControllersMixin<YearlyAssetsSpendInfoAlert> {
  final Utility utility = Utility();

  late final DateTime _asOf;
  late final Future<List<Map<String, dynamic>>> _futureDisplayData;

  final ScrollController _listController = ScrollController();

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  ///
  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    _asOf = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    _futureDisplayData = Future<List<Map<String, dynamic>>>(() => _generateData(asOf: _asOf));
  }

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    _listController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('資産変動推移 (月次・年次)'), SizedBox.shrink()],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /// 一気ボタン / s
                Row(
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!_listController.hasClients) {
                          return;
                        }
                        final double max = _listController.position.maxScrollExtent;
                        _listController.jumpTo(max);
                      },

                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(child: Icon(Icons.vertical_align_bottom, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!_listController.hasClients) {
                          return;
                        }
                        _listController.jumpTo(0.0);
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(child: Icon(Icons.vertical_align_top, color: Colors.white)),
                      ),
                    ),
                  ],
                ),

                /// 一気ボタン / e
                Row(
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) => _startRepeating(() => _scrollBy(_moveAmount)),
                      onTapUp: (_) => _stopRepeating(),
                      onTapCancel: _stopRepeating,
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(child: Icon(Icons.arrow_downward, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) => _startRepeating(() => _scrollBy(-_moveAmount)),
                      onTapUp: (_) => _stopRepeating(),
                      onTapCancel: _stopRepeating,
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(child: Icon(Icons.arrow_upward, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureDisplayData,
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('計算中...', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('計算エラー: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
                    );
                  }

                  final List<Map<String, dynamic>> displayData = snapshot.data ?? <Map<String, dynamic>>[];

                  return ListView.builder(
                    controller: _listController,
                    itemCount: displayData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> data = displayData[index];
                      final String type = data['type'] as String;

                      if (type == 'baseline') {
                        return _buildBaselineItem(data);
                      } else if (type == 'year_summary') {
                        return _buildYearSummaryItem(data);
                      } else {
                        return _buildMonthItem(data);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!_listController.hasClients) {
      return;
    }

    final ScrollPosition pos = _listController.position;
    final double newOffset = (_listController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    _listController.jumpTo(newOffset);
  }

  ///
  List<Map<String, dynamic>> _generateData({required DateTime asOf}) {
    final List<Map<String, dynamic>> results = <Map<String, dynamic>>[];

    // 支払日リストのパースは月ごとではなく一度だけ行う
    final List<DateTime> insurancePaidDates = AssetsCalc.parsePaidDates(appParamState.keepInsuranceDataList);
    final List<DateTime> nenkinKikinPaidDates = AssetsCalc.parsePaidDates(appParamState.keepNenkinKikinDataList);

    final DateTime baselineDate = DateTime(2022, 12, 31);
    int prevMonthEndAssets = _calcTotalAssetsAtDate(
      baselineDate,
      insurancePaidDates: insurancePaidDates,
      nenkinKikinPaidDates: nenkinKikinPaidDates,
    );

    results.add(<String, dynamic>{'type': 'baseline', 'title': '2022-12-31 基準資産合計', 'value': prevMonthEndAssets});

    final int currentYear = asOf.year;
    final int currentMonth = asOf.month;

    for (int year = 2023; year <= currentYear; year++) {
      final int assetsAtYearStart = prevMonthEndAssets;

      final int insertIdx = results.length;

      final int endMonth = (year == currentYear) ? currentMonth : 12;

      for (int month = 1; month <= endMonth; month++) {
        final DateTime monthEnd = DateTime(year, month + 1, 0);

        final DateTime targetDate = monthEnd.isAfter(asOf) ? asOf : monthEnd;

        final int currentMonthEndAssets = _calcTotalAssetsAtDate(
          targetDate,
          insurancePaidDates: insurancePaidDates,
          nenkinKikinPaidDates: nenkinKikinPaidDates,
        );
        final int monthlyDiff = currentMonthEndAssets - prevMonthEndAssets;

        results.add(<String, dynamic>{
          'type': 'month',
          'title': '$year-${month.toString().padLeft(2, '0')}',
          'value': monthlyDiff,
          'total': currentMonthEndAssets,
          'prevTotal': prevMonthEndAssets,
        });

        prevMonthEndAssets = currentMonthEndAssets;
      }

      final int yearlyDiff = prevMonthEndAssets - assetsAtYearStart;
      results.insert(insertIdx, <String, dynamic>{
        'type': 'year_summary',
        'title': '$year年 年間変動',
        'value': yearlyDiff,
        'startValue': assetsAtYearStart,
        'endValue': prevMonthEndAssets,
      });
    }

    return results;
  }

  ///
  /// 計算本体は AssetsCalc.calcTotalAssetsAtDate（monthly_assets_graph_alert.dart と yearly_assets_spend_info_alert.dart で共通）
  int _calcTotalAssetsAtDate(
    DateTime date, {
    required List<DateTime> insurancePaidDates,
    required List<DateTime> nenkinKikinPaidDates,
  }) {
    return AssetsCalc.calcTotalAssetsAtDate(
      date: date,
      goldMap: appParamState.keepGoldMap,
      stockMap: appParamState.keepStockMap,
      toushiShintakuMap: appParamState.keepToushiShintakuMap,
      moneyMap: appParamState.keepMoneyMap,
      insurancePaidDates: insurancePaidDates,
      nenkinKikinPaidDates: nenkinKikinPaidDates,
    );
  }

  ///
  Widget _buildBaselineItem(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.2),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(data['title'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 5),
          Text(
            (data['value'] as int).toString().toCurrency(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildYearSummaryItem(Map<String, dynamic> data) {
    final int value = data['value'] as int;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.3), width: 2)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data['title'] as String,
                style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                '${(data['startValue'] as int).toString().toCurrency()} → ${(data['endValue'] as int).toString().toCurrency()}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                value >= 0 ? '+${value.toString().toCurrency()}' : value.toString().toCurrency(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: value >= 0 ? Colors.yellowAccent : Colors.redAccent,
                ),
              ),
              const SizedBox(width: 5),
              utility.dispUpDownMark(before: 0, after: value, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildMonthItem(Map<String, dynamic> data) {
    final int value = data['value'] as int;

    // 先頭4桁を切り出す方式だと、1,000万円未満では千円単位・以上では万円単位になり、4桁未満では RangeError になるため万円単位で揃える
    final String aaa = ((data['prevTotal'] as int) ~/ 10000).toString();
    final String bbb = ((data['total'] as int) ~/ 10000).toString();

    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text('$aaa / $bbb', style: const TextStyle(color: Color(0xFFFBB6CE))),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  Text(
                    '${(data['prevTotal'] as int).toString().toCurrency()} → ${(data['total'] as int).toString().toCurrency()}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    value >= 0 ? '+${value.toString().toCurrency()}' : value.toString().toCurrency(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: value >= 0
                          ? Colors.yellowAccent.withValues(alpha: 0.8)
                          : Colors.redAccent.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 5),
                  utility.dispUpDownMark(before: 0, after: value, size: 16),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
