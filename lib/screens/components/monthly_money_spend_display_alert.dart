import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'monthly_money_spend_summary_alert.dart';
import 'spend_data_input_alert.dart';

class MonthlyMoneySpendDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendDisplayAlert> createState() => _MonthlyMoneySpendDisplayAlertState();
}

class _MonthlyMoneySpendDisplayAlertState extends ConsumerState<MonthlyMoneySpendDisplayAlert>
    with ControllersMixin<MonthlyMoneySpendDisplayAlert> {
  Utility utility = Utility();

  int monthlySum = 0;

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
                  children: <Widget>[
                    Text(widget.yearmonth),

                    ChoiceChip(
                      label: const Text('summary', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.black.withValues(alpha: 0.1),
                      selectedColor: Colors.greenAccent.withValues(alpha: 0.2),
                      selected: true,
                      onSelected: (bool isSelected) {
                        LifetimeDialog(
                          context: context,
                          widget: MonthlyMoneySpendSummaryAlert(yearmonth: widget.yearmonth),
                        );
                      },
                      showCheckmark: false,
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayMonthlyMoneySpendList()),

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
    );
  }

  ///
  Widget displayMonthlyMoneySpendList() {
    final List<Widget> list = <Widget>[];

    int listSum = 0;

    final int endNum = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt() + 1,
      0,
    ).day;

    for (int i = 1; i <= endNum; i++) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      final Color headColor = (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date))
          ? utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
          : Colors.yellowAccent.withValues(alpha: 0.1);

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
                if (diff != 0 &&
                    DateTime(
                      date.split('-')[0].toInt(),
                      date.split('-')[1].toInt(),
                      date.split('-')[2].toInt(),
                    ).isBefore(DateTime.now()))
                  GestureDetector(
                    onTap: () {
                      LifetimeDialog(
                        context: context,
                        widget: SpendDateInputAlert(date: date),
                      );
                    },
                    child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.4)),
                  )
                else
                  const Icon(Icons.square_outlined, color: Colors.transparent),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: headColor),
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        margin: const EdgeInsets.symmetric(vertical: 2),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(i.toString().padLeft(2, '0')),
                                const SizedBox(width: 5),
                                Text(youbi),
                              ],
                            ),
                            Text(spend.toString().toCurrency()),
                          ],
                        ),
                      ),

                      if (appParamState.keepMoneySpendMap[date] != null) ...<Widget>[
                        Column(
                          children: appParamState.keepMoneySpendMap[date]!.map((MoneySpendModel e) {
                            listSum += e.price;

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
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[Text(e.item), Text(e.price.toString().toCurrency())],
                                  ),
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
