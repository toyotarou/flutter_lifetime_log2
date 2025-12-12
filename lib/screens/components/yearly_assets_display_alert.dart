import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/prev_year_last_assets_model.dart';
import '../../models/common/year_day_assets_model.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/utility.dart';
import 'yearly_assets_line_graph_alert.dart';

class YearlyAssetsDisplayAlert extends ConsumerStatefulWidget {
  const YearlyAssetsDisplayAlert({
    super.key,
    required this.date,
    required this.insuranceDataList,
    required this.nenkinKikinDataList,
  });

  final String date;

  final List<Map<String, String>> insuranceDataList;
  final List<Map<String, String>> nenkinKikinDataList;

  @override
  ConsumerState<YearlyAssetsDisplayAlert> createState() => _YearlyAssetsDisplayPageState();
}

class _YearlyAssetsDisplayPageState extends ConsumerState<YearlyAssetsDisplayAlert>
    with ControllersMixin<YearlyAssetsDisplayAlert> {
  final Utility utility = Utility();

  late final int year;

  // ▼ 追加：上下ジャンプ用
  final AutoScrollController autoScrollController = AutoScrollController();

  ///
  @override
  void initState() {
    super.initState();
    year = widget.date.split('-')[0].toInt();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final List<YearDayAssetsModel> yearlyList = _buildYearlyDayAssetsList(year: year);

    return Scaffold(
      appBar: AppBar(
        title: Text('$year 年 資産推移'),
        actions: <Widget>[
          // ▼ 追加：monthly_assets_display_alert.dart と同等の上下ジャンプ
          Row(
            children: <Widget>[
              IconButton(
                tooltip: '折れ線グラフ',
                icon: const Icon(Icons.graphic_eq),
                onPressed: () {
                  Navigator.of(context).push(
                    // ignore: inference_failure_on_instance_creation, always_specify_types
                    MaterialPageRoute(
                      builder: (_) =>
                          YearlyAssetsLineGraphAlert(year: year, totals: yearlyList.map((YearDayAssetsModel e) => e.total).toList()),
                    ),
                  );
                },
              ),

              IconButton(
                onPressed: () {
                  // 最下部へ（最終index）
                  if (yearlyList.isEmpty) {
                    return;
                  }
                  autoScrollController.scrollToIndex(
                    yearlyList.length - 1,
                    preferPosition: AutoScrollPosition.end,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                icon: const Icon(Icons.arrow_downward),
              ),
              IconButton(
                onPressed: () {
                  // 最上部へ
                  if (yearlyList.isEmpty) {
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

      body: SafeArea(
        child: ListView.builder(
          controller: autoScrollController, // ▼ 追加
          itemCount: yearlyList.length,
          itemBuilder: (BuildContext context, int index) {
            final YearDayAssetsModel item = yearlyList[index];
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 日付ブロック
          Container(
            width: 60,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: youbiColor),
            child: Column(
              children: <Widget>[
                Text(item.mmdd, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(item.youbiShort, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // 本文
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(color: isBeforeOrToday ? Colors.black87 : Colors.grey, fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // total + 前日比
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            isBeforeOrToday ? item.total.toString().toCurrency() : '-',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          if (isBeforeOrToday && item.totalBefore != null) ...<Widget>[
                            _dispUpDownMark(before: item.totalBefore!, after: item.total, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _diffString(before: item.totalBefore!, after: item.total),
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ],
                      ),
                      if (item.date == DateTime.now().yyyymmdd)
                        const Text('TODAY', style: TextStyle(color: Colors.orangeAccent))
                      else
                        const SizedBox.shrink(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 内訳
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: <Widget>[
                      _miniChip(label: 'money', value: item.money),
                      _miniChip(label: 'gold(0.8)', value: item.gold),
                      _miniChip(label: 'stock(0.8)', value: item.stock),
                      _miniChip(label: 'toushi(0.8)', value: item.toushiShintaku),
                      _miniChip(label: 'insurance', value: item.insurance),
                      _miniChip(label: 'nenkinKikin', value: item.nenkinKikin),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 何ヶ月分かも表示（任意）
                  Text(
                    'insurance months: ${item.insurancePassedMonths}, nenkinKikin months: ${item.nenkinKikinPassedMonths}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _miniChip({required String label, required int value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text('$label: ${value.toString().toCurrency()}'),
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
          int sum = 0;
          for (final StockModel e in stockList) {
            if (e.jikaHyoukagaku != '-') {
              sum += e.jikaHyoukagaku.replaceAll(',', '').toInt();
            }
          }
          lastStock = sum;
          foundStock = true;
        }
      }

      if (!foundToushi) {
        final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
        if (toushiList != null) {
          int sum = 0;
          for (final ToushiShintakuModel e in toushiList) {
            if (e.jikaHyoukagaku != '-') {
              sum += e.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
            }
          }
          lastToushi = sum;
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
  int countPaidUpTo({required List<Map<String, dynamic>> data, required DateTime date, String dateKey = 'date'}) {
    final DateTime target = DateTime(date.year, date.month, date.day);

    final List<DateTime> dates =
        data
            .where((Map<String, dynamic> e) => e[dateKey] != null)
            .map((Map<String, dynamic> e) => DateTime.parse(e[dateKey] as String))
            .map((DateTime d) => DateTime(d.year, d.month, d.day))
            .toList()
          ..sort();

    return dates.where((DateTime d) => !d.isAfter(target)).length;
  }

  ///
  List<YearDayAssetsModel> _buildYearlyDayAssetsList({required int year}) {
    const double assetRate = 0.8;

    final List<YearDayAssetsModel> list = <YearDayAssetsModel>[];

    final PrevYearLastAssetsModel prev = _getPrevYearLastValues(year: year);

    int lastGoldSum = prev.gold;
    int lastStockSum = prev.stock;
    int lastToushiShintakuSum = prev.toushi;

    final DateTime start = DateTime(year);
    final DateTime endExclusive = DateTime(year + 1);

    int? prevTotal;

    for (DateTime d = start; d.isBefore(endExclusive); d = d.add(const Duration(days: 1))) {
      final String key = d.yyyymmdd;

      final GoldModel? gold = appParamState.keepGoldMap[key];
      if (gold != null && gold.goldValue != '-') {
        lastGoldSum = gold.goldValue.toString().toInt();
      }

      final List<StockModel>? stockList = appParamState.keepStockMap[key];
      if (stockList != null) {
        int sum = 0;
        for (final StockModel e in stockList) {
          if (e.jikaHyoukagaku != '-') {
            sum += e.jikaHyoukagaku.replaceAll(',', '').toInt();
          }
        }
        lastStockSum = sum;
      }

      final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
      if (toushiList != null) {
        int sum = 0;
        for (final ToushiShintakuModel e in toushiList) {
          if (e.jikaHyoukagaku != '-') {
            sum += e.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
          }
        }
        lastToushiShintakuSum = sum;
      }

      final String moneyStr = appParamState.keepMoneyMap[key]?.sum ?? '';
      final int money = moneyStr.isNotEmpty ? (int.tryParse(moneyStr) ?? 0) : 0;

      final int insurancePassedMonths = countPaidUpTo(data: widget.insuranceDataList, date: d) + 102;
      final int insuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths = countPaidUpTo(data: widget.nenkinKikinDataList, date: d) + 32;
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

      prevTotal = total;
    }

    return list;
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
