import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';
import '../../models/stock_model.dart';
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
}
