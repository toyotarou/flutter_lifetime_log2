import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/salary_model.dart';
import '../../models/temple_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../components/lifetime_geoloc_map_display_alert.dart';
import '../components/lifetime_input_alert.dart';
import '../components/money_data_input_alert.dart';
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

  final AutoScrollController autoScrollController = AutoScrollController();

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
                Stack(
                  children: <Widget>[
                    Container(alignment: Alignment.center, child: Text(widget.yearmonth)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox.shrink(),

                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => autoScrollController.scrollToIndex(
                                DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
                              ),
                              child: Icon(Icons.arrow_downward, color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => autoScrollController.scrollToIndex(0),
                              child: Icon(Icons.arrow_upward, color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ],
                        ),
                      ],
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

      final List<GeolocModel>? geolocModelList = appParamState.keepGeolocMap[date];

      String boundingBoxArea = '';
      if (geolocModelList != null) {
        boundingBoxArea = utility.getBoundingBoxArea(points: geolocModelList);
      }

      list.add(
        AutoScrollTag(
          // ignore: always_specify_types
          key: ValueKey(i),
          index: i,
          controller: autoScrollController,

          child: Card(
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
                                                Text(
                                                  i.toString().padLeft(2, '0'),
                                                  style: const TextStyle(fontSize: 20),
                                                ),
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
                                                      isReloadHomeScreen: true,
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

                                                    if (appParamState.keepTempleMap[date] != null) {
                                                      final Map<String, GeolocModel> nearestTempleNameGeolocModelMap =
                                                          <String, GeolocModel>{};

                                                      for (final TempleDataModel element
                                                          in appParamState.keepTempleMap[date]!.templeDataList) {
                                                        final GeolocModel? nearestGeolocModel = utility
                                                            .findNearestGeoloc(
                                                              geolocModelList: appParamState.keepGeolocMap[date]!,
                                                              latStr: element.latitude,
                                                              lonStr: element.longitude,
                                                            );

                                                        if (nearestGeolocModel != null) {
                                                          nearestTempleNameGeolocModelMap[element.name] =
                                                              nearestGeolocModel;
                                                        }
                                                      }

                                                      // ignore: always_specify_types
                                                      Future(() {
                                                        appParamNotifier.setKeepNearestTempleNameGeolocModelMap(
                                                          map: nearestTempleNameGeolocModelMap,
                                                        );
                                                      });
                                                    }

                                                    LifetimeDialog(
                                                      context: context,
                                                      widget: LifetimeGeolocMapDisplayAlert(
                                                        date: date,
                                                        geolocList: appParamState.keepGeolocMap[date],
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
                                      Stack(
                                        children: <Widget>[
                                          if (boundingBoxArea != '') ...<Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(width: context.screenSize.width * 0.1),

                                                Expanded(
                                                  child: Opacity(
                                                    opacity: 0.3,
                                                    child: Container(
                                                      alignment: Alignment.topRight,
                                                      padding: const EdgeInsets.only(top: 15),
                                                      child: Transform(
                                                        alignment: Alignment.centerLeft,
                                                        transform: Matrix4.identity()..setEntry(0, 1, -0.8),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: <InlineSpan>[
                                                              TextSpan(
                                                                text: boundingBoxArea.split('.')[0],
                                                                style: const TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w900,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '.${boundingBoxArea.split('.')[1]}',
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 40),
                                              ],
                                            ),
                                          ],

                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Stack(
                                                  children: <Widget>[
                                                    Text(
                                                      '🦶',
                                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topRight,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.white.withValues(alpha: 0.3),
                                                          ),
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
                                                    Text(
                                                      '🚩',
                                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topRight,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.white.withValues(alpha: 0.3),
                                                          ),
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
                                                    child: Icon(
                                                      Icons.input,
                                                      color: Colors.white.withValues(alpha: 0.3),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Stack(
                                              children: <Widget>[
                                                Text(
                                                  '👛',
                                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                                ),

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
                                                Text(
                                                  '➡️',
                                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                                ),

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
        ),
      );
    }

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

  ///
  Widget getLifetimeDisplayCell({required String date, required int num}) {
    final List<String> dispValList = (appParamState.keepLifetimeMap[date] != null)
        ? getLifetimeData(lifetimeModel: appParamState.keepLifetimeMap[date]!)
        : <String>[];

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
          (num % 3 == 0) ? num.toString().padLeft(2, '0') : '',
          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}
