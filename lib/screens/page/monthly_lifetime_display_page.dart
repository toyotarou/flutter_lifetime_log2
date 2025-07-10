import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class MonthlyLifetimeDisplayPage extends ConsumerStatefulWidget {
  const MonthlyLifetimeDisplayPage({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyLifetimeDisplayPage> createState() => _MonthlyLifetimeDisplayPageState();
}

class _MonthlyLifetimeDisplayPageState extends ConsumerState<MonthlyLifetimeDisplayPage>
    with ControllersMixin<MonthlyLifetimeDisplayPage> {
  Utility utility = Utility();

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
                Text(widget.yearmonth),

                const SizedBox(height: 10),

                Expanded(child: _displayMonthlyLifetimeList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayMonthlyLifetimeList() {
    final List<Widget> list = <Widget>[];

    for (
      int i = 1;
      i <= DateTime(widget.yearmonth.split('-')[0].toInt(), widget.yearmonth.split('-')[1].toInt() + 1, 0).day;
      i++
    ) {
      final String date = '${widget.yearmonth}-${i.toString().padLeft(2, '0')}';

      list.add(
        Card(
          color: Colors.blueGrey.withValues(alpha: 0.2),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: context.screenSize.height / 5),

              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[Text(i.toString().padLeft(2, '0')), const SizedBox.shrink()],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                                const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),

                        const Expanded(child: Column()),
                      ],
                    ),

                    if (lifetimeState.lifetimeMap[date] != null) ...<Widget>[
                      const SizedBox(height: 10),

                      Row(
                        // ignore: always_specify_types
                        children: List.generate(24, (index) => index).map((e) {
                          return getLifetimeDisplayCell(date: date, num: e);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
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

  ///
  Widget getLifetimeDisplayCell({required String date, required int num}) {
    List<String> dispValList = <String>[];
    if (lifetimeState.lifetimeMap[date] != null) {
      dispValList = <String>[
        lifetimeState.lifetimeMap[date]!.hour00,
        lifetimeState.lifetimeMap[date]!.hour01,
        lifetimeState.lifetimeMap[date]!.hour02,
        lifetimeState.lifetimeMap[date]!.hour03,
        lifetimeState.lifetimeMap[date]!.hour04,
        lifetimeState.lifetimeMap[date]!.hour05,
        lifetimeState.lifetimeMap[date]!.hour06,
        lifetimeState.lifetimeMap[date]!.hour07,
        lifetimeState.lifetimeMap[date]!.hour08,
        lifetimeState.lifetimeMap[date]!.hour09,
        lifetimeState.lifetimeMap[date]!.hour10,
        lifetimeState.lifetimeMap[date]!.hour11,
        lifetimeState.lifetimeMap[date]!.hour12,
        lifetimeState.lifetimeMap[date]!.hour13,
        lifetimeState.lifetimeMap[date]!.hour14,
        lifetimeState.lifetimeMap[date]!.hour15,
        lifetimeState.lifetimeMap[date]!.hour16,
        lifetimeState.lifetimeMap[date]!.hour17,
        lifetimeState.lifetimeMap[date]!.hour18,
        lifetimeState.lifetimeMap[date]!.hour19,
        lifetimeState.lifetimeMap[date]!.hour20,
        lifetimeState.lifetimeMap[date]!.hour21,
        lifetimeState.lifetimeMap[date]!.hour22,
        lifetimeState.lifetimeMap[date]!.hour23,
      ];
    }

    final Color color = utility.getLifetimeRowBgColor(value: dispValList[num], textDisplay: false);

    return Column(
      children: <Widget>[
        Container(
          width: context.screenSize.width / 35,

          margin: const EdgeInsets.all(1),

          decoration: BoxDecoration(color: color),

          child: Text(num.toString(), style: const TextStyle(fontSize: 5, color: Colors.transparent)),
        ),

        const SizedBox(height: 5),

        Text(
          (num % 6 == 0) ? num.toString() : '',
          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}
