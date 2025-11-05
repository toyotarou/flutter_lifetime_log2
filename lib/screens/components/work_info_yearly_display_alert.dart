import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

///
class WorkInfoYearlyDisplayAlert extends StatefulWidget {
  const WorkInfoYearlyDisplayAlert({
    super.key,
    required this.startYear,
    required this.years,
    required this.initialScrollYear,
  });

  final int startYear;

  final int years;

  final int initialScrollYear;

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
  List<YearRangeSpan> _demoRanges() {
    return <YearRangeSpan>[
      YearRangeSpan(start: DateTime(2023, 3), end: DateTime(2023, 7, 31), color: Colors.teal, label: '妊娠中期'),
      YearRangeSpan(start: DateTime(2024, 11, 10), end: DateTime(2025, 2, 5), color: Colors.orange, label: 'つわりがピーク'),
      YearRangeSpan(start: DateTime(2025, 9), end: DateTime(2025, 10, 31), color: Colors.pinkAccent, label: '検診強化'),
      YearRangeSpan(start: DateTime(2026, 4), end: DateTime(2028, 2, 28), color: Colors.indigoAccent, label: 'プロジェクトX'),
    ];
  }

  ///
  List<YearSpan> _spansForYear(int year, List<YearRangeSpan> ranges) {
    final List<YearSpan> result = <YearSpan>[];
    final DateTime yearStart = DateTime(year);
    final DateTime yearEnd = DateTime(year, 12, 31, 23, 59, 59, 999);

    for (final YearRangeSpan r in ranges) {
      final bool overlaps = r.start.isBefore(yearEnd) && r.end.isAfter(yearStart);
      if (!overlaps) {
        continue;
      }

      final DateTime clippedStart = r.start.isBefore(yearStart) ? yearStart : r.start;
      final DateTime clippedEnd = r.end.isAfter(yearEnd) ? yearEnd : r.end;

      result.add(YearSpan(startMonth: clippedStart.month, endMonth: clippedEnd.month, color: r.color, label: r.label));
    }
    return result;
  }

  ///
  @override
  Widget build(BuildContext context) {
    final List<YearRangeSpan> ranges = _demoRanges();
    final double screenH = MediaQuery.of(context).size.height;
    final double oneYearHeight = screenH / 3;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '年タイムライン（${widget.startYear}〜${widget.startYear + widget.years - 1}）',
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
              final List<YearSpan> spansThisYear = _spansForYear(year, ranges);

              return AutoScrollTag(
                // ignore: always_specify_types
                key: ValueKey(index),
                controller: _autoCtrl,
                index: index,
                highlightColor: Colors.yellow.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: YearRow(year: year, height: oneYearHeight, spans: spansThisYear),
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

///
class YearRangeSpan {
  YearRangeSpan({required this.start, required this.end, required this.color, required this.label});

  final DateTime start;
  final DateTime end;
  final Color color;
  final String label;
}

////////////////////////////////////////////////////////////////////////////////

///
class YearSpan {
  YearSpan({required this.startMonth, required this.endMonth, required this.color, required this.label});

  final int startMonth;

  final int endMonth;

  final Color color;
  final String label;
}
////////////////////////////////////////////////////////////////////////////////

///
class YearRow extends StatelessWidget {
  const YearRow({super.key, required this.year, required this.height, required this.spans});

  final int year;
  final double height;
  final List<YearSpan> spans;

  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$year 年', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        YearTimeline(height: height, spans: spans, gridColor: const Color(0xFF2A2F36)),
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
    this.height = 140,
    this.gridColor = const Color(0xFFE5E7EB),
    this.labelStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  });

  final List<YearSpan> spans;
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
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${i + 1}月', style: const TextStyle(fontSize: 10, color: Colors.white70)),
                    ),
                  ),
                ),
              ),
            ),

            ...spans.map((YearSpan s) {
              final double left = (s.startMonth - 1) * colW;
              final double width = (s.endMonth - s.startMonth + 1) * colW;

              return Positioned(
                left: left,
                width: width,
                top: 28,

                height: height - 40,

                child: _Band(color: s.color, label: s.label, labelStyle: labelStyle),
              );
            }),
          ],
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

///
class _Band extends StatelessWidget {
  const _Band({required this.color, required this.label, required this.labelStyle});

  final Color color;
  final String label;
  final TextStyle labelStyle;

  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.55)),
      ),
      child: Text(label, style: labelStyle, overflow: TextOverflow.ellipsis),
    );
  }
}
