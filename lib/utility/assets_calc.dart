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
    final DateTime target = DateTime(date.year, date.month, date.day);

    final List<DateTime> dates =
        data
            .where((Map<String, dynamic> e) => e[dateKey] != null)
            .map((Map<String, dynamic> e) => DateTime.parse(e[dateKey] as String))
            .map((DateTime d) => DateTime(d.year, d.month, d.day))
            .toList()
          ..sort();

    return dates.where((DateTime d) => !d.isAfter(target)).length;
  }
}
