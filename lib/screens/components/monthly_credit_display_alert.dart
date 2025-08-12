import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';
import '../parts/lifetime_dialog.dart';
import 'monthly_credit_summary_alert.dart';

class MonthlyCreditDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyCreditDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyCreditDisplayAlert> createState() => _MonthlyCreditDisplayAlertState();
}

class _MonthlyCreditDisplayAlertState extends ConsumerState<MonthlyCreditDisplayAlert>
    with ControllersMixin<MonthlyCreditDisplayAlert> {
  int monthlyCreditSum = 0;
  int monthlySpendCreditSum = 0;

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[const Text('クレジット'), Text(widget.yearmonth)],
                    ),

                    ChoiceChip(
                      label: const Text('summary', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.black.withValues(alpha: 0.1),
                      selectedColor: Colors.greenAccent.withValues(alpha: 0.2),
                      selected: true,
                      onSelected: (bool isSelected) {
                        LifetimeDialog(
                          context: context,
                          widget: MonthlyCreditSummaryAlert(yearmonth: widget.yearmonth),
                        );
                      },
                      showCheckmark: false,
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayCreditSummaryList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('spend : ${monthlySpendCreditSum.toString().toCurrency()}'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('credit : ${monthlyCreditSum.toString().toCurrency()}'),

                        const Text('over 10,000', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                      ],
                    ),
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
  Widget displayCreditSummaryList() {
    final List<Widget> list = <Widget>[];

    int sum = 0;
    appParamState.keepCreditSummaryMap[widget.yearmonth]?.forEach((CreditSummaryModel element) {
      final Color listColor = (element.price >= 10000) ? Colors.orangeAccent : Colors.white;

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: DefaultTextStyle(
            style: TextStyle(color: listColor, fontSize: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text(element.useDate)),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.detail),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Text(
                            element.item,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency())),
                ),
              ],
            ),
          ),
        ),
      );

      sum += element.price;
    });

    setState(() => monthlyCreditSum = sum);

    int sum2 = 0;
    appParamState.keepMoneySpendMap.forEach((String key, List<MoneySpendModel> value) {
      if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
        for (final MoneySpendModel element in value) {
          if (element.item == 'クレジット') {
            sum2 += element.price;
          }
        }
      }
    });

    setState(() => monthlySpendCreditSum = sum2);

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
