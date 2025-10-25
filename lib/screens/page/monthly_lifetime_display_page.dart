import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/lifetime_model.dart';
import '../../models/money_spend_model.dart';
import '../../models/salary_model.dart';
import '../../utility/utility.dart';
import '../components/lifetime_geoloc_map_display_alert.dart';
import '../components/lifetime_input_alert.dart';
import '../components/money_data_input_alert.dart';
import '../components/monthly_assets_display_alert.dart';
import '../components/monthly_lifetime_display_alert.dart';
import '../components/monthly_money_spend_display_alert.dart';
import '../components/monthly_work_time_display_alert.dart';
import '../components/walk_data_input_alert.dart';
import '../parts/error_dialog.dart';
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

  List<Map<String, String>> insuranceDataList = <Map<String, String>>[];

  List<Map<String, String>> nenkinKikinDataList = <Map<String, String>>[];

  ///
  @override
  Widget build(BuildContext context) {
    makeNenkinKikinDataList();

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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => LifetimeDialog(
                                  context: context,
                                  widget: MonthlyLifetimeDisplayAlert(yearmonth: widget.yearmonth),
                                ),
                                child: Icon(Icons.list, color: Colors.white.withValues(alpha: 0.3)),
                              ),

                              const SizedBox(width: 20),

                              GestureDetector(
                                onTap: () {
                                  if (appParamState.keepMoneySpendItemMap.isEmpty) {
                                    // ignore: always_specify_types
                                    Future.delayed(
                                      Duration.zero,
                                      () => error_dialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        title: '表示できません。',
                                        content: 'appParamState.keepMoneySpendItemMapが作成されていません。',
                                      ),
                                    );

                                    return;
                                  }

                                  LifetimeDialog(
                                    context: context,
                                    widget: MonthlyMoneySpendDisplayAlert(yearmonth: widget.yearmonth),
                                  );
                                },
                                child: Icon(Icons.money, color: Colors.white.withValues(alpha: 0.3)),
                              ),






                              /*






                              if (appParamState.keepGeolocMap.isNotEmpty) ...<Widget>[
                                const SizedBox(width: 20),

                                GestureDetector(
                                  onTap: () {
                                    if (DateTime.now().day == 1) {
                                      // ignore: always_specify_types
                                      Future.delayed(
                                        Duration.zero,
                                        () => error_dialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          title: '表示できません。',
                                          content: '今月分のgeolocが存在しません。',
                                        ),
                                      );

                                      return;
                                    }

                                    appParamNotifier.setSelectedYearMonth(yearmonth: widget.yearmonth);
                                    appParamNotifier.clearMonthlyGeolocMapSelectedDateList();

                                    LifetimeDialog(
                                      context: context,
                                      widget: MonthlyGeolocMapDisplayAlert(yearmonth: widget.yearmonth),
                                      executeFunctionWhenDialogClose: true,
                                      from: 'MonthlyGeolocMapDisplayAlert',
                                      ref: ref,
                                    );
                                  },
                                  child: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.3)),
                                ),
                              ],




                              */





                            ],
                          ),

                          const SizedBox.shrink(),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(alignment: Alignment.center, child: Text(widget.yearmonth)),
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),

                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (appParamState.keepGoldMap.isEmpty ||
                                      appParamState.keepStockMap.isEmpty ||
                                      appParamState.keepToushiShintakuMap.isEmpty) {
                                    // ignore: always_specify_types
                                    Future.delayed(
                                      Duration.zero,
                                      () => error_dialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        title: '表示できません。',
                                        content: '資産情報が作成されていません。',
                                      ),
                                    );

                                    return;
                                  }

                                  LifetimeDialog(
                                    context: context,
                                    widget: MonthlyAssetsDisplayAlert(
                                      yearmonth: widget.yearmonth,
                                      insuranceDataList: insuranceDataList,
                                      nenkinKikinDataList: nenkinKikinDataList,
                                    ),
                                  );
                                },
                                child: Icon(FontAwesomeIcons.sun, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                              ),

                              const SizedBox(width: 20),

                              GestureDetector(
                                onTap: () {
                                  if (appParamState.keepWorkTimeMap.isEmpty) {
                                    // ignore: always_specify_types
                                    Future.delayed(
                                      Duration.zero,
                                      () => error_dialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        title: '表示できません。',
                                        content: 'appParamState.keepWorkTimeMapが作成されていません。',
                                      ),
                                    );

                                    return;
                                  }

                                  LifetimeDialog(
                                    context: context,
                                    widget: MonthlyWorkTimeDisplayAlert(yearmonth: widget.yearmonth),
                                  );
                                },
                                child: Icon(Icons.work, color: Colors.white.withValues(alpha: 0.3)),
                              ),
                            ],
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
  void makeNenkinKikinDataList() {
    insuranceDataList.clear();
    nenkinKikinDataList.clear();

    appParamState.keepMoneySpendMap.forEach((String key, List<MoneySpendModel> value) {
      for (final MoneySpendModel element in value) {
        if (element.price == 55880) {
          insuranceDataList.add(<String, String>{'date': key, 'price': element.price.toString()});
        }

        if (element.item == '国民年金基金') {
          nenkinKikinDataList.add(<String, String>{'date': key, 'price': element.price.toString()});
        }
      }
    });
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

      double constrainedBoxHeight = context.screenSize.height / 6;

      if (DateTime.parse(date).isAfter(DateTime.now())) {
        cardColor = Colors.transparent;
        constrainedBoxHeight = context.screenSize.height / 15;
      }

      //////////////////////////////////////////////////////////////////////
      final DateTime beforeDate = DateTime(
        widget.yearmonth.split('-')[0].toInt(),
        widget.yearmonth.split('-')[1].toInt(),
        i,
      ).add(const Duration(days: -1));

      String dateSum = '';
      if (appParamState.keepMoneyMap[date] != null) {
        dateSum = appParamState.keepMoneyMap[date]!.sum;
      }

      String beforeSum = '';
      if (appParamState.keepMoneyMap[beforeDate.yyyymmdd] != null) {
        beforeSum = appParamState.keepMoneyMap[beforeDate.yyyymmdd]!.sum;
      }

      int sumDiff = 0;

      if (beforeSum != '' && dateSum != '') {
        sumDiff = beforeSum.toInt() - dateSum.toInt();
      }
      //////////////////////////////////////////////////////////////////////

      list.add(
        Card(
          margin: (DateTime.parse(date).isBeforeOrSameDate(DateTime.now()))
              ? null
              : EdgeInsets.only(right: context.screenSize.width * 0.5),

          color: cardColor,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constrainedBoxHeight),
              child: Stack(
                children: <Widget>[
                  if (appParamState.keepWorkTimeDateMap[date] != null &&
                      appParamState.keepWorkTimeDateMap[date]!['start'] != '' &&
                      appParamState.keepWorkTimeDateMap[date]!['end'] != '') ...<Widget>[
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.grey.withValues(alpha: 0.3)),
                        child: Row(
                          children: <Widget>[
                            const Text('🔨'),
                            const SizedBox(width: 20),
                            Text(appParamState.keepWorkTimeDateMap[date]!['start'] ?? ''),
                            const Text(' - '),
                            Text(appParamState.keepWorkTimeDateMap[date]!['end'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (DateTime.parse(date).isBeforeOrSameDate(DateTime.now())) ...<Widget>[
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.grey.withValues(alpha: 0.3)),
                        child: Text(
                          (appParamState.keepWeatherMap[date] != null)
                              ? appParamState.keepWeatherMap[date]!.weather
                              : '',
                        ),
                      ),
                    ),
                  ],

                  if (appParamState.keepSalaryMap[date] != null) ...<Widget>[
                    Positioned(
                      bottom: 30,
                      right: 10,
                      left: 10,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.diamond, color: Colors.yellowAccent.withValues(alpha: 0.3)),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: appParamState.keepSalaryMap[date]!.map((SalaryModel e) {
                                  return Text(
                                    e.salary.toString().toCurrency(),

                                    style: TextStyle(color: Colors.yellowAccent.withValues(alpha: 0.3)),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  Padding(
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
                                        if (appParamState.keepTempleMap[date] != null) ...<Widget>[
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
                                          ),
                                          const SizedBox(height: 10),
                                        ],

                                        if (appParamState.keepTransportationMap[date] != null) ...<Widget>[
                                          Icon(Icons.train, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                                        ],
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

                                      if (DateTime.parse(date).isBeforeOrSameDate(DateTime.now())) ...<Widget>[
                                        const SizedBox(height: 10),

                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                if (appParamState.keepLifetimeItemList.isEmpty) {
                                                  // ignore: always_specify_types
                                                  Future.delayed(
                                                    Duration.zero,
                                                    () => error_dialog(
                                                      // ignore: use_build_context_synchronously
                                                      context: context,
                                                      title: '表示できません。',
                                                      content: 'appParamState.keepLifetimeItemListが作成されていません。',
                                                    ),
                                                  );

                                                  return;
                                                }

                                                LifetimeDialog(
                                                  context: context,
                                                  widget: LifetimeInputAlert(
                                                    date: date,
                                                    dateLifetime: appParamState.keepLifetimeMap[date],
                                                  ),
                                                );
                                              },

                                              child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
                                            ),

                                            const SizedBox(width: 20),

                                            if (appParamState.keepGeolocMap[date] != null) ...<Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  appParamNotifier.setSelectedGeolocTime(time: '');

                                                  LifetimeDialog(
                                                    context: context,
                                                    widget: LifetimeGeolocMapDisplayAlert(
                                                      date: date,
                                                      geolocList: appParamState.keepGeolocMap[date],
                                                      temple: appParamState.keepTempleMap[date],
                                                      transportation: appParamState.keepTransportationMap[date],
                                                    ),

                                                    executeFunctionWhenDialogClose: true,
                                                    from: 'LifetimeGeolocMapDisplayAlert',
                                                    ref: ref,
                                                  );
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(Icons.map, color: Colors.white.withValues(alpha: 0.3)),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      appParamState.keepGeolocMap[date]!.length.toString(),
                                                      style: const TextStyle(fontSize: 8),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],

                                            if (appParamState.keepGeolocMap[date] == null) ...<Widget>[
                                              const SizedBox(height: 38),
                                            ],
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
                                  if (appParamState.keepLifetimeMap[date] != null) ...<Widget>[
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
                                                      ? appParamState.keepWalkModelMap[date]!.step
                                                            .toString()
                                                            .toCurrency()
                                                      : '',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),

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
                                              onTap: () => LifetimeDialog(
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
                                              ),
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
                                                      : '${sumDiff.toString().toCurrency()} 円',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),

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

                        if (appParamState.keepLifetimeMap[date] != null) ...<Widget>[
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

                  if (DateTime.parse(date).isBeforeOrSameDate(DateTime.now())) ...<Widget>[
                    Positioned(
                      top: 45,
                      left: 70,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        radius: 14,

                        child: Text(
                          (appParamState.keepTimePlaceMap[date] != null)
                              ? appParamState.keepTimePlaceMap[date]!.length.toString()
                              : '',

                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ],
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
    if (appParamState.keepLifetimeMap[date] != null) {
      final LifetimeModel? dataMap = appParamState.keepLifetimeMap[date];

      dispValList = <String>[
        dataMap!.hour00,
        dataMap.hour01,
        dataMap.hour02,
        dataMap.hour03,
        dataMap.hour04,
        dataMap.hour05,
        dataMap.hour06,
        dataMap.hour07,
        dataMap.hour08,
        dataMap.hour09,
        dataMap.hour10,
        dataMap.hour11,
        dataMap.hour12,
        dataMap.hour13,
        dataMap.hour14,
        dataMap.hour15,
        dataMap.hour16,
        dataMap.hour17,
        dataMap.hour18,
        dataMap.hour19,
        dataMap.hour20,
        dataMap.hour21,
        dataMap.hour22,
        dataMap.hour23,
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
