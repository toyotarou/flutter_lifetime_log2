import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';

class MonthlyMoneySpendPickupListAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendPickupListAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendPickupListAlert> createState() => _MonthlyMoneySpendPickupListAlertState();
}

class _MonthlyMoneySpendPickupListAlertState extends ConsumerState<MonthlyMoneySpendPickupListAlert>
    with ControllersMixin<MonthlyMoneySpendPickupListAlert> {
  List<String> itemKeysFromDisplayList = <String>[];

  List<String> yearMonthList = <String>[];

  final Map<String, Map<String, int>> itemMoneySpendModelMap = <String, Map<String, int>>{};

  ///
  @override
  Widget build(BuildContext context) {
    makeItemKeysFromDisplayList();

    makeYearMonthList();

    makeItemMoneySpendModelMap();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('pickup compare'),

                    Row(children: <Widget>[Text(yearMonthList.first), const Text(' ... '), Text(yearMonthList.last)]),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayPickupCompareList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void makeYearMonthList() {
    yearMonthList.clear();

    final Set<String> set = <String>{};

    for (int i = 0; i < 500; i++) {
      set.add(DateTime.now().subtract(Duration(days: i)).yyyymm);
    }

    final List<String> list = set.toList();

    final List<String> listA = list.sublist(0, 12);

    listA.sort();

    yearMonthList = listA;
  }

  ///
  Widget displayPickupCompareList() {
    final List<Widget> list = <Widget>[];

    for (final String item in itemKeysFromDisplayList) {
      final List<Widget> list2 = <Widget>[];

      final List<String> zeroList = <String>[];

      for (final String yearMonth in yearMonthList) {
        if (itemMoneySpendModelMap[item] != null) {
          if (itemMoneySpendModelMap[item]![yearMonth] == null || itemMoneySpendModelMap[item]![yearMonth] == 0) {
            zeroList.add(yearMonth);
          }

          list2.add(
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  bottom: 2,
                  child: Text(yearMonth, style: const TextStyle(fontSize: 8, color: Colors.white60)),
                ),

                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.2))),

                  width: context.screenSize.width / 6,
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.topRight,

                  child: Text(
                    ((itemMoneySpendModelMap[item]![yearMonth] != null) ? itemMoneySpendModelMap[item]![yearMonth] : 0)
                        .toString()
                        .toCurrency(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }
      }

      if (zeroList.length != yearMonthList.length) {
        list.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item, style: const TextStyle(fontSize: 12)),

              Wrap(children: list2),

              const SizedBox(height: 5),
            ],
          ),
        );
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  void makeItemKeysFromDisplayList() {
    itemKeysFromDisplayList.clear();

    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>['共済戻り', '年金', 'アイアールシー', 'メルカリ', '牛乳代', '弁当代'];

    extraItems.forEach(itemKeys.add);

    itemKeysFromDisplayList = itemKeys;
  }

  ///
  /// 月ごとの item 別支出合計を作成する
  ///
  /// 最終的なデータ構造
  /// Map<item, Map<yearMonth, price>>
  ///
  /// 例:
  /// {
  ///   食費: {2026-01: 12000, 2026-02: 9000},
  ///   交通費: {2026-01: 3000}
  /// }
  ///
  void makeItemMoneySpendModelMap() {
    // 既存データをクリア
    itemMoneySpendModelMap.clear();

    // itemごとにMapを初期化しておく
    // {食費:{}, 交通費:{}, ...}
    for (final String item in itemKeysFromDisplayList) {
      itemMoneySpendModelMap[item] = <String, int>{};
    }

    // 月単位で処理
    for (final String yearMonth in yearMonthList) {
      // この月にクレジットサマリーが存在するか
      final bool hasCreditSummary = appParamState.keepCreditSummaryMap[yearMonth] != null;

      ///
      /// ---- クレジットサマリー集計 ----
      ///
      /// クレジットの支払いは、月単位の summary が存在する場合はこちらを優先して加算する
      ///
      if (hasCreditSummary) {
        appParamState.keepCreditSummaryMap[yearMonth]?.forEach((CreditSummaryModel element) {
          // 表示対象 item でない場合は無視
          if (!itemKeysFromDisplayList.contains(element.item)) {
            return;
          }

          // item別・月別に加算
          itemMoneySpendModelMap[element.item]![yearMonth] =
              (itemMoneySpendModelMap[element.item]![yearMonth] ?? 0) + element.price;
        });
      }

      ///
      /// ---- 日別支出集計（keepMoneySpendMap） ----
      ///
      for (final String item in itemKeysFromDisplayList) {
        // 交通費は Suica チャージ（credit）経由のため
        // credit summary がある月は二重計上になるのでスキップ
        if (hasCreditSummary && item == '交通費') {
          continue;
        }

        int sum = 0;

        // 月内の日付をループ
        for (int day = 1; day <= 31; day++) {
          final String date = '$yearMonth-${day.toString().padLeft(2, '0')}';

          // その日の支出一覧
          appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel moneySpendModel) {
            ///
            /// ---- クレジット明細の除外ルール ----
            ///
            /// credit summary が存在する月は、通常の credit 明細は二重計上になるので除外する
            /// ただし「投資」は credit 経由でも実支出として扱うため例外として除外しない
            ///
            if (hasCreditSummary && moneySpendModel.kind == 'credit' && moneySpendModel.item != '投資') {
              return;
            }

            // item が一致する場合のみ加算
            if (moneySpendModel.item == item) {
              sum += moneySpendModel.price;
            }
          });
        }

        // 既存値があれば加算
        itemMoneySpendModelMap[item]![yearMonth] = (itemMoneySpendModelMap[item]![yearMonth] ?? 0) + sum;
      }
    }
  }
}
