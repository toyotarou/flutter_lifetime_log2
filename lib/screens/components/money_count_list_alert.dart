import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/money_model.dart';

class MoneyCountListAlert extends ConsumerStatefulWidget {
  const MoneyCountListAlert({super.key, required this.initialRowIndex, required this.moneyEntries});

  final int initialRowIndex;
  final List<MapEntry<String, MoneyModel>> moneyEntries;

  @override
  ConsumerState<MoneyCountListAlert> createState() => _MoneyCountListAlertState();
}

class _MoneyCountListAlertState extends ConsumerState<MoneyCountListAlert> {
  late final List<MapEntry<String, MoneyModel>> _entries;
  int? _initialRowIndexSafe;

  static const List<FlexibleColumn> headerContents = <FlexibleColumn>[
    FlexibleColumn(title: '10000', width: 80),
    FlexibleColumn(title: '5000', width: 80),
    FlexibleColumn(title: '2000', width: 80),
    FlexibleColumn(title: '1000', width: 80),
    FlexibleColumn(title: '500', width: 80),
    FlexibleColumn(title: '100', width: 80),
    FlexibleColumn(title: '50', width: 80),
    FlexibleColumn(title: '10', width: 80),
    FlexibleColumn(title: '5', width: 80),
    FlexibleColumn(title: '1', width: 80),
  ];

  @override
  void initState() {
    super.initState();
    _entries = widget.moneyEntries;

    if (_entries.isEmpty) {
      _initialRowIndexSafe = null;
    } else {
      _initialRowIndexSafe = widget.initialRowIndex.clamp(0, _entries.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double dateCellWidth = 80.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: FlexibleTable(
            rowCount: _entries.length,
            headerContents: headerContents,

            leftHeader: FlexibleTable.headerCell(
              text: 'DATE',
              width: dateCellWidth,
              height: 30,

              /// 「DATE」のセルの装飾
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.3),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),

            initialScrollToRow: _initialRowIndexSafe,
            autoScrollDuration: const Duration(milliseconds: 450),

            buildLeftCell: (BuildContext context, int row) {
              final String text = (row >= 0 && row < _entries.length) ? _entries[row].key : '';

              /// 日付セル
              return FlexibleTable.bodyCell(
                text: text,
                width: dateCellWidth,
                height: 50,
                textStyle: const TextStyle(fontSize: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3))),
              );
            },

            buildCell: (BuildContext context, int row, int colIndex) {
              final MapEntry<String, MoneyModel> entries = widget.moneyEntries[row];

              final String value = getDisplayValue(entries: entries, colIndex: colIndex);

              return Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  /// 右のテーブル部分の罫線
                  border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.3))),
                ),

                child: Text(value, style: const TextStyle(fontSize: 10)),
              );
            },

            /// 右側のヘッダーの装飾
            headerDecoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.3),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),

            /// 右側のテーブルセルの装飾
            bodyCellDecoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2))),
          ),
        ),
      ),
    );
  }

  ///
  String getDisplayValue({required MapEntry<String, MoneyModel> entries, required int colIndex}) {
    switch (colIndex) {
      case 0:
        return entries.value.yen10000;
      case 1:
        return entries.value.yen5000;
      case 2:
        return entries.value.yen2000;
      case 3:
        return entries.value.yen1000;
      case 4:
        return entries.value.yen500;
      case 5:
        return entries.value.yen100;
      case 6:
        return entries.value.yen50;
      case 7:
        return entries.value.yen10;
      case 8:
        return entries.value.yen5;
      case 9:
        return entries.value.yen1;
    }

    return '';
  }
}

class FlexibleColumn {
  const FlexibleColumn({required this.title, required this.width});

  final String title;
  final double width;
}

class FlexibleTable extends StatefulWidget {
  const FlexibleTable({
    super.key,
    required this.rowCount,
    required this.headerContents,
    required this.buildLeftCell,
    required this.buildCell,
    this.leftColumnWidth = 80,
    this.leftHeader,
    this.headerHeight = 30,
    this.rowHeight = 50,
    this.headerDecoration = const BoxDecoration(
      color: Colors.blueAccent,

      /// 右側のヘッダーの罫線
      border: Border.fromBorderSide(BorderSide(color: Colors.pinkAccent)),
    ),
    this.bodyCellDecoration = const BoxDecoration(
      /// 不明
      border: Border.fromBorderSide(BorderSide(color: Colors.pinkAccent)),
    ),
    this.initialScrollToRow,
    this.autoScrollDuration = const Duration(milliseconds: 400),
    this.cacheExtentRows = 12,
  });

  final int rowCount;
  final List<FlexibleColumn> headerContents;
  final double leftColumnWidth;
  final Widget? leftHeader;
  final double headerHeight;
  final double rowHeight;
  final BoxDecoration headerDecoration;
  final BoxDecoration bodyCellDecoration;
  final Widget Function(BuildContext context, int rowIndex) buildLeftCell;
  final Widget Function(BuildContext context, int rowIndex, int colIndex) buildCell;
  final int? initialScrollToRow;
  final Duration autoScrollDuration;
  final int cacheExtentRows;

  @override
  State<FlexibleTable> createState() => _FlexibleTableState();

  /// ヘッダーセル
  static Widget headerCell({
    required String text,
    required double width,
    required double height,
    BoxDecoration decoration = const BoxDecoration(border: Border.fromBorderSide(BorderSide())),
    TextStyle textStyle = const TextStyle(fontWeight: FontWeight.w700),
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10),
  }) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: Text(text, style: textStyle),
    );
  }

  static Widget bodyCell({
    required String text,
    required double width,
    required double height,
    BoxDecoration decoration = const BoxDecoration(border: Border.fromBorderSide(BorderSide())),
    Alignment alignment = Alignment.centerLeft,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    TextStyle? textStyle,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: Text(text, style: textStyle),
    );
  }
}

class _FlexibleTableState extends State<FlexibleTable> {
  late final ScrollController _headerHorizontalScrollController;
  late final ScrollController _bodyHorizontalScrollController;

  late final ScrollController _leftVertical;
  late final ScrollController _rightVertical;

  bool _syncing = false;
  bool _didAutoScroll = false;

  late final VoidCallback _fromHeaderListener;
  late final VoidCallback _fromBodyListener;

  double get _rightMinWidth => widget.headerContents.fold<double>(0, (double acc, FlexibleColumn c) => acc + c.width);

  @override
  void initState() {
    super.initState();

    _headerHorizontalScrollController = ScrollController();
    _bodyHorizontalScrollController = ScrollController();

    _leftVertical = ScrollController();
    _rightVertical = ScrollController();

    _fromHeaderListener = () {
      if (_syncing) {
        return;
      }
      _syncing = true;
      if (_bodyHorizontalScrollController.hasClients) {
        _bodyHorizontalScrollController.jumpTo(_headerHorizontalScrollController.offset);
      }
      _syncing = false;
    };

    _fromBodyListener = () {
      if (_syncing) {
        return;
      }
      _syncing = true;
      if (_headerHorizontalScrollController.hasClients) {
        _headerHorizontalScrollController.jumpTo(_bodyHorizontalScrollController.offset);
      }
      _syncing = false;
    };

    _headerHorizontalScrollController.addListener(_fromHeaderListener);
    _bodyHorizontalScrollController.addListener(_fromBodyListener);

    _leftVertical.addListener(() {
      if (_syncing) {
        return;
      }
      _syncing = true;
      if (_rightVertical.hasClients) {
        _rightVertical.jumpTo(_leftVertical.offset);
      }
      _syncing = false;
    });

    _rightVertical.addListener(() {
      if (_syncing) {
        return;
      }
      _syncing = true;
      if (_leftVertical.hasClients) {
        _leftVertical.jumpTo(_rightVertical.offset);
      }
      _syncing = false;
    });
  }

  @override
  void dispose() {
    _headerHorizontalScrollController.removeListener(_fromHeaderListener);
    _bodyHorizontalScrollController.removeListener(_fromBodyListener);

    _headerHorizontalScrollController.dispose();
    _bodyHorizontalScrollController.dispose();
    _leftVertical.dispose();
    _rightVertical.dispose();
    super.dispose();
  }

  void _scheduleInitialScrollIfNeeded() {
    if (_didAutoScroll) {
      return;
    }

    final int? targetRow = widget.initialScrollToRow;
    if (targetRow == null) {
      return;
    }
    if (!_rightVertical.hasClients) {
      return;
    }

    final double rawOffset = widget.rowHeight * targetRow.toDouble();
    final double max = _rightVertical.position.maxScrollExtent;
    final double target = rawOffset.clamp(0.0, max);

    _didAutoScroll = true;
    _rightVertical.animateTo(target, duration: widget.autoScrollDuration, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double rightContentWidth = math.max(_rightMinWidth, constraints.maxWidth - widget.leftColumnWidth - 2);

        final Material header = Material(
          elevation: 2,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: widget.leftColumnWidth,
                height: widget.headerHeight,
                child:
                    widget.leftHeader ??
                    Container(
                      decoration: widget.headerDecoration,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
              ),
              const SizedBox(width: 2),

              Expanded(
                child: SingleChildScrollView(
                  controller: _headerHorizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: rightContentWidth,

                    height: widget.headerHeight,
                    child: Row(
                      // ignore: always_specify_types
                      children: List.generate(widget.headerContents.length, (int i) {
                        final FlexibleColumn col = widget.headerContents[i];
                        return FlexibleTable.headerCell(
                          text: col.title,
                          width: col.width,
                          height: widget.headerHeight,
                          decoration: widget.headerDecoration,
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        final Widget body = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints bodyBox) {
            final double bodyHeight = bodyBox.maxHeight;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: widget.leftColumnWidth,
                  child: Scrollbar(
                    controller: _leftVertical,
                    thumbVisibility: true,
                    child: SizedBox(
                      height: bodyHeight,
                      child: ListView.builder(
                        controller: _leftVertical,
                        itemCount: widget.rowCount,
                        itemExtent: widget.rowHeight,
                        cacheExtent: widget.rowHeight * widget.cacheExtentRows,
                        itemBuilder: (BuildContext context, int row) => widget.buildLeftCell(context, row),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),

                Expanded(
                  child: SingleChildScrollView(
                    controller: _bodyHorizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: rightContentWidth,

                      height: bodyHeight,

                      child: Scrollbar(
                        controller: _rightVertical,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _rightVertical,
                          itemCount: widget.rowCount,
                          itemExtent: widget.rowHeight,
                          cacheExtent: widget.rowHeight * widget.cacheExtentRows,

                          primary: false,
                          itemBuilder: (BuildContext context, int row) {
                            return Row(
                              // ignore: always_specify_types
                              children: List.generate(widget.headerContents.length, (int colIdx) {
                                return SizedBox(
                                  width: widget.headerContents[colIdx].width,
                                  height: widget.rowHeight,
                                  child: widget.buildCell(context, row, colIdx),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleInitialScrollIfNeeded());

        return Column(
          children: <Widget>[
            header,
            const SizedBox(height: 2),
            Expanded(child: body),
          ],
        );
      },
    );
  }
}
