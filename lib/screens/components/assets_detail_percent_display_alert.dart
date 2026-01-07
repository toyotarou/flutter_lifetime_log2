import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';

class AssetsDetailPercentDisplayAlert extends ConsumerStatefulWidget {
  const AssetsDetailPercentDisplayAlert({
    super.key,
    required this.title,
    required this.goldMap,
    required this.stockTickerMap,
    required this.toushiShintakuRelationalMap,
  });

  final String title;
  final Map<String, GoldModel> goldMap;
  final Map<String, List<StockModel>> stockTickerMap;
  final Map<int, List<ToushiShintakuModel>> toushiShintakuRelationalMap;

  @override
  ConsumerState<AssetsDetailPercentDisplayAlert> createState() => _AssetsDetailPercentDisplayAlertState();
}

class _AssetsDetailPercentDisplayAlertState extends ConsumerState<AssetsDetailPercentDisplayAlert>
    with ControllersMixin<AssetsDetailPercentDisplayAlert> {
  Map<String, Map<String, int>> assetsValueMap = <String, Map<String, int>>{};

  ///
  @override
  void initState() {
    super.initState();

    switch (widget.title) {
      case 'gold':
        assetsValueMap[widget.title] = <String, int>{};

        final Map<String, List<int>> map = <String, List<int>>{};
        for (int i = 2021; i <= DateTime.now().year; i++) {
          widget.goldMap.forEach((String key, GoldModel value) {
            if (value.goldValue.toString() != '-' && value.payPrice.toString() != '-') {
              final List<String> exKey = key.split('-');
              if (i.toString() == exKey[0]) {
                (map[i.toString()] ??= <int>[]).add(
                  ((value.goldValue.toString().toInt() / value.payPrice.toString().toInt()) * 100).toInt(),
                );
              }
            }
          });
        }

        map.forEach((String key, List<int> value) {
          int result = 0;
          for (final int element in value) {
            result += element;
          }

          assetsValueMap['gold']![key] = (result / value.length).toInt();
        });

      case 'stock':
        final Map<String, Map<String, List<int>>> map2 = <String, Map<String, List<int>>>{};

        widget.stockTickerMap.forEach((String key, List<StockModel> value) {
          final Map<String, List<int>> map = <String, List<int>>{};

          for (int i = 2021; i <= DateTime.now().year; i++) {
            for (final StockModel element in value) {
              if (element.year == i.toString()) {
                (map[i.toString()] ??= <int>[]).add(
                  ((element.jikaHyoukagaku.replaceAll(',', '').toInt() /
                              (element.hoyuuSuuryou * element.heikinShutokuKagaku.replaceAll(',', '').toDouble())) *
                          100)
                      .toInt(),
                );
              }
            }
          }

          map2[key] = map;
        });

        map2.forEach((String key, Map<String, List<int>> value) {
          final Map<String, int> map3 = <String, int>{};
          value.forEach((String key2, List<int> value2) {
            int result = 0;
            for (final int element in value2) {
              result += element;
            }

            map3[key2] = (result / value2.length).toInt();
          });
          assetsValueMap[key] = map3;
        });

      case 'toushiShintaku':
        final Map<String, Map<String, List<int>>> map2 = <String, Map<String, List<int>>>{};

        widget.toushiShintakuRelationalMap.forEach((int key, List<ToushiShintakuModel> value) {
          final Map<String, List<int>> map = <String, List<int>>{};

          for (int i = 2021; i <= DateTime.now().year; i++) {
            for (final ToushiShintakuModel element in value) {
              if (element.year == i.toString()) {
                (map[i.toString()] ??= <int>[]).add(
                  ((element.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt() /
                              element.shutokuSougaku.replaceAll(',', '').replaceAll('円', '').trim().toInt()) *
                          100)
                      .toInt(),
                );
              }
            }
          }

          map2[key.toString()] = map;
        });

        map2.forEach((String key, Map<String, List<int>> value) {
          final Map<String, int> map3 = <String, int>{};
          value.forEach((String key2, List<int> value2) {
            int result = 0;
            for (final int element in value2) {
              result += element;
            }

            map3[key2] = (result / value2.length).toInt();
          });
          assetsValueMap[key] = map3;
        });
    }
  }

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
                  children: <Widget>[Text(widget.title), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayAssetsDetailPercentList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayAssetsDetailPercentList() {
    final List<Widget> list = <Widget>[];

    assetsValueMap.forEach((String key, Map<String, int> value) {
      String dispName = '';
      switch (widget.title) {
        case 'stock':
          final List<StockModel>? last = widget.stockTickerMap[key];

          if (last != null) {
            dispName = last.last.name;
          }

        case 'toushiShintaku':
          final List<ToushiShintakuModel>? last = widget.toushiShintakuRelationalMap[key.toInt()];

          if (last != null) {
            dispName = last.last.name;
          }

        default:
          break;
      }

      list.add(
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.1)),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(key),
                      const SizedBox(width: 20),
                      Expanded(child: (widget.title == 'gold') ? const SizedBox.shrink() : Text(dispName)),
                    ],
                  ),
                ),

                Row(
                  children: <Widget>[
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children: value.entries.map((MapEntry<String, int> e) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                            ),
                            padding: const EdgeInsets.all(5),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[Text(e.key), Text('${e.value} %')],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });

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
