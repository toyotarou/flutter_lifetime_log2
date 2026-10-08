import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';

//=======================================================//

class DraggableOverlayItem {
  DraggableOverlayItem({required this.position, required this.width, required this.height, required this.color});

  late OverlayEntry entry;

  Offset position;

  final double width;
  final double height;

  final Color color;
}

//=======================================================//

OverlayEntry createDraggableOverlayEntry({
  required BuildContext context,
  required Offset initialOffset,
  required double width,
  required double height,
  required Color color,
  required VoidCallback onRemove,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
}) {
  final Size screenSize = MediaQuery.sizeOf(context);

  final DraggableOverlayItem item = DraggableOverlayItem(
    position: initialOffset,
    width: width,
    height: height,
    color: color,
  );

  final OverlayEntry entry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        left: item.position.dx,
        top: item.position.dy,
        child: Material(
          elevation: 8,
          color: item.color,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: item.width,
            height: item.height,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: 40,
                  width: double.infinity,
                  child: Listener(
                    // ignore: use_if_null_to_convert_nulls_to_bools
                    onPointerMove: (fixedFlag == true)
                        ? null
                        : (PointerMoveEvent event) {
                            if (event.buttons == 1) {
                              item.position += event.delta;

                              final double maxX = screenSize.width - item.width;
                              final double maxY = screenSize.height - item.height;
                              final num clampedX = item.position.dx.clamp(0, maxX);
                              final num clampedY = item.position.dy.clamp(0, maxY);

                              item.position = Offset(clampedX.toDouble(), clampedY.toDouble());

                              onPositionChanged(item.position);

                              item.entry.markNeedsBuild();
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ignore: use_if_null_to_convert_nulls_to_bools
                        if (fixedFlag == true)
                          const Icon(Icons.check_box_outline_blank, color: Colors.transparent)
                        else
                          const Icon(Icons.drag_indicator, color: Colors.white),
                        const Expanded(child: Text('')),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(width: double.infinity),
                        widget,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  item.entry = entry;
  return entry;
}

//=======================================================//

///
void addFirstOverlay({
  required BuildContext context,
  required List<OverlayEntry> firstEntries,
  required List<OverlayEntry> secondEntries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
  WidgetRef? ref,
  String? from,
}) {
  if (firstEntries.isNotEmpty) {
    firstEntries.forEach(_removeOverlayEntrySafely);
    setStateCallback(() => firstEntries.clear());
  }

  late OverlayEntry entry;
  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      entry.remove();
      setStateCallback(() => firstEntries.remove(entry));
    },
    widget: widget,
    onPositionChanged: onPositionChanged,
    fixedFlag: fixedFlag,
  );

  setStateCallback(() => firstEntries.add(entry));

  final OverlayState overlayState = Overlay.of(context);

  if (secondEntries.isNotEmpty) {
    overlayState.insert(entry, above: secondEntries.last);
  } else {
    overlayState.insert(entry);
  }
}

//=======================================================//

///
void addSecondOverlay({
  required BuildContext context,
  required List<OverlayEntry> secondEntries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
  required ValueChanged<Offset> onPositionChanged,
  bool? fixedFlag,
}) {
  if (secondEntries.isNotEmpty) {
    secondEntries.forEach(_removeOverlayEntrySafely);
    setStateCallback(() => secondEntries.clear());
  }

  late OverlayEntry entry;
  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      entry.remove();
      setStateCallback(() => secondEntries.remove(entry));
    },
    widget: widget,
    onPositionChanged: onPositionChanged,
    fixedFlag: fixedFlag,
  );

  setStateCallback(() => secondEntries.add(entry));
  Overlay.of(context).insert(entry);
}

///
/// 修正: コールバック（onTap / post-frame）から呼ばれるため ref.watch ではなく ref.read を使う
void closeAllOverlays({required WidgetRef ref}) {
  final AppParamState appParam = ref.read(appParamProvider);

  final List<OverlayEntry>? firstEntries = appParam.firstEntries;

  if (firstEntries != null) {
    firstEntries.forEach(_removeOverlayEntrySafely);
  }

  final List<OverlayEntry>? secondEntries = appParam.secondEntries;

  if (secondEntries != null) {
    secondEntries.forEach(_removeOverlayEntrySafely);
  }
}

///
/// closeAllOverlays で外した後もリストに残っている entry を再度 remove すると
/// OverlayEntry 内部の assert / null チェックで例外になるため、外れ済みの entry は無視する
void _removeOverlayEntrySafely(OverlayEntry e) {
  try {
    e.remove();
  } on Object catch (_) {
    // 既に Overlay から外れている entry（何もしない）
  }
}
