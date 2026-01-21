import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';

class SpendEachYearSummaryDisplayAlert extends ConsumerStatefulWidget {
  const SpendEachYearSummaryDisplayAlert({super.key});

  @override
  ConsumerState<SpendEachYearSummaryDisplayAlert> createState() => _SpendEachYearSummaryDisplayAlertState();
}

class _SpendEachYearSummaryDisplayAlertState extends ConsumerState<SpendEachYearSummaryDisplayAlert>
    with ControllersMixin<SpendEachYearSummaryDisplayAlert> {
  final AutoScrollController autoScrollController = AutoScrollController();

  int summaryTotal = 0;

  bool hidePlus = false;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('spend each year summary', style: TextStyle(fontSize: 12)),
                    Text(appParamState.yearlyAllSpendSelectedYear),
                  ],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Expanded(child: displayYearlyAllSpendSummary()),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => setState(() => hidePlus = !hidePlus),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: hidePlus ? const Text('show plus') : const Text('hide plus'),
                    ),
                    Text(summaryTotal.toString().toCurrency()),
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
  Widget displayYearlyAllSpendSummary() {
    final String selectedYear = appParamState.yearlyAllSpendSelectedYear;

    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>[
      '年金',
      'GOLD',
      'アイアールシー',
      'メルカリ',
      '衣料費',
      '牛乳代',
      '共済費',
      '共済戻り',
      '住民税',
      '所得税',
      '消費税',
      '弁当代',
    ];

    for (final String item in extraItems) {
      if (!itemKeys.contains(item)) {
        itemKeys.add(item);
      }
    }

    final Map<String, int> summary = <String, int>{};
    for (final String key in itemKeys) {
      summary[key] = 0;
    }

    appParamState.keepMoneySpendMap.forEach((String key2, List<MoneySpendModel> value2) {
      if (key2.split('-').first != selectedYear) {
        return;
      }

      for (final MoneySpendModel element in value2) {
        final String itemKey = element.item;

        final int? current = summary[itemKey];
        if (current != null) {
          summary[itemKey] = current + element.price;
        }
      }
    });

    final List<Widget> list = <Widget>[];

    int st = 0;

    for (final String key in itemKeys) {
      final int total = summary[key] ?? 0;

      bool flag = true;

      if (hidePlus) {
        if (total < 0) {
          flag = false;
        }
      }

      if (flag) {
        if (total != 0) {
          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    total.toString().toCurrency(),
                    style: TextStyle(color: (total < 0) ? Colors.yellowAccent : Colors.white),
                  ),
                ],
              ),
            ),
          );

          st += total;
        }
      }
    }

    setState(() => summaryTotal = st);

    return CustomScrollView(
      controller: autoScrollController,
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
}
