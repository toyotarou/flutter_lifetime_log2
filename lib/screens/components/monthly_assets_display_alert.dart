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

      if (date.isBefore(DateTime.now())) {
        monthlyAssetsMap[date.yyyymmdd] = <String, int>{
          'gold': lastGoldSum,
          'stock': lastStockSum,
          'toushiShintaku': lastToushiShintakuSum,
          'insurance': lastInsuranceSum,
        };
      }

      if (appParamState.keepGoldMap[date.yyyymmdd] != null &&
          appParamState.keepGoldMap[date.yyyymmdd]!.goldValue != '-') {
        lastGoldSum = appParamState.keepGoldMap[date.yyyymmdd]!.goldValue.toString().toInt();
      }

      if (appParamState.keepStockMap[date.yyyymmdd] != null) {
        lastStockSum = 0;
        for (final StockModel element in appParamState.keepStockMap[date.yyyymmdd]!) {
          if (element.jikaHyoukagaku != '-') {
            lastStockSum += element.jikaHyoukagaku.toInt();
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

      final int elapsedMonths = utility.elapsedMonthsByCutoff(start: checkStart, end: date) + 102;
      lastInsuranceSum = elapsedMonths * (55880 * 0.7).toInt();
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

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 20),

              Row(
                children: <Widget>[
                  Text(i.toString().padLeft(2, '0')),

                  IconButton(
                    onPressed: () {
                      LifetimeDialog(
                        context: context,
                        widget: StockDataInputAlert(date: date),
                      );
                    },
                    icon: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(beforeDate ? total.toString().toCurrency() : '-', style: const TextStyle(fontSize: 24)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[const Text('money'), Text(beforeDate ? money.toCurrency() : '')],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[const Text('gold'), Text(beforeDate ? gold.toCurrency() : '')],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[const Text('stock'), Text(beforeDate ? stock.toCurrency() : '')],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('toushiShintaku'),
                        Text(beforeDate ? toushiShintaku.toCurrency() : ''),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[const Text('insurance'), Text(beforeDate ? insurance.toCurrency() : '')],
                    ),
                  ],
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
}
