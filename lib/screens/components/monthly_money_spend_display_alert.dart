import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_dialog.dart';
import 'monthly_money_spend_pickup_alert.dart';
import 'monthly_money_spend_summary_alert.dart';
import 'spend_data_input_alert.dart';

class MonthlyMoneySpendDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendDisplayAlert> createState() => _MonthlyMoneySpendDisplayAlertState();
}

class MonthlyMoneySpendListResult {
  const MonthlyMoneySpendListResult({
    required this.listWidget,
    required this.monthlySum,
    required this.creditRecordMap,
  });

  final Widget listWidget;
  final int monthlySum;

  final Map<String, int> creditRecordMap;
}

class _MonthlyMoneySpendDisplayAlertState extends ConsumerState<MonthlyMoneySpendDisplayAlert>
    with ControllersMixin<MonthlyMoneySpendDisplayAlert> {
  static const int _itemCount = 100000;
  static const int _initialIndex = _itemCount ~/ 2;

  late final DateTime _baseMonth;
  int currentIndex = _initialIndex;

  final Utility utility = Utility();

  final AutoScrollController autoScrollController = AutoScrollController();

  ///
  @override
  void initState() {
    super.initState();
    _baseMonth = DateTime.parse('${widget.yearmonth}-01');
  }

  ///
  @override
  void dispose() {
    autoScrollController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/frame_arrow.png',
              color: Colors.orangeAccent.withValues(alpha: 0.4),
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
          CarouselSlider.builder(
            itemCount: _itemCount,
            initialPage: _initialIndex,
            slideTransform: const CubeTransform(),
            onSlideChanged: (int index) => setState(() => currentIndex = index),
            slideBuilder: (int index) => makeMonthlyMoneySpendSlide(index),
          ),
        ],
      ),
    );
  }

  ///
  Widget makeMonthlyMoneySpendSlide(int index) {
    final DateTime genDate = monthForIndex(index: index, baseMonth: _baseMonth);

    final String monthKey = '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}-01';

    final bool hasData = appParamState.keepMoneyMap.containsKey(monthKey);

    final MonthlyMoneySpendListResult? monthlyResult = hasData ? buildMonthlyMoneySpendList(genDate: genDate) : null;

    final int monthlySum = monthlyResult?.monthlySum ?? 0;

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.2)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 18, right: 10, left: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 60, child: Text(genDate.yyyymm)),
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  final int lastDay = DateTime(genDate.year, genDate.month + 1, 0).day;
                                  autoScrollController.scrollToIndex(lastDay);
                                },
                                icon: Icon(Icons.arrow_downward, color: Colors.white.withValues(alpha: 0.3)),
                              ),
                              IconButton(
                                onPressed: () {
                                  autoScrollController.scrollToIndex(0);
                                },
                                icon: Icon(Icons.arrow_upward, color: Colors.white.withValues(alpha: 0.3)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.black.withValues(alpha: 0.3),
                            child: IconButton(
                              onPressed: () {
                                final int creditTotal =
                                    monthlyResult?.creditRecordMap.values.fold<int>(
                                      0,
                                      (int sum, int price) => sum + price,
                                    ) ??
                                    0;

                                final int creditSummaryTotal =
                                    appParamState.keepCreditSummaryMap[widget.yearmonth]?.fold<int>(
                                      0,
                                      (int sum, CreditSummaryModel e) => sum + e.price,
                                    ) ??
                                    0;

                                if (creditTotal != creditSummaryTotal) {
                                  error_dialog(
                                    context: context,
                                    title: '表示できません。',
                                    content:
                                        '二つの値が同値ではありません。\ncreditTotal: $creditTotal\ncreditSummaryTotal: $creditSummaryTotal',
                                  );

                                  return;
                                }

                                LifetimeDialog(
                                  context: context,
                                  widget: MonthlyMoneySpendPickupAlert(yearmonth: widget.yearmonth),
                                );
                              },

                              icon: const Icon(Icons.check),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text('summary', style: TextStyle(fontSize: 10)),
                            backgroundColor: Colors.black.withValues(alpha: 0.1),
                            selectedColor: Colors.greenAccent.withValues(alpha: 0.2),
                            selected: true,
                            onSelected: (bool isSelected) {
                              appParamNotifier.setIsMonthlySpendSummaryMinusJogai(flag: false);

                              LifetimeDialog(
                                context: context,
                                widget: MonthlyMoneySpendSummaryAlert(yearmonth: genDate.yyyymm),
                              );
                            },
                            showCheckmark: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                  if (hasData) ...<Widget>[Expanded(child: monthlyResult!.listWidget)] else ...<Widget>[
                    const Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('no data', style: TextStyle(color: Colors.yellowAccent)),
                              SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
        ],
      ),
    );
  }

  ///
  MonthlyMoneySpendListResult buildMonthlyMoneySpendList({required DateTime genDate}) {
    final List<Widget> monthlyMoneySpendList = <Widget>[];

    final Map<String, int> creditRecordMap = <String, int>{};

    final int endNum = DateTime(genDate.year, genDate.month + 1, 0).day;

    final List<int> listSumList = <int>[];

    for (int i = 1; i <= endNum; i++) {
      final String date = '${genDate.yyyymm}-${i.toString().padLeft(2, '0')}';

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

      listSumList.add(spend);

      final int diff = spend - sum;

      final bool inputDisplay = DateTime.parse(date).isBeforeOrSameDate(DateTime.now());

      if (date == DateTime.now().yyyymmdd) {
        monthlyMoneySpendList.add(const DottedLine(dashColor: Colors.orangeAccent, lineThickness: 2, dashGapLength: 3));
      }

      monthlyMoneySpendList.add(
        AutoScrollTag(
          // ignore: always_specify_types
          key: ValueKey(i),
          index: i,
          controller: autoScrollController,
          child: Stack(
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
                              displayDateMoneySpendList(date: date, creditRecordMap: creditRecordMap),
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
        ),
      );
    }

    final int listSum = utility.getListSum<int>(listSumList, (int e) => e);

    return MonthlyMoneySpendListResult(
      monthlySum: listSum,
      creditRecordMap: creditRecordMap,
      listWidget: CustomScrollView(
        controller: autoScrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => monthlyMoneySpendList[index],
              childCount: monthlyMoneySpendList.length,
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayDateMoneySpendList({required String date, required Map<String, int> creditRecordMap}) {
    final List<MoneySpendModel>? spends = appParamState.keepMoneySpendMap[date];
    if (spends == null) {
      return const SizedBox.shrink();
    }

    final List<Widget> list = <Widget>[];

    final Map<String, List<MoneySpendModel>> map = <String, List<MoneySpendModel>>{};

    for (final MoneySpendModel element in spends) {
      (map[element.item] ??= <MoneySpendModel>[]).add(element);
    }

    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>['共済戻り', '年金', 'アイアールシー', 'メルカリ', '牛乳代', '弁当代'];

    for (final String item in extraItems) {
      if (!itemKeys.contains(item)) {
        itemKeys.add(item);
      }
    }

    for (final String key in itemKeys) {
      map[key]?.forEach((MoneySpendModel element) {
        if (key == 'クレジット' && element.item == 'クレジット') {
          creditRecordMap[date] = element.price;
        }

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
    }

    return Column(children: list);
  }
}
