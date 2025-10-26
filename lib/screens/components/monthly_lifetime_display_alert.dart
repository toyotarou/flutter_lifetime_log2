import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/lifetime_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';

class MonthlyLifetimeDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyLifetimeDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyLifetimeDisplayAlert> createState() => _MonthlyLifetimeDisplayAlertState();
}

class _MonthlyLifetimeDisplayAlertState extends ConsumerState<MonthlyLifetimeDisplayAlert>
    with ControllersMixin<MonthlyLifetimeDisplayAlert> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.yearmonth), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayLifetime()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayLifetime() {
    final List<Widget> list = <Widget>[];

    const double oneWidth = 120.0;

    appParamState.keepLifetimeMap.forEach((String key, LifetimeModel value) {
      if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
        final List<String> dispValList = getOnedayLifetimeItemList(value: value);

        final String youbi = DateTime.parse(key).youbiStr;

        final Color headColor =
            (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(key))
            ? utility.getYoubiColor(date: key, youbiStr: youbi, holiday: appParamState.keepHolidayList)
            : Colors.white.withValues(alpha: 0.1);

        list.add(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: oneWidth,

                  decoration: BoxDecoration(color: headColor),
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),

                  child: Row(
                    children: <Widget>[
                      Text(key.split('-')[2], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 5),
                      Text(youbi),
                    ],
                  ),
                ),

                displayLifetimeTimeItem(dispValList: dispValList, oneWidth: oneWidth),
              ],
            ),
          ),
        );
      }
    });

    return SingleChildScrollView(
      child: SizedBox(
        height: context.screenSize.height * 0.7,

        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: list),
        ),
      ),
    );
  }

  ///
  Widget displayLifetimeTimeItem({required List<String> dispValList, required double oneWidth}) {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < dispValList.length; i++) {
      final Color color = utility.getLifetimeRowBgColor(value: dispValList[i], textDisplay: true);

      list.add(
        Container(
          width: oneWidth,

          decoration: BoxDecoration(color: color),
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(2),

          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const SizedBox.shrink(), Text((i % 6 == 0) ? i.toString().padLeft(2, '0') : '')],
              ),
              Text(dispValList[i]),
            ],
          ),
        ),
      );
    }

    return Column(children: list);
  }
}
