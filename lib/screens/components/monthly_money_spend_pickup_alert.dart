import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';

class MonthlyMoneySpendPickupAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendPickupAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendPickupAlert> createState() => _MonthlyMoneySpendPickupAlertState();
}

class _MonthlyMoneySpendPickupAlertState extends ConsumerState<MonthlyMoneySpendPickupAlert>
    with ControllersMixin<MonthlyMoneySpendPickupAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    final _YearMonth? ym = _parseYearMonth(widget.yearmonth);

    if (ym == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(widget.yearmonth), const Text('yearmonth format error')],
                  ),
                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                  const Expanded(child: Center(child: Text('表示できるデータがありません'))),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final Map<String, int> itemRank = _makeItemRankMap();

    final List<MoneySpendModel> displayList = _makeMoneySpendModelList(
      year: ym.year,
      month: ym.month,
      itemRank: itemRank,
    );

    final int total = displayList.fold<int>(0, (int sum, MoneySpendModel e) {
      if (e.price <= 0) {
        return sum;
      }
      return sum + e.price;
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.yearmonth), Text('${displayList.length}件')],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displayMoneySpendModelList(displayList)),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[const SizedBox.shrink(), Text(total.toString().toCurrency())],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Map<String, int> _makeItemRankMap() {
    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>['共済戻り', '年金', 'アイアールシー', 'メルカリ', '牛乳代', '弁当代'];

    for (final String item in extraItems) {
      if (!itemKeys.contains(item)) {
        itemKeys.add(item);
      }
    }

    return <String, int>{for (int i = 0; i < itemKeys.length; i++) itemKeys[i]: i};
  }

  ///
  List<MoneySpendModel> _makeMoneySpendModelList({
    required int year,
    required int month,
    required Map<String, int> itemRank,
  }) {
    final List<MoneySpendModel> list = <MoneySpendModel>[];

    final int monthEnd = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= monthEnd; day++) {
      final String date = DateTime(year, month, day).yyyymmdd;

      final Iterable<MoneySpendModel> spends = appParamState.keepMoneySpendMap[date] ?? const <MoneySpendModel>[];

      for (final MoneySpendModel e in spends) {
        if (e.price <= 0 || e.item == 'クレジット' || e.item == '楽天キャッシュ') {
          continue;
        }
        list.add(e);
      }
    }

    final Iterable<CreditSummaryModel> creditSummaries =
        appParamState.keepCreditSummaryMap[widget.yearmonth] ?? const <CreditSummaryModel>[];

    for (final CreditSummaryModel cs in creditSummaries) {
      final _Ymd? ymd = _parseYmd(cs.useDate);
      if (ymd == null) {
        continue;
      }

      if (ymd.year == year && ymd.month == month) {
        final String date = DateTime(ymd.year, ymd.month, ymd.day).yyyymmdd;
        list.add(MoneySpendModel(date, cs.item, cs.price, 'credit'));
      }
    }

    list.sort((MoneySpendModel a, MoneySpendModel b) {
      final int d = a.date.compareTo(b.date);
      if (d != 0) {
        return d;
      }

      final int ra = itemRank[a.item] ?? 999999;
      final int rb = itemRank[b.item] ?? 999999;
      final int r = ra.compareTo(rb);
      if (r != 0) {
        return r;
      }

      final int k = a.kind.compareTo(b.kind);
      if (k != 0) {
        return k;
      }

      final int p = a.price.compareTo(b.price);
      if (p != 0) {
        return p;
      }

      return a.item.compareTo(b.item);
    });

    return list;
  }

  ///
  Widget _displayMoneySpendModelList(List<MoneySpendModel> items) {
    if (items.isEmpty) {
      return const Center(child: Text('表示できるデータがありません'));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            final MoneySpendModel e = items[index];

            final Color color = (e.kind == 'credit') ? Colors.greenAccent : Colors.white;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: DefaultTextStyle(
                style: TextStyle(color: color, fontSize: 12),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 90, child: Text(e.date)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.item, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    SizedBox(width: 90, child: Text(e.price.toString().toCurrency(), textAlign: TextAlign.right)),
                  ],
                ),
              ),
            );
          }, childCount: items.length),
        ),
      ],
    );
  }
}

class _YearMonth {
  const _YearMonth(this.year, this.month);

  final int year;
  final int month;
}

class _Ymd {
  const _Ymd(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

///
_YearMonth? _parseYearMonth(String yearmonth) {
  final List<String> parts = yearmonth.split('-');
  if (parts.length != 2) {
    return null;
  }

  final int? y = int.tryParse(parts[0]);
  final int? m = int.tryParse(parts[1]);
  if (y == null || m == null) {
    return null;
  }
  if (m < 1 || m > 12) {
    return null;
  }

  return _YearMonth(y, m);
}

///
_Ymd? _parseYmd(String ymd) {
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
  if (m < 1 || m > 12) {
    return null;
  }
  if (d < 1 || d > 31) {
    return null;
  }

  try {
    final DateTime dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) {
      return null;
    }
  } catch (_) {
    return null;
  }

  return _Ymd(y, m, d);
}
