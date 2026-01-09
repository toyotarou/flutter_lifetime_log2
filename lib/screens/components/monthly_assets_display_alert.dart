import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/assets_calc.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_dialog.dart';
import 'assets_detail_graph_alert.dart';
import 'monthly_assets_graph_alert.dart';
import 'stock_data_input_alert.dart';
import 'toushi_shintaku_data_update_alert.dart';
import 'yearly_assets_display_alert.dart';

class MonthlyAssetsDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyAssetsDisplayAlert> createState() => _MonthlyAssetsDisplayAlertState();
}

class _MonthlyAssetsDisplayAlertState extends ConsumerState<MonthlyAssetsDisplayAlert>
    with ControllersMixin<MonthlyAssetsDisplayAlert> {
  static const int _itemCount = 100000;
  static const int _initialIndex = _itemCount ~/ 2;

  late final DateTime _baseMonth;
  int currentIndex = _initialIndex;

  Utility utility = Utility();

  bool todayStockExists = false;
  bool todayToushiShintakuRelationalIdBlankExists = false;

  final Map<int, int> monthlyGraphAssetsMap = <int, int>{};

  final AutoScrollController autoScrollController = AutoScrollController();
  final List<Widget> monthlyAssetsList = <Widget>[];

  ///
  @override
  void initState() {
    super.initState();

    _baseMonth = DateTime.parse('${widget.yearmonth}-01');
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CarouselSlider.builder(
        itemCount: _itemCount,
        initialPage: _initialIndex,
        slideTransform: const CubeTransform(),
        onSlideChanged: (int index) => setState(() => currentIndex = index),
        slideBuilder: (int index) => makeMonthlyWorktimeSlide(index),
      ),
    );
  }

  ///
  Widget makeMonthlyWorktimeSlide(int index) {
    final DateTime genDate = monthForIndex(index: index, baseMonth: _baseMonth);

    final bool hasData = appParamState.keepMoneyMap.containsKey(
      '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}-01',
    );

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
                  Stack(
                    children: <Widget>[
                      Positioned(top: 20, right: 5, left: 5, child: Center(child: Text(genDate.yyyymm))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  autoScrollController.scrollToIndex(
                                    monthlyAssetsList.length,
                                    preferPosition: AutoScrollPosition.end,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                icon: const Icon(Icons.arrow_downward),
                              ),
                              IconButton(
                                onPressed: () {
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
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  LifetimeDialog(
                                    context: context,
                                    widget: YearlyAssetsDisplayAlert(
                                      date: '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}-01',
                                    ),
                                  );
                                },
                                child: const Icon(Icons.calendar_view_month),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (DateTime.now().year == genDate.year &&
                                      DateTime.now().month == genDate.month &&
                                      DateTime.now().day == 1) {
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
                                      yearmonth: genDate.yyyymm,
                                      monthlyGraphAssetsMap: monthlyGraphAssetsMap,
                                    ),
                                  );
                                },
                                child: const Icon(Icons.graphic_eq),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  if (hasData) ...<Widget>[
                    Expanded(child: displayMonthlyAssetsList(genDate: genDate)),
                  ] else ...<Widget>[
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayMonthlyAssetsList({required DateTime genDate}) {
    monthlyAssetsList.clear();
    monthlyGraphAssetsMap.clear();

    final Map<String, Map<String, int>> monthlyAssetsMap = _buildMonthlyAssetsMap(genDate: genDate);

    final int endDay = DateTime(genDate.year, genDate.month + 1, 0).day;

    int lastMoneySum = 0;

    for (int day = 1; day <= endDay; day++) {
      final String date = '${genDate.yyyymm}-${day.toString().padLeft(2, '0')}';

      final bool isBeforeDate = DateTime.parse(date).isBeforeOrSameDate(DateTime.now());

      final DateTime beforeDate = DateTime(
        date.split('-')[0].toInt(),
        date.split('-')[1].toInt(),
        date.split('-')[2].toInt() - 1,
      );

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      final Map<String, int>? monthlyAssets = monthlyAssetsMap[date];

      final String moneyStrRaw = appParamState.keepMoneyMap[date]?.sum ?? '';
      if (moneyStrRaw.isNotEmpty) {
        lastMoneySum = int.tryParse(moneyStrRaw) ?? lastMoneySum;
      }
      final String moneyForTotal = lastMoneySum.toString();

      final Map<String, int>? monthlyAssetsBefore = monthlyAssetsMap[beforeDate.yyyymmdd];

      final String moneyBeforeRaw = appParamState.keepMoneyMap[beforeDate.yyyymmdd]?.sum ?? '';
      final int moneyBeforeValue = moneyBeforeRaw.isNotEmpty ? (int.tryParse(moneyBeforeRaw) ?? 0) : lastMoneySum;
      final String moneyBeforeForTotal = moneyBeforeValue.toString();

      const List<String> keys = <String>['gold', 'stock', 'toushiShintaku', 'insurance', 'nenkinKikin'];

      final int total = AssetsCalc.calcTotalAssets(money: moneyForTotal, assets: monthlyAssets, keys: keys);

      final int totalBefore = AssetsCalc.calcTotalAssets(
        money: moneyBeforeForTotal,
        assets: monthlyAssetsBefore,
        keys: keys,
      );

      if (isBeforeDate) {
        monthlyGraphAssetsMap[day] = total;
      }

      Map<String, int>? beforeData = monthlyAssetsMap[beforeDate.yyyymmdd];
      beforeData ??= <String, int>{};
      beforeData['money'] = moneyBeforeValue;

      // today の点線
      if (date == DateTime.now().yyyymmdd) {
        monthlyAssetsList.add(const DottedLine(dashColor: Colors.orangeAccent, lineThickness: 2, dashGapLength: 3));
      }

      monthlyAssetsList.add(
        AutoScrollTag(
          // ignore: always_specify_types
          key: ValueKey(day),
          index: day,
          controller: autoScrollController,
          child: _buildDayItem(
            day: day,
            date: date,
            youbi: youbi,
            isBeforeDate: isBeforeDate,
            total: total,
            totalBefore: totalBefore,
            beforeData: beforeData,
            monthlyAssets: monthlyAssets,
          ),
        ),
      );
    }

    return CustomScrollView(
      controller: autoScrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => monthlyAssetsList[index],
            childCount: monthlyAssetsList.length,
          ),
        ),
      ],
    );
  }

  ///
  Map<String, Map<String, int>> _buildMonthlyAssetsMap({required DateTime genDate}) {
    final Map<String, Map<String, int>> monthlyAssetsMap = <String, Map<String, int>>{};

    final DateTime tenDaysAgoFromBeforeMonthEndDay = DateTime(
      genDate.year,
      genDate.month,
      0,
    ).add(const Duration(days: 10 * -1));

    int lastGoldSum = 0;
    int lastStockSum = 0;
    int lastToushiShintakuSum = 0;
    int lastInsuranceSum = 0;

    for (int i = 0; i < 50; i++) {
      final DateTime date = tenDaysAgoFromBeforeMonthEndDay.add(Duration(days: i));
      final String key = date.yyyymmdd;

      final GoldModel? gold = appParamState.keepGoldMap[key];
      if (gold != null && gold.goldValue != '-') {
        lastGoldSum = gold.goldValue.toString().toInt();
      }

      final List<StockModel>? stockList = appParamState.keepStockMap[key];
      if (stockList != null) {
        lastStockSum = AssetsCalc.calcStockSum(stockList);
        if (key == DateTime.now().yyyymmdd && lastStockSum > 0) {
          todayStockExists = true;
        }
      }

      final List<ToushiShintakuModel>? toushiList = appParamState.keepToushiShintakuMap[key];
      if (toushiList != null) {
        lastToushiShintakuSum = AssetsCalc.calcToushiSum(
          toushiList,
          onRelationalIdBlankFound: () {
            if (key == DateTime.now().yyyymmdd) {
              todayToushiShintakuRelationalIdBlankExists = true;
            }
          },
        );
      }

      final int insurancePassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: date) + 102;
      lastInsuranceSum = insurancePassedMonths * (55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
      final int nenkinKikinSum = nenkinKikinPassedMonths * (26625 * 0.7).toInt();

      monthlyAssetsMap[key] = <String, int>{
        'gold': (lastGoldSum * 0.8).toInt(),
        'stock': (lastStockSum * 0.8).toInt(),
        'toushiShintaku': (lastToushiShintakuSum * 0.8).toInt(),
        'insurance': lastInsuranceSum,
        'insurancePassedMonths': insurancePassedMonths,
        'nenkinKikin': nenkinKikinSum,
        'nenkinKikinPassedMonths': nenkinKikinPassedMonths,
      };
    }

    return monthlyAssetsMap;
  }

  ///
  Widget _buildDayItem({
    required int day,
    required String date,
    required String youbi,
    required bool isBeforeDate,
    required int total,
    required int totalBefore,
    required Map<String, int>? beforeData,
    required Map<String, int>? monthlyAssets,
  }) {
    final String money = appParamState.keepMoneyMap[date]?.sum ?? '';

    final String gold = (monthlyAssets != null) ? monthlyAssets['gold'].toString() : '';
    final String stock = (monthlyAssets != null) ? monthlyAssets['stock'].toString() : '';
    final String toushiShintaku = (monthlyAssets != null) ? monthlyAssets['toushiShintaku'].toString() : '';
    final String insurance = (monthlyAssets != null) ? monthlyAssets['insurance'].toString() : '';
    final String nenkinKikin = (monthlyAssets != null) ? monthlyAssets['nenkinKikin'].toString() : '';

    final String insurancePassedMonths = (monthlyAssets != null)
        ? monthlyAssets['insurancePassedMonths'].toString()
        : '';
    final String nenkinKikinPassedMonths = (monthlyAssets != null)
        ? monthlyAssets['nenkinKikinPassedMonths'].toString()
        : '';

    return Container(
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
                Text(day.toString().padLeft(2, '0')),
                const SizedBox(height: 10),
                Text(youbi.substring(0, 3), style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(color: isBeforeDate ? Colors.white : Colors.grey.withValues(alpha: 0.6), fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        right: 5,
                        child: Text(date, style: const TextStyle(color: Colors.grey)),
                      ),

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
                    buttonDisp: true,
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
    );
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
    final String youbi = DateTime.parse(date).youbiStr;

    final GestureDetector stockInputButton = GestureDetector(
      onTap: () => LifetimeDialog(
        context: context,
        widget: StockDataInputAlert(date: date),
      ),
      child: Icon(
        Icons.input,
        color: (date == DateTime.now().yyyymmdd && !todayStockExists)
            ? Colors.greenAccent.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.3),
      ),
    );

    final GestureDetector toushiShintakuUpdateButton = GestureDetector(
      onTap: () {
        if (appParamState.keepToushiShintakuMap[date] == null) {
          // ignore: always_specify_types
          Future.delayed(
            Duration.zero,
            // ignore: use_build_context_synchronously
            () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
          );
          return;
        }

        MapEntry<String, List<ToushiShintakuModel>>? referenceDataMapEntry;

        List<int> idList = <int>[];
        List<int> relationalIdList = <int>[];

        final List<MapEntry<String, List<ToushiShintakuModel>>> toushiShintakuMapSortedByKey =
            appParamState.keepToushiShintakuMap.entries.toList()..sort(
              (MapEntry<String, List<ToushiShintakuModel>> a, MapEntry<String, List<ToushiShintakuModel>> b) =>
                  a.key.compareTo(b.key),
            );

        for (int j = 0; j < 7; j++) {
          idList = <int>[];
          relationalIdList = <int>[];

          final int index = toushiShintakuMapSortedByKey.length - (j + 1);
          final MapEntry<String, List<ToushiShintakuModel>> reverseDayData = toushiShintakuMapSortedByKey[index];

          reverseDayData.value.sort((ToushiShintakuModel a, ToushiShintakuModel b) => a.id.compareTo(b.id));

          for (int i = 0; i < reverseDayData.value.length; i++) {
            idList.add(reverseDayData.value[i].id);
            if (reverseDayData.value[i].relationalId != 0) {
              relationalIdList.add(reverseDayData.value[i].relationalId);
            }
          }

          if (idList.length == relationalIdList.length) {
            referenceDataMapEntry = reverseDayData;
            break;
          }
        }

        final Map<String, List<ToushiShintakuModel>> referenceNameAndToushiShintakuModelListMap =
            <String, List<ToushiShintakuModel>>{};
        referenceDataMapEntry?.value.forEach((ToushiShintakuModel element) {
          (referenceNameAndToushiShintakuModelListMap[element.name] ??= <ToushiShintakuModel>[]).add(element);
        });

        List<ToushiShintakuModel> todayDataList = <ToushiShintakuModel>[];
        if (appParamState.keepToushiShintakuMap[date] != null) {
          todayDataList = appParamState.keepToushiShintakuMap[date]!
            ..sort((ToushiShintakuModel a, ToushiShintakuModel b) => a.id.compareTo(b.id));
        }

        LifetimeDialog(
          context: context,
          widget: ToushiShintakuDataUpdateAlert(
            date: date,
            todayDataList: todayDataList,
            referenceDataMapEntry: referenceDataMapEntry,
            referenceNameAndToushiShintakuModelListMap: referenceNameAndToushiShintakuModelListMap,
          ),
          executeFunctionWhenDialogClose: true,
          ref: ref,
          from: 'ToushiShintakuDataUpdateAlert',
        );
      },
      child: Icon(
        Icons.input,
        color: (date == DateTime.now().yyyymmdd && todayToushiShintakuRelationalIdBlankExists)
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
              if (buttonDisp && youbi != 'Saturday' && youbi != 'Sunday' && isBeforeDate && exTitle[0] == 'stock')
                stockInputButton
              else if (buttonDisp &&
                  youbi != 'Saturday' &&
                  youbi != 'Sunday' &&
                  isBeforeDate &&
                  exTitle[0] == 'toushiShintaku')
                toushiShintakuUpdateButton
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
                    appParamNotifier.setSelectedToushiGraphYear(year: '');

                    LifetimeDialog(
                      context: context,
                      widget: AssetsDetailGraphAlert(date: date, title: title),
                    );
                  },
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isBeforeDate ? Colors.white : Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
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
