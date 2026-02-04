import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/amazon_purchase_model.dart';
import '../../utility/utility.dart';

class AmazonPurchaseListAlert extends ConsumerStatefulWidget {
  const AmazonPurchaseListAlert({super.key, this.date});

  final String? date;

  @override
  ConsumerState<AmazonPurchaseListAlert> createState() => _AmazonPurchaseListAlertState();
}

class _AmazonPurchaseListAlertState extends ConsumerState<AmazonPurchaseListAlert>
    with ControllersMixin<AmazonPurchaseListAlert> {
  Utility utility = Utility();

  late final AutoScrollController autoScrollController;

  final List<AmazonPurchaseModel> amazonPurchases = <AmazonPurchaseModel>[];

  bool _didJump = false;

  ///
  @override
  void initState() {
    super.initState();
    autoScrollController = AutoScrollController(suggestedRowHeight: 90);
  }

  ///
  @override
  void dispose() {
    autoScrollController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_didJump) {
        return;
      }
      _didJump = true;

      if (widget.date != null) {
        final List<String> dateList = <String>[];
        for (final AmazonPurchaseModel element in amazonPurchases) {
          dateList.add('${element.year}-${element.month.padLeft(2, '0')}-${element.day.padLeft(2, '0')}');
        }

        final String target = widget.date!.trim();

        int pos = dateList.indexOf(target);

        if (pos == -1) {
          pos = _findNearestPastOrSameIndex(dateList: dateList, targetDate: target);

          if (pos == -1) {
            pos = _findNearestIndex(dateList: dateList, targetDate: target);
          }
        }

        if (pos >= 0) {
          await _scrollTo(pos, AutoScrollPosition.begin);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('amazon purchase list'), SizedBox.shrink()],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Expanded(child: displayAmazonPurchaseList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayAmazonPurchaseList() {
    amazonPurchases.clear();

    appParamState.keepAmazonPurchaseMap.values.forEach(amazonPurchases.addAll);

    if (amazonPurchases.isEmpty) {
      return const Center(child: Text('Amazon購入履歴がありません'));
    }

    final List<Color> fortyEightColor = utility.getFortyEightColor();

    return ListView.builder(
      controller: autoScrollController,
      itemCount: amazonPurchases.length,
      itemBuilder: (BuildContext context, int index) {
        final AmazonPurchaseModel element = amazonPurchases[index];

        final int month = int.tryParse(element.month) ?? 0;
        final Color color = fortyEightColor.isInRange(month - 1)
            ? fortyEightColor[month - 1]
            : Colors.white.withOpacity(0.2);

        return AutoScrollTag(
          key: ValueKey<int>(index),
          controller: autoScrollController,
          index: index,
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${element.year}-${element.month.padLeft(2, '0')}-${element.day.padLeft(2, '0')}'),
                      const SizedBox.shrink(),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: color.withValues(alpha: 0.2),
                          child: Text(element.month, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(element.item),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[const SizedBox.shrink(), Text(element.price.toString().toCurrency())],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///
  Future<void> _scrollTo(int index, AutoScrollPosition position) async {
    if (index < 0) {
      return;
    }

    await autoScrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 300),
    );

    await Future<void>.delayed(const Duration(milliseconds: 16));

    await autoScrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 1),
    );
  }

  ///
  DateTime? _parseYmd(String ymd) {
    final List<String> parts = ymd.split('-');
    if (parts.length != 3) {
      return null;
    }

    final int? y = int.tryParse(parts[0]);
    final int? m = int.tryParse(parts[1]);
    final int? d = int.tryParse(parts[2]);

    if (y == null || m == null || d == null) {
      return null;
    }

    return DateTime(y, m, d);
  }

  ///
  int _findNearestIndex({required List<String> dateList, required String targetDate}) {
    final DateTime? target = _parseYmd(targetDate);
    if (target == null) {
      return -1;
    }

    int bestIndex = -1;
    int bestDiff = 1 << 62;

    for (int i = 0; i < dateList.length; i++) {
      final DateTime? dt = _parseYmd(dateList[i]);
      if (dt == null) {
        continue;
      }

      final int diff = (dt.millisecondsSinceEpoch - target.millisecondsSinceEpoch).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestIndex = i;
      }
    }

    return bestIndex;
  }

  ///
  int _findNearestPastOrSameIndex({required List<String> dateList, required String targetDate}) {
    final DateTime? target = _parseYmd(targetDate);
    if (target == null) {
      return -1;
    }

    int bestIndex = -1;
    int bestTime = -1;

    final int targetTime = target.millisecondsSinceEpoch;

    for (int i = 0; i < dateList.length; i++) {
      final DateTime? dt = _parseYmd(dateList[i]);
      if (dt == null) {
        continue;
      }

      final int t = dt.millisecondsSinceEpoch;

      if (t <= targetTime) {
        if (t > bestTime) {
          bestTime = t;
          bestIndex = i;
        }
      }
    }

    return bestIndex;
  }
}
