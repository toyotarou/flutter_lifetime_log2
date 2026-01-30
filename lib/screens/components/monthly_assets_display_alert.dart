import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final AutoScrollController autoScrollController = AutoScrollController();
  final List<Widget> monthlyAssetsList = <Widget>[];

  ///
  @override
  void initState() {
    super.initState();

    final DateTime? parsed = DateTime.tryParse('${widget.yearmonth}-01');
    _baseMonth = parsed ?? DateTime(DateTime.now().year, DateTime.now().month);
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
            slideBuilder: (int index) => makeMonthlyWorktimeSlide(index),
          ),
        ],
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
                                  if (monthlyAssetsList.isNotEmpty) {
                                    autoScrollController.scrollToIndex(
                                      monthlyAssetsList.length - 1,
                                      preferPosition: AutoScrollPosition.end,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                  }
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
                                  final DateTime lastYearEnd = DateTime(genDate.year, 1, 0);

                                  final int lastYearFinalAssets = _calcTotalAssetsAtDate(lastYearEnd);

                                  LifetimeDialog(
                                    context: context,
                                    widget: YearlyAssetsDisplayAlert(
                                      date: '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}-01',
                                      lastYearFinalAssets: lastYearFinalAssets,
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

                                  final DateTime lastMonthEnd = DateTime(genDate.year, genDate.month, 0);

                                  final int lastMonthFinalAssets = _calcTotalAssetsAtDate(lastMonthEnd);

                                  LifetimeDialog(
                                    context: context,
                                    widget: MonthlyAssetsGraphAlert(
                                      yearmonth: genDate.yyyymm,

                                      monthlyGraphAssetsMap: const <int, int>{},
                                      lastMonthFinalAssets: lastMonthFinalAssets,
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

    final Map<String, Map<String, int>> monthlyAssetsMap = _buildMonthlyAssetsMap(genDate: genDate);

    final int endDay = DateTime(genDate.year, genDate.month + 1, 0).day;

    int lastMoneySum = 0;

    for (int day = 1; day <= endDay; day++) {
      final String dateStr = '${genDate.yyyymm}-${day.toString().padLeft(2, '0')}';
      final DateTime? date = DateTime.tryParse(dateStr);
      if (date == null) {
        continue;
      }

      final bool isBeforeDate = date.isBeforeOrSameDate(DateTime.now());

      final DateTime beforeDate = date.subtract(const Duration(days: 1));
      final String beforeDateStr = beforeDate.yyyymmdd;

      final String youbi = date.youbiStr;

      final Map<String, int>? monthlyAssets = monthlyAssetsMap[dateStr];

      final String? moneyStrRaw = appParamState.keepMoneyMap[dateStr]?.sum;
      if (moneyStrRaw != null && moneyStrRaw.isNotEmpty) {
        lastMoneySum = moneyStrRaw.toInt();
      }

      final Map<String, int>? monthlyAssetsBefore = monthlyAssetsMap[beforeDateStr];

      final String? moneyBeforeRaw = appParamState.keepMoneyMap[beforeDateStr]?.sum;
      final int moneyBeforeValue = (moneyBeforeRaw != null && moneyBeforeRaw.isNotEmpty)
          ? moneyBeforeRaw.toInt()
          : lastMoneySum;

      final int total = isBeforeDate ? _calcTotalAssetsAtDate(date) : 0;
      final int totalBefore = isBeforeDate ? _calcTotalAssetsAtDate(beforeDate) : 0;

      final Map<String, int> beforeData = monthlyAssetsBefore ?? <String, int>{};
      beforeData['money'] = moneyBeforeValue;

      if (dateStr == DateTime.now().yyyymmdd) {
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
            date: dateStr,
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
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < 0 || index >= monthlyAssetsList.length) {
              return const SizedBox.shrink();
            }
            return monthlyAssetsList[index];
          }, childCount: monthlyAssetsList.length),
        ),
      ],
    );
  }

  ///
  Map<String, Map<String, int>> _buildMonthlyAssetsMap({required DateTime genDate}) {
    todayStockExists = false;
    todayToushiShintakuRelationalIdBlankExists = false;

    final Map<String, Map<String, int>> monthlyAssetsMap = <String, Map<String, int>>{};

    DateTime start = DateTime(genDate.year, genDate.month).subtract(const Duration(days: 10));

    final DateTime prevYearEndMinus10 = DateTime(genDate.year - 1, 12, 31).subtract(const Duration(days: 10));
    if (prevYearEndMinus10.isBefore(start)) {
      start = prevYearEndMinus10;
    }

    final DateTime end = DateTime(genDate.year, genDate.month + 1, 0).add(const Duration(days: 10));

    final int days = end.difference(start).inDays + 1;

    int lastGoldSum = 0;
    int lastStockSum = 0;
    int lastToushiShintakuSum = 0;
    int lastInsuranceSum = 0;

    for (int i = 0; i < days; i++) {
      final DateTime date = start.add(Duration(days: i));
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
      lastInsuranceSum = (insurancePassedMonths * 55880 * 0.7).toInt();

      final int nenkinKikinPassedMonths =
          AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
      final int nenkinKikinSum = (nenkinKikinPassedMonths * 26625 * 0.7).toInt();

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
  int _calcTotalAssetsAtDate(DateTime date) {
    final int lastGoldSum = _findLastValidGoldValue(date);
    final int lastStockSum = _findLastValidStockSum(date);
    final int lastToushiSum = _findLastValidToushiSum(date);
    final int lastMoneySum = _findLastValidMoneySum(date);

    final int insurancePassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepInsuranceDataList, date: date) + 102;
    final int insuranceSum = (insurancePassedMonths * 55880 * 0.7).toInt();

    final int nenkinKikinPassedMonths =
        AssetsCalc.countPaidUpTo(data: appParamState.keepNenkinKikinDataList, date: date) + 32;
    final int nenkinKikinSum = (nenkinKikinPassedMonths * 26625 * 0.7).toInt();

    const double assetRate = 0.8;

    return lastMoneySum +
        (lastGoldSum * assetRate).toInt() +
        (lastStockSum * assetRate).toInt() +
        (lastToushiSum * assetRate).toInt() +
        insuranceSum +
        nenkinKikinSum;
  }

  ///
  int _findLastValidGoldValue(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final GoldModel? model = appParamState.keepGoldMap[key];
      if (model != null) {
        final dynamic val = model.goldValue;
        if (val != null && val.toString() != '-') {
          return val.toString().toInt();
        }
      }
    }
    return 0;
  }

  ///
  int _findLastValidStockSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<StockModel>? list = appParamState.keepStockMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcStockSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidToushiSum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final List<ToushiShintakuModel>? list = appParamState.keepToushiShintakuMap[key];
      if (list != null && list.isNotEmpty) {
        return AssetsCalc.calcToushiSum(list);
      }
    }
    return 0;
  }

  ///
  int _findLastValidMoneySum(DateTime date) {
    for (int i = 0; i < 366; i++) {
      final String key = date.subtract(Duration(days: i)).yyyymmdd;
      final String? sum = appParamState.keepMoneyMap[key]?.sum;
      if (sum != null && sum.isNotEmpty) {
        return sum.toInt();
      }
    }
    return 0;
  }

  ///
  Widget _buildDayItem({
    required int day,
    required String date,
    required String youbi,
    required bool isBeforeDate,
    required int total,
    required int totalBefore,
    required Map<String, int> beforeData,
    required Map<String, int>? monthlyAssets,
  }) {
    final String money = appParamState.keepMoneyMap[date]?.sum ?? '';

    final String gold = monthlyAssets?['gold']?.toString() ?? '';
    final String stock = monthlyAssets?['stock']?.toString() ?? '';
    final String toushiShintaku = monthlyAssets?['toushiShintaku']?.toString() ?? '';
    final String insurance = monthlyAssets?['insurance']?.toString() ?? '';
    final String nenkinKikin = monthlyAssets?['nenkinKikin']?.toString() ?? '';

    final String insurancePassedMonths = monthlyAssets?['insurancePassedMonths']?.toString() ?? '';
    final String nenkinKikinPassedMonths = monthlyAssets?['nenkinKikinPassedMonths']?.toString() ?? '';

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
                                utility.dispUpDownMark(before: totalBefore, after: total, size: 24),
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
    final String youbi = DateTime.tryParse(date)?.youbiStr ?? '';

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

        final List<MapEntry<String, List<ToushiShintakuModel>>> toushiShintakuMapSortedByKey =
            appParamState.keepToushiShintakuMap.entries.toList()..sort(
              (MapEntry<String, List<ToushiShintakuModel>> a, MapEntry<String, List<ToushiShintakuModel>> b) =>
                  a.key.compareTo(b.key),
            );

        for (int j = 0; j < 7; j++) {
          final int index = toushiShintakuMapSortedByKey.length - (j + 1);
          if (index < 0 || index >= toushiShintakuMapSortedByKey.length) {
            continue;
          }

          final MapEntry<String, List<ToushiShintakuModel>> reverseDayData = toushiShintakuMapSortedByKey[index];

          final List<ToushiShintakuModel> sortedData = List<ToushiShintakuModel>.from(reverseDayData.value)
            ..sort((ToushiShintakuModel a, ToushiShintakuModel b) => a.id.compareTo(b.id));

          bool allRelationalIdExists = true;
          for (final ToushiShintakuModel element in sortedData) {
            if (element.relationalId == 0) {
              allRelationalIdExists = false;
              break;
            }
          }

          if (allRelationalIdExists && sortedData.isNotEmpty) {
            // ignore: always_specify_types
            referenceDataMapEntry = MapEntry(reverseDayData.key, sortedData);
            break;
          }
        }

        final Map<String, List<ToushiShintakuModel>> referenceNameAndToushiShintakuModelListMap =
            <String, List<ToushiShintakuModel>>{};
        referenceDataMapEntry?.value.forEach((ToushiShintakuModel element) {
          (referenceNameAndToushiShintakuModelListMap[element.name] ??= <ToushiShintakuModel>[]).add(element);
        });

        List<ToushiShintakuModel> todayDataList = <ToushiShintakuModel>[];
        final List<ToushiShintakuModel>? keepData = appParamState.keepToushiShintakuMap[date];
        if (keepData != null) {
          todayDataList = List<ToushiShintakuModel>.from(keepData)
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

    final String keyForBefore = exTitle[0].trim();
    final int beforeValue = beforeData?[keyForBefore] ?? 0;
    final int currentPrice = price.toInt();

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
                          if ((beforeValue - currentPrice) < 0) ...<Widget>[
                            const Text('+', style: TextStyle(color: Colors.yellowAccent)),
                          ],
                          Text(
                            ((beforeValue - currentPrice) * -1).toString().toCurrency(),
                            style: const TextStyle(fontSize: 10, color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                if (beforeData != null) ...<Widget>[
                  const SizedBox(width: 5),
                  utility.dispUpDownMark(before: beforeValue, after: currentPrice, size: 12),
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
}
