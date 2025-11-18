import 'package:flutter/material.dart';

import '../../models/stamp_rally_model.dart';
import '../../models/temple_model.dart';
import '../../models/weekly_history_badge_model.dart';

void iconToolChipDisplayOverlay({
  required String type,
  required BuildContext context,
  required GlobalKey buttonKey,
  Duration displayDuration = const Duration(seconds: 1),
  Duration fadeDuration = const Duration(milliseconds: 300),
  double? timeGutterWidth,
  int? dayIndex,
  TempleDataModel? templeDataModel,
  StampRallyModel? stampRallyModel,
  WeeklyHistoryBadgeModel? weeklyHistoryBadgeModel,
}) {
  final OverlayState overlayState = Overlay.of(context);

  final RenderBox? renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return;
  }

  final Offset buttonOffset = renderBox.localToGlobal(Offset.zero);

  final AnimationController animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: fadeDuration,
  );

  final CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

  late OverlayEntry? overlayEntry;

  switch (type) {
    case 'weekly_history_alert_badge':
      overlayEntry = getOverlayContents(
        type: type,
        buttonOffset: buttonOffset,
        curvedAnimation: curvedAnimation,
        timeGutterWidth: timeGutterWidth,
        dayIndex: dayIndex,
        weeklyHistoryBadgeModel: weeklyHistoryBadgeModel,
      );

    case 'lifetime_geoloc_map_display_alert_icon':
    case 'stamp_rally_map_alert_icon':
      overlayEntry = getOverlayContents(
        type: type,
        buttonOffset: buttonOffset,
        curvedAnimation: curvedAnimation,
        templeDataModel: templeDataModel,
        stampRallyModel: stampRallyModel,
      );
  }

  if (overlayEntry != null) {
    overlayState.insert(overlayEntry);
    animationController.forward();

    // ignore: always_specify_types
    Future.delayed(displayDuration, () async {
      await animationController.reverse();
      overlayEntry!.remove();
      animationController.dispose();
    });
  }
}

///
OverlayEntry? getOverlayContents({
  required String type,
  required Offset buttonOffset,
  required CurvedAnimation curvedAnimation,
  double? timeGutterWidth,
  int? dayIndex,
  WeeklyHistoryBadgeModel? weeklyHistoryBadgeModel,
  TempleDataModel? templeDataModel,
  StampRallyModel? stampRallyModel,
}) {
  switch (type) {
    case 'weekly_history_alert_badge':
      return OverlayEntry(
        builder: (BuildContext context) {
          return Positioned(
            left: 0,
            right: 0,
            top: buttonOffset.dy - 15,
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: curvedAnimation,
                child: Padding(
                  padding: EdgeInsets.only(left: 30 + timeGutterWidth!, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (<int>[1, 2, 3, 4, 5, 6].contains(dayIndex)) ...<Widget>[const SizedBox.shrink()],

                      Text(
                        weeklyHistoryBadgeModel!.tooltip ?? '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),

                      if (<int>[0, 1, 2, 3, 4, 5].contains(dayIndex)) ...<Widget>[const SizedBox.shrink()],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

    case 'lifetime_geoloc_map_display_alert_icon':
    case 'stamp_rally_map_alert_icon':
      return OverlayEntry(
        builder: (BuildContext context) {
          return Positioned(
            left: buttonOffset.dx,
            top: buttonOffset.dy - 15,
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: curvedAnimation,

                child: Text(
                  displayText(templeDataModel: templeDataModel, stampRallyModel: stampRallyModel),
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          );
        },
      );
  }

  return null;
}

///
String displayText({TempleDataModel? templeDataModel, StampRallyModel? stampRallyModel}) {
  if (templeDataModel != null) {
    return templeDataModel.name;
  } else if (stampRallyModel != null) {
    return stampRallyModel.stationName;
  }

  return '';
}
