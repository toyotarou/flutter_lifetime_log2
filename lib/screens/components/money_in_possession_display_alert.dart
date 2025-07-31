import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_model.dart';
import '../parts/lifetime_dialog.dart';
import 'money_in_possession_graph_alert.dart';

class MoneyInPossessionDisplayAlert extends ConsumerStatefulWidget {
  const MoneyInPossessionDisplayAlert({super.key});

  @override
  ConsumerState<MoneyInPossessionDisplayAlert> createState() => _MoneyInPossessionDisplayAlertState();
}

class _MoneyInPossessionDisplayAlertState extends ConsumerState<MoneyInPossessionDisplayAlert>
    with ControllersMixin<MoneyInPossessionDisplayAlert> {
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
                  children: <Widget>[
                    const Text('money in possession'),
                    GestureDetector(
                      onTap: () => LifetimeDialog(context: context, widget: const MoneyInPossessionGraphAlert()),
                      child: const Icon(Icons.graphic_eq),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displayPossessionMoneyList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayPossessionMoneyList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() >= 2023) {
        list.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(key), Text(value.sum.toCurrency())],
            ),
          ),
        );
      }
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
