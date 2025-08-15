import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_dialog.dart';
import 'assets_detail_display_alert.dart';
import 'monthly_assets_graph_alert.dart';
import 'stock_data_input_alert.dart';

class MonthlyAssetsDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsDisplayAlert({
    super.key,
    required this.yearmonth,
    required this.nenkinKikinDataList,
    required this.insuranceDataList,
  });

  final String yearmonth;
  final List<Map<String, String>> nenkinKikinDataList;
  final List<Map<String, String>> insuranceDataList;

  @override
  ConsumerState<MonthlyAssetsDisplayAlert> createState() => _MonthlyAssetsDisplayAlertState();
}

class _MonthlyAssetsDisplayAlertState extends ConsumerState<MonthlyAssetsDisplayAlert>
    with ControllersMixin<MonthlyAssetsDisplayAlert> {
  Utility utility = Utility();

  bool todayStockExists = false;

  Map<int, int> monthlyGraphAssetsMap = <int, int>{};

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

                    GestureDetector(
                      onTap: () {
                        if (DateTime.now().day == 1) {
                          // ignore: always_specify_types
                          Future.delayed(
                            Duration.zero,
                            () => error_dialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              title: '表示できません。',
                              content: 'データが1日分しかないため、assets graphが表示できません。',
                            ),
                          );

                          return;
                        }

                        LifetimeDialog(
                          context: context,
                          widget: MonthlyAssetsGraphAlert(
                            yearmonth: widget.yearmonth,

                            monthlyGraphAssetsMap: monthlyGraphAssetsMap,
                          ),
                        );
                      },
                      child: const Icon(Icons.graphic_eq),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayMonthlyAssetsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayMonthlyAssetsList() {
    final List<Widget> list = <Widget>[];

    final Map<String, Map<String, int>> monthlyAssetsMap = <String, Map<String, int>>{};

    final DateTime tenDaysAgoFromBeforeMonthEndDay = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt(),
      0,
    ).add(const Duration(days: 10 * -1));

    int lastGoldSum = 0;
    int lastStockSum = 0;
    int lastToushiShintakuSum = 0;
    int lastInsuranceSum = 0;
    for (int i = 0; i < 50; i++) {
      final DateTime date = tenDaysAgoFromBeforeMonthEndDay.add(Duration(days: i));

      if (appParamState.keepGoldMap[date.yyyymmdd] != null &&
          appParamState.keepGoldMap[date.yyyymmdd]!.goldValue != '-') {
        lastGoldSum = appParamState.keepGoldMap[date.yyyymmdd]!.goldValue.toString().toInt();
      }

      if (appParamState.keepStockMap[date.yyyymmdd] != null) {
        lastStockSum = 0;
        for (final StockModel element in appParamState.keepStockMap[date.yyyymmdd]!) {
          if (element.jikaHyoukagaku != '-') {
            lastStockSum += element.jikaHyoukagaku.replaceAll(',', '').toInt();

            if (date.yyyymmdd == DateTime.now().yyyymmdd) {
              todayStockExists = true;
            }
          }
        }
      }

      if (appParamState.keepToushiShintakuMap[date.yyyymmdd] != null) {
        lastToushiShintakuSum = 0;
        for (final ToushiShintakuModel element in appParamState.keepToushiShintakuMap[date.yyyymmdd]!) {
          if (element.jikaHyoukagaku != '-') {
            lastToushiShintakuSum += element.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          }
        }
      }

      final int insurancePassedMonths = getInsurancePassedMonths(date: date) + 102;
      lastInsuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths = getNenkinKikinPassedMonths(date: date) + 32;
      final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

      if (date.isBefore(DateTime.now())) {
        monthlyAssetsMap[date.yyyymmdd] = <String, int>{
          'gold': lastGoldSum,
          'stock': lastStockSum,
          'toushiShintaku': lastToushiShintakuSum,
          'insurance': lastInsuranceSum,
          'insurancePassedMonths': insurancePassedMonths,
          'nenkinKikin': nenkinKikinSum,
          'nenkinKikinPassedMonths': nenkinKikinPassedMonths,
        };
      }
    }

    final int endDay = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt() + 1,
      0,
    ).day;

    for (int i = 1; i <= endDay; i++) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      final String money = appParamState.keepMoneyMap[date]?.sum ?? '';

      final List<String> keys = <String>['gold', 'stock', 'toushiShintaku', 'insurance', 'nenkinKikin'];

      final String gold = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['gold'].toString() : '';
      final String stock = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['stock'].toString() : '';
      final String toushiShintaku = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['toushiShintaku'].toString()
          : '';
      final String insurance = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['insurance'].toString() : '';

      final String nenkinKikin = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['nenkinKikin'].toString()
          : '';

      final bool isBeforeDate = DateTime(
        date.split('-')[0].toInt(),
        date.split('-')[1].toInt(),
        date.split('-')[2].toInt(),
      ).isBefore(DateTime.now());

      final DateTime beforeDate = DateTime(
        date.split('-')[0].toInt(),
        date.split('-')[1].toInt(),
        date.split('-')[2].toInt() - 1,
      );

      final Map<String, int>? beforeData = monthlyAssetsMap[beforeDate.yyyymmdd];

      if (isBeforeDate) {
        beforeData!['money'] = appParamState.keepMoneyMap[beforeDate.yyyymmdd]?.sum.toInt() ?? 0;
      }

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      final String insurancePassedMonths = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['insurancePassedMonths'].toString()
          : '';

      final String nenkinKikinPassedMonths = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['nenkinKikinPassedMonths'].toString()
          : '';

      if (date == DateTime.now().yyyymmdd) {
        list.add(const DottedLine(dashColor: Colors.orangeAccent, lineThickness: 2, dashGapLength: 3));
      }

      //-----------------------------------------//
      final Map<String, dynamic>? monthlyAssets = monthlyAssetsMap[date];

      final List<int> items = <int>[
        if (money.isNotEmpty) int.tryParse(money) ?? 0 else 0,
        ...keys.map((String key) {
          final String value = monthlyAssets?[key]?.toString() ?? '';
          return value.isNotEmpty ? int.tryParse(value) ?? 0 : 0;
        }),
      ];

      final int total = items.fold(0, (int sum, int value) => sum + value);
      //-----------------------------------------//

      if (isBeforeDate) {
        monthlyGraphAssetsMap[i] = total;
      }

      //-----------------------------------------//
      final Map<String, dynamic>? monthlyAssetsBefore = monthlyAssetsMap[beforeDate.yyyymmdd];

      final String moneyBefore = appParamState.keepMoneyMap[beforeDate.yyyymmdd]?.sum ?? '';

      final List<int> itemsBefore = <int>[
        if (moneyBefore.isNotEmpty) int.tryParse(moneyBefore) ?? 0 else 0,
        ...keys.map((String key) {
          final String value = monthlyAssetsBefore?[key]?.toString() ?? '';
          return value.isNotEmpty ? int.tryParse(value) ?? 0 : 0;
        }),
      ];

      final int totalBefore = itemsBefore.fold(0, (int sum, int value) => sum + value);
      //-----------------------------------------//

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList),
                ),

                padding: const EdgeInsets.all(5),

                height: context.screenSize.height * 0.2,

                child: Column(
                  children: <Widget>[
                    Text(i.toString().padLeft(2, '0')),
                    const SizedBox(height: 10),
                    Text(youbi.substring(0, 3), style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: isBeforeDate ? Colors.white : Colors.grey.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    isBeforeDate ? total.toString().toCurrency() : '-',
                                    style: const TextStyle(fontSize: 24),
                                  ),

                                  if (isBeforeDate) ...<Widget>[
                                    Row(
                                      children: <Widget>[
                                        if ((totalBefore - total) < 0) ...<Widget>[
                                          const Text('+', style: TextStyle(color: Colors.yellowAccent)),
                                        ],

                                        Text(
                                          ((totalBefore - total) * -1).toString().toCurrency(),

                                          style: const TextStyle(color: Colors.yellowAccent),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),

                              if (isBeforeDate) ...<Widget>[
                                const SizedBox(width: 5),

                                _dispUpDownMark(before: totalBefore, after: total, size: 24),
                              ],
                            ],
                          ),

                          if (date == DateTime.now().yyyymmdd)
                            const Text('TODAY', style: TextStyle(color: Colors.orangeAccent))
                          else
                            const Text(''),
                        ],
                      ),

                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: 'money',
                        price: money,
                        buttonDisp: false,
                        beforeData: beforeData,
                      ),

                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: 'stock',
                        price: stock,
                        buttonDisp: true,
                        beforeData: beforeData,
                      ),
                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: 'toushiShintaku',
                        price: toushiShintaku,
                        buttonDisp: false,
                        beforeData: beforeData,
                      ),

                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: 'gold',
                        price: gold,
                        buttonDisp: false,
                        beforeData: beforeData,
                      ),

                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: isBeforeDate ? 'insurance ($insurancePassedMonths)' : 'insurance',
                        price: insurance,
                        buttonDisp: false,
                        beforeData: beforeData,
                      ),

                      priceDisplayParts(
                        date: date,
                        isBeforeDate: isBeforeDate,
                        title: isBeforeDate ? 'nenkinKikin ($nenkinKikinPassedMonths)' : 'nenkinKikin',
                        price: nenkinKikin,
                        buttonDisp: false,
                        beforeData: beforeData,
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
  int getInsurancePassedMonths({required DateTime date}) {
    int ret = 0;

    for (int i = 0; i < widget.insuranceDataList.length; i++) {
      if (widget.insuranceDataList[i]['date'] != null) {
        final DateTime listDate = DateTime(
          widget.insuranceDataList[i]['date']!.split('-')[0].toInt(),
          widget.insuranceDataList[i]['date']!.split('-')[1].toInt(),
          widget.insuranceDataList[i]['date']!.split('-')[2].toInt(),
        );

        if (!listDate.isAfter(date)) {
          ret = i;
        }
      }
    }

    return ret;
  }

  ///
  int getNenkinKikinPassedMonths({required DateTime date}) {
    int ret = 0;

    for (int i = 0; i < widget.nenkinKikinDataList.length; i++) {
      if (widget.nenkinKikinDataList[i]['date'] != null) {
        final DateTime listDate = DateTime(
          widget.nenkinKikinDataList[i]['date']!.split('-')[0].toInt(),
          widget.nenkinKikinDataList[i]['date']!.split('-')[1].toInt(),
          widget.nenkinKikinDataList[i]['date']!.split('-')[2].toInt(),
        );

        if (!listDate.isAfter(date)) {
          ret = i;
        }
      }
    }
    return ret;
  }

  ///
  Widget priceDisplayParts({
    required String date,
    required bool isBeforeDate,
    required String title,
    required String price,
    required bool buttonDisp,
    Map<String, int>? beforeData,
  }) {
    final List<String> exTitle = title.split('(');

    final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

    final GestureDetector stockInputButton = GestureDetector(
      onTap: () {
        LifetimeDialog(
          context: context,
          widget: StockDataInputAlert(date: date),
        );
      },
      child: Icon(
        Icons.input,
        color: (date == DateTime.now().yyyymmdd && !todayStockExists)
            ? Colors.greenAccent.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.3),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (buttonDisp && youbi != 'Saturday' && youbi != 'Sunday' && isBeforeDate)
                stockInputButton
              else
                const Icon(Icons.square_outlined, color: Colors.transparent),

              const SizedBox(width: 10),

              if (<String>['stock', 'toushiShintaku', 'gold'].contains(title))
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {
                    LifetimeDialog(
                      context: context,
                      widget: AssetsDetailDisplayAlert(date: date, title: title),
                    );
                  },
                  child: Text(
                    title,

                    style: const TextStyle(color: Colors.white, fontSize: 12, decoration: TextDecoration.underline),
                  ),
                )
              else
                Text(title),
            ],
          ),

          if (isBeforeDate && price != '') ...<Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(price.toCurrency()),

                    const SizedBox(height: 2),

                    if (beforeData != null) ...<Widget>[
                      Row(
                        children: <Widget>[
                          if ((beforeData[exTitle[0].trim()]! - price.toInt()) < 0) ...<Widget>[
                            const Text('+', style: TextStyle(color: Colors.yellowAccent)),
                          ],

                          Text(
                            ((beforeData[exTitle[0].trim()]! - price.toInt()) * -1).toString().toCurrency(),

                            style: const TextStyle(fontSize: 10, color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                if (beforeData != null) ...<Widget>[
                  const SizedBox(width: 5),

                  _dispUpDownMark(before: beforeData[exTitle[0].trim()]!, after: price.toInt(), size: 12),
                ],
              ],
            ),
          ],

          if (!isBeforeDate || price == '') ...<Widget>[
            if (!isBeforeDate) ...<Widget>[const SizedBox.shrink()],

            if (price == '') ...<Widget>[const Text('-------------------------')],
          ],
        ],
      ),
    );
  }

  ///
  Widget _dispUpDownMark({required int before, required int after, required double size}) {
    if (before < after) {
      return Icon(Icons.arrow_upward, color: Colors.greenAccent, size: size);
    } else if (before > after) {
      return Icon(Icons.arrow_downward, color: Colors.redAccent, size: size);
    } else {
      return Icon(FontAwesomeIcons.equals, color: Colors.blueAccent, size: size);
    }
  }
}
