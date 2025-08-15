import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';

class AssetsDetailDisplayAlert extends ConsumerStatefulWidget {
  const AssetsDetailDisplayAlert({super.key, required this.date, required this.title});

  final String date;
  final String title;

  @override
  ConsumerState<AssetsDetailDisplayAlert> createState() => _AssetsDetailDisplayAlertState();
}

class _AssetsDetailDisplayAlertState extends ConsumerState<AssetsDetailDisplayAlert>
    with ControllersMixin<AssetsDetailDisplayAlert> {
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
                  children: <Widget>[Text(widget.date), Text(widget.title)],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayAssetsNameList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayAssetsNameList() {
    final List<Widget> list = <Widget>[];

    final List<String> nameList = <String>[];

    switch (widget.title) {
      case 'stock':
        appParamState.keepStockMap.forEach((String key, List<StockModel> value) {
          for (final StockModel element in value) {
            if (!nameList.contains(element.ticker)) {
              list.add(Text('${element.ticker} ${element.name}'));
              nameList.add(element.ticker);
            }
          }
        });
      case 'toushiShintaku':
        appParamState.keepToushiShintakuMap.forEach((String key, List<ToushiShintakuModel> value) {
          for (final ToushiShintakuModel element in value) {
            if (!nameList.contains(element.name)) {
              list.add(Text(element.name));
              nameList.add(element.name);
            }
          }
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
