import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/salary_model.dart';
import '../../models/tarot_history_model.dart';
import '../../models/tarot_model.dart';
import '../../models/temple_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../components/fortune_display_alert.dart';
import '../components/lifetime_geoloc_map_display_alert.dart';
import '../components/lifetime_input_alert.dart';
import '../components/money_data_input_alert.dart';
import '../components/tarot_info_display_alert.dart';
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

  // yearmonth (例: "2024-01") を一度だけ安全にパース
  late final int _year;
  late final int _month;
  late final String _safeYearMonth;

  ///
  @override
  void initState() {
    super.initState();
    final List<String> parts = widget.yearmonth.split('-');
    final DateTime now = DateTime.now();

    _year = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? now.year) : now.year;

    final int rawMonth = parts.length > 1 ? (int.tryParse(parts[1]) ?? now.month) : now.month;
    _month = rawMonth.clamp(1, 12);

    _safeYearMonth = '${_year.toString().padLeft(4, '0')}-${_month.toString().padLeft(2, '0')}';
  }

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
                    Container(
                      alignment: Alignment.center,
                      child: Text(_safeYearMonth, style: const TextStyle(fontSize: 24)),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// 一気ボタン / s
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (!autoScrollController.hasClients) {
                                  return;
                                }

                                final double max = autoScrollController.position.maxScrollExtent;
                                autoScrollController.jumpTo(max);
                              },
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(child: Icon(Icons.vertical_align_bottom, color: Colors.white)),
                              ),
                            ),

                            const SizedBox(width: 20),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (!autoScrollController.hasClients) {
                                  return;
                                }

                                autoScrollController.jumpTo(0.0);
                              },
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(child: Icon(Icons.vertical_align_top, color: Colors.white)),
                              ),
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
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(child: Icon(Icons.arrow_downward, color: Colors.white)),
                              ),
                            ),

                            const SizedBox(width: 20),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (_) => _startRepeating(() => _scrollBy(-_moveAmount)),
                              onTapUp: (_) => _stopRepeating(),
                              onTapCancel: _stopRepeating,
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(child: Icon(Icons.arrow_upward, color: Colors.white)),
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
    // 月の最終日を一度だけ計算
    final int lastDay = DateTime(_year, _month + 1, 0).day;

    final List<Widget> list = <Widget>[for (int i = 1; i <= lastDay; i++) _buildDayCard(day: i)];

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
  Widget _buildDayCard({required int day}) {
    final DateTime parsedDate = DateTime(_year, _month, day);
    final String date = parsedDate.yyyymmdd;
    final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

    // DateTime.now() は一度だけ取得
    final DateTime now = DateTime.now();

    Color cardColor = (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date))
        ? utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
        : Colors.blueGrey.withValues(alpha: 0.2);

    double constrainedBoxHeight = context.screenSize.height / 4.5;

    if (parsedDate.isAfter(now)) {
      cardColor = Colors.transparent;
      constrainedBoxHeight = context.screenSize.height / 15;
    }

    //////////////////////////////////////////////////////////////////////
    final DateTime beforeDate = parsedDate.add(const Duration(days: -1));

    // ?. 演算子で null を安全に扱う
    final String dateSum = appParamState.keepMoneyMap[date]?.sum ?? '';
    final String beforeSum = appParamState.keepMoneyMap[beforeDate.yyyymmdd]?.sum ?? '';

    int sumDiff = 0;
    if (beforeSum.isNotEmpty && dateSum.isNotEmpty) {
      sumDiff = beforeSum.toInt() - dateSum.toInt();
    }
    //////////////////////////////////////////////////////////////////////

    final List<GeolocModel>? geolocModelList = appParamState.keepGeolocMap[date];

    String boundingBoxArea = '';
    if (geolocModelList != null) {
      boundingBoxArea = utility.getBoundingBoxArea(points: geolocModelList);
    }

    TarotHistoryModel? tarotHistory;
    int qt = -1;
    String imageUrl = '';

    Icon? marubatsu;

    TarotModel? tarot;

    if (appParamState.keepTarotHistoryMap[date] != null) {
      tarotHistory = appParamState.keepTarotHistoryMap[date];

      qt = (tarotHistory!.reverse == '0') ? 0 : 2;
      imageUrl = 'http://toyohide.work/BrainLog/tarotcards/${tarotHistory.image}.jpg';

      tarot = appParamState.keepTarotMap[tarotHistory.image];

      if (tarot != null) {
        final int feel = (tarotHistory.reverse == '0') ? tarot.feelJ : tarot.feelR;
        marubatsu = (feel == 9)
            ? Icon(Icons.circle_outlined, color: Colors.greenAccent.withOpacity(0.4))
            : Icon(Icons.close, color: Colors.pinkAccent.withOpacity(0.8));
      }
    }

    return AutoScrollTag(
      // ignore: always_specify_types
      key: ValueKey(date),
      index: day - 1,
      controller: autoScrollController,

      child: Card(
        margin: parsedDate.isBeforeOrSameDate(now) ? null : EdgeInsets.only(right: context.screenSize.width * 0.5),

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
                                        Text(day.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 20)),
                                        const SizedBox(width: 5),
                                        Text(youbi),
                                      ],
                                    ),
                                    const SizedBox.shrink(),
                                  ],
                                ),

                                if (parsedDate.isBeforeOrSameDate(now)) ...<Widget>[
                                  const SizedBox(height: 10),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //====================================================// lifetime input // s
                                      GestureDetector(
                                        onTap: () {
                                          if (appParamState.keepLifetimeItemList.isEmpty) {
                                            // mounted チェックを追加して context を安全に使用
                                            if (mounted) {
                                              // ignore: always_specify_types
                                              Future.delayed(Duration.zero, () {
                                                if (mounted) {
                                                  error_dialog(
                                                    context: context,
                                                    title: '表示できません。',
                                                    content: 'appParamState.keepLifetimeItemListが作成されていません。',
                                                  );
                                                }
                                              });
                                            }

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
                                                    onTap: () => _onGeolocTap(
                                                      date: date,
                                                      geolocModelList: appParamState.keepGeolocMap[date]!,
                                                    ),

                                                    child: Column(
                                                      children: <Widget>[
                                                        Icon(
                                                          // startsWith で安全に先頭チェック
                                                          boundingBoxArea.startsWith('0.0')
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
                                                : const SizedBox.shrink(),
                                          ),

                                          if (parsedDate.isBeforeOrSameDate(now)) ...<Widget>[
                                            Positioned(
                                              top: 10,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                                radius: 14,

                                                child: Text(
                                                  appParamState.keepTimePlaceMap[date]?.length.toString() ?? '',

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

                                        child: (boundingBoxArea.isNotEmpty)
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
                                                              // split を安全に行うヘルパーで RangeError を防止
                                                              children: _buildBoundingBoxAreaSpans(boundingBoxArea),
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

                                      //====================================================// boundingBoxArea // e
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
                                                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(5),
                                                  // ?. 演算子で null-safe アクセス
                                                  child: Text(
                                                    appParamState.keepWalkModelMap[date]?.step
                                                            .toString()
                                                            .toCurrency() ??
                                                        '',
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
                                                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(
                                                    appParamState.keepWalkModelMap[date]?.distance
                                                            .toString()
                                                            .toCurrency() ??
                                                        '',
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
                                                    step: appParamState.keepWalkModelMap[date]?.step.toString() ?? '',
                                                    distance:
                                                        appParamState.keepWalkModelMap[date]?.distance.toString() ?? '',
                                                  ),
                                                ),
                                                child: Icon(Icons.input, color: Colors.white.withValues(alpha: 0.3)),
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
                                                          ? '0'
                                                          : appParamState.keepWalkModelMap[date]!.spend
                                                                .replaceAll('円', '')
                                                                .trim()
                                                    : sumDiff.toString().toCurrency(),
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
                                                    ? appParamState.keepMoneyMap[date]!.sum.toCurrency()
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              //====================================================// leo fortune // s
                              SizedBox(
                                width: 40,
                                child: (appParamState.keepFortuneMap[date] != null)
                                    ? GestureDetector(
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
                                                  child: Image.asset(
                                                    'assets/images/leo_mark.png',
                                                    width: 15,
                                                    height: 15,
                                                  ),
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

                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Builder(
                                                builder: (BuildContext context) {
                                                  final DateTime borderDate = DateTime(2026, 4, 9);
                                                  final DateTime parsedDate = DateTime(_year, _month, day);
                                                  final String label = parsedDate.isBefore(borderDate)
                                                      ? 'tomorrow'
                                                      : 'today';
                                                  return Text(label, style: const TextStyle(fontSize: 8));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : null,
                              ),

                              //====================================================// leo fortune // e
                              const SizedBox(width: 20),

                              //====================================================// tarot // s
                              SizedBox(
                                width: 40,
                                child: (appParamState.keepTarotHistoryMap[date] != null)
                                    ? GestureDetector(
                                        onTap: () {
                                          LifetimeDialog(
                                            context: context,
                                            widget: TarotInfoDisplayAlert(tarot: tarot, tarotHistory: tarotHistory),
                                          );
                                        },

                                        child: Stack(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 25,
                                                  child: Opacity(
                                                    opacity: 0.5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Builder(
                                                        builder: (BuildContext context) {
                                                          return RotatedBox(
                                                            quarterTurns: qt,
                                                            child: Image.network(imageUrl, width: 40),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 15),
                                              ],
                                            ),

                                            if (marubatsu != null) ...<Widget>[
                                              Positioned(right: 0, bottom: 0, child: marubatsu),
                                            ],
                                          ],
                                        ),
                                      )
                                    : null,
                              ),

                              //====================================================// tarot // e

                              //====================================================// weather // s
                              if (parsedDate.isBeforeOrSameDate(now) &&
                                  appParamState.keepWeatherMap[date] != null) ...<Widget>[
                                const SizedBox(width: 10),

                                Column(
                                  children: <Widget>[
                                    Builder(
                                      builder: (_) {
                                        final String w = appParamState.keepWeatherMap[date]!.weather;

                                        const Map<String, String> kanjiToKey = <String, String>{
                                          '晴': 'sunny',
                                          '曇': 'cloudy',
                                          '雨': 'rain',
                                          '雪': 'snow',
                                        };

                                        final List<MapEntry<int, String>> found = <MapEntry<int, String>>[];
                                        for (final MapEntry<String, String> e in kanjiToKey.entries) {
                                          final int idx = w.indexOf(e.key);
                                          if (idx >= 0) {
                                            found.add(MapEntry<int, String>(idx, e.value));
                                          }
                                        }
                                        found.sort(
                                          (MapEntry<int, String> a, MapEntry<int, String> b) => a.key.compareTo(b.key),
                                        );

                                        final String mainKey = found.isNotEmpty ? found[0].value : '';
                                        final String subKey = found.length > 1 ? found[1].value : '';

                                        if (mainKey.isEmpty) {
                                          return const SizedBox.shrink();
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                Opacity(
                                                  opacity: 0.3,
                                                  child: Image.asset(
                                                    'assets/images/weather/$mainKey.png',
                                                    width: 36,
                                                    height: 36,
                                                  ),
                                                ),

                                                if (subKey.isNotEmpty)
                                                  Positioned(
                                                    bottom: -4,
                                                    right: -4,
                                                    child: Opacity(
                                                      opacity: 0.3,
                                                      child: Image.asset(
                                                        'assets/images/weather/$subKey.png',
                                                        width: 18,
                                                        height: 18,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    Text(
                                      appParamState.keepWeatherMap[date]?.weather ?? '',
                                      style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
                                    ),
                                  ],
                                ),
                              ],

                              //====================================================// weather // e
                            ],
                          ),

                          const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// boundingBoxArea を整数部・小数部に安全に分割して TextSpan を生成
  /// split('.')[1] の RangeError を防止
  List<InlineSpan> _buildBoundingBoxAreaSpans(String boundingBoxArea) {
    final List<String> parts = boundingBoxArea.split('.');
    if (parts.length < 2) {
      return <InlineSpan>[
        TextSpan(
          text: boundingBoxArea,
          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ];
    }

    return <InlineSpan>[
      TextSpan(
        text: parts[0],
        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w900),
      ),
      TextSpan(
        text: '.${parts[1]}',
        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }

  /// geoloc タップ処理を抽出
  void _onGeolocTap({required String date, required List<GeolocModel> geolocModelList}) {
    try {
      appParamNotifier.setSelectedGeolocTime(time: '');
      appParamNotifier.setSelectedGeolocPointTime(time: '');
      appParamNotifier.setIsDisplayGhostGeolocPolyline(flag: false);
      appParamNotifier.setSelectedGhostPolylineDate(date: '');

      List<String> templeGeolocNearlyDateList = <String>[];

      if (appParamState.keepTempleMap[date] != null) {
        final Map<String, GeolocModel> nearestTempleNameGeolocModelMap = <String, GeolocModel>{};

        for (final TempleDataModel element in appParamState.keepTempleMap[date]!.templeDataList) {
          final GeolocModel? nearestGeolocModel = utility.findNearestGeoloc(
            geolocModelList: geolocModelList,
            latStr: element.latitude,
            lonStr: element.longitude,
          );

          if (nearestGeolocModel != null) {
            nearestTempleNameGeolocModelMap[element.name] = nearestGeolocModel;
          }
        }

        appParamNotifier.setKeepNearestTempleNameGeolocModelMap(map: nearestTempleNameGeolocModelMap);

        templeGeolocNearlyDateList = utility.getTempleGeolocNearlyDateList(
          date: date,
          templeMap: appParamState.keepTempleMap,
        );
      }

      LifetimeDialog(
        context: context,
        widget: LifetimeGeolocMapDisplayAlert(
          date: date,
          geolocList: geolocModelList,
          templeGeolocNearlyDateList: templeGeolocNearlyDateList,
        ),

        executeFunctionWhenDialogClose: true,
        from: 'LifetimeGeolocMapDisplayAlert',
        ref: ref,
      );
    } catch (e) {
      debugPrint('_onGeolocTap error: $e');
      if (mounted) {
        error_dialog(context: context, title: '表示できません。', content: '位置情報の表示処理でエラーが発生しました。');
      }
    }
  }

  ///
  Widget getLifetimeDisplayCell({required String date, required int num}) {
    final List<String> dispValList = (appParamState.keepLifetimeMap[date] != null)
        ? getLifetimeData(lifetimeModel: appParamState.keepLifetimeMap[date]!)
        : <String>[];

    // 境界チェック: dispValList の要素数が不足していても IndexError を起こさない
    if (num >= dispValList.length) {
      return const SizedBox.shrink();
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
          (num % 3 == 0) ? num.toString().padLeft(2, '0') : '',
          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}
