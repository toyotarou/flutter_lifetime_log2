import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
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

    final int endDay = DateTime(
      widget.yearmonth.split('-')[0].toInt(),
      widget.yearmonth.split('-')[1].toInt() + 1,
      0,
    ).day;

    for (int i = 1; i <= endDay; i++) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      // ignore: always_specify_types
      final goldSum = (appParamState.keepGoldMap[date] != null && appParamState.keepGoldMap[date]!.goldValue != '-')
          ? appParamState.keepGoldMap[date]!.goldValue
          : 0;

      int stockSum = 0;
      appParamState.keepStockMap[date]?.forEach((StockModel element) {
        if (element.jikaHyoukagaku != '-') {
          stockSum += element.jikaHyoukagaku.toInt();
        }
      });

      int toushiShintakuSum = 0;
      appParamState.keepToushiShintakuMap[date]?.forEach((ToushiShintakuModel element) {
        if (element.jikaHyoukagaku != '-') {
          toushiShintakuSum += element.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
        }
      });

      list.add(
        Row(
          children: <Widget>[
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[const Text('gold'), Text(goldSum.toString().toCurrency())],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[const Text('stock'), Text(stockSum.toString().toCurrency())],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[const Text('toushi_shintaku'), Text(toushiShintakuSum.toString().toCurrency())],
                  ),
                ],
              ),
            ),
          ],
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
