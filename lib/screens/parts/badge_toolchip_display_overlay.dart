import 'package:flutter/material.dart';

void showBadgeToolChipDisplayOverlay({
  required BuildContext context,
  required GlobalKey buttonKey,
  required int dayIndex,
  required String message,
  Duration displayDuration = const Duration(seconds: 1),
  Duration fadeDuration = const Duration(milliseconds: 300),
  required double timeGutterWidth,
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

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
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
              padding: EdgeInsets.only(left: 30 + timeGutterWidth, right: 30),
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

  overlayState.insert(overlayEntry);
  animationController.forward();

  // ignore: always_specify_types
  Future.delayed(displayDuration, () async {
    await animationController.reverse();
    overlayEntry.remove();
    animationController.dispose();
  });
}
