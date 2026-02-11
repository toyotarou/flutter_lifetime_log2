import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';
import '../../models/money_spend_model.dart';
import '../parts/lifetime_dialog.dart';
import 'amazon_purchase_list_alert.dart';
import 'mobile_suica_charge_history_list.dart';

class MonthlyMoneySpendPickupAlert extends ConsumerStatefulWidget {
  const MonthlyMoneySpendPickupAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyMoneySpendPickupAlert> createState() => _MonthlyMoneySpendPickupAlertState();
}

class _MonthlyMoneySpendPickupAlertState extends ConsumerState<MonthlyMoneySpendPickupAlert>
    with ControllersMixin<MonthlyMoneySpendPickupAlert> {
  final AutoScrollController autoScrollController = AutoScrollController();

  List<MoneySpendModel> moneySpendModelList = <MoneySpendModel>[];

  Map<String, List<Map<String, int>>> itemMoneySpendModelMap = <String, List<Map<String, int>>>{};

  Set<String> spendModelItemList = <String>{};

  ///
  @override
  void dispose() {
    autoScrollController.dispose();
    super.dispose();
  }

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

    final List<MoneySpendModel> rawList = _makeMoneySpendModelListRaw(year: ym.year, month: ym.month);

    final List<String> itemKeys = _makeItemKeysFromDisplayList(rawList);
    final Map<String, int> itemRank = _makeItemRankMap(itemKeys);

    moneySpendModelList = _sortMoneySpendModelList(list: rawList, itemRank: itemRank);

    final int total = moneySpendModelList.fold<int>(0, (int sum, MoneySpendModel e) {
      if (!_isCountTarget(e)) {
        return sum;
      }
      return sum + e.price;
    });

    makeItemMoneySpendModelMap(itemKeys: itemKeys, moneySpendModelList: moneySpendModelList);

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
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text(widget.yearmonth), Text('${moneySpendModelList.length}件')],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            if (moneySpendModelList.isNotEmpty) {
                              autoScrollController.scrollToIndex(
                                moneySpendModelList.length - 1,
                                preferPosition: AutoScrollPosition.end,
                                duration: const Duration(milliseconds: 300),
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_downward),
                        ),
                        IconButton(
                          onPressed: () {
                            if (moneySpendModelList.isNotEmpty) {
                              autoScrollController.scrollToIndex(
                                0,
                                preferPosition: AutoScrollPosition.begin,
                                duration: const Duration(milliseconds: 300),
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_upward),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: spendModelItemList.map((String itemText) {
                      final int? sum = itemMoneySpendModelMap[itemText]?.fold<int>(0, (int sum, Map<String, int> e) {
                        return sum + e['price']!;
                      });

                      return GestureDetector(
                        onTap: () {
                          if (itemMoneySpendModelMap[itemText] != null) {
                            for (final Map<String, int> element in itemMoneySpendModelMap[itemText]!) {
                              appParamNotifier.setSelectedMoneySpendPickupListIndexList(
                                index: element['index']!,
                                price: element['price']!,
                              );
                            }

                            appParamNotifier.setSelectedMoneySpendPickupItemTextList(item: itemText);
                          }
                        },

                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                  margin: const EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 3),
                                  decoration: BoxDecoration(
                                    color: (appParamState.selectedMoneySpendPickupItemTextList.contains(itemText))
                                        ? Colors.yellowAccent.withValues(alpha: 0.2)
                                        : Colors.white.withValues(alpha: 0.2),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
                                  ),
                                  child: Text(itemText, style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                                  child: Text(
                                    sum.toString().toCurrency(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ((sum ?? 0) >= 30000) ? Colors.orangeAccent : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              right: 0,
                              top: 0,
                              child: Transform(
                                alignment: Alignment.centerLeft,
                                transform: Matrix4.identity()..setEntry(0, 1, -0.8),
                                child: Text(
                                  (itemMoneySpendModelMap[itemText] != null)
                                      ? itemMoneySpendModelMap[itemText]!.length.toString()
                                      : '',
                                  style: const TextStyle(
                                    color: Color(0xFFFBB6CE),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displayMoneySpendModelList(moneySpendModelList)),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[const SizedBox.shrink(), Text(total.toString().toCurrency())],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Text(appParamState.selectedMoneySpendPickupListSum.toString().toCurrency()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  bool _isCountTarget(MoneySpendModel e) {
    return !(e.price == 0 || e.item == 'クレジット');
  }

  ///
  String _rankKey(String itemText) {
    final int p = itemText.indexOf(' / ');
    if (p <= 0) {
      return itemText;
    }
    return itemText.substring(0, p);
  }

  List<String> _makeItemKeysFromDisplayList(List<MoneySpendModel> items) {
    final List<String> itemKeys = appParamState.keepMoneySpendItemMap.keys.toList();

    const List<String> extraItems = <String>['共済戻り', '年金', 'アイアールシー', 'メルカリ', '牛乳代', '弁当代'];

    for (final String item in extraItems) {
      if (!itemKeys.contains(item)) {
        itemKeys.add(item);
      }
    }

    final Set<String> presentKeys = <String>{};
    for (final MoneySpendModel e in items) {
      final String key = _rankKey(e.item).trim();
      if (key.isNotEmpty) {
        presentKeys.add(key);
      }
    }

    return itemKeys.where((String key) => presentKeys.contains(key)).toList();
  }

  ///
  Map<String, int> _makeItemRankMap(List<String> itemKeys) {
    return <String, int>{for (int i = 0; i < itemKeys.length; i++) itemKeys[i]: i};
  }

  ///
  List<MoneySpendModel> _makeMoneySpendModelListRaw({required int year, required int month}) {
    final List<MoneySpendModel> list = <MoneySpendModel>[];

    final int monthEnd = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= monthEnd; day++) {
      final String date = DateTime(year, month, day).yyyymmdd;

      final Iterable<MoneySpendModel> spends = appParamState.keepMoneySpendMap[date] ?? const <MoneySpendModel>[];

      for (final MoneySpendModel e in spends) {
        if (!_isCountTarget(e)) {
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

      final String date = DateTime(ymd.year, ymd.month, ymd.day).yyyymmdd;
      list.add(MoneySpendModel(date, '${cs.item} / ${cs.detail}', cs.price, 'card'));
    }

    return list;
  }

  ///
  List<MoneySpendModel> _sortMoneySpendModelList({
    required List<MoneySpendModel> list,
    required Map<String, int> itemRank,
  }) {
    list.sort((MoneySpendModel a, MoneySpendModel b) {
      final int d = a.date.compareTo(b.date);
      if (d != 0) {
        return d;
      }

      final int ra = itemRank[_rankKey(a.item)] ?? 999999;
      final int rb = itemRank[_rankKey(b.item)] ?? 999999;

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
      controller: autoScrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            final MoneySpendModel e = items[index];

            final Color color = (e.kind == 'credit')
                ? Colors.greenAccent
                : (e.kind == 'card')
                ? Colors.yellowAccent
                : Colors.white;

            final String youbi = _safeYoubi(e.date);

            Color? priceColor;
            if (e.price >= 10000) {
              priceColor = Colors.orangeAccent;
            } else if (e.price < 0) {
              priceColor = const Color(0xFFFBB6CE);
            }

            final _DateLabelParts dateParts = _safeDateLabelParts(e.date);

            return AutoScrollTag(
              // ignore: always_specify_types
              key: ValueKey(index),
              index: index,
              controller: autoScrollController,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: DefaultTextStyle(
                  style: TextStyle(color: color, fontSize: 12),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              appParamNotifier.setSelectedMoneySpendPickupListIndexList(index: index, price: e.price);
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: (appParamState.selectedMoneySpendPickupListIndexList.contains(index))
                                  ? Colors.yellowAccent.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.3),

                              child: (appParamState.selectedMoneySpendPickupListIndexList.contains(index))
                                  ? getCircleAvatarIndexNumber(data: e, index: index)
                                  : const Text(''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: Row(
                              children: <Widget>[
                                Column(children: <Widget>[Text(dateParts.yearText), Text(dateParts.monthDayText)]),
                                const SizedBox(width: 10),
                                Text(youbi),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(e.item, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(
                                  e.price.toString().toCurrency(),
                                  textAlign: TextAlign.right,
                                  style: (priceColor != null) ? TextStyle(color: priceColor) : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (e.item == '交通費' || e.item == '雑費 / アマゾン') ...<Widget>[
                        Positioned(
                          top: 5,
                          right: 5,
                          child: (e.item == '交通費')
                              ? GestureDetector(
                                  onTap: () {
                                    LifetimeDialog(context: context, widget: const MobileSuicaChargeHistoryList());
                                  },
                                  child: Icon(Icons.train, color: Colors.white.withValues(alpha: 0.7)),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    LifetimeDialog(
                                      context: context,
                                      widget: AmazonPurchaseListAlert(
                                        date: '${dateParts.yearText}-${dateParts.monthDayText}',
                                      ),
                                    );
                                  },
                                  child: Icon(FontAwesomeIcons.amazon, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }, childCount: items.length),
        ),
      ],
    );
  }

  ///
  Widget getCircleAvatarIndexNumber({required MoneySpendModel data, required int index}) {
    if (appParamState.selectedMoneySpendPickupItemTextList.length != 1) {
      return const Text('');
    }

    final String key = data.item.split('/').first.trim();
    if (key.isEmpty) {
      return const Text('');
    }

    final List<Map<String, int>>? categoryItems = itemMoneySpendModelMap[key];
    if (categoryItems == null) {
      return const Text('');
    }

    final int listIndex = categoryItems.indexWhere((Map<String, int> e) => e['index'] == index);
    final String answer = (listIndex != -1) ? (listIndex + 1).toString() : '';

    return Text(
      answer,
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    );
  }

  ///
  String _safeYoubi(String ymd) {
    try {
      final DateTime dt = DateTime.parse(ymd);
      final String s = dt.youbiStr;
      return (s.length >= 3) ? s.substring(0, 3) : s;
    } catch (_) {
      return '---';
    }
  }

  ///
  _DateLabelParts _safeDateLabelParts(String ymd) {
    final List<String> parts = ymd.split('-');
    if (parts.length >= 3) {
      return _DateLabelParts(yearText: parts[0], monthDayText: '${parts[1]}-${parts[2]}');
    }

    return const _DateLabelParts(yearText: '----', monthDayText: '--/--');
  }

  ///
  void makeItemMoneySpendModelMap({
    required List<String> itemKeys,

    required List<MoneySpendModel> moneySpendModelList,
  }) {
    itemMoneySpendModelMap.clear();

    spendModelItemList.clear();

    for (final String key in itemKeys) {
      for (int i = 0; i < moneySpendModelList.length; i++) {
        final List<String> exItem = moneySpendModelList[i].item.split('/');

        if (exItem[0].trim() == key) {
          (itemMoneySpendModelMap[key] ??= <Map<String, int>>[]).add(<String, int>{
            'index': i,
            'price': moneySpendModelList[i].price,
          });

          spendModelItemList.add(key);
        }
      }
    }
  }
}

///
class _DateLabelParts {
  const _DateLabelParts({required this.yearText, required this.monthDayText});

  final String yearText;
  final String monthDayText;
}

///
class _YearMonth {
  const _YearMonth(this.year, this.month);

  final int year;
  final int month;
}

///
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
