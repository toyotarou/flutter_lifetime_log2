import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/fortune_model.dart';
import '../../models/geoloc_model.dart';
import '../../models/lifetime_model.dart';
import '../../models/money_model.dart';
import '../../models/money_spend_model.dart';
import '../../models/salary_model.dart';
import '../../models/tarot_history_model.dart';
import '../../models/tarot_model.dart';
import '../../models/temple_model.dart';
import '../../models/time_place_model.dart';
import '../../models/transportation_model.dart';
import '../../models/walk_model.dart';
import '../../models/weather_model.dart';
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
  late final DateTime _pageOpenTime;

  /// 日付ごとの面積表示文字列キャッシュ（geoloc リストが同一インスタンスなら再計算しない）
  final Map<String, (List<GeolocModel>, String)> _boundingBoxAreaCache = <String, (List<GeolocModel>, String)>{};

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
    _pageOpenTime = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTodayIfCurrentMonth();
    });
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
    // 日付カードで使う項目だけを購読する。
    // appParamState 全体を watch すると、ダイアログ内の選択状態などが変わるたびに全タブの全カードが再構築されていた。
    final _DayCardSource src = ref.watch(appParamProvider.select(_DayCardSource.fromState));

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

                Expanded(child: _displayMonthlyLifetimeList(src)),
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
  void _scrollToTodayIfCurrentMonth() {
    final DateTime now = DateTime.now();
    if (_year != now.year || _month != now.month) {
      return;
    }

    final int todayIndex = now.day - 1;

    // ignore: always_specify_types
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && autoScrollController.hasClients) {
        autoScrollController.scrollToIndex(todayIndex, preferPosition: AutoScrollPosition.begin);
      }
    });
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
  Widget _displayMonthlyLifetimeList(_DayCardSource src) {
    // 月の最終日を一度だけ計算
    final int lastDay = DateTime(_year, _month + 1, 0).day;

    return CustomScrollView(
      controller: autoScrollController,

      slivers: <Widget>[
        SliverList(
          // 表示される日のカードだけを遅延生成する
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => DayFlipCard(
              dayIndex: index,
              pageOpenTime: _pageOpenTime,
              child: _buildDayCard(day: index + 1, src: src),
            ),
            childCount: lastDay,
          ),
        ),
      ],
    );
  }

  ///
  String _getBoundingBoxArea({required String date, required List<GeolocModel> geolocModelList}) {
    final (List<GeolocModel>, String)? cached = _boundingBoxAreaCache[date];

    if (cached != null && identical(cached.$1, geolocModelList)) {
      return cached.$2;
    }

    final String area = utility.getBoundingBoxArea(points: geolocModelList);
    _boundingBoxAreaCache[date] = (geolocModelList, area);

    return area;
  }

  ///
  Widget _buildDayCard({required int day, required _DayCardSource src}) {
    final DateTime parsedDate = DateTime(_year, _month, day);
    final String date = parsedDate.yyyymmdd;
    final String youbi = '$date 00:00:00'.toDateTime().youbiStr;

    // DateTime.now() は一度だけ取得
    final DateTime now = DateTime.now();

    Color cardColor = (youbi == 'Saturday' || youbi == 'Sunday' || src.keepHolidayList.contains(date))
        ? utility.getYoubiColor(date: date, youbiStr: youbi, holiday: src.keepHolidayList)
        : Colors.blueGrey.withValues(alpha: 0.2);

    double constrainedBoxHeight = context.screenSize.height / 4.5;

    if (parsedDate.isAfter(now)) {
      cardColor = Colors.transparent;
      constrainedBoxHeight = context.screenSize.height / 15;
    }

    //////////////////////////////////////////////////////////////////////
    final DateTime beforeDate = parsedDate.add(const Duration(days: -1));

    // ?. 演算子で null を安全に扱う
    final String dateSum = src.keepMoneyMap[date]?.sum ?? '';
    final String beforeSum = src.keepMoneyMap[beforeDate.yyyymmdd]?.sum ?? '';

    int sumDiff = 0;
    if (beforeSum.isNotEmpty && dateSum.isNotEmpty) {
      sumDiff = beforeSum.toInt() - dateSum.toInt();
    }
    //////////////////////////////////////////////////////////////////////

    final List<GeolocModel>? geolocModelList = src.keepGeolocMap[date];

    String boundingBoxArea = '';
    if (geolocModelList != null) {
      boundingBoxArea = _getBoundingBoxArea(date: date, geolocModelList: geolocModelList);
    }

    // 24時間分の行動データ（セルごとに作り直さない）
    final LifetimeModel? dateLifetime = src.keepLifetimeMap[date];
    final List<String> lifetimeData = (dateLifetime != null)
        ? getLifetimeData(lifetimeModel: dateLifetime)
        : <String>[];

    TarotHistoryModel? tarotHistory;
    int qt = -1;
    String imageUrl = '';

    Icon? marubatsu;

    TarotModel? tarot;

    if (src.keepTarotHistoryMap[date] != null) {
      tarotHistory = src.keepTarotHistoryMap[date];

      qt = (tarotHistory!.reverse == '0') ? 0 : 2;
      imageUrl = 'http://toyohide.work/BrainLog/tarotcards/${tarotHistory.image}.jpg';

      tarot = src.keepTarotMap[tarotHistory.image];

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
                if (src.keepWorkTimeDateMap[date] != null &&
                    src.keepWorkTimeDateMap[date]!['start'] != '' &&
                    src.keepWorkTimeDateMap[date]!['end'] != '') ...<Widget>[
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.grey.withValues(alpha: 0.3)),
                      child: Row(
                        children: <Widget>[
                          const Text('🔨'),
                          const SizedBox(width: 20),
                          Text(src.keepWorkTimeDateMap[date]!['start'] ?? ''),
                          const Text(' - '),
                          Text(src.keepWorkTimeDateMap[date]!['end'] ?? ''),
                        ],
                      ),
                    ),
                  ),
                ],

                /// 収入
                if (src.keepSalaryMap[date] != null) ...<Widget>[
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
                              children: src.keepSalaryMap[date]!.map((SalaryModel e) {
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
                      if (src.keepTempleMap[date] != null) ...<Widget>[
                        const SizedBox(width: 10),
                        Column(
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.toriiGate, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                            const SizedBox(height: 10),
                            Text(
                              src.keepTempleMap[date]!.templeDataList.length.toString(),
                              style: const TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      //====================================================// temple // e

                      //====================================================// train // s
                      if (src.keepTransportationMap[date] != null) ...<Widget>[
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
                                          if (ref.read(appParamProvider).keepLifetimeItemList.isEmpty) {
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
                                              dateLifetime: src.keepLifetimeMap[date],
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
                                            child: (src.keepGeolocMap[date] != null)
                                                ? GestureDetector(
                                                    onTap: () => _onGeolocTap(
                                                      date: date,
                                                      geolocModelList: src.keepGeolocMap[date]!,
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
                                                          src.keepGeolocMap[date]!.length.toString(),
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
                                                  src.keepTimePlaceMap[date]?.length.toString() ?? '',

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
                                if (src.keepLifetimeMap[date] != null) ...<Widget>[
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
                                                    src.keepWalkModelMap[date]?.step
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
                                                    src.keepWalkModelMap[date]?.distance
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
                                                    step: src.keepWalkModelMap[date]?.step.toString() ?? '',
                                                    distance:
                                                        src.keepWalkModelMap[date]?.distance.toString() ?? '',
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
                                                (src.keepWalkModelMap[date] != null)
                                                    ? (src.keepWalkModelMap[date]!.spend == '0')
                                                          ? '0'
                                                          : src.keepWalkModelMap[date]!.spend
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
                                                (src.keepMoneyMap[date] != null)
                                                    ? src.keepMoneyMap[date]!.sum.toCurrency()
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
                      if (src.keepLifetimeMap[date] != null) ...<Widget>[
                        const SizedBox(height: 10),
                        Row(
                          // ignore: always_specify_types
                          children: List.generate(
                            24,
                            (int index) => index,
                          ).map((int e) => getLifetimeDisplayCell(dispValList: lifetimeData, num: e)).toList(),
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
                                child: (src.keepFortuneMap[date] != null)
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
                                                    src.keepFortuneMap[date]!.rank,
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
                                child: (src.keepTarotHistoryMap[date] != null)
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
                                  src.keepWeatherMap[date] != null) ...<Widget>[
                                const SizedBox(width: 10),

                                Column(
                                  children: <Widget>[
                                    Builder(
                                      builder: (_) {
                                        final String w = src.keepWeatherMap[date]!.weather;

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
                                      src.keepWeatherMap[date]?.weather ?? '',
                                      style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
                                    ),
                                  ],
                                ),
                              ],

                              //====================================================// weather // e
                              if (src.keepOhakamairiDataMap.containsKey(date)) ...<Widget>[
                                const SizedBox(width: 25),
                                Column(
                                  children: <Widget>[
                                    const SizedBox(height: 5),

                                    Opacity(
                                      opacity: 0.5,
                                      child: Image.asset('assets/images/toyoda_kamon.png', width: 30, height: 30),
                                    ),
                                  ],
                                ),
                              ],
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
    // コールバック内なので watch ではなく read で参照する
    final AppParamState appParamState = ref.read(appParamProvider);

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
  Widget getLifetimeDisplayCell({required List<String> dispValList, required int num}) {
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

/// 日付カードの表示に使う appParamState の項目
///
/// select() で購読し、ここに含まれる Map / List のいずれかが差し替わった時だけ再構築する。
/// freezed の getter が返す EqualUnmodifiableXxxView の == は「中身のインスタンスが同一か」で比較するため軽量。
@immutable
class _DayCardSource {
  const _DayCardSource({
    required this.keepHolidayList,
    required this.keepMoneyMap,
    required this.keepGeolocMap,
    required this.keepTarotHistoryMap,
    required this.keepTarotMap,
    required this.keepWorkTimeDateMap,
    required this.keepSalaryMap,
    required this.keepTempleMap,
    required this.keepTransportationMap,
    required this.keepTimePlaceMap,
    required this.keepLifetimeMap,
    required this.keepWalkModelMap,
    required this.keepFortuneMap,
    required this.keepWeatherMap,
    required this.keepOhakamairiDataMap,
  });

  factory _DayCardSource.fromState(AppParamState s) => _DayCardSource(
    keepHolidayList: s.keepHolidayList,
    keepMoneyMap: s.keepMoneyMap,
    keepGeolocMap: s.keepGeolocMap,
    keepTarotHistoryMap: s.keepTarotHistoryMap,
    keepTarotMap: s.keepTarotMap,
    keepWorkTimeDateMap: s.keepWorkTimeDateMap,
    keepSalaryMap: s.keepSalaryMap,
    keepTempleMap: s.keepTempleMap,
    keepTransportationMap: s.keepTransportationMap,
    keepTimePlaceMap: s.keepTimePlaceMap,
    keepLifetimeMap: s.keepLifetimeMap,
    keepWalkModelMap: s.keepWalkModelMap,
    keepFortuneMap: s.keepFortuneMap,
    keepWeatherMap: s.keepWeatherMap,
    keepOhakamairiDataMap: s.keepOhakamairiDataMap,
  );

  final List<String> keepHolidayList;
  final Map<String, MoneyModel> keepMoneyMap;
  final Map<String, List<GeolocModel>> keepGeolocMap;
  final Map<String, TarotHistoryModel> keepTarotHistoryMap;
  final Map<String, TarotModel> keepTarotMap;
  final Map<String, Map<String, String>> keepWorkTimeDateMap;
  final Map<String, List<SalaryModel>> keepSalaryMap;
  final Map<String, TempleModel> keepTempleMap;
  final Map<String, TransportationModel> keepTransportationMap;
  final Map<String, List<TimePlaceModel>> keepTimePlaceMap;
  final Map<String, LifetimeModel> keepLifetimeMap;
  final Map<String, WalkModel> keepWalkModelMap;
  final Map<String, FortuneModel> keepFortuneMap;
  final Map<String, WeatherModel> keepWeatherMap;
  final Map<String, List<MoneySpendModel>> keepOhakamairiDataMap;

  @override
  bool operator ==(Object other) =>
      other is _DayCardSource &&
      other.keepHolidayList == keepHolidayList &&
      other.keepMoneyMap == keepMoneyMap &&
      other.keepGeolocMap == keepGeolocMap &&
      other.keepTarotHistoryMap == keepTarotHistoryMap &&
      other.keepTarotMap == keepTarotMap &&
      other.keepWorkTimeDateMap == keepWorkTimeDateMap &&
      other.keepSalaryMap == keepSalaryMap &&
      other.keepTempleMap == keepTempleMap &&
      other.keepTransportationMap == keepTransportationMap &&
      other.keepTimePlaceMap == keepTimePlaceMap &&
      other.keepLifetimeMap == keepLifetimeMap &&
      other.keepWalkModelMap == keepWalkModelMap &&
      other.keepFortuneMap == keepFortuneMap &&
      other.keepWeatherMap == keepWeatherMap &&
      other.keepOhakamairiDataMap == keepOhakamairiDataMap;

  @override
  int get hashCode => Object.hashAll(<Object>[
    keepHolidayList,
    keepMoneyMap,
    keepGeolocMap,
    keepTarotHistoryMap,
    keepTarotMap,
    keepWorkTimeDateMap,
    keepSalaryMap,
    keepTempleMap,
    keepTransportationMap,
    keepTimePlaceMap,
    keepLifetimeMap,
    keepWalkModelMap,
    keepFortuneMap,
    keepWeatherMap,
    keepOhakamairiDataMap,
  ]);
}
