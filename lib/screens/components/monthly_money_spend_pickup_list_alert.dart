import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
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
  void makeItemMoneySpendModelMap() {
    itemMoneySpendModelMap.clear();

    for (final String item in itemKeysFromDisplayList) {
      final Map<String, int> monthPriceMap = <String, int>{};

      for (final String yearMonth in yearMonthList) {
        int sum = 0;

        for (int day = 1; day <= 31; day++) {
          final String date = '$yearMonth-${day.toString().padLeft(2, '0')}';

          appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel moneySpendModel) {
            if (moneySpendModel.item == item) {
              sum += moneySpendModel.price;
            }
          });
        }

        monthPriceMap[yearMonth] = sum;
      }

      itemMoneySpendModelMap[item] = monthPriceMap;
    }
  }
}
