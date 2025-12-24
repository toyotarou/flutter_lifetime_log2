import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  final AutoScrollController autoScrollController = AutoScrollController();

  final List<Widget> assetsDetailList = <Widget>[];

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text(widget.name)),

                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              autoScrollController.scrollToIndex(
                                assetsDetailList.length,
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
                    ],
                  ),

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
    assetsDetailList.clear();

    switch (widget.title) {
      case 'stock':
        int lastCost = 0;
        int i = 0;
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

          assetsDetailList.add(
            AutoScrollTag(
              // ignore: always_specify_types
              key: ValueKey(i),
              index: i,
              controller: autoScrollController,

              child: Container(
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
            ),
          );

          lastCost = cost;

          i++;
        });

      case 'toushiShintaku':
        int lastCost = 0;
        int i = 0;
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

          assetsDetailList.add(
            AutoScrollTag(
              // ignore: always_specify_types
              key: ValueKey(i),
              index: i,
              controller: autoScrollController,

              child: Container(
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
            ),
          );

          lastCost = cost;

          i++;
        });
    }

    return CustomScrollView(
      controller: autoScrollController,

      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => assetsDetailList[index],
            childCount: assetsDetailList.length,
          ),
        ),
      ],
    );
  }
}
