import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/common/work_history_model.dart';
import '../../models/yearly_history_event.dart';
import '../../models/yearly_span_item.dart';

class WorkInfoYearlyDisplayAlert extends ConsumerStatefulWidget {
  const WorkInfoYearlyDisplayAlert({
    super.key,
    required this.startYear,
    required this.years,
    required this.initialScrollYear,
    required this.workInfoList,
  });

  final int startYear;
  final int years;
  final int initialScrollYear;
  final List<YearlyHistoryEvent> workInfoList;

  @override
  ConsumerState<WorkInfoYearlyDisplayAlert> createState() => _WorkInfoYearlyDisplayAlertState();
}

class _WorkInfoYearlyDisplayAlertState extends ConsumerState<WorkInfoYearlyDisplayAlert>
    with ControllersMixin<WorkInfoYearlyDisplayAlert> {
  late final AutoScrollController autoScrollController;

  ///
  @override
  void initState() {
    super.initState();
    autoScrollController = AutoScrollController(axis: Axis.vertical);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(const Duration(milliseconds: 30));
      final int? targetIndex = _yearToIndex(widget.initialScrollYear);
      if (targetIndex != null) {
        await autoScrollController.scrollToIndex(
          targetIndex,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  ///
  int? _yearToIndex(int year) {
    if (year < widget.startYear || year >= widget.startYear + widget.years) {
      return null;
    }
    return year - widget.startYear;
  }

  ///
  bool _isInvalidName(String s) {
    final String norm = s
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')
        .replaceAll(RegExp(r'[\uFE0E\uFE0F]'), '')
        .replaceAll(RegExp(r'[\u3000\s]+'), '')
        .trim();

    if (norm.isEmpty) {
      return true;
    }

    const Set<String> banned = <String>{'×', '✕', '✖', '╳', '✗', '✘', '❌', 'x', 'X'};

    return banned.contains(norm);
  }

  ///
  List<YearlySpanItem> _spansForYear(int year, List<YearlyHistoryEvent> ranges) {
    final List<YearlySpanItem> result = <YearlySpanItem>[];
    final DateTime yearStart = DateTime(year);
    final DateTime yearEnd = DateTime(year, 12, 31, 23, 59, 59, 999);

    for (final YearlyHistoryEvent r in ranges) {
      if (_isInvalidName(r.agentName) || _isInvalidName(r.genbaName)) {
        continue;
      }

      final bool overlaps = r.start.isBefore(yearEnd) && r.end.isAfter(yearStart);
      if (!overlaps) {
        continue;
      }

      final DateTime clippedStart = r.start.isBefore(yearStart) ? yearStart : r.start;
      final DateTime clippedEnd = r.end.isAfter(yearEnd) ? yearEnd : r.end;

      result.add(
        YearlySpanItem(
          startMonth: clippedStart.month,
          endMonth: clippedEnd.month,
          color: r.color,
          agentName: r.agentName,
          genbaName: r.genbaName,
        ),
      );
    }
    return result;
  }

  ///
  String? _findOriginalStartYearMonth({required int rowYear, required YearlySpanItem span}) {
    final DateTime probe = DateTime(rowYear, span.startMonth);

    for (final YearlyHistoryEvent ev in widget.workInfoList) {
      if (_isInvalidName(ev.agentName) || _isInvalidName(ev.genbaName)) {
        continue;
      }

      if (ev.agentName != span.agentName || ev.genbaName != span.genbaName) {
        continue;
      }

      if (probe.isBefore(ev.start) || probe.isAfter(ev.end)) {
        continue;
      }

      return _formatYearMonth(ev.start.year, ev.start.month);
    }

    return null;
  }

  ///
  String? _findOriginalEndYearMonth({required int rowYear, required YearlySpanItem span}) {
    final DateTime probe = DateTime(rowYear, span.startMonth);

    for (final YearlyHistoryEvent ev in widget.workInfoList) {
      if (_isInvalidName(ev.agentName) || _isInvalidName(ev.genbaName)) {
        continue;
      }

      if (ev.agentName != span.agentName || ev.genbaName != span.genbaName) {
        continue;
      }

      if (probe.isBefore(ev.start) || probe.isAfter(ev.end)) {
        continue;
      }

      return _formatYearMonth(ev.end.year, ev.end.month);
    }

    return null;
  }

  ///
  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    final double oneYearHeight = screenH / 10;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('勤務履歴（${widget.startYear}〜${widget.startYear + widget.years - 1}）'),
                    const SizedBox.shrink(),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            autoScrollController.scrollToIndex(widget.workInfoList.length);
                          },
                          child: const Icon(Icons.arrow_downward),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            autoScrollController.scrollToIndex(0);
                          },
                          child: const Icon(Icons.arrow_upward),
                        ),
                      ],
                    ),

                    Expanded(
                      child: (appParamState.selectedWorkHistoryModel != null)
                          ? DefaultTextStyle(
                              style: const TextStyle(fontSize: 10),
                              child: Container(
                                margin: const EdgeInsets.only(top: 5, left: 20, bottom: 5, right: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '${appParamState.selectedWorkHistoryModel!.year}-${appParamState.selectedWorkHistoryModel!.month}',
                                        ),

                                        Text(appParamState.selectedWorkHistoryModel!.endYm ?? ''),
                                      ],
                                    ),
                                    Text(
                                      appParamState.selectedWorkHistoryModel!.workTruthName,

                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      appParamState.selectedWorkHistoryModel!.workContractName,

                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 3),

                Expanded(
                  child: ListView.builder(
                    controller: autoScrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    itemCount: widget.years,
                    itemBuilder: (BuildContext context, int index) {
                      final int year = widget.startYear + index;
                      final List<YearlySpanItem> spansThisYear = _spansForYear(year, widget.workInfoList);

                      return AutoScrollTag(
                        // ignore: always_specify_types
                        key: ValueKey(index),
                        controller: autoScrollController,
                        index: index,
                        highlightColor: Colors.yellow.withOpacity(0.08),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: YearRow(
                            year: year,
                            height: oneYearHeight,
                            spans: spansThisYear,
                            onSpanTap: (YearlySpanItem span) {
                              final String startYm =
                                  _findOriginalStartYearMonth(rowYear: year, span: span) ??
                                  _formatYearMonth(year, span.startMonth);

                              final String endYm =
                                  _findOriginalEndYearMonth(rowYear: year, span: span) ??
                                  _formatYearMonth(year, span.endMonth);

                              setState(() {
                                appParamNotifier.setSelectedWorkHistoryModel(
                                  model: WorkHistoryModel(
                                    year: startYm.split('-')[0],
                                    month: startYm.split('-')[1],
                                    workTruthName: span.genbaName,
                                    workContractName: span.agentName,
                                    endYm: endYm,
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class YearRow extends StatelessWidget {
  const YearRow({super.key, required this.year, required this.height, required this.spans, required this.onSpanTap});

  final int year;
  final double height;
  final List<YearlySpanItem> spans;
  final void Function(YearlySpanItem span) onSpanTap;

  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$year 年', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        YearTimeline(height: height, spans: spans, gridColor: const Color(0xFF2A2F36), onSpanTap: onSpanTap),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class YearTimeline extends StatelessWidget {
  const YearTimeline({
    super.key,
    required this.spans,
    required this.onSpanTap,
    this.height = 140,
    this.gridColor = const Color(0xFFE5E7EB),
    this.labelStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  });

  final List<YearlySpanItem> spans;
  final void Function(YearlySpanItem span) onSpanTap;
  final double height;
  final Color gridColor;
  final TextStyle labelStyle;

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final double totalW = constraints.maxWidth;

        final double colW = totalW / 12.0;

        const double headerHeight = 18;
        const double vPadding = 4;
        const double targetBandHeight = 30.0;

        final double available = height - headerHeight - vPadding * 2;
        final double bandHeight = available >= targetBandHeight
            ? targetBandHeight
            : available.clamp(18.0, targetBandHeight);

        final double bandTop = height - vPadding - bandHeight;

        return Stack(
          children: <Widget>[
            Row(
              // ignore: always_specify_types
              children: List.generate(
                12,
                (int i) => Container(
                  width: colW,
                  height: height,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: gridColor),
                      bottom: BorderSide(color: gridColor),
                      right: BorderSide(color: gridColor),
                      left: i == 0 ? BorderSide(color: gridColor) : BorderSide.none,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),

                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ...spans.map((YearlySpanItem yearlySpanItem) {
              final double left = (yearlySpanItem.startMonth - 1) * colW;
              double width = (yearlySpanItem.endMonth - yearlySpanItem.startMonth + 1) * colW;

              const double minWidth = 14.0;
              if (width < minWidth) {
                width = minWidth;
              }

              final bool isNarrow = width < 56;
              final bool isUltraNarrow = width < 36;

              final Widget bandChild = isNarrow
                  ? _BandCompact(
                      labelStyle: labelStyle,
                      maxLetters: isUltraNarrow ? 1 : 2,
                      yearlySpanItem: yearlySpanItem,
                    )
                  : _BandTwoLines(labelStyle: labelStyle, yearlySpanItem: yearlySpanItem);

              return Positioned(
                left: left,
                width: width,
                top: bandTop,
                height: bandHeight,
                child: GestureDetector(onTap: () => onSpanTap(yearlySpanItem), child: bandChild),
              );
            }),
          ],
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _BandTwoLines extends ConsumerStatefulWidget {
  const _BandTwoLines({required this.labelStyle, required this.yearlySpanItem});

  final TextStyle labelStyle;
  final YearlySpanItem yearlySpanItem;

  @override
  ConsumerState<_BandTwoLines> createState() => _BandTwoLinesState();
}

class _BandTwoLinesState extends ConsumerState<_BandTwoLines> with ControllersMixin<_BandTwoLines> {
  ///
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: widget.yearlySpanItem.color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border:
              (appParamState.selectedWorkHistoryModel != null &&
                  widget.yearlySpanItem.agentName == appParamState.selectedWorkHistoryModel!.workContractName &&
                  widget.yearlySpanItem.genbaName == appParamState.selectedWorkHistoryModel!.workTruthName)
              ? Border.all(color: Colors.yellowAccent, width: 2)
              : Border.all(color: widget.yearlySpanItem.color.withOpacity(0.55)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.yearlySpanItem.genbaName,
                style: widget.labelStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              Text(
                widget.yearlySpanItem.agentName,
                style: widget.labelStyle.copyWith(fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.85)),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _BandCompact extends ConsumerStatefulWidget {
  const _BandCompact({required this.labelStyle, this.maxLetters = 2, required this.yearlySpanItem});

  final TextStyle labelStyle;
  final int maxLetters;
  final YearlySpanItem yearlySpanItem;

  @override
  ConsumerState<_BandCompact> createState() => _BandCompactState();
}

class _BandCompactState extends ConsumerState<_BandCompact> with ControllersMixin<_BandCompact> {
  @override
  Widget build(BuildContext context) {
    final String abbrGenba = _abbr(widget.yearlySpanItem.genbaName, widget.maxLetters);
    final String abbrAgent = _abbr(widget.yearlySpanItem.agentName, widget.maxLetters);
    final Widget face = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: widget.yearlySpanItem.color.withOpacity(0.22),
        borderRadius: BorderRadius.circular(8),
        border:
            (appParamState.selectedWorkHistoryModel != null &&
                widget.yearlySpanItem.agentName == appParamState.selectedWorkHistoryModel!.workContractName &&
                widget.yearlySpanItem.genbaName == appParamState.selectedWorkHistoryModel!.workTruthName)
            ? Border.all(color: Colors.yellowAccent, width: 2)
            : Border.all(color: widget.yearlySpanItem.color.withOpacity(0.75)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              abbrGenba,
              style: widget.labelStyle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            Text(
              abbrAgent,
              style: widget.labelStyle.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ),
      ),
    );

    return Tooltip(
      message: '${widget.yearlySpanItem.genbaName}\n${widget.yearlySpanItem.agentName}',
      waitDuration: const Duration(milliseconds: 200),
      child: face,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

String _abbr(String s, int n) {
  if (s.isEmpty || n <= 0) {
    return '';
  }
  final String trimmed = s.trim();
  if (trimmed.length <= n) {
    return trimmed;
  }
  return trimmed.substring(0, n);
}

String _formatYearMonth(int year, int month) {
  final String m = month.toString().padLeft(2, '0');
  return '$year-$m';
}
