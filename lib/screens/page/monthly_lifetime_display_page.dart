import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';
import '../components/lifetime_display_alert.dart';
import '../components/lifetime_geoloc_map_display_alert.dart';
import '../components/lifetime_input_alert.dart';
import '../components/money_data_input_alert.dart';
import '../components/walk_data_input_alert.dart';
import '../parts/lifetime_dialog.dart';

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
                Row(
                  children: <Widget>[
                    const Expanded(child: Icon(Icons.square_outlined, color: Colors.transparent)),

                    Expanded(
                      child: Container(alignment: Alignment.center, child: Text(widget.yearmonth)),
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),

                          GestureDetector(
                            onTap: () {
                              LifetimeDialog(
                                context: context,
                                widget: LifetimeDisplayAlert(yearmonth: widget.yearmonth),
                              );
                            },
                            child: Icon(Icons.list, color: Colors.white.withValues(alpha: 0.3)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

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

      final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

      Color cardColor = (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date))
          ? utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
          : Colors.blueGrey.withValues(alpha: 0.2);

      double constrainedBoxHeight = context.screenSize.height / 7;

      if (DateTime(
        date.split('-')[0].toInt(),
        date.split('-')[1].toInt(),
        date.split('-')[2].toInt(),
      ).isAfter(DateTime.now())) {
        cardColor = Colors.transparent;

        constrainedBoxHeight = context.screenSize.height / 15;
      }

      list.add(
        Card(
          margin:
              (DateTime(
                date.split('-')[0].toInt(),
                date.split('-')[1].toInt(),
                date.split('-')[2].toInt(),
              ).isBefore(DateTime.now()))
              ? null
              : EdgeInsets.only(right: context.screenSize.width * 0.5),

          color: cardColor,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constrainedBoxHeight),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: context.screenSize.width * 0.3,

                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 5,
                                right: 10,
                                child: Column(
                                  children: <Widget>[
                                    if (appParamState.keepTempleMap[date] != null)
                                      Column(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.toriiGate,
                                            size: 20,
                                            color: Colors.white.withValues(alpha: 0.3),
                                          ),
                                          const SizedBox(height: 5),

                                          Text(
                                            appParamState.keepTempleMap[date]!.templeDataList.length.toString(),
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ],
                                      )
                                    else
                                      const SizedBox.shrink(),

                                    const SizedBox(height: 5),

                                    if (appParamState.keepTransportationMap[date] != null)
                                      const Icon(Icons.train)
                                    else
                                      const SizedBox.shrink(),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(i.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 20)),

                                          const SizedBox(width: 5),

                                          Text(youbi),
                                        ],
                                      ),
                                      const SizedBox.shrink(),
                                    ],
                                  ),

                                  if (DateTime(
                                    date.split('-')[0].toInt(),
                                    date.split('-')[1].toInt(),
                                    date.split('-')[2].toInt(),
                                  ).isBefore(DateTime.now())) ...<Widget>[
                                    const SizedBox(height: 10),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            LifetimeDialog(
                                              context: context,
                                              widget: LifetimeInputAlert(
                                                date: date,
                                                dateLifetime: lifetimeState.lifetimeMap[date],
                                              ),
                                            );
                                          },

                                          child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                                        ),

                                        const SizedBox(width: 20),

                                        GestureDetector(
                                          onTap: () {
                                            LifetimeDialog(
                                              context: context,

                                              widget: LifetimeGeolocMapDisplayAlert(
                                                date: date,
                                                geolocList: appParamState.keepGeolocMap[date],
                                                templeMap: templeState.templeMap[date],
                                              ),
                                            );
                                          },

                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.map, color: Colors.white.withValues(alpha: 0.3)),

                                              const SizedBox(height: 5),

                                              Text(
                                                (appParamState.keepGeolocMap[date] != null)
                                                    ? appParamState.keepGeolocMap[date]!.length.toString()
                                                    : '0',
                                                style: const TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: <Widget>[
                              if (lifetimeState.lifetimeMap[date] != null) ...<Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Text('🦶', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),

                                          Container(
                                            alignment: Alignment.topRight,

                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                              ),
                                            ),

                                            padding: const EdgeInsets.all(5),

                                            child: Text(
                                              (appParamState.keepWalkModelMap[date] != null)
                                                  ? appParamState.keepWalkModelMap[date]!.step.toString().toCurrency()
                                                  : '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Text('🚩', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),

                                          Container(
                                            alignment: Alignment.topRight,

                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                              ),
                                            ),

                                            padding: const EdgeInsets.all(5),

                                            child: Text(
                                              (appParamState.keepWalkModelMap[date] != null)
                                                  ? appParamState.keepWalkModelMap[date]!.distance
                                                        .toString()
                                                        .toCurrency()
                                                  : '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      width: 30,

                                      child: Container(
                                        alignment: Alignment.topRight,

                                        child: GestureDetector(
                                          onTap: () {
                                            LifetimeDialog(
                                              context: context,
                                              widget: WalkDataInputAlert(
                                                date: date,

                                                step: (appParamState.keepWalkModelMap[date] != null)
                                                    ? appParamState.keepWalkModelMap[date]!.step.toString()
                                                    : '',

                                                distance: (appParamState.keepWalkModelMap[date] != null)
                                                    ? appParamState.keepWalkModelMap[date]!.distance.toString()
                                                    : '',
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Text('👛', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),

                                          Container(
                                            alignment: Alignment.topRight,

                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                              ),
                                            ),

                                            padding: const EdgeInsets.all(5),

                                            child: Text(
                                              (appParamState.keepWalkModelMap[date] != null)
                                                  ? (appParamState.keepWalkModelMap[date]!.spend == '0')
                                                        ? '0 円'
                                                        : appParamState.keepWalkModelMap[date]!.spend
                                                  : '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Text('➡️', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),

                                          Container(
                                            alignment: Alignment.topRight,

                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                              ),
                                            ),

                                            padding: const EdgeInsets.all(5),

                                            child: Text(
                                              (appParamState.keepMoneyMap[date] != null)
                                                  ? '${appParamState.keepMoneyMap[date]!.sum.toCurrency()} 円'
                                                  : '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      width: 30,

                                      child: Container(
                                        alignment: Alignment.topRight,

                                        child: GestureDetector(
                                          onTap: () {
                                            moneyInputNotifier.setIsReplaceInputValueList(flag: false);

                                            moneyInputNotifier.setPos(pos: -1);

                                            LifetimeDialog(
                                              context: context,
                                              widget: MoneyDataInputAlert(date: date),
                                              executeFunctionWhenDialogClose: true,
                                              from: 'MoneyDataInputAlert',
                                              ref: ref,
                                            );
                                          },
                                          child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
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
          width: context.screenSize.width / 40,

          margin: const EdgeInsets.all(1),

          decoration: BoxDecoration(color: color),

          child: Text(num.toString(), style: const TextStyle(fontSize: 5, color: Colors.transparent)),
        ),

        const SizedBox(height: 5),

        Text(
          (num % 6 == 0) ? num.toString().padLeft(2, '0') : '',
          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}
