import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';
import '../parts/flexible_table.dart';

class MoneySpendCrossTableAlert extends ConsumerStatefulWidget {
  const MoneySpendCrossTableAlert({super.key});

  @override
  ConsumerState<MoneySpendCrossTableAlert> createState() => _MoneySpendCrossTableAlertState();
}

class _MoneySpendCrossTableAlertState extends ConsumerState<MoneySpendCrossTableAlert>
    with ControllersMixin<MoneySpendCrossTableAlert> {
  FlexibleTableController? _tableCtl;

  static const double leftItemWidth = 140.0;
  static const double colWidth = 110.0;

  ///
  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, int>> yearItemTotalMap = buildYearItemTotalMap(appParamState.keepMoneySpendMap);
    final List<String> years = collectYears(yearItemTotalMap);

    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>['共済戻り', '年金', 'アイアールシー', 'メルカリ', '牛乳代', '弁当代'];

    for (final String item in extraItems) {
      if (!itemKeys.contains(item)) {
        itemKeys.add(item);
      }
    }

    final Set<String> existingItems = <String>{};

    for (final Map<String, int> m in yearItemTotalMap.values) {
      existingItems.addAll(m.keys);
    }

    final List<String> items = itemKeys.where((String item) => existingItems.contains(item)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('spend each year cross table', style: TextStyle(fontSize: 12)),

                  SizedBox.shrink(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () => _tableCtl?.scrollToTop(),
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('先頭へ'),
                  ),
                  TextButton.icon(
                    onPressed: () => _tableCtl?.scrollToBottom(),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('末尾へ'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FlexibleTable(
                  rowCount: items.length,

                  headerContents: years.map((String y) => FlexibleColumn(title: y, width: colWidth)).toList(),

                  leftColumnWidth: leftItemWidth,

                  leftHeader: FlexibleTable.headerCell(
                    text: 'ITEM',
                    width: leftItemWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                  ),

                  buildLeftCell: (BuildContext context, int row) {
                    final String item = (row >= 0 && row < items.length) ? items[row] : '';

                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3))),
                      child: Text(item, style: const TextStyle(fontSize: 12)),
                    );
                  },

                  buildCell: (BuildContext context, int row, int colIndex) {
                    final String item = items[row];
                    final String year = years[colIndex];

                    final int total = yearItemTotalMap[year]?[item] ?? 0;

                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.3))),
                      ),
                      child: Text(total.toString().toCurrency(), style: const TextStyle(fontSize: 12)),
                    );
                  },

                  headerDecoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),

                  bodyCellDecoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2))),

                  onControllerReady: (FlexibleTableController ctl) => _tableCtl = ctl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Map<String, Map<String, int>> buildYearItemTotalMap(Map<String, List<MoneySpendModel>> keepMoneySpendMap) {
    final Map<String, Map<String, int>> result = <String, Map<String, int>>{};

    keepMoneySpendMap.forEach((String ymd, List<MoneySpendModel> spendList) {
      final List<String> parts = ymd.split('-');
      if (parts.isEmpty) {
        return;
      }

      final String year = parts.first;
      if (year.isEmpty) {
        return;
      }

      // ignore: unnecessary_statements
      (result[year] ??= <String, int>{});

      for (final MoneySpendModel m in spendList) {
        result[year]![m.item] = (result[year]![m.item] ?? 0) + m.price;
      }
    });

    return result;
  }

  ///
  List<String> collectYears(Map<String, Map<String, int>> yearItemTotalMap) {
    final List<String> years = yearItemTotalMap.keys.toList()..sort();
    return years;
  }
}
