import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/prev_year_last_assets_model.dart';
import '../../models/common/year_day_assets_model.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/assets_calc.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'month_end_assets_display_alert.dart';
import 'yearly_assets_graph_alert.dart';

class YearlyAssetsDisplayAlert extends ConsumerStatefulWidget {
  const YearlyAssetsDisplayAlert({super.key, required this.date, required this.lastYearFinalAssets});

  final String date;
  final int lastYearFinalAssets;

  @override
  ConsumerState<YearlyAssetsDisplayAlert> createState() => _YearlyAssetsDisplayPageState();
}

class _YearlyAssetsDisplayPageState extends ConsumerState<YearlyAssetsDisplayAlert>
    with ControllersMixin<YearlyAssetsDisplayAlert> {
  final Utility utility = Utility();

  late final int year;

  final AutoScrollController autoScrollController = AutoScrollController();

  int lastAssets = 0;
  int totalDiff = 0;

  List<YearDayAssetsModel> yearlyDayAssetsList = <YearDayAssetsModel>[];

  List<YearDayAssetsModel> monthEndAssetsList = <YearDayAssetsModel>[];

  ///
  @override
  void initState() {
    super.initState();
    year = widget.date.split('-')[0].toInt();
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      yearlyDayAssetsList = makeYearlyDayAssetsList();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('$year 年 資産推移'),
                      const SizedBox(width: 10),

                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              if (yearlyDayAssetsList.isEmpty) {
                                return;
                              }
                              autoScrollController.scrollToIndex(
                                yearlyDayAssetsList.length - 1,
                                preferPosition: AutoScrollPosition.end,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            icon: const Icon(Icons.arrow_downward),
                          ),
                          IconButton(
                            onPressed: () {
                              if (yearlyDayAssetsList.isEmpty) {
                                return;
                              }
                              autoScrollController.scrollToIndex(
                                0,
                                preferPosition: AutoScrollPosition.begin,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            icon: const Icon(Icons.arrow_upward),
                          ),
                        ],
                      ),
                    ],
                  ),

                  IconButton(
                    tooltip: '折れ線グラフ',
                    icon: const Icon(Icons.graphic_eq),
                    onPressed: () {
                      LifetimeDialog(
                        context: context,
                        widget: YearlyAssetsGraphAlert(
                          year: year,
                          totals: yearlyDayAssetsList.map((YearDayAssetsModel e) => e.total).toList(),
                          lastYearFinalAssets: widget.lastYearFinalAssets,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Expanded(
              child: ListView.builder(
                controller: autoScrollController,
                itemCount: yearlyDayAssetsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final YearDayAssetsModel item = yearlyDayAssetsList[index];
                  final bool isToday = item.date == DateTime.now().yyyymmdd;

                  return AutoScrollTag(
                    // ignore: always_specify_types
                    key: ValueKey(index),
                    index: index,
                    controller: autoScrollController,
                    child: Column(
                      children: <Widget>[
                        if (isToday)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DottedLine(dashColor: Colors.orangeAccent, lineThickness: 2, dashGapLength: 3),
                          ),
                        _dayRow(item: item),
                      ],
                    ),
                  );
                },
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        LifetimeDialog(
                          context: context,
                          widget: MonthEndAssetsDisplayAlert(
                            date: widget.date,
                            monthEndAssetsList: monthEndAssetsList,
                            lastYearFinalAssets: widget.lastYearFinalAssets,
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('月末リスト'),
                    ),

                    const Spacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(lastAssets.toString().toCurrency()),

                        Row(
                          children: <Widget>[
                            utility.dispUpDownMark(before: 0, after: totalDiff, size: 18),
                            const SizedBox(width: 10),

                            Text(totalDiff.toString().toCurrency(), style: const TextStyle(color: Colors.orange)),
                          ],
                        ),
                      ],
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

  ///
  Widget _dayRow({required YearDayAssetsModel item}) {
    final bool isBeforeOrToday = DateTime.parse(item.date).isBeforeOrSameDate(DateTime.now());

    final Color youbiColor = utility.getYoubiColor(
      date: item.date,
      youbiStr: item.youbiStr,
      holiday: appParamState.keepHolidayList,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.25))),
      ),

      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80,
              decoration: BoxDecoration(color: youbiColor),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                    child: Text(item.mmdd, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Text(item.youbiShort, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(isBeforeOrToday ? item.total.toString().toCurrency() : '-'),
              ),
            ),

            SizedBox(
              width: 100,
              child: (isBeforeOrToday && item.totalBefore != null)
                  ? Row(
                      children: <Widget>[
                        const Spacer(),
                        SizedBox(
                          width: 90,
                          child: Row(
                            children: <Widget>[
                              utility.dispUpDownMark(before: item.totalBefore!, after: item.total, size: 18),

                              const Spacer(),

                              Text(
                                _diffString(before: item.totalBefore!, after: item.total),
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : (item.mmdd.split('/')[1] == '01')
                  ? Row(
                      children: <Widget>[
                        const Spacer(),
                        SizedBox(
                          width: 90,
                          child: Row(
                            children: <Widget>[
                              utility.dispUpDownMark(before: widget.lastYearFinalAssets, after: item.total, size: 18),

                              const Spacer(),

                              Text(
                                _diffString(before: widget.lastYearFinalAssets, after: item.total),
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  ///
  String _diffString({required int before, required int after}) {
    final int diff = after - before;
    if (diff > 0) {
      return '+${diff.toString().toCurrency()}';
    }
    return diff.toString().toCurrency();
  }

  ///
  PrevYearLastAssetsModel _getPrevYearLastValues({required int year}) {
    final DateTime start = DateTime(year - 1, 12, 31);
    final DateTime min = DateTime(year - 1);

    int lastGold = 0;
    int lastStock = 0;
    int lastToushi = 0;

    bool foundGold = false;
    bool foundStock = false;
    bool foundToushi = false;

    for (DateTime d = start; !d.isBefore(min); d = d.add(const Duration(days: -1))) {
      final String key = d.yyyymmdd;

      if (!foundGold) {
        final GoldModel? gold = appParamState.keepGoldMap[key];
        if (gold != null && gold.goldValue != '-') {
          lastGold = gold.goldValue.toString().toInt();
          foundGold = true;
        }
      }

      if (!foundStock) {
        final List<StockModel>? stockList = appParamState.keepStockMap[key];
        if (stockList != null) {
          lastStock = AssetsCalc.calcStockSum(stockList);
          foundStock = true;
        }
      }

      if (!foundToushi) {
        final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
        if (toushiList != null) {
          lastToushi = AssetsCalc.calcToushiSum(toushiList);
          foundToushi = true;
        }
      }

      if (foundGold && foundStock && foundToushi) {
        break;
      }
    }

    return PrevYearLastAssetsModel(gold: lastGold, stock: lastStock, toushi: lastToushi);
  }

  ///
  List<YearDayAssetsModel> makeYearlyDayAssetsList() {
    yearlyDayAssetsList.clear();

    monthEndAssetsList.clear();

    const double assetRate = 0.8;

    final List<YearDayAssetsModel> list = <YearDayAssetsModel>[];

    final PrevYearLastAssetsModel prev = _getPrevYearLastValues(year: year);

    int lastGoldSum = prev.gold;
    int lastStockSum = prev.stock;
    int lastToushiShintakuSum = prev.toushi;

    int lastMoneySum = 0;

    final DateTime start = DateTime(year);
    final DateTime endExclusive = DateTime(year + 1);

    int? prevTotal;

    int first = 0;
    int last = 0;

    for (DateTime d = start; d.isBefore(endExclusive); d = d.add(const Duration(days: 1))) {
      final String key = d.yyyymmdd;

      final GoldModel? gold = appParamState.keepGoldMap[key];
      if (gold != null && gold.goldValue != '-') {
        lastGoldSum = gold.goldValue.toString().toInt();
      }

      final List<StockModel>? stockList = appParamState.keepStockMap[key];
      if (stockList != null) {
        lastStockSum = AssetsCalc.calcStockSum(stockList);
      }

      final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
      if (toushiList != null) {
        lastToushiShintakuSum = AssetsCalc.calcToushiSum(toushiList);
      }

      final String moneyStr = appParamState.keepMoneyMap[key]?.sum ?? '';
      if (moneyStr.isNotEmpty) {
        lastMoneySum = AssetsCalc.calcMoney(moneyStr);
      }
      final int money = lastMoneySum;

      final int insurancePassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: d) + 102;
      final int insuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: d) + 32;
      final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

      final int gold80 = (lastGoldSum * assetRate).toInt();
      final int stock80 = (lastStockSum * assetRate).toInt();
      final int toushi80 = (lastToushiShintakuSum * assetRate).toInt();

      final int total = money + gold80 + stock80 + toushi80 + insuranceSum + nenkinKikinSum;

      final String youbiStr = d.youbiStr;
      final String mmdd = '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
      final String youbiShort = youbiStr.length >= 3 ? youbiStr.substring(0, 3) : youbiStr;

      list.add(
        YearDayAssetsModel(
          date: key,
          mmdd: mmdd,
          youbiStr: youbiStr,
          youbiShort: youbiShort,
          money: money,
          gold: gold80,
          stock: stock80,
          toushiShintaku: toushi80,
          insurance: insuranceSum,
          insurancePassedMonths: insurancePassedMonths,
          nenkinKikin: nenkinKikinSum,
          nenkinKikinPassedMonths: nenkinKikinPassedMonths,
          total: total,
          totalBefore: prevTotal,
        ),
      );

      if (d.yyyymmdd == DateTime(d.year, d.month + 1, 0).yyyymmdd) {
        monthEndAssetsList.add(
          YearDayAssetsModel(
            date: key,
            mmdd: mmdd,
            youbiStr: youbiStr,
            youbiShort: youbiShort,
            money: money,
            gold: gold80,
            stock: stock80,
            toushiShintaku: toushi80,
            insurance: insuranceSum,
            insurancePassedMonths: insurancePassedMonths,
            nenkinKikin: nenkinKikinSum,
            nenkinKikinPassedMonths: nenkinKikinPassedMonths,
            total: total,
            totalBefore: prevTotal,
          ),
        );
      }

      if (mmdd == '01/01') {
        first = widget.lastYearFinalAssets;
      }

      if (total != 0) {
        last = total;
      }

      prevTotal = total;
    }

    setState(() {
      lastAssets = last;

      totalDiff = last - first;
    });

    return list;
  }
}
