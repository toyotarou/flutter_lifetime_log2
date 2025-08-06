import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'stock_data_input_alert.dart';

class MonthlyAssetsDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyAssetsDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyAssetsDisplayAlert> createState() => _MonthlyAssetsDisplayAlertState();
}

class _MonthlyAssetsDisplayAlertState extends ConsumerState<MonthlyAssetsDisplayAlert>
    with ControllersMixin<MonthlyAssetsDisplayAlert> {
  Utility utility = Utility();

  bool todayStockExists = false;

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

    final DateTime checkStart = DateTime(2023, 01, 27);

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
            lastStockSum += element.jikaHyoukagaku.toInt();

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

      final int passedMonths = utility.elapsedMonthsByCutoff(start: checkStart, end: date) + 102;
      lastInsuranceSum = passedMonths * (55880 * 0.7).toInt();

      if (date.isBefore(DateTime.now())) {
        monthlyAssetsMap[date.yyyymmdd] = <String, int>{
          'gold': lastGoldSum,
          'stock': lastStockSum,
          'toushiShintaku': lastToushiShintakuSum,
          'insurance': lastInsuranceSum,
          'passedMonths': passedMonths,
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

      final Map<String, dynamic>? monthlyAssets = monthlyAssetsMap[date];

      final List<String> keys = <String>['gold', 'stock', 'toushiShintaku', 'insurance'];

      final List<int> items = <int>[
        if (money.isNotEmpty) int.tryParse(money) ?? 0 else 0,
        ...keys.map((String key) {
          final String value = monthlyAssets?[key]?.toString() ?? '';
          return value.isNotEmpty ? int.tryParse(value) ?? 0 : 0;
        }),
      ];

      final int total = items.fold(0, (int sum, int value) => sum + value);

      final String gold = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['gold'].toString() : '';
      final String stock = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['stock'].toString() : '';
      final String toushiShintaku = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['toushiShintaku'].toString()
          : '';
      final String insurance = (monthlyAssetsMap[date] != null) ? monthlyAssetsMap[date]!['insurance'].toString() : '';

      final bool beforeDate = DateTime(
        date.split('-')[0].toInt(),
        date.split('-')[1].toInt(),
        date.split('-')[2].toInt(),
      ).isBefore(DateTime.now());

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      final String passedMonths = (monthlyAssetsMap[date] != null)
          ? monthlyAssetsMap[date]!['passedMonths'].toString()
          : '';

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(10),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList),
                ),

                padding: const EdgeInsets.all(5),

                height: context.screenSize.height * 0.12,

                child: Column(
                  children: <Widget>[
                    Text(i.toString().padLeft(2, '0')),
                    const SizedBox(height: 10),
                    Text(youbi.substring(0, 3), style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(color: beforeDate ? Colors.white : Colors.grey.withValues(alpha: 0.6), fontSize: 12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Text(beforeDate ? total.toString().toCurrency() : '-', style: const TextStyle(fontSize: 24)),

                          if (date == DateTime.now().yyyymmdd)
                            const Text('TODAY', style: TextStyle(color: Colors.orangeAccent))
                          else
                            const Text(''),
                        ],
                      ),

                      priceDisplayParts(
                        date: date,
                        beforeDate: beforeDate,
                        title: 'money',
                        price: money,
                        buttonDisp: false,
                      ),

                      priceDisplayParts(
                        date: date,
                        beforeDate: beforeDate,
                        title: 'stock',
                        price: stock,
                        buttonDisp: true,
                      ),
                      priceDisplayParts(
                        date: date,
                        beforeDate: beforeDate,
                        title: 'toushiShintaku',
                        price: toushiShintaku,
                        buttonDisp: false,
                      ),

                      priceDisplayParts(
                        date: date,
                        beforeDate: beforeDate,
                        title: 'gold',
                        price: gold,
                        buttonDisp: false,
                      ),

                      priceDisplayParts(
                        date: date,
                        beforeDate: beforeDate,
                        title: beforeDate ? 'insurance ($passedMonths)' : 'insurance',
                        price: insurance,
                        buttonDisp: false,
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
  Widget priceDisplayParts({
    required String date,

    required bool beforeDate,
    required String title,
    required String price,
    required bool buttonDisp,
  }) {
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
              if (buttonDisp && youbi != 'Saturday' && youbi != 'Sunday' && beforeDate)
                stockInputButton
              else
                const Icon(Icons.square_outlined, color: Colors.transparent),

              const SizedBox(width: 10),

              Text(title),
            ],
          ),
          Text(beforeDate ? price.toCurrency() : ''),
        ],
      ),
    );
  }
}
