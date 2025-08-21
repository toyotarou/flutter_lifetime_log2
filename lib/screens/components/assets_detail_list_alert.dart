import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';

class AssetsDetailListAlert extends ConsumerStatefulWidget {
  const AssetsDetailListAlert({super.key, required this.title, required this.item, required this.name});

  final String title;
  final String item;
  final String name;

  @override
  ConsumerState<AssetsDetailListAlert> createState() => _AssetsDetailListAlertState();
}

class _AssetsDetailListAlertState extends ConsumerState<AssetsDetailListAlert>
    with ControllersMixin<AssetsDetailListAlert> {
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
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.name),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  Expanded(child: _displayAssetsDetailList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayAssetsDetailList() {
    final List<Widget> list = <Widget>[];

    switch (widget.title) {
      case 'stock':
        var lastCost = 0;
        appParamState.keepStockTickerMap[widget.item]?.forEach((StockModel element) {
          final String jikaHyoukagaku = element.jikaHyoukagaku.replaceAll(',', '');
          final String heikinShutokuKagaku = element.heikinShutokuKagaku.replaceAll(',', '');

          int cost = 0;
          int price = 0;
          int diff = 0;
          if (int.tryParse(jikaHyoukagaku) != null && double.tryParse(heikinShutokuKagaku) != null) {
            cost = (element.hoyuuSuuryou * heikinShutokuKagaku.toDouble()).toInt();
            price = jikaHyoukagaku.toDouble().toInt();
            diff = price - cost;
          }

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                children: <Widget>[
                  Expanded(child: Text('${element.year}-${element.month}-${element.day}')),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        cost.toString().toCurrency(),

                        style: TextStyle(color: (cost != lastCost) ? Colors.yellowAccent : Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(alignment: Alignment.topRight, child: Text(price.toString().toCurrency())),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        diff.toString().toCurrency(),

                        style: TextStyle(color: (diff < 0) ? Colors.orangeAccent : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          lastCost = cost;
        });

      case 'toushiShintaku':
        var lastCost = 0;
        appParamState.keepToushiShintakuRelationalMap[widget.item.toInt()]?.forEach((ToushiShintakuModel element) {
          final String jikaHyoukagaku = element.jikaHyoukagaku
              .replaceAll(',', '')
              .replaceAll(',', '')
              .replaceAll('円', '')
              .trim();

          final String shutokuSougaku = element.shutokuSougaku.replaceAll(',', '').replaceAll('円', '').trim();

          int cost = 0;
          int price = 0;
          int diff = 0;
          if (int.tryParse(jikaHyoukagaku) != null && int.tryParse(shutokuSougaku) != null) {
            cost = shutokuSougaku.toInt();
            price = jikaHyoukagaku.toDouble().toInt();
            diff = price - cost;
          }

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                children: <Widget>[
                  Expanded(child: Text('${element.year}-${element.month}-${element.day}')),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        cost.toString().toCurrency(),

                        style: TextStyle(color: (cost != lastCost) ? Colors.yellowAccent : Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(alignment: Alignment.topRight, child: Text(price.toString().toCurrency())),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        diff.toString().toCurrency(),

                        style: TextStyle(color: (diff < 0) ? Colors.orangeAccent : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          lastCost = cost;
        });
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
