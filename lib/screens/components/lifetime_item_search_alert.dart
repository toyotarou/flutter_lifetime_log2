import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/lifetime_model.dart';
import '../../utility/utility.dart';

class LifetimeItemSearchAlert extends ConsumerStatefulWidget {
  const LifetimeItemSearchAlert({super.key});

  @override
  ConsumerState<LifetimeItemSearchAlert> createState() => _LifetimeItemSearchAlertState();
}

class _LifetimeItemSearchAlertState extends ConsumerState<LifetimeItemSearchAlert>
    with ControllersMixin<LifetimeItemSearchAlert> {
  Utility utility = Utility();

  final Map<String, Color> _lifetimeColorCache = <String, Color>{};

  ///
  Color _lifetimeColor(String value) {
    final Color? c = _lifetimeColorCache[value];
    if (c != null) {
      return c;
    }
    final Color v = utility.getLifetimeRowBgColor(value: value, textDisplay: false);
    _lifetimeColorCache[value] = v;
    return v;
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('lifetime item search'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                displayLifetimeItemSearchItemList(),

                Expanded(child: displayLifetimeItemSearchResultList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayLifetimeItemSearchItemList() {
    final List<Widget> list = <Widget>[];

    for (final LifetimeItemModel element in appParamState.keepLifetimeItemList) {
      final Color color = _lifetimeColor(element.item);

      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: (element.item == lifetimeInputState.selectedInputChoiceChip)
                    ? Colors.yellowAccent
                    : Colors.transparent,
              ),
            ),
          ),

          child: ChoiceChip(
            label: Text(element.item, style: const TextStyle(fontSize: 12)),
            backgroundColor: color.withValues(alpha: 0.3),
            selectedColor: Colors.greenAccent.withValues(alpha: 0.4),
            selected: element.item == lifetimeInputState.selectedInputChoiceChip,
            onSelected: (bool isSelected) async {
              lifetimeInputNotifier.setSelectedInputChoiceChip(item: element.item);
            },
            showCheckmark: false,
          ),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: list),
      ),
    );
  }

  ///
  Widget displayLifetimeItemSearchResultList() {
    final List<Widget> list = <Widget>[];

    String keepYear = '';

    appParamState.keepAllDateLifetimeSummaryMap.forEach((String key, List<Map<String, dynamic>> value) {
      for (final Map<String, dynamic> element in value) {
        if (element['title'] == lifetimeInputState.selectedInputChoiceChip) {
          if (key.split('-')[0] != keepYear) {
            list.add(
              Container(
                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(key.split('-')[0], style: const TextStyle(color: Colors.yellowAccent)),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }

          final String youbiStr = DateTime.parse(key).youbiStr;

          final Color color = utility.getYoubiColor(date: key, youbiStr: youbiStr, holiday: holidayState.holidayList);

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),

                color: color,
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('$key ${youbiStr.substring(0, 3)}'),

                  Text(
                    '${(element['startHour'] as int).toString().padLeft(2, '0')}:00 - ${(element['endHour'] as int).toString().padLeft(2, '0')}:00',
                  ),
                ],
              ),
            ),
          );

          keepYear = key.split('-')[0];
        }
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
