import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';

class MonthlyMoneySpendDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendDisplayAlert> createState() => _MonthlyMoneySpendDisplayAlertState();
}

class _MonthlyMoneySpendDisplayAlertState extends ConsumerState<MonthlyMoneySpendDisplayAlert>
    with ControllersMixin<MonthlyMoneySpendDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
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
                  children: <Widget>[Text(widget.yearmonth), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayMonthlyMoneySpendList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayMonthlyMoneySpendList() {
    final List<Widget> list = <Widget>[];

    final int endNum = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt() + 1,
      0,
    ).day;

    for (int i = 1; i <= endNum; i++) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      int sum = 0;
      appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel element) {
        sum += element.price;
      });

      int spend = 0;
      if (appParamState.keepWalkModelMap[date] != null) {
        spend = appParamState.keepWalkModelMap[date]!.spend.replaceAll(',', '').replaceAll('円', '').toInt();
      }

      final int diff = spend - sum;

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
          ),
          padding: const EdgeInsets.all(5),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (diff == 0)
                  const Icon(Icons.square_outlined, color: Colors.transparent)
                else
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.4)),
                  ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.1)),
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        margin: const EdgeInsets.symmetric(vertical: 2),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[Text(i.toString().padLeft(2, '0')), Text(spend.toString().toCurrency())],
                        ),
                      ),

                      if (appParamState.keepMoneySpendMap[date] != null) ...<Widget>[
                        Column(
                          children: appParamState.keepMoneySpendMap[date]!.map((MoneySpendModel e) {
                            if (e.item == 'aaa') {
                              return const SizedBox.shrink();
                            } else {
                              return DefaultTextStyle(
                                style: TextStyle(
                                  color: (e.kind == 'credit')
                                      ? Colors.greenAccent.withValues(alpha: 0.6)
                                      : Colors.white,
                                  fontSize: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[Text(e.item), Text(e.price.toString().toCurrency())],
                                ),
                              );
                            }
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Text(
                            diff.toString().toCurrency(),
                            style: TextStyle(color: Colors.pinkAccent.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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
}
