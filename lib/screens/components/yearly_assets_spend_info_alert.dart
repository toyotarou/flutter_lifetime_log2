import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
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
  List<Map<String, dynamic>> _generateData({required DateTime asOf}) {
    final List<Map<String, dynamic>> results = <Map<String, dynamic>>[];

    final DateTime baselineDate = DateTime(2022, 12, 31);
    int prevMonthEndAssets = _calcTotalAssetsAtDate(baselineDate);

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

        final int currentMonthEndAssets = _calcTotalAssetsAtDate(targetDate);
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
  int _calcTotalAssetsAtDate(DateTime date) {
    final int lastGoldSum = _findLastValidGoldValue(date);
    final int lastStockSum = _findLastValidStockSum(date);
    final int lastToushiSum = _findLastValidToushiSum(date);
    final int lastMoneySum = _findLastValidMoneySum(date);

    final int insurancePassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: date) + 102;
    final int insuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

    final int nenkinKikinPassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
    final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

    const double assetRate = 0.8;

    return lastMoneySum +
        (lastGoldSum * assetRate).toInt() +
        (lastStockSum * assetRate).toInt() +
        (lastToushiSum * assetRate).toInt() +
        insuranceSum +
        nenkinKikinSum;
  }

  ///
  int _findLastValidGoldValue(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final GoldModel? model = appParamState.keepGoldMap[key];
      if (model != null) {
        final dynamic val = model.goldValue;
        if (val != null && val.toString() != '-') {
          return val.toString().toInt();
        }
      }
    }
    return 0;
  }

  ///
  int _findLastValidStockSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<StockModel>? list = appParamState.keepStockMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcStockSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidToushiSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<ToushiShintakuModel>? list = appParamState.keepToushiShintakuMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcToushiSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidMoneySum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final String? sum = appParamState.keepMoneyMap[key]?.sum;
      if (sum != null && sum.isNotEmpty) {
        return sum.toInt();
      }
    }
    return 0;
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
    return Container(
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
    );
  }
}
