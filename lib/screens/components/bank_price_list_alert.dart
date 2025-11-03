import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utils/ui_utils.dart';

class BankPriceListAlert extends ConsumerStatefulWidget {
  const BankPriceListAlert({super.key, required this.bankKey});

  final String bankKey;

  @override
  ConsumerState<BankPriceListAlert> createState() => _BankPriceListAlertState();
}

class _BankPriceListAlertState extends ConsumerState<BankPriceListAlert> with ControllersMixin<BankPriceListAlert> {
  Map<String, String> bankNameMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    bankNameMap = UiUtils.bankName();
  }

  ///
  @override
  Widget build(BuildContext context) {
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
                  children: <Widget>[Text(widget.bankKey), Text(bankNameMap[widget.bankKey] ?? '')],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displayBankPriceList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayBankPriceList() {
    final List<Widget> list = <Widget>[];

    int keepPrice = 0;

    final List<Map<String, int>>? mapList = moneyState.bankMoneyMap[widget.bankKey];

    if (mapList != null) {
      // 日付順にソートした新しいリストを作成
      final List<Map<String, int>> sortedList = List<Map<String, int>>.from(mapList)
        ..sort((Map<String, int> a, Map<String, int> b) {
          final DateTime dateA = DateTime.parse(a.entries.first.key);
          final DateTime dateB = DateTime.parse(b.entries.first.key);
          return dateA.compareTo(dateB); // 昇順
        });

      for (final Map<String, int> element in sortedList) {
        final MapEntry<String, int> entry = element.entries.first;

        if (keepPrice != entry.value) {
          list.add(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(entry.key), Text(entry.value.toString().toCurrency())],
              ),
            ),
          );
        }

        keepPrice = entry.value;
      }
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
