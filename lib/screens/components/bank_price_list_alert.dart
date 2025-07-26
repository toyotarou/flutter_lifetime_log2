import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class BankPriceListAlert extends ConsumerStatefulWidget {
  const BankPriceListAlert({super.key, required this.bankKey});

  final String bankKey;

  @override
  ConsumerState<BankPriceListAlert> createState() => _BankPriceListAlertState();
}

class _BankPriceListAlertState extends ConsumerState<BankPriceListAlert> with ControllersMixin<BankPriceListAlert> {
  Utility utility = Utility();

  Map<String, String> bankNameMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    bankNameMap = utility.getBankName();
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
    moneyState.bankMoneyMap[widget.bankKey]?.forEach((Map<String, int> element) {
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
