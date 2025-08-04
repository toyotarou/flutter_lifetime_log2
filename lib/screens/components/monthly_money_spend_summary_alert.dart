import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';
import '../../utility/utility.dart';

class MonthlyMoneySpendSummaryAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendSummaryAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendSummaryAlert> createState() => _MonthlyMoneySpendSummaryAlertState();
}

class _MonthlyMoneySpendSummaryAlertState extends ConsumerState<MonthlyMoneySpendSummaryAlert>
    with ControllersMixin<MonthlyMoneySpendSummaryAlert> {
  Map<String, int> moneySpendSummaryMap = <String, int>{};

  Utility utility = Utility();

  int monthlySum = 0;

  ///
  @override
  Widget build(BuildContext context) {
    makeMoneySpendSummary();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),

              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(widget.yearmonth), const SizedBox.shrink()],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  Expanded(child: displayMoneySpendSummaryList()),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      const SizedBox.shrink(),
                      Text(monthlySum.toString().toCurrency(), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  void makeMoneySpendSummary() {
    final Map<String, List<int>> map = <String, List<int>>{};

    appParamState.keepMoneySpendMap.forEach((String key, List<MoneySpendModel> value) {
      if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
        for (final MoneySpendModel element in value) {
          (map[element.item] ??= <int>[]).add(element.price);
        }
      }
    });

    map.forEach((String key, List<int> value) {
      int sum = 0;
      for (final int element in value) {
        sum += element;
      }

      moneySpendSummaryMap[key] = sum;
    });
  }

  ///
  Widget displayMoneySpendSummaryList() {
    final List<Widget> list = <Widget>[];

    int listSum = 0;

    appParamState.keepMoneySpendItemMap.forEach((String key, MoneySpendItemModel value) {
      if (moneySpendSummaryMap[value.name] != null) {
        listSum += moneySpendSummaryMap[value.name]!;

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[Text(value.name), Text(moneySpendSummaryMap[value.name].toString().toCurrency())],
            ),
          ),
        );
      }
    });

    setState(() => monthlySum = listSum);

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
}
