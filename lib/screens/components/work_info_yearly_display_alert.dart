import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../models/yearly_history_event.dart';
import '../../models/yearly_span_item.dart';

class WorkInfoYearlyDisplayAlert extends StatefulWidget {
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
  State<WorkInfoYearlyDisplayAlert> createState() => _WorkInfoYearlyDisplayAlertState();
}

class _WorkInfoYearlyDisplayAlertState extends State<WorkInfoYearlyDisplayAlert> {
  late final AutoScrollController _autoCtrl;

  ///
  @override
  void initState() {
    super.initState();
    _autoCtrl = AutoScrollController(axis: Axis.vertical);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(const Duration(milliseconds: 30));
      final int? targetIndex = _yearToIndex(widget.initialScrollYear);
      if (targetIndex != null) {
        await _autoCtrl.scrollToIndex(
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

  // ///
  // String? _findOriginalStartYearMonth({required int rowYear, required YearlySpanItem span}) {
  //   final DateTime probe = DateTime(rowYear, span.startMonth);
  //
  //   for (final YearlyHistoryEvent ev in widget.workInfoList) {
  //     if (_isInvalidName(ev.agentName) || _isInvalidName(ev.genbaName)) {
  //       continue;
  //     }
  //
  //     if (ev.agentName != span.agentName || ev.genbaName != span.genbaName) {
  //       continue;
  //     }
  //
  //     if (probe.isBefore(ev.start) || probe.isAfter(ev.end)) {
  //       continue;
  //     }
  //
  //     return _formatYearMonth(ev.start.year, ev.start.month);
  //   }
  //
  //   return null;
  // }

  ///
  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    final double oneYearHeight = screenH / 10;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '勤務履歴（${widget.startYear}〜${widget.startYear + widget.years - 1}）',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: ListView.builder(
            controller: _autoCtrl,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: widget.years,
            itemBuilder: (BuildContext context, int index) {
              final int year = widget.startYear + index;
              final List<YearlySpanItem> spansThisYear = _spansForYear(year, widget.workInfoList);

              return AutoScrollTag(
                // ignore: always_specify_types
                key: ValueKey(index),
                controller: _autoCtrl,
                index: index,
                highlightColor: Colors.yellow.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: YearRow(
                    year: year,
                    height: oneYearHeight,
                    spans: spansThisYear,

                    onSpanTap: (YearlySpanItem span) {
//                      final String? origin = _findOriginalStartYearMonth(rowYear: year, span: span);

//                      final String ym = origin ?? _formatYearMonth(year, span.startMonth);

                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////

//                      print('Tapped span start yearmonth: $ym');

                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                      //////////////////
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

///
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
                      child: Text('${i + 1}月', style: const TextStyle(fontSize: 10, color: Colors.white70)),
                    ),
                  ),
                ),
              ),
            ),

            ...spans.map((YearlySpanItem s) {
              final double left = (s.startMonth - 1) * colW;
              double width = (s.endMonth - s.startMonth + 1) * colW;

              const double minWidth = 14.0;
              if (width < minWidth) {
                width = minWidth;
              }

              final bool isNarrow = width < 56;
              final bool isUltraNarrow = width < 36;

              final Widget bandChild = isNarrow
                  ? _BandCompact(
                      color: s.color,
                      agent: s.agentName,
                      genba: s.genbaName,
                      labelStyle: labelStyle,
                      maxLetters: isUltraNarrow ? 1 : 2,
                    )
                  : _BandTwoLines(color: s.color, agent: s.agentName, genba: s.genbaName, labelStyle: labelStyle);

              return Positioned(
                left: left,
                width: width,
                top: bandTop,
                height: bandHeight,
                child: GestureDetector(onTap: () => onSpanTap(s), child: bandChild),
              );
            }),
          ],
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _BandTwoLines extends StatelessWidget {
  const _BandTwoLines({required this.color, required this.agent, required this.genba, required this.labelStyle});

  final Color color;
  final String agent;
  final String genba;
  final TextStyle labelStyle;

  ///
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.55)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                genba,
                style: labelStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              Text(
                agent,
                style: labelStyle.copyWith(fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.85)),
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

class _BandCompact extends StatelessWidget {
  const _BandCompact({
    required this.color,
    required this.agent,
    required this.genba,
    required this.labelStyle,
    this.maxLetters = 2,
  });

  final Color color;
  final String agent;
  final String genba;
  final TextStyle labelStyle;
  final int maxLetters;

  @override
  Widget build(BuildContext context) {
    final String abbrGenba = _abbr(genba, maxLetters);
    final String abbrAgent = _abbr(agent, maxLetters);

    final Widget face = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.75)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              abbrGenba,
              style: labelStyle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            Text(
              abbrAgent,
              style: labelStyle.copyWith(
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

    return Tooltip(message: '$genba\n$agent', waitDuration: const Duration(milliseconds: 200), child: face);
  }
}

////////////////////////////////////////////////////////////////////////////////

///
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

// ///
// String _formatYearMonth(int year, int month) {
//   final String m = month.toString().padLeft(2, '0');
//   return '$year-$m';
// }
