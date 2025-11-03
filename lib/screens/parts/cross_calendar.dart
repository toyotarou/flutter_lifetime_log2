import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/weekly_history_badge_model.dart';
import '../../models/weekly_history_event_model.dart';
import '../../utils/date_lifetime_utils.dart';
import '../../utils/ui_utils.dart';
import '../components/weekly_history_alert.dart';
import '../parts/diagonal_slash_painter.dart';
import 'lifetime_dialog.dart';

class CrossCalendar extends ConsumerStatefulWidget {
  const CrossCalendar({
    super.key,
    required this.years,
    required this.monthDays,
    required this.headerHeight,
    required this.leftColWidth,
    required this.rowHeights,
    required this.colWidths,
  }) : assert(rowHeights.length == years.length + 1),
       assert(colWidths.length == monthDays.length + 1);

  final List<String> years;
  final List<String> monthDays;

  final double headerHeight;
  final double leftColWidth;
  final List<double> rowHeights;
  final List<double> colWidths;

  @override
  ConsumerState<CrossCalendar> createState() => _CrossCalendarState();
}

class _CrossCalendarState extends ConsumerState<CrossCalendar> with ControllersMixin<CrossCalendar> {
  late final AutoScrollController horizontalHeaderAutoScrollController;
  late final AutoScrollController horizontalBodyAutoScrollController;

  final ScrollController verticalLeftScrollController = ScrollController();
  final ScrollController verticalBodyScrollController = ScrollController();

  final ScrollController monthSelectorScrollController = ScrollController();

  final List<GlobalKey> _monthKeys = List<GlobalKey>.generate(12, (_) => GlobalKey());
  late final List<GlobalKey> _yearKeys;

  bool _syncingH = false;
  bool _syncingV = false;
  int _currentMonth = 1;

  late final Map<int, int> _monthStartIndex;

  late final Map<String, int> _dayIndex;

  late final List<double> _prefixWidths;

  final Map<String, String> _weekdayCache = <String, String>{};

  final Map<String, Color> _lifetimeColorCache = <String, Color>{};

  final Map<String, bool> _holidayCache = <String, bool>{};

  late final List<double> _rowPrefixHeights;
  final bool _sundayNavLocked = false;

  static const TextStyle _text12 = TextStyle(fontSize: 12);
  static const TextStyle _text12Bold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  static const EdgeInsets _cellPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

  bool doAutoScroll = true;

  ///
  double get _bodyTotalHeight => widget.rowHeights
      .asMap()
      .entries
      .where((MapEntry<int, double> e) => e.key > 0)
      .fold<double>(0, (double sum, MapEntry<int, double> e) => sum + e.value);

  ///
  @override
  void initState() {
    super.initState();

    horizontalHeaderAutoScrollController = AutoScrollController(axis: Axis.horizontal);
    horizontalBodyAutoScrollController = AutoScrollController(axis: Axis.horizontal);

    final DateTime now = DateTime.now();
    _currentMonth = now.month;
    _yearKeys = List<GlobalKey>.generate(widget.years.length, (_) => GlobalKey());

    _monthStartIndex = <int, int>{
      for (int m = 1; m <= 12; m++)
        m: widget.monthDays.indexWhere((String md) => md.startsWith('${m.toString().padLeft(2, '0')}-')),
    };
    _dayIndex = <String, int>{for (int i = 0; i < widget.monthDays.length; i++) widget.monthDays[i]: i};

    _prefixWidths = List<double>.filled(widget.monthDays.length + 1, 0);
    for (int i = 1; i <= widget.monthDays.length; i++) {
      _prefixWidths[i] = _prefixWidths[i - 1] + widget.colWidths[i];
    }

    _rowPrefixHeights = List<double>.filled(widget.years.length + 1, 0);
    for (int i = 1; i <= widget.years.length; i++) {
      _rowPrefixHeights[i] = _rowPrefixHeights[i - 1] + widget.rowHeights[i];
    }

    horizontalHeaderAutoScrollController.addListener(() {
      if (_syncingH) {
        return;
      }
      _syncingH = true;

      if (doAutoScroll) {
        if (horizontalBodyAutoScrollController.hasClients) {
          /// 自動スクロール 1/8

          horizontalBodyAutoScrollController.jumpTo(horizontalHeaderAutoScrollController.offset);
        }
      }

      _syncingH = false;
      _updateCurrentMonthByOffset(horizontalHeaderAutoScrollController.offset);
    });
    horizontalBodyAutoScrollController.addListener(() {
      if (_syncingH) {
        return;
      }
      _syncingH = true;

      if (doAutoScroll) {
        if (horizontalHeaderAutoScrollController.hasClients) {
          /// 自動スクロール 2/8

          horizontalHeaderAutoScrollController.jumpTo(horizontalBodyAutoScrollController.offset);
        }
      }

      _syncingH = false;
      _updateCurrentMonthByOffset(horizontalBodyAutoScrollController.offset);
    });

    verticalLeftScrollController.addListener(() {
      if (_syncingV) {
        return;
      }
      _syncingV = true;

      if (doAutoScroll) {
        if (verticalBodyScrollController.hasClients) {
          /// 自動スクロール 3/8

          verticalBodyScrollController.jumpTo(verticalLeftScrollController.offset);
        }
      }

      _syncingV = false;
      if (!_sundayNavLocked) {
        _updateBaseYearByOffset(verticalLeftScrollController.offset);
      }
    });
    verticalBodyScrollController.addListener(() {
      if (_syncingV) {
        return;
      }
      _syncingV = true;

      if (doAutoScroll) {
        if (verticalLeftScrollController.hasClients) {
          /// 自動スクロール 4/8

          verticalLeftScrollController.jumpTo(verticalBodyScrollController.offset);
        }
      }

      _syncingV = false;
      if (!_sundayNavLocked) {
        _updateBaseYearByOffset(verticalBodyScrollController.offset);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollToTodayDay(fromInit: true);
    });
  }

  ///
  void _updateCurrentMonthByOffset(double dx) {
    int lo = 0, hi = widget.monthDays.length;
    while (lo < hi) {
      final int mid = (lo + hi) >> 1;
      if (_prefixWidths[mid] <= dx) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    final int idx = (lo - 1).clamp(0, widget.monthDays.length - 1);
    final String md = widget.monthDays[idx];
    final int m = int.tryParse(md.substring(0, 2)) ?? 1;
    if (m != _currentMonth) {
      setState(() => _currentMonth = m);
      _ensureMonthButtonVisible(m);
    }
  }

  ///
  Future<void> _scrollToMonth(int month) async {
    final int idx = _monthStartIndex[month] ?? 0;
    _syncingH = true;

    if (doAutoScroll) {
      // ignore: strict_raw_type, always_specify_types
      await Future.wait(<Future>[
        /// 自動スクロール 5/8
        horizontalHeaderAutoScrollController.scrollToIndex(
          idx,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 260),
        ),

        /// 自動スクロール 6/8
        horizontalBodyAutoScrollController.scrollToIndex(
          idx,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 260),
        ),
      ]);
    }

    _syncingH = false;
    if (_currentMonth != month) {
      setState(() => _currentMonth = month);
    }
    _ensureMonthButtonVisible(month);
  }

  ///
  Future<void> _scrollToTodayDay({bool fromInit = false}) async {
    final DateTime now = DateTime.now();
    final String md = '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final int? idx = _dayIndex[md];
    if (idx != null && doAutoScroll) {
      _syncingH = true;
      // ignore: strict_raw_type, always_specify_types
      await Future.wait(<Future>[
        /// 自動スクロール 7/8
        horizontalHeaderAutoScrollController.scrollToIndex(
          idx,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 260),
        ),

        /// 自動スクロール 8/8
        horizontalBodyAutoScrollController.scrollToIndex(
          idx,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 260),
        ),
      ]);
      _syncingH = false;
    } else {
      await _scrollToMonth(now.month);
    }

    if (_currentMonth != now.month) {
      setState(() => _currentMonth = now.month);
    }
    _ensureMonthButtonVisible(now.month, alignment: fromInit ? (now.month >= 7 ? 1.0 : 0.0) : 0.5, animate: !fromInit);
    _ensureYearVisible(_closestYearTo(now.year), animate: !fromInit);
  }

  ///
  void _ensureMonthButtonVisible(int month, {double alignment = 0.5, bool animate = true}) {
    final int i = (month - 1).clamp(0, 11);
    final BuildContext? ctx = _monthKeys[i].currentContext;
    if (ctx == null) {
      return;
    }
    Scrollable.ensureVisible(
      ctx,
      alignment: alignment,
      duration: animate ? const Duration(milliseconds: 220) : Duration.zero,
      curve: Curves.easeOut,
    );
  }

  ///
  void _ensureYearVisible(int year, {double alignment = 0.5, bool animate = true}) {
    final int idx = widget.years.indexOf(year.toString());
    if (idx < 0 || idx >= _yearKeys.length) {
      return;
    }
    final BuildContext? ctx = _yearKeys[idx].currentContext;
    if (ctx == null) {
      return;
    }
    Scrollable.ensureVisible(
      ctx,
      alignment: alignment,
      duration: animate ? const Duration(milliseconds: 240) : Duration.zero,
      curve: Curves.easeOut,
    );
  }

  ///
  int _closestYearTo(int y) {
    final int idx = widget.years.indexOf(y.toString());
    if (idx >= 0) {
      return y;
    }
    final List<int> nums = widget.years.map(int.parse).toList()..sort();
    int best = nums.first, diff = (nums.first - y).abs();
    for (final int v in nums) {
      final int d = (v - y).abs();
      if (d < diff) {
        best = v;
        diff = d;
      }
    }
    return best;
  }

  ///
  String _weekdayOf(String y, String md) {
    final String key = '$y-$md';
    final String? cached = _weekdayCache[key];
    if (cached != null) {
      return cached;
    }

    final int yy = int.parse(y);
    final int mm = int.parse(md.substring(0, 2));
    final int dd = int.parse(md.substring(3, 5));

    final String val = DateTime(yy, mm, dd).youbiStr;

    _weekdayCache[key] = val;
    return val;
  }

  ///
  void _updateBaseYearByOffset(double dy) {
    int lo = 0, hi = widget.years.length;
    while (lo < hi) {
      final int mid = (lo + hi) >> 1;
      if (_rowPrefixHeights[mid] <= dy) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
  }

  ///
  int _currentColIndex() {
    final double dx = horizontalBodyAutoScrollController.hasClients ? horizontalBodyAutoScrollController.offset : 0.0;
    int lo = 0, hi = widget.monthDays.length;
    while (lo < hi) {
      final int mid = (lo + hi) >> 1;
      if (_prefixWidths[mid] <= dx) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return (lo - 1).clamp(0, widget.monthDays.length - 1);
  }

  ///
  Future<void> _scrollToSunday({required bool next}) async {
    _ensureYearVisible(appParamState.selectedCrossCalendarYear, alignment: 0.0);

    int i = _currentColIndex() + (next ? 1 : -1);
    while (i >= 0 && i < widget.monthDays.length) {
      final String md = widget.monthDays[i];
      final int mm = int.parse(md.substring(0, 2));
      final int dd = int.parse(md.substring(3, 5));

      final DateTime dt = DateTime(appParamState.selectedCrossCalendarYear, mm).add(Duration(days: dd - 1));
      if (dt.month == mm && dt.day == dd) {
        if (dt.weekday == DateTime.sunday) {
          _syncingH = true;
          // ignore: strict_raw_type, always_specify_types
          await Future.wait(<Future>[
            horizontalHeaderAutoScrollController.scrollToIndex(
              i,
              preferPosition: AutoScrollPosition.begin,
              duration: const Duration(milliseconds: 260),
            ),
            horizontalBodyAutoScrollController.scrollToIndex(
              i,
              preferPosition: AutoScrollPosition.begin,
              duration: const Duration(milliseconds: 260),
            ),
          ]);
          _syncingH = false;
          return;
        }
      }
      i += (next ? 1 : -1);
    }
  }

  ///
  Color _lifetimeColor(String value) {
    final Color? c = _lifetimeColorCache[value];
    if (c != null) {
      return c;
    }
    final Color v = UiUtils.lifetimeRowBgColor(value: value, textDisplay: false);
    _lifetimeColorCache[value] = v;
    return v;
  }

  ///
  bool _isHoliday(String date, String youbi) {
    final bool? c = _holidayCache[date];
    if (c != null) {
      return c;
    }

    /// アプリデータ依存
    final bool v = youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date);
    _holidayCache[date] = v;
    return v;
  }

  ///
  @override
  void dispose() {
    horizontalHeaderAutoScrollController.dispose();
    horizontalBodyAutoScrollController.dispose();

    verticalLeftScrollController.dispose();
    verticalBodyScrollController.dispose();

    monthSelectorScrollController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final double headerH = widget.headerHeight;
    final double leftW = widget.leftColWidth;

    final double lifetimeTileW = MediaQuery.of(context).size.width / 30;

    return Column(
      children: <Widget>[
        getMonthSelectButton(),
        const Divider(height: 1),

        Row(
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: () => _scrollToSunday(next: false),
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              label: const Text('前の日曜', style: TextStyle(color: Colors.white)),
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: OutlinedButton.icon(
                onPressed: () => _scrollToSunday(next: true),
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                label: const Text('次の日曜', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),

        const Divider(height: 1),

        Expanded(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                width: leftW,
                height: headerH,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      right: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                  ),
                  child: const Center(child: Text(r'Year \ Date', style: _text12Bold)),
                ),
              ),

              Positioned(
                left: leftW,
                right: 0,
                top: 0,
                height: headerH,
                child: ListView.builder(
                  controller: horizontalHeaderAutoScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.monthDays.length,
                  cacheExtent: 400,

                  addAutomaticKeepAlives: false,
                  addSemanticIndexes: false,
                  itemBuilder: (_, int idx) => AutoScrollTag(
                    // ignore: always_specify_types
                    key: ValueKey('hheader_$idx'),
                    controller: horizontalHeaderAutoScrollController,
                    index: idx,
                    child: getHeaderCellContent(width: widget.colWidths[idx + 1], md: widget.monthDays[idx]),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                top: headerH,
                bottom: 0,
                width: leftW,
                child: Scrollbar(
                  controller: verticalLeftScrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: verticalLeftScrollController,
                    itemCount: widget.years.length,
                    addAutomaticKeepAlives: false,
                    addSemanticIndexes: false,
                    itemBuilder: (BuildContext context, int i) {
                      final String year = widget.years[i];
                      return SizedBox(
                        key: _yearKeys[i],
                        height: widget.rowHeights[i + 1],
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                appParamNotifier.setSelectedCrossCalendarYear(year: year.toInt());
                              },

                              child: CircleAvatar(
                                backgroundColor: (appParamState.selectedCrossCalendarYear == year.toInt())
                                    ? Colors.yellowAccent.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.2),

                                child: Text(
                                  year,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                left: leftW,
                top: headerH,
                right: 0,
                bottom: 0,
                child: Scrollbar(
                  controller: verticalBodyScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: verticalBodyScrollController,

                    child: SizedBox(
                      height: _bodyTotalHeight,
                      child: ListView.builder(
                        controller: horizontalBodyAutoScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.monthDays.length,
                        cacheExtent: 400,
                        addAutomaticKeepAlives: false,
                        addSemanticIndexes: false,
                        itemBuilder: (_, int colIdx) => AutoScrollTag(
                          // ignore: always_specify_types
                          key: ValueKey('hbody_$colIdx'),
                          controller: horizontalBodyAutoScrollController,
                          index: colIdx,
                          child: RepaintBoundary(
                            child: _buildColumnOfYear(
                              md: widget.monthDays[colIdx],
                              colWidth: widget.colWidths[colIdx + 1],
                              lifetimeTileW: lifetimeTileW,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget getMonthSelectButton() {
    return SizedBox(
      height: 64,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              controller: monthSelectorScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              cacheExtent: 200,
              addAutomaticKeepAlives: false,
              addSemanticIndexes: false,
              itemBuilder: (BuildContext context, int i) {
                final int month = i + 1;
                final bool selected = month == _currentMonth;
                return Container(
                  key: _monthKeys[i],
                  child: GestureDetector(
                    onTap: () => _scrollToMonth(month),
                    child: CircleAvatar(
                      backgroundColor: selected
                          ? Colors.yellowAccent.withValues(alpha: 0.3)
                          : Colors.blueGrey.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,

                      child: Text('$month月', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _scrollToTodayDay(),
            icon: const Icon(Icons.today, size: 18),

            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
            label: const Text('今日'),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  ///
  Widget getHeaderCellContent({required double width, required String md}) {
    return SizedBox(
      width: width,
      height: widget.headerHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
        ),
        child: Center(child: Text(md, style: _text12Bold)),
      ),
    );
  }

  ///
  Widget _buildColumnOfYear({required String md, required double colWidth, required double lifetimeTileW}) {
    final DateTime today = DateTime.now();
    final String todayMd = '${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final String todayYear = today.year.toString();

    double sum = 0;
    for (int r = 0; r < widget.years.length; r++) {
      sum += widget.rowHeights[r + 1];
    }
    if ((sum - _bodyTotalHeight).abs() > 0.5) {
      debugPrint('[CrossCalendar] ⚠ sumRows=$sum  bodyTotal=$_bodyTotalHeight  (md:$md)');
    }

    return SizedBox(
      width: colWidth,
      height: _bodyTotalHeight,

      child: Column(
        children: <Widget>[
          for (int r = 0; r < widget.years.length; r++)
            _bodyCell(
              width: colWidth,
              height: widget.rowHeights[r + 1],
              isDisabled: _isNonLeapFeb29(widget.years[r], md),
              isCurrentYear: widget.years[r] == todayYear,
              isToday: widget.years[r] == todayYear && md == todayMd,
              child: _isNonLeapFeb29(widget.years[r], md)
                  ? const SizedBox.shrink()
                  : getOneCellContent(widget.years[r], md, lifetimeTileW: lifetimeTileW),

              date: '${widget.years[r]}-$md',
            ),
        ],
      ),
    );
  }

  ///
  Widget getOneCellContent(String year, String md, {required double lifetimeTileW}) {
    final String date = '$year-$md';

    final String youbi = _weekdayOf(year, md);

    final bool isHoliday = _isHoliday(date, youbi);

    /// アプリデータ依存
    final Color containerColor = isHoliday
        ? UiUtils.youbiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
        : Colors.transparent;

    final List<String> lifetimeData = (appParamState.keepLifetimeMap[date] != null)
        ? getLifetimeData(lifetimeModel: appParamState.keepLifetimeMap[date]!)
        : <String>[];

    final Map<int, String> duplicateConsecutiveMap = getDuplicateConsecutiveMap(lifetimeData);

    final List<Widget> displayIcons = <Widget>[];

    if (appParamState.keepTempleMap[date] != null) {
      displayIcons.add(Icon(FontAwesomeIcons.toriiGate, size: 20, color: Colors.white.withValues(alpha: 0.3)));
    }

    if (appParamState.keepTransportationMap[date] != null) {
      displayIcons.add(Icon(Icons.train, size: 20, color: Colors.white.withValues(alpha: 0.3)));
    }

    if (appParamState.keepDateMetroStampMap[date] != null) {
      displayIcons.add(Icon(FontAwesomeIcons.stamp, size: 15, color: Colors.white.withValues(alpha: 0.3)));
    }

    displayIcons.add(const Icon(Icons.square_outlined, size: 20, color: Colors.transparent));

    /// アプリデータ依存

    return Column(
      children: <Widget>[
        ColoredBox(
          color: containerColor,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(date, maxLines: 1, overflow: TextOverflow.ellipsis, style: _text12),
                  Text(youbi.substring(0, 3), style: _text12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        if (lifetimeData.isNotEmpty) ...<Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              getLifetimeDisplayCellForCrossCalendar(date: date, lifetimeData: lifetimeData, tileW: lifetimeTileW),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: duplicateConsecutiveMap.entries.map((MapEntry<int, String> e) {
                    return Text(
                      e.value,
                      style: TextStyle(fontSize: 10, color: _lifetimeColor(e.value).withValues(alpha: 1)),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: displayIcons.map((Widget e) {
                    return Column(children: <Widget>[e, const SizedBox(height: 10)]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  ///
  Widget getLifetimeDisplayCellForCrossCalendar({
    required String date,
    required List<String> lifetimeData,
    required double tileW,
  }) {
    final List<Widget> rows = <Widget>[];
    int i = 0;

    while (i < lifetimeData.length) {
      final int end = (i + 6 <= lifetimeData.length) ? i + 6 : lifetimeData.length;
      final List<Widget> line = <Widget>[];

      for (int j = i; j < end; j++) {
        final String value = lifetimeData[j];
        final Color color = _lifetimeColor(value);

        line.add(
          Padding(
            padding: const EdgeInsets.all(1),
            child: ColoredBox(
              color: color,
              child: SizedBox(
                width: tileW,
                child: Center(
                  child: Text((j % 3 == 0) ? j.toString().padLeft(2, '0') : '', style: const TextStyle(fontSize: 10)),
                ),
              ),
            ),
          ),
        );
      }

      rows.add(Row(children: line));
      i = end;
    }

    return Column(children: rows);
  }

  ///
  bool _isNonLeapFeb29(String year, String md) {
    if (md != '02-29') {
      return false;
    }
    final int y = int.tryParse(year) ?? 0;
    final bool isLeap = (y % 400 == 0) || (y % 4 == 0 && y % 100 != 0);
    return !isLeap;
  }

  ///
  Widget _bodyCell({
    required double width,
    required double height,
    required Widget child,
    bool isDisabled = false,
    bool isCurrentYear = false,
    bool isToday = false,
    required String date,
  }) {
    Color? bg;
    if (isDisabled) {
      bg = Colors.black.withValues(alpha: 0.2);
    } else if (isToday) {
      bg = Colors.white.withValues(alpha: 0.2);
    } else if (isCurrentYear) {
      bg = Colors.white.withValues(alpha: 0.1);
    }

    BorderSide borderColor;
    if (isToday) {
      borderColor = BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.3), width: 5);
    } else if (isCurrentYear) {
      borderColor = BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.2), width: 1.5);
    } else {
      borderColor = BorderSide(color: Colors.white.withValues(alpha: 0.2));
    }

    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: <Widget>[
            if (bg != null) const Positioned.fill(child: ColoredBox(color: Colors.transparent)),
            if (bg != null) Positioned.fill(child: ColoredBox(color: bg)),

            if (isDisabled) CustomPaint(size: Size(width, height), painter: DiagonalSlashPainter()),

            if (appParamState.keepWorkTimeMap['${date.split('-')[0]}-${date.split('-')[1]}'] != null &&
                appParamState.keepWorkTimeMap['${date.split('-')[0]}-${date.split('-')[1]}']!.genbaName !=
                    '✕') ...<Widget>[
              Positioned(
                bottom: 5,
                left: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.2)),
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5)),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(appParamState.keepWorkTimeMap['${date.split('-')[0]}-${date.split('-')[1]}']!.genbaName),

                        Text(appParamState.keepWorkTimeMap['${date.split('-')[0]}-${date.split('-')[1]}']!.agentName),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    right: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Padding(
                padding: _cellPadding,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
                        child: child,
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: borderColor, right: borderColor),
                  ),
                ),
              ),
            ),

            if (DateTime.parse(date).youbiStr == 'Sunday') ...<Widget>[
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    appParamNotifier.setWeeklyHistorySelectedDate(date: date);

                    bool isNeedGeolocMapDisplayHeight = false;
                    bool isNeedStationStampDisplayHeight = false;

                    getWeeklyHistoryDisplayWeekDate(date: date).forEach((String key, String value) {
                      if (appParamState.keepGeolocMap[value] != null) {
                        isNeedGeolocMapDisplayHeight = true;
                      }

                      if (appParamState.keepDateMetroStampMap[value] != null ||
                          appParamState.keepMetroStamp20AnniversaryMap[value] != null) {
                        isNeedStationStampDisplayHeight = true;
                      }
                    });

                    final List<WeeklyHistoryEventModel> weeklyHistoryEvent = getWeeklyHistoryEvent(date: date);

                    final List<WeeklyHistoryBadgeModel> weeklyHistoryBadge = getWeeklyHistoryBadges(date: date);

                    LifetimeDialog(
                      context: context,
                      widget: WeeklyHistoryAlert(
                        weeklyHistoryEvent: weeklyHistoryEvent,
                        weeklyHistoryBadge: weeklyHistoryBadge,
                        isNeedGeolocMapDisplayHeight: isNeedGeolocMapDisplayHeight,
                        isNeedStationStampDisplayHeight: isNeedStationStampDisplayHeight,
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2),
                    child: const Icon(Icons.vertical_align_bottom, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ///
  List<WeeklyHistoryEventModel> getWeeklyHistoryEvent({required String date}) {
    final List<WeeklyHistoryEventModel> list = <WeeklyHistoryEventModel>[];

    for (int i = 0; i < 7; i++) {
      final String genDate = DateTime.parse(date).add(Duration(days: i)).yyyymmdd;

      if (appParamState.keepLifetimeMap[genDate] != null) {
        final List<String> lifetimeData = getLifetimeData(lifetimeModel: appParamState.keepLifetimeMap[genDate]!);

        final Map<int, String> duplicateConsecutiveMap = getDuplicateConsecutiveMap(lifetimeData);

        list.addAll(getWeeklyHistoryEvents(dayIndex: i, data: duplicateConsecutiveMap));
      }
    }

    return list;
  }

  ///
  int toMinutes(int h, int m) {
    return h * 60 + m;
  }

  ///
  List<WeeklyHistoryEventModel> getWeeklyHistoryEvents({required int dayIndex, required Map<int, String> data}) {
    final List<WeeklyHistoryEventModel> list = <WeeklyHistoryEventModel>[];

    final List<String> exclusionItemList = <String>[]; // ['睡眠', '自宅', '実家']

    final List<Map<String, dynamic>> startEndList = getStartEndTitleList(data: data);

    for (final Map<String, dynamic> item in startEndList) {
      final int startHour = item['startHour'] as int;
      final int endHour = item['endHour'] as int;
      final String title = item['title'] as String;

      if (exclusionItemList.contains(title)) {
        continue;
      }

      final Color color = _lifetimeColor(title);

      list.add(
        WeeklyHistoryEventModel(
          dayIndex: dayIndex,
          startMinutes: toMinutes(startHour, 0),
          endMinutes: toMinutes(endHour, 0),
          title: title,
          color: color,
        ),
      );
    }

    return list;
  }

  ///
  List<WeeklyHistoryBadgeModel> getWeeklyHistoryBadges({required String date}) {
    final List<WeeklyHistoryBadgeModel> list = <WeeklyHistoryBadgeModel>[];

    for (int i = 0; i < 7; i++) {
      final String genDate = DateTime.parse(date).add(Duration(days: i)).yyyymmdd;

      if (appParamState.keepTempleDateTimeBadgeMap[genDate] != null) {
        for (final String element in appParamState.keepTempleDateTimeBadgeMap[genDate]!) {
          final List<String> exElement = element.split(':');

          final String? templeName = appParamState.keepTempleDateTimeNameMap['$genDate|$element'];

          list.add(
            WeeklyHistoryBadgeModel(
              dayIndex: i,
              minutesOfDay: exElement[0].toInt() * 60 + exElement[1].toInt(),
              icon: FontAwesomeIcons.toriiGate,
              color: Colors.pinkAccent,
              tooltip: templeName,
            ),
          );
        }
      }
    }

    return list;
  }
}
