import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';

class MonthlyCreditSummaryDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyCreditSummaryDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyCreditSummaryDisplayAlert> createState() => _MonthlyCreditSummaryDisplayAlertState();
}

class _MonthlyCreditSummaryDisplayAlertState extends ConsumerState<MonthlyCreditSummaryDisplayAlert>
    with ControllersMixin<MonthlyCreditSummaryDisplayAlert> {
  int monthlyCreditSum = 0;
  int monthlySpendCreditSum = 0;

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

                Expanded(child: displayCreditSummaryList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('spend : ${monthlySpendCreditSum.toString().toCurrency()}'),
                    Text('credit : ${monthlyCreditSum.toString().toCurrency()}'),
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
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
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
