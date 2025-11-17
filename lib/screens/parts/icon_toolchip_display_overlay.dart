import 'package:flutter/material.dart';

void iconToolChipDisplayOverlay({
  required String type,

  required BuildContext context,
  required GlobalKey buttonKey,
  required String message,
  Duration displayDuration = const Duration(seconds: 1),
  Duration fadeDuration = const Duration(milliseconds: 300),

  double? timeGutterWidth,
  int? dayIndex,
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
        message: message,
        timeGutterWidth: timeGutterWidth,
        dayIndex: dayIndex,
      );

    case 'lifetime_geoloc_map_display_alert_icon':
    case 'stamp_rally_map_alert_icon':
      overlayEntry = getOverlayContents(
        type: type,
        buttonOffset: buttonOffset,
        curvedAnimation: curvedAnimation,
        message: message,
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
  required String message,
  double? timeGutterWidth,
  int? dayIndex,
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
                        message,
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
                  message,
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
