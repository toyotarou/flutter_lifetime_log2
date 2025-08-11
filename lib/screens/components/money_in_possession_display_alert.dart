import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  final AutoScrollController autoScrollController = AutoScrollController();

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
                  children: <Widget>[
                    const Text('money in possession'),
                    GestureDetector(
                      onTap: () => LifetimeDialog(context: context, widget: const MoneyInPossessionGraphAlert()),
                      child: const Icon(Icons.graphic_eq),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            autoScrollController.scrollToIndex(appParamState.keepMoneyMap.length);
                          },
                          icon: const Icon(Icons.arrow_downward),
                        ),

                        IconButton(
                          onPressed: () {
                            autoScrollController.scrollToIndex(0);
                          },
                          icon: const Icon(Icons.arrow_upward),
                        ),
                      ],
                    ),
                  ],
                ),

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

    int lastSum = 0;
    int i = 0;
    appParamState.keepMoneyMap.forEach((String key, MoneyModel value) {
      if (key.split('-')[0].toInt() >= 2023) {
        list.add(
          AutoScrollTag(
            // ignore: always_specify_types
            key: ValueKey(i),
            index: i,
            controller: autoScrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(value.sum.toCurrency()),

                      if (i == 0)
                        const SizedBox.shrink()
                      else
                        Text(
                          (lastSum - value.sum.toInt()).toString().toCurrency(),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        lastSum = value.sum.toInt();
        i++;
      }
    });

    return CustomScrollView(
      controller: autoScrollController,
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
