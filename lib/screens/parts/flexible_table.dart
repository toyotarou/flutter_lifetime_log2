import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class FlexibleColumn {
  const FlexibleColumn({required this.title, required this.width});

  final String title;
  final double width;
}

//////////////////////////////////////////////////////////////////////////////////////

// ignore: must_be_immutable
class FlexibleTable extends StatefulWidget {
  FlexibleTable({
    super.key,
    required this.rowCount,
    required this.headerContents,
    required this.buildLeftCell,
    required this.buildCell,
    this.leftColumnWidth = 80,
    this.leftHeader,

    this.headerHeight = 24,
    this.rowHeight = 36,

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
    this.onControllerReady,
  });

  FlexibleTableController? _tableCtl;

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

  final void Function(FlexibleTableController controller)? onControllerReady;

  ///
  @override
  State<FlexibleTable> createState() => _FlexibleTableState();

  /// 日付側　ヘッダーセル
  static Widget headerCell({
    required String text,
    required double width,
    required double height,
    BoxDecoration decoration = const BoxDecoration(border: Border.fromBorderSide(BorderSide())),
    TextStyle textStyle = const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 6),
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

  /// 左側　日付セル
  static Widget bodyCell({
    required String text,
    required double width,
    required double height,
    BoxDecoration decoration = const BoxDecoration(border: Border.fromBorderSide(BorderSide())),
    Alignment alignment = Alignment.centerLeft,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    TextStyle? textStyle,
    required List<String> holiday,
  }) {
    final String youbi = DateTime.parse(text).youbiStr;
    final Utility utility = Utility();

    final TextStyle resolvedTextStyle = textStyle ?? const TextStyle(fontSize: 10);

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text, style: resolvedTextStyle),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: utility.getYoubiColor(date: text, youbiStr: youbi, holiday: holiday).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(youbi.substring(0, 3), style: resolvedTextStyle),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////

class FlexibleTableController {
  FlexibleTableController._(this._state);

  final _FlexibleTableState _state;

  ///
  Future<void> scrollToTop({Duration? duration, Curve curve = Curves.easeOut}) async {
    if (!_state._rightVertical.hasClients) {
      return;
    }
    final Duration d = duration ?? _state.widget.autoScrollDuration;
    await _state._rightVertical.animateTo(0, duration: d, curve: curve);
  }

  ///
  Future<void> scrollToRow(int row, {Duration? duration, Curve curve = Curves.easeOut}) async {
    if (!_state._rightVertical.hasClients) {
      return;
    }
    final double raw = _state.widget.rowHeight * row.toDouble();
    final double max = _state._rightVertical.position.maxScrollExtent;
    final double target = raw.clamp(0.0, max);
    final Duration d = duration ?? _state.widget.autoScrollDuration;
    await _state._rightVertical.animateTo(target, duration: d, curve: curve);
  }

  ///
  Future<void> scrollToBottom({Duration? duration, Curve curve = Curves.easeOut}) async {
    if (!_state._rightVertical.hasClients) {
      return;
    }
    final Duration d = duration ?? _state.widget.autoScrollDuration;
    await _state._rightVertical.animateTo(_state._rightVertical.position.maxScrollExtent, duration: d, curve: curve);
  }
}

//////////////////////////////////////////////////////////////////////////////////////

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

  ///
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

    widget._tableCtl = FlexibleTableController._(this);
    widget.onControllerReady?.call(widget._tableCtl!);
  }

  ///
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

  ///
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

  ///
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
                      padding: const EdgeInsets.symmetric(horizontal: 6),
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
