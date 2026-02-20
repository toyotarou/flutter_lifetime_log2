import 'dart:async';

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
import '../components/fortune_display_alert.dart';
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

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    autoScrollController.dispose();
    super.dispose();
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
                Stack(
                  children: <Widget>[
                    Container(alignment: Alignment.center, child: Text(widget.yearmonth)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// 一気ボタン / s
                        Row(
                          children: <Widget>[
                            IconButton(
                              tooltip: '一気に下',
                              onPressed: () {
                                if (!autoScrollController.hasClients) {
                                  return;
                                }

                                final double max = autoScrollController.position.maxScrollExtent;
                                autoScrollController.jumpTo(max);
                              },
                              icon: Icon(Icons.vertical_align_bottom, color: Colors.white.withValues(alpha: 0.3)),
                            ),

                            IconButton(
                              tooltip: '一気に上',
                              onPressed: () {
                                if (!autoScrollController.hasClients) {
                                  return;
                                }

                                autoScrollController.jumpTo(0.0);
                              },
                              icon: Icon(Icons.vertical_align_top, color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ],
                        ),

                        /// 一気ボタン / e
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (_) => _startRepeating(() => _scrollBy(_moveAmount)),
                              onTapUp: (_) => _stopRepeating(),
                              onTapCancel: _stopRepeating,
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: Icon(Icons.arrow_downward, color: Colors.white.withValues(alpha: 0.3)),
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (_) => _startRepeating(() => _scrollBy(-_moveAmount)),
                              onTapUp: (_) => _stopRepeating(),
                              onTapCancel: _stopRepeating,
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: Icon(Icons.arrow_upward, color: Colors.white.withValues(alpha: 0.3)),
                                ),
                              ),
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
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!autoScrollController.hasClients) {
      return;
    }

    final ScrollPosition pos = autoScrollController.position;
    final double newOffset = (autoScrollController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    autoScrollController.jumpTo(newOffset);
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

      double constrainedBoxHeight = context.screenSize.height / 4.5;

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
                    /// 勤務時間
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

                    /// 天気
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

                    /// 収入
                    if (appParamState.keepSalaryMap[date] != null) ...<Widget>[
                      Positioned(
                        bottom: 25,
                        right: 10,
                        left: 10,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox.shrink(),

                            Column(
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

                    Positioned(
                      top: 20,
                      left: 90,
                      child: Column(
                        children: <Widget>[
                          //====================================================// temple // s
                          if (appParamState.keepTempleMap[date] != null) ...<Widget>[
                            const SizedBox(width: 10),
                            Column(
                              children: <Widget>[
                                Icon(FontAwesomeIcons.toriiGate, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                                const SizedBox(height: 10),
                                Text(
                                  appParamState.keepTempleMap[date]!.templeDataList.length.toString(),
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          //====================================================// temple // e

                          //====================================================// train // s
                          if (appParamState.keepTransportationMap[date] != null) ...<Widget>[
                            const SizedBox(width: 10),
                            Icon(Icons.train, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                          ],

                          //====================================================// train // e
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: context.screenSize.width * 0.3,

                                child: Column(
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
                                          //====================================================// lifetime input // s
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

                                          //====================================================// lifetime input // e
                                          const SizedBox(width: 15),

                                          //====================================================// geoloc // s
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width: 45,
                                                height: 40,
                                                alignment: Alignment.topLeft,
                                                child: (appParamState.keepGeolocMap[date] != null)
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          appParamNotifier.setSelectedGeolocTime(time: '');

                                                          appParamNotifier.setSelectedGeolocPointTime(time: '');

                                                          appParamNotifier.setIsDisplayGhostGeolocPolyline(flag: false);
                                                          appParamNotifier.setSelectedGhostPolylineDate(date: '');

                                                          List<String> templeGeolocNearlyDateList = <String>[];

                                                          if (appParamState.keepTempleMap[date] != null) {
                                                            //////////////////////////////////////////////
                                                            final Map<String, GeolocModel>
                                                            nearestTempleNameGeolocModelMap = <String, GeolocModel>{};

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

                                                            appParamNotifier.setKeepNearestTempleNameGeolocModelMap(
                                                              map: nearestTempleNameGeolocModelMap,
                                                            );

                                                            //////////////////////////////////////////////

                                                            templeGeolocNearlyDateList = utility
                                                                .getTempleGeolocNearlyDateList(
                                                                  date: date,
                                                                  templeMap: appParamState.keepTempleMap,
                                                                );
                                                          }

                                                          LifetimeDialog(
                                                            context: context,
                                                            widget: LifetimeGeolocMapDisplayAlert(
                                                              date: date,
                                                              geolocList: appParamState.keepGeolocMap[date],
                                                              templeGeolocNearlyDateList: templeGeolocNearlyDateList,
                                                            ),

                                                            executeFunctionWhenDialogClose: true,
                                                            from: 'LifetimeGeolocMapDisplayAlert',
                                                            ref: ref,
                                                          );
                                                        },

                                                        child: Column(
                                                          children: <Widget>[
                                                            Icon(
                                                              (boundingBoxArea.substring(0, 3) == '0.0')
                                                                  ? Icons.home_outlined
                                                                  : Icons.map,
                                                              color: Colors.white.withValues(alpha: 0.3),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              appParamState.keepGeolocMap[date]!.length.toString(),
                                                              style: const TextStyle(fontSize: 8),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                              ),

                                              if (DateTime.parse(date).isBeforeOrSameDate(DateTime.now())) ...<Widget>[
                                                Positioned(
                                                  top: 10,
                                                  right: 0,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                                                    radius: 14,

                                                    child: Text(
                                                      (appParamState.keepTimePlaceMap[date] != null)
                                                          ? appParamState.keepTimePlaceMap[date]!.length.toString()
                                                          : '',

                                                      style: TextStyle(
                                                        color: Colors.white.withValues(alpha: 0.5),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),

                                          //====================================================// geoloc // e
                                          const SizedBox(width: 15),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    if (appParamState.keepLifetimeMap[date] != null) ...<Widget>[
                                      Stack(
                                        children: <Widget>[
                                          //====================================================// boundingBoxArea // s
                                          SizedBox(
                                            height: 40,

                                            child: (boundingBoxArea != '')
                                                ? Row(
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
                                                  )
                                                : const SizedBox(),
                                          ),

                                          //====================================================// boundingBoxArea // s
                                          Row(
                                            children: <Widget>[
                                              //====================================================// step // s
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

                                              //====================================================// step // e
                                              const SizedBox(width: 5),

                                              //====================================================// distance // s
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

                                              //====================================================// distance // e

                                              //====================================================// step input // s
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

                                              //====================================================// step input // e
                                            ],
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: <Widget>[
                                          //====================================================// spend // s
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

                                          //====================================================// spend // e
                                          const SizedBox(width: 5),

                                          //====================================================// money // s
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

                                          //====================================================// money // e

                                          //====================================================// money input // s
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

                                          //====================================================// money input // e
                                        ],
                                      ),

                                      const SizedBox(height: 10),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //====================================================// hour // s
                          if (appParamState.keepLifetimeMap[date] != null) ...<Widget>[
                            const SizedBox(height: 10),
                            Row(
                              // ignore: always_specify_types
                              children: List.generate(
                                24,
                                (int index) => index,
                              ).map((int e) => getLifetimeDisplayCell(date: date, num: e)).toList(),
                            ),
                          ],

                          //====================================================// hour // e

                          //====================================================// leo fortune // s
                          if (appParamState.keepFortuneMap[date] != null) ...<Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    LifetimeDialog(
                                      context: context,
                                      widget: FortuneDisplayAlert(date: date),
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Opacity(
                                          opacity: 0.4,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.orangeAccent.withValues(alpha: 0.4),
                                            child: Image.asset('assets/images/leo_mark.png', width: 15, height: 15),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(alpha: 0.2),
                                          ),

                                          child: Center(
                                            child: Text(
                                              appParamState.keepFortuneMap[date]!.rank,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const Positioned(
                                        bottom: 0,
                                        right: 0,

                                        child: Text('tomorrow', style: TextStyle(fontSize: 8)),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox.shrink(),
                              ],
                            ),
                          ],

                          //====================================================// leo fortune // e
                        ],
                      ),
                    ),
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
