import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';

class SpendEachYearDisplayAlert extends ConsumerStatefulWidget {
  const SpendEachYearDisplayAlert({super.key});

  @override
  ConsumerState<SpendEachYearDisplayAlert> createState() => _SpendEachYearDisplayAlertState();
}

class _SpendEachYearDisplayAlertState extends ConsumerState<SpendEachYearDisplayAlert>
    with ControllersMixin<SpendEachYearDisplayAlert> {
  final AutoScrollController autoScrollController = AutoScrollController();

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('spend each year', style: TextStyle(fontSize: 12)),
                    SizedBox.shrink(),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),

                    GestureDetector(
                      onTap: () => appParamNotifier.setYearlyAllSpendSelectedYear(year: ''),
                      child: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Expanded(child: displaySpendEachYearList()),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  children: <Widget>[
                    const Expanded(flex: 2, child: SizedBox.shrink()),

                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,

                        child: GestureDetector(
                          onTap: () {
                            appParamNotifier.setYearlyAllSpendSelectedPrice(price: '');
                            autoScrollController.scrollToIndex(0);
                          },
                          child: Text(
                            '-',

                            style: TextStyle(
                              color: (appParamState.yearlyAllSpendSelectedPrice == '')
                                  ? Colors.yellowAccent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            appParamNotifier.setYearlyAllSpendSelectedPrice(price: '10000');
                            autoScrollController.scrollToIndex(0);
                          },
                          child: Text(
                            '10000',

                            style: TextStyle(
                              color: (appParamState.yearlyAllSpendSelectedPrice == '10000')
                                  ? Colors.yellowAccent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            appParamNotifier.setYearlyAllSpendSelectedPrice(price: '30000');
                            autoScrollController.scrollToIndex(0);
                          },
                          child: Text(
                            '30000',

                            style: TextStyle(
                              color: (appParamState.yearlyAllSpendSelectedPrice == '30000')
                                  ? Colors.yellowAccent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                SizedBox(height: 350, child: displayYearlyAllSpend()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displaySpendEachYearList() {
    final List<Widget> list = <Widget>[];

    final Map<int, int> eachYearSpendMap = <int, int>{};

    appParamState.keepMoneySpendMap.forEach((String key, List<MoneySpendModel> value) {
      for (final MoneySpendModel element in value) {
        final int year = int.parse(element.date.split('-')[0]);

        eachYearSpendMap.update(year, (int prev) => prev + element.price, ifAbsent: () => element.price);
      }
    });

    final List<String> dates = appParamState.keepMoneySpendMap.keys.toList();
    dates.sort();

    final List<int> keys = eachYearSpendMap.keys.toList();
    final Map<int, Map<String, String>> eachYearStartEndDate = <int, Map<String, String>>{};
    for (final int element in keys) {
      eachYearStartEndDate[element] = <String, String>{
        'start': DateTime(element).yyyymmdd,
        'end': (element == DateTime.now().year) ? dates.last : DateTime(element + 1, 1, 0).yyyymmdd,
      };
    }

    eachYearSpendMap.forEach((int key, int value) {
      String dispTerm = '';
      int dateDiff = 0;
      int perDay = 0;
      int estimate = 0;

      if (eachYearStartEndDate[key] != null) {
        dispTerm = '${eachYearStartEndDate[key]!['start']} - ${eachYearStartEndDate[key]!['end']}';

        dateDiff = DateTime.parse(eachYearStartEndDate[key]!['end']!)
            .difference(
              DateTime(
                eachYearStartEndDate[key]!['start']!.split('-')[0].toInt(),
                eachYearStartEndDate[key]!['start']!.split('-')[1].toInt(),
                eachYearStartEndDate[key]!['start']!.split('-')[2].toInt() - 1,
              ),
            )
            .inDays;

        perDay = (value / dateDiff).toInt();

        final DateTime nextYearStart = (key == DateTime.now().year) ? DateTime(key + 1) : DateTime.now();
        final int thisYearDiff = (key == DateTime.now().year) ? nextYearStart.difference(DateTime(key)).inDays : 0;

        estimate = (key == DateTime.now().year) ? (perDay * thisYearDiff) : value;
      }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text(dispTerm), Text(value.toString().toCurrency())],
                      ),

                      const SizedBox(height: 5),

                      DefaultTextStyle(
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Expanded(flex: 2, child: SizedBox.shrink()),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[Text(dateDiff.toString()), Text(perDay.toString().toCurrency())],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[const SizedBox.shrink(), Text(estimate.toString().toCurrency())],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: () {
                    appParamNotifier.setYearlyAllSpendSelectedYear(year: key.toString());

                    autoScrollController.scrollToIndex(0);
                  },
                  child: Icon(
                    Icons.info_outline,
                    color: (appParamState.yearlyAllSpendSelectedYear == key.toString())
                        ? Colors.yellowAccent.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

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
  Widget displayYearlyAllSpend() {
    if (appParamState.yearlyAllSpendSelectedYear == '') {
      return const SizedBox.shrink();
    }

    final List<Widget> list = <Widget>[];

    /// マップをキーでソートする方法
    // ignore: always_specify_types
    final Map<String, List<MoneySpendModel>> sortedByKey = Map.fromEntries(
      appParamState.keepMoneySpendMap.entries.toList()..sort(
        (MapEntry<String, List<MoneySpendModel>> a, MapEntry<String, List<MoneySpendModel>> b) =>
            a.key.compareTo(b.key),
      ),
    );

    int i = 0;
    sortedByKey.forEach((String key, List<MoneySpendModel> value) {
      if (appParamState.yearlyAllSpendSelectedYear == key.split('-')[0]) {
        for (final MoneySpendModel element in value) {
          bool flag = true;

          if (appParamState.yearlyAllSpendSelectedPrice != '') {
            if (element.price < appParamState.yearlyAllSpendSelectedPrice.toInt()) {
              flag = false;
            }
          }

          if (flag) {
            list.add(
              AutoScrollTag(
                // ignore: always_specify_types
                key: ValueKey(i),
                index: i,
                controller: autoScrollController,

                child: Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(element.date)),
                        Expanded(child: Text(element.item)),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              element.price.toString().toCurrency(),
                              style: TextStyle(color: (element.price >= 30000) ? Colors.orangeAccent : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        i++;
      }
    });

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
