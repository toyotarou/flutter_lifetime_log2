import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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

  List<Widget> monthlyLifetimeList = <Widget>[];

  final AutoScrollController autoScrollController = AutoScrollController(axis: Axis.horizontal);

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
                  children: <Widget>[
                    Text(widget.yearmonth),

                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            autoScrollController.scrollToIndex(0);
                          },
                          icon: Icon(Icons.arrow_left, color: Colors.white.withValues(alpha: 0.3)),
                        ),

                        IconButton(
                          onPressed: () {
                            autoScrollController.scrollToIndex(monthlyLifetimeList.length);
                          },
                          icon: Icon(Icons.arrow_right, color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ],
                    ),
                  ],
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
    monthlyLifetimeList.clear();

    const double oneWidth = 120.0;

    int i = 0;
    appParamState.keepLifetimeMap.forEach((String key, LifetimeModel value) {
      if ('${key.split('-')[0]}-${key.split('-')[1]}' == widget.yearmonth) {
        final List<String> dispValList = getLifetimeData(lifetimeModel: value);

        final String youbi = DateTime.parse(key).youbiStr;

        final Color headColor =
            (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(key))
            ? utility.getYoubiColor(date: key, youbiStr: youbi, holiday: appParamState.keepHolidayList)
            : Colors.white.withValues(alpha: 0.1);

        final Map<String, List<String>> displayTemples = <String, List<String>>{};
        if (appParamState.keepTempleDateTimeBadgeMap[key] != null) {
          for (final String element in appParamState.keepTempleDateTimeBadgeMap[key]!) {
            final String? templeName = appParamState.keepTempleDateTimeNameMap['$key|$element'];
            if (templeName != null) {
              (displayTemples[element.split(':')[0]] ??= <String>[]).add(templeName);
            }
          }
        }

        monthlyLifetimeList.add(
          AutoScrollTag(
            // ignore: always_specify_types
            key: ValueKey(i),
            index: i,
            controller: autoScrollController,

            child: DefaultTextStyle(
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

                  displayLifetimeTimeItem(dispValList: dispValList, oneWidth: oneWidth, displayTemples: displayTemples),
                ],
              ),
            ),
          ),
        );

        i++;
      }
    });

    return SingleChildScrollView(
      child: SizedBox(
        height: context.screenSize.height * 0.7,

        child: SingleChildScrollView(
          controller: autoScrollController,
          scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: monthlyLifetimeList),
        ),
      ),
    );
  }

  ///
  Widget displayLifetimeTimeItem({
    required List<String> dispValList,
    required double oneWidth,
    required Map<String, List<String>> displayTemples,
  }) {
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
                children: <Widget>[const SizedBox.shrink(), Text((i % 3 == 0) ? i.toString().padLeft(2, '0') : '')],
              ),
              Text(dispValList[i]),

              if (displayTemples[i.toString().padLeft(2, '0')] != null) ...<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Row(
                      children: displayTemples[i.toString().padLeft(2, '0')]!.map((String e) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(FontAwesomeIcons.toriiGate, size: 10, color: Color(0xFFFBB6CE)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(children: list);
  }
}
