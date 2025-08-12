import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../utility/utility.dart';

class MonthlyCreditSummaryAlert extends ConsumerStatefulWidget {
  const MonthlyCreditSummaryAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyCreditSummaryAlert> createState() => _MonthlyCreditSummaryAlertState();
}

class _MonthlyCreditSummaryAlertState extends ConsumerState<MonthlyCreditSummaryAlert>
    with ControllersMixin<MonthlyCreditSummaryAlert> {
  Map<String, List<int>> creditSummaryMap = <String, List<int>>{};

  int listSum = 0;

  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    makeCreditSummaryMap();

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
                    const SizedBox.shrink(),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayCreditSummaryList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('over 30,000', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                    Text('sum : ${listSum.toString().toCurrency()}'),
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
  List<String> getCreditItemList() {
    final List<String> ret = <String>[];

    const String str = '''
    楽天キャッシュ
    食費
    交通費
    交際費
    支払い
    遊興費
    教育費
    設備費
    投資
    ジム会費
    ふるさと納税
    衣料費
    雑費
    美容費
    医療費
    水道光熱費
    通信費
    不明
    ''';

    final List<String> exStr = str.split('\n');

    for (final String element in exStr) {
      if (element != '') {
        ret.add(element.trim());
      }
    }

    return ret;
  }

  ///
  Widget displayCreditSummaryList() {
    listSum = 0;

    final List<Widget> list = <Widget>[];

    final Map<String, int> totalMap = <String, int>{};

    getCreditItemList().forEach((String element2) {
      creditSummaryMap.forEach((String key, List<int> value) {
        if (element2 == key) {
          int sum = 0;
          for (final int element in value) {
            sum += element;
          }

          totalMap[key] = sum;

          final Color listColor = (sum >= 30000) ? Colors.orangeAccent : Colors.white;

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 12, color: listColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(key), Text(sum.toString().toCurrency())],
                ),
              ),
            ),
          );
        }
      });
    });

    final int total = utility.getListSum<int>(totalMap.values.toList(), (int e) => e);

    setState(() => listSum = total);

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
  void makeCreditSummaryMap() {
    appParamState.keepCreditSummaryMap[widget.yearmonth]?.forEach((CreditSummaryModel element) {
      (creditSummaryMap[element.item] ??= <int>[]).add(element.price);
    });
  }
}
