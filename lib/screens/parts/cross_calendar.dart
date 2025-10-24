// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';
import '../parts/diagonal_slash_painter.dart';

///
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

///
class _CrossCalendarState extends ConsumerState<CrossCalendar> with ControllersMixin<CrossCalendar> {
  late final AutoScrollController _hHeaderCtrl;
  late final AutoScrollController _hBodyCtrl;
  final ScrollController _vLeftCtrl = ScrollController();
  final ScrollController _vBodyCtrl = ScrollController();
  final ScrollController _monthBarCtrl = ScrollController();
  final List<GlobalKey> _monthKeys = List<GlobalKey>.generate(12, (_) => GlobalKey());
  late final List<GlobalKey> _yearKeys;

  bool _syncingH = false;
  bool _syncingV = false;
  int _currentMonth = 1;

  late final Map<int, int> _monthStartIndex;
  late final Map<String, int> _dayIndex;
  late final List<double> _prefixWidths;

  Utility utility = Utility();

  ///
  double get _bodyTotalHeight => widget.rowHeights.sublist(1).reduce((double a, double b) => a + b);

  ///
  @override
  void initState() {
    super.initState();
    _hHeaderCtrl = AutoScrollController(axis: Axis.horizontal);
    _hBodyCtrl = AutoScrollController(axis: Axis.horizontal);

    final DateTime now = DateTime.now();
    _currentMonth = now.month;
    // ignore: always_specify_types
    _yearKeys = List.generate(widget.years.length, (_) => GlobalKey());

    _monthStartIndex = <int, int>{
      for (int m = 1; m <= 12; m++)
        m: widget.monthDays.indexWhere((String md) => md.startsWith('${m.toString().padLeft(2, '0')}-')),
    };
    _dayIndex = <String, int>{for (int i = 0; i < widget.monthDays.length; i++) widget.monthDays[i]: i};
    _prefixWidths = List<double>.filled(widget.monthDays.length + 1, 0);
    for (int i = 1; i <= widget.monthDays.length; i++) {
      _prefixWidths[i] = _prefixWidths[i - 1] + widget.colWidths[i];
    }

    // 横同期
    _hHeaderCtrl.addListener(() {
      if (_syncingH) {
        return;
      }
      _syncingH = true;
      if (_hBodyCtrl.hasClients) {
        _hBodyCtrl.jumpTo(_hHeaderCtrl.offset);
      }
      _syncingH = false;
      _updateCurrentMonthByOffset(_hHeaderCtrl.offset);
    });
    _hBodyCtrl.addListener(() {
      if (_syncingH) {
        return;
      }
      _syncingH = true;
      if (_hHeaderCtrl.hasClients) {
        _hHeaderCtrl.jumpTo(_hBodyCtrl.offset);
      }
      _syncingH = false;
      _updateCurrentMonthByOffset(_hBodyCtrl.offset);
    });

    // 縦同期
    _vLeftCtrl.addListener(() {
      if (_syncingV) {
        return;
      }
      _syncingV = true;
      if (_vBodyCtrl.hasClients) {
        _vBodyCtrl.jumpTo(_vLeftCtrl.offset);
      }
      _syncingV = false;
    });
    _vBodyCtrl.addListener(() {
      if (_syncingV) {
        return;
      }
      _syncingV = true;
      if (_vLeftCtrl.hasClients) {
        _vLeftCtrl.jumpTo(_vBodyCtrl.offset);
      }
      _syncingV = false;
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
    // ignore: strict_raw_type, always_specify_types
    await Future.wait(<Future>[
      _hHeaderCtrl.scrollToIndex(
        idx,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 260),
      ),
      _hBodyCtrl.scrollToIndex(
        idx,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 260),
      ),
    ]);
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
    if (idx != null) {
      _syncingH = true;
      // ignore: strict_raw_type, always_specify_types
      await Future.wait(<Future>[
        _hHeaderCtrl.scrollToIndex(
          idx,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 260),
        ),
        _hBodyCtrl.scrollToIndex(
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
  @override
  void dispose() {
    _hHeaderCtrl.dispose();
    _hBodyCtrl.dispose();
    _vLeftCtrl.dispose();
    _vBodyCtrl.dispose();
    _monthBarCtrl.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final double headerH = widget.headerHeight;
    final double leftW = widget.leftColWidth;

    return Column(
      children: <Widget>[
        getMonthSelectButton(),

        const Divider(height: 1),

        // テーブル本体
        Expanded(
          child: Stack(
            children: <Widget>[
              // 左上固定セル
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
                  child: const Center(
                    child: Text(r'Year \ Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              // 上部ヘッダー
              Positioned(
                left: leftW,
                right: 0,
                top: 0,
                height: headerH,
                child: ListView.builder(
                  controller: _hHeaderCtrl,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.monthDays.length,
                  itemBuilder: (_, int idx) => AutoScrollTag(
                    // ignore: always_specify_types
                    key: ValueKey('hheader_$idx'),
                    controller: _hHeaderCtrl,
                    index: idx,
                    child: getHeaderCellContent(width: widget.colWidths[idx + 1], md: widget.monthDays[idx]),
                  ),
                ),
              ),

              // 左の年列
              Positioned(
                left: 0,
                top: headerH,
                bottom: 0,
                width: leftW,
                child: Scrollbar(
                  controller: _vLeftCtrl,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _vLeftCtrl,
                    itemCount: widget.years.length,
                    itemBuilder: (BuildContext context, int i) {
                      final String year = widget.years[i];
                      return Container(
                        key: _yearKeys[i],
                        height: widget.rowHeights[i + 1],
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(year, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
              ),

              // 本体（横×縦）
              Positioned(
                left: leftW,
                top: headerH,
                right: 0,
                bottom: 0,
                child: Scrollbar(
                  controller: _vBodyCtrl,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _vBodyCtrl,
                    child: SizedBox(
                      height: _bodyTotalHeight,
                      child: ListView.builder(
                        controller: _hBodyCtrl,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.monthDays.length,
                        itemBuilder: (_, int colIdx) => AutoScrollTag(
                          // ignore: always_specify_types
                          key: ValueKey('hbody_$colIdx'),
                          controller: _hBodyCtrl,
                          index: colIdx,
                          child: _buildColumnOfYear(
                            md: widget.monthDays[colIdx],
                            colWidth: widget.colWidths[colIdx + 1],
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
              controller: _monthBarCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              itemBuilder: (BuildContext context, int i) {
                final int month = i + 1;
                final bool selected = month == _currentMonth;
                return Container(
                  key: _monthKeys[i],
                  child: GestureDetector(
                    onTap: () => _scrollToMonth(month),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: selected ? Colors.blue : Colors.grey.shade300,
                      foregroundColor: selected ? Colors.white : Colors.black87,
                      child: Text('$month月'),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
            ),
          ),
          const SizedBox(width: 8),

          OutlinedButton.icon(
            onPressed: () => _scrollToTodayDay(),
            icon: const Icon(Icons.today, size: 18),
            label: const Text('今日'),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  ///
  Widget getHeaderCellContent({required double width, required String md}) {
    return Container(
      width: width,
      height: widget.headerHeight,

      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),

        border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      ),

      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(md, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  ///
  Widget _buildColumnOfYear({required String md, required double colWidth}) {
    final DateTime today = DateTime.now();
    final String todayMd = '${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final String todayYear = today.year.toString();

    return SizedBox(
      width: colWidth,
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
                  : getOneCellContent(widget.years[r], md),
            ),
        ],
      ),
    );
  }

  ///
  Widget getOneCellContent(String year, String md) {
    final String date = '$year-$md';

    final String youbi = DateTime.parse(date).youbiStr;

    final Color containerColor =
        (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(date))
        ? utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList)
        : Colors.transparent;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: containerColor),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(date, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
              Text(youbi.substring(0, 3), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: <Widget>[
            const Spacer(),
            getLifetimeDisplayCellForCrossCalendar(date: date),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  ///
  Widget getLifetimeDisplayCellForCrossCalendar({required String date}) {
    List<String> lifetimeData = <String>[];

    if (lifetimeState.lifetimeMap[date] != null) {
      lifetimeData = <String>[
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

    if (lifetimeData.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<List<String>> chunks = lifetimeData.slices(6).toList();

    final List<Widget> list = <Widget>[];

    int i = 0;
    for (final List<String> element in chunks) {
      final List<Widget> list2 = <Widget>[];

      for (final String element2 in element) {
        final Color color = utility.getLifetimeRowBgColor(value: element2, textDisplay: false);

        list2.add(
          Container(
            width: context.screenSize.width / 30,
            margin: const EdgeInsets.all(1),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color),
            child: Text((i % 6 == 0) ? i.toString().padLeft(2, '0') : '', style: const TextStyle(fontSize: 10)),
          ),
        );

        i++;
      }

      list.add(Row(children: list2));
    }

    return Column(children: list);
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
  }) {
    // 背景色設定
    Color? bg;
    if (isDisabled) {
      bg = Colors.black.withValues(alpha: 0.2);
    } else if (isToday) {
      bg = Colors.white.withValues(alpha: 0.2);
    } else if (isCurrentYear) {
      bg = Colors.white.withValues(alpha: 0.1);
    }

    // 枠線設定
    BorderSide borderColor;
    if (isToday) {
      borderColor = BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.3), width: 5);
    } else if (isCurrentYear) {
      borderColor = BorderSide(color: Colors.orangeAccent.withValues(alpha: 0.2), width: 1.5);
    } else {
      borderColor = BorderSide(color: Colors.white.withValues(alpha: 0.2));
    }

    return Stack(
      children: <Widget>[
        Container(width: width, height: height, color: bg),
        if (isDisabled) CustomPaint(size: Size(width, height), painter: DiagonalSlashPainter()),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(bottom: borderColor, right: borderColor),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: child),
      ],
    );
  }
}
