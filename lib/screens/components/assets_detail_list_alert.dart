import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
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
  late final AutoScrollController autoScrollController;

  // パフォーマンス向上のため、フォーマッタをstaticで保持して再利用する
  static final NumberFormat _currencyFormatter = NumberFormat('#,###');

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    autoScrollController.dispose();
    super.dispose();
  }

  ///
  @override
  void initState() {
    super.initState();
    autoScrollController = AutoScrollController();
  }

  /// 文字列から数値を安全かつ高速に取得するためのヘルパー
  double _safeParseDouble(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    // カンマと円を効率的に除去
    final String cleaned = value.replaceAll(',', '').replaceAll('円', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  ///
  @override
  Widget build(BuildContext context) {
    // 必要なデータのみを select でピンポイントに監視
    final List<dynamic> dataList;
    if (widget.title == 'stock') {
      dataList =
          ref.watch(appParamProvider.select((AppParamState s) => s.keepStockTickerMap[widget.item])) ?? <dynamic>[];
    } else if (widget.title == 'toushiShintaku') {
      final int? id = int.tryParse(widget.item);
      dataList = (id != null)
          ? (ref.watch(appParamProvider.select((AppParamState s) => s.keepToushiShintakuRelationalMap[id])) ??
                <dynamic>[])
          : <dynamic>[];
    } else {
      dataList = <dynamic>[];
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(dataList),
                const Divider(color: Colors.white38, thickness: 5),
                Expanded(
                  child: CustomScrollView(
                    controller: autoScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          if (index >= dataList.length) {
                            return null;
                          }
                          // 各アイテムに RepaintBoundary を適用してスクロールを滑らかにする
                          return RepaintBoundary(child: _buildListItem(index, dataList));
                        }, childCount: dataList.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildHeader(List<dynamic> dataList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) {
                if (dataList.isEmpty) return;
                _startRepeating(() => _scrollBy(_moveAmount));
              },
              onTapUp: (_) => _stopRepeating(),
              onTapCancel: _stopRepeating,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Center(child: Icon(Icons.arrow_downward, color: Colors.white70)),
              ),
            ),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => _startRepeating(() => _scrollBy(-_moveAmount)),
              onTapUp: (_) => _stopRepeating(),
              onTapCancel: _stopRepeating,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Center(child: Icon(Icons.arrow_upward, color: Colors.white70)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!autoScrollController.hasClients) {
      return;
    }

    final ScrollPosition pos = autoScrollController.position;
    final double newOffset = (autoScrollController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    autoScrollController.jumpTo(newOffset);
  }

  ///
  Widget _buildListItem(int index, List<dynamic> dataList) {
    final dynamic item = dataList[index];

    String date = '';
    int cost = 0;
    int price = 0;
    int diff = 0;
    int lastCost = 0;

    // 型安全なデータ抽出と計算
    if (widget.title == 'stock' && item is StockModel) {
      date = '${item.year}-${item.month}-${item.day}';
      cost = (item.hoyuuSuuryou * _safeParseDouble(item.heikinShutokuKagaku)).toInt();
      price = _safeParseDouble(item.jikaHyoukagaku).toInt();
      diff = price - cost;

      if (index > 0) {
        final dynamic prev = dataList[index - 1];
        if (prev is StockModel) {
          lastCost = (prev.hoyuuSuuryou * _safeParseDouble(prev.heikinShutokuKagaku)).toInt();
        }
      }
    } else if (widget.title == 'toushiShintaku' && item is ToushiShintakuModel) {
      date = '${item.year}-${item.month}-${item.day}';
      cost = _safeParseDouble(item.shutokuSougaku).toInt();
      price = _safeParseDouble(item.jikaHyoukagaku).toInt();
      diff = price - cost;

      if (index > 0) {
        final dynamic prev = dataList[index - 1];
        if (prev is ToushiShintakuModel) {
          lastCost = _safeParseDouble(prev.shutokuSougaku).toInt();
        }
      }
    }

    return AutoScrollTag(
      key: ValueKey<int>(index),
      index: index,
      controller: autoScrollController,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: <Widget>[
            Expanded(flex: 2, child: Text(date)),
            _buildPriceText(cost, lastCost: lastCost, isCost: true),
            _buildPriceText(price),
            _buildPriceText(diff, isDiff: true),
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildPriceText(int value, {int lastCost = 0, bool isCost = false, bool isDiff = false}) {
    Color textColor = Colors.white;
    if (isCost && value != lastCost && lastCost != 0) {
      textColor = Colors.yellowAccent;
    } else if (isDiff && value < 0) {
      textColor = Colors.orangeAccent;
    }

    return Expanded(
      child: Text(
        _currencyFormatter.format(value),
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor, fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]),
      ),
    );
  }
}
