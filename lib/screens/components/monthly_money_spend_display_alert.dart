import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';
import '../../utils/iterable_extensions.dart';
import '../../utils/ui_utils.dart';
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
                        appParamNotifier.setIsMonthlySpendSummaryMinusJogai(flag: false);

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
                    Text('spend : ${monthlySum.toString().toCurrency()}', style: const TextStyle(fontSize: 12)),
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

    final int endNum = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt() + 1,
      0,
    ).day;

    final List<int> listSumList = <int>[];

    for (int i = 1; i <= endNum; i++) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      final Color headColor = (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date))
          ? UiUtils.youbiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
          : Colors.yellowAccent.withValues(alpha: 0.1);

      int sum = 0;
      appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel element) {
        sum += element.price;
      });

      int spend = 0;
      if (appParamState.keepWalkModelMap[date] != null) {
        spend = appParamState.keepWalkModelMap[date]!.spend.replaceAll(',', '').replaceAll('円', '').toInt();
      }

      listSumList.add(spend);

      final int diff = spend - sum;

      bool inputDisplay;
      if (DateTime.parse(date).isBeforeOrSameDate(DateTime.now())) {
        inputDisplay = true;
      } else {
        inputDisplay = false;
      }

      if (date == DateTime.now().yyyymmdd) {
        list.add(const DottedLine(dashColor: Colors.orangeAccent, lineThickness: 2, dashGapLength: 3));
      }

      list.add(
        Stack(
          children: <Widget>[
            if (appParamState.keepAmazonPurchaseMap[date] != null) ...<Widget>[
              Positioned(
                right: 30,
                bottom: 5,
                child: Icon(FontAwesomeIcons.amazon, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],

            if (date == DateTime.now().yyyymmdd) ...<Widget>[
              const Positioned(
                left: 3,
                bottom: 3,
                child: Text('TODAY', style: TextStyle(fontSize: 10, color: Colors.orangeAccent)),
              ),
            ],

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
                    if (inputDisplay)
                      GestureDetector(
                        onTap: () => LifetimeDialog(
                          context: context,
                          widget: SpendDateInputAlert(date: date),
                        ),
                        child: Icon(
                          Icons.input,
                          color: (diff != 0)
                              ? Colors.greenAccent.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.4),
                        ),
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
                            displayDateMoneySpendList(date: date),
                          ],

                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const SizedBox.shrink(),
                              Text(
                                diff.toString().toCurrency(),
                                style: TextStyle(
                                  color: (diff != 0)
                                      ? Colors.yellowAccent.withValues(alpha: 0.5)
                                      : Colors.pinkAccent.withValues(alpha: 0.5),
                                ),
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
          ],
        ),
      );
    }

    final int listSum = listSumList.sumByInt((int e) => e);

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

  ///
  Widget displayDateMoneySpendList({required String date}) {
    if (appParamState.keepMoneySpendMap[date] == null) {
      return const SizedBox.shrink();
    }

    final List<Widget> list = <Widget>[];

    final Map<String, List<MoneySpendModel>> map = <String, List<MoneySpendModel>>{};

    appParamState.keepMoneySpendMap[date]?.forEach(
      (MoneySpendModel element) => (map[element.item] ??= <MoneySpendModel>[]).add(element),
    );

    appParamState.keepMoneySpendItemMap.forEach((String key, MoneySpendItemModel value) {
      map[key]?.forEach((MoneySpendModel element) {
        list.add(
          DefaultTextStyle(
            style: TextStyle(
              color: (element.kind == 'credit') ? Colors.greenAccent.withValues(alpha: 0.6) : Colors.white,
              fontSize: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(element.item), Text(element.price.toString().toCurrency())],
              ),
            ),
          ),
        );
      });
    });

    return Column(children: list);
  }
}
