import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';
import '../../models/salary_model.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_dialog.dart';
import 'monthly_credit_display_alert.dart';

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
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(widget.yearmonth), const Text('使用金額')],
                      ),

                      ChoiceChip(
                        label: Text(
                          (appParamState.isMonthlySpendSummaryMinusJogai) ? '増加分除外中' : '増加分除外',
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.black.withValues(alpha: 0.1),
                        selectedColor: Colors.orangeAccent.withValues(alpha: 0.2),
                        selected: appParamState.isMonthlySpendSummaryMinusJogai,
                        onSelected: (bool isSelected) {
                          appParamNotifier.setIsMonthlySpendSummaryMinusJogai(flag: isSelected);
                        },
                        showCheckmark: false,
                      ),
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  Expanded(child: displayMoneySpendSummaryList()),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      const Text('over 30,000', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),

                      Text('list total : ${monthlySum.toString().toCurrency()}', style: const TextStyle(fontSize: 12)),
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
        final int moneySpendSummary = moneySpendSummaryMap[value.name]!;

        bool flag = true;

        if (appParamState.isMonthlySpendSummaryMinusJogai && moneySpendSummary < 0) {
          flag = false;
        }

        if (flag) {
          listSum += moneySpendSummary;

          final Color listColor = (moneySpendSummary >= 30000) ? Colors.orangeAccent : Colors.white;

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: DefaultTextStyle(
                style: TextStyle(color: listColor, fontSize: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Text(value.name),
                    Row(
                      children: <Widget>[
                        Text(moneySpendSummary.toString().toCurrency()),
                        SizedBox(
                          width: 40,

                          child: Container(
                            alignment: Alignment.topRight,
                            child: (value.name == 'クレジット')
                                ? (widget.yearmonth == DateTime.now().yyyymm)
                                      ? const Text('未入力', style: TextStyle(color: Colors.greenAccent, fontSize: 8))
                                      : GestureDetector(
                                          onTap: () {
                                            if (appParamState.keepCreditSummaryMap.isEmpty) {
                                              // ignore: always_specify_types
                                              Future.delayed(
                                                Duration.zero,
                                                () => error_dialog(
                                                  // ignore: use_build_context_synchronously
                                                  context: context,
                                                  title: '表示できません。',
                                                  content: 'appParamState.keepCreditSummaryMapが作成されていません。',
                                                ),
                                              );

                                              return;
                                            }

                                            LifetimeDialog(
                                              context: context,
                                              widget: MonthlyCreditDisplayAlert(yearmonth: widget.yearmonth),
                                            );
                                          },
                                          child: Icon(Icons.star, color: Colors.white.withValues(alpha: 0.4)),
                                        )
                                : const Icon(Icons.square_outlined, color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    });

    ///////////////////////////////////////////////////////////////// salary start

    if (!appParamState.isMonthlySpendSummaryMinusJogai) {
      List<SalaryModel> salaryModelList = <SalaryModel>[];
      appParamState.keepSalaryMap.forEach((String key, List<SalaryModel> value) {
        if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
          salaryModelList = value;
        }
      });

      int salary = 0;

      if (salaryModelList.isNotEmpty) {
        for (final SalaryModel element in salaryModelList) {
          salary += element.salary;
        }

        listSum += salary * -1;

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                const Text('収入'),
                Row(children: <Widget>[Text((salary * -1).toString().toCurrency()), const SizedBox(width: 40)]),
              ],
            ),
          ),
        );
      }
    }

    ///////////////////////////////////////////////////////////////// salary end

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
