import 'package:flutter/material.dart';

import '../extensions/extensions.dart';
import '../models/gold_model.dart';
import '../models/money_model.dart';
import '../models/stock_model.dart';
import '../models/toushi_shintaku_model.dart';

///
class AssetsCalc {
  ///
  static int calcMoney(String? money) {
    if (money == null || money.isEmpty) {
      return 0;
    }
    return int.tryParse(money) ?? 0;
  }

  ///
  static int calcTotalAssets({
    required String money,
    required Map<String, dynamic>? assets,
    required List<String> keys,
    Map<String, dynamic>? fallbackAssets,
    String? fallbackMoney,
  }) {
    final Map<String, dynamic>? srcAssets = assets ?? fallbackAssets;
    final String srcMoney = money.isNotEmpty ? money : (fallbackMoney ?? '');

    final List<int> items = <int>[
      if (srcMoney.isNotEmpty) int.tryParse(srcMoney) ?? 0 else 0,
      ...keys.map((String key) {
        final String value = srcAssets?[key]?.toString() ?? '';
        return value.isNotEmpty ? int.tryParse(value) ?? 0 : 0;
      }),
    ];

    return items.fold(0, (int sum, int value) => sum + value);
  }

  ///
  static int calcStockSum(List<StockModel> stockList) {
    int sum = 0;
    for (final StockModel e in stockList) {
      if (e.jikaHyoukagaku != '-') {
        sum += e.jikaHyoukagaku.replaceAll(',', '').toInt();
      }
    }
    return sum;
  }

  ///
  static int calcToushiSum(List<ToushiShintakuModel> toushiList, {VoidCallback? onRelationalIdBlankFound}) {
    int sum = 0;
    for (final ToushiShintakuModel e in toushiList) {
      if (e.jikaHyoukagaku != '-') {
        sum += e.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
      }
      if (e.relationalId == 0) {
        onRelationalIdBlankFound?.call();
      }
    }
    return sum;
  }

  ///
  static int countPaidUpTo({
    required List<Map<String, dynamic>> data,
    required DateTime date,
    String dateKey = 'date',
  }) {
    return countPaidDatesUpTo(paidDates: parsePaidDates(data, dateKey: dateKey), date: date);
  }

  /// 支払データ（{'date': 'yyyy-MM-dd', ...}）の日付を「日単位」の DateTime に変換する。
  /// 日ごとのループ内で countPaidUpTo を繰り返し呼ぶと毎回パースが走るため、
  /// ループの外で 1 回だけこれを呼び、結果を countPaidDatesUpTo に渡すこと。
  static List<DateTime> parsePaidDates(List<Map<String, dynamic>> data, {String dateKey = 'date'}) {
    return <DateTime>[
      for (final Map<String, dynamic> e in data)
        if (e[dateKey] != null) _dateOnly(DateTime.parse(e[dateKey] as String)),
    ];
  }

  /// parsePaidDates の結果のうち、date 以前（同日を含む）の件数
  static int countPaidDatesUpTo({required List<DateTime> paidDates, required DateTime date}) {
    final DateTime target = _dateOnly(date);

    int count = 0;
    for (final DateTime d in paidDates) {
      if (!d.isAfter(target)) {
        count++;
      }
    }

    return count;
  }

  ///
  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// 指定日時点の総資産（各資産は直近366日以内の最新値を使う）
  /// monthly_assets_graph_alert.dart と yearly_assets_spend_info_alert.dart に同一コードがあったものを集約
  static int calcTotalAssetsAtDate({
    required DateTime date,
    required Map<String, GoldModel> goldMap,
    required Map<String, List<StockModel>> stockMap,
    required Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
    required Map<String, MoneyModel> moneyMap,
    required List<DateTime> insurancePaidDates,
    required List<DateTime> nenkinKikinPaidDates,
  }) {
    final int lastGoldSum = _findLastValidGoldValue(date: date, goldMap: goldMap);
    final int lastStockSum = _findLastValidStockSum(date: date, stockMap: stockMap);
    final int lastToushiSum = _findLastValidToushiSum(date: date, toushiShintakuMap: toushiShintakuMap);
    final int lastMoneySum = _findLastValidMoneySum(date: date, moneyMap: moneyMap);

    final int insurancePassedMonths = countPaidDatesUpTo(paidDates: insurancePaidDates, date: date) + 102;
    // 丸めは他画面（月別資産表示・棒グラフ・年別資産）と同じく最後に1回だけ切り捨てる
    final int insuranceSum = (insurancePassedMonths * 55880 * 0.7).toInt();

    final int nenkinKikinPassedMonths = countPaidDatesUpTo(paidDates: nenkinKikinPaidDates, date: date) + 32;
    // 2026-06-15に国民年金基金解約のため、同日以降は0
    final int nenkinKikinSum = date.isBefore(DateTime(2026, 6, 15))
        ? (nenkinKikinPassedMonths * 26625 * 0.7).toInt()
        : 0;

    const double assetRate = 0.8;

    return lastMoneySum +
        (lastGoldSum * assetRate).toInt() +
        (lastStockSum * assetRate).toInt() +
        (lastToushiSum * assetRate).toInt() +
        insuranceSum +
        nenkinKikinSum;
  }

  ///
  static int _findLastValidGoldValue({required DateTime date, required Map<String, GoldModel> goldMap}) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final GoldModel? model = goldMap[key];
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
  static int _findLastValidStockSum({required DateTime date, required Map<String, List<StockModel>> stockMap}) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<StockModel>? list = stockMap[key];
      if (list != null && list.isNotEmpty) {
        return calcStockSum(list);
      }
    }
    return 0;
  }

  ///
  static int _findLastValidToushiSum({
    required DateTime date,
    required Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
  }) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<ToushiShintakuModel>? list = toushiShintakuMap[key];
      if (list != null && list.isNotEmpty) {
        return calcToushiSum(list);
      }
    }
    return 0;
  }

  ///
  static int _findLastValidMoneySum({required DateTime date, required Map<String, MoneyModel> moneyMap}) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final String? sum = moneyMap[key]?.sum;
      if (sum != null && sum.isNotEmpty) {
        return sum.toInt();
      }
    }
    return 0;
  }
}
