import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'glow_blink.dart';

class GlowingPolylineLayer extends StatefulWidget {
  const GlowingPolylineLayer({
    super.key,
    required this.points,
    this.coreColor = Colors.cyanAccent,
    this.glowColor = Colors.cyan,
    this.coreWidth = 4.0,
    this.glowMinWidth = 10.0,
    this.glowMaxWidth = 24.0,
    this.maxGlowOpacityOuter = 0.45,
    this.maxGlowOpacityMiddle = 0.60,
    this.blink,
    this.ownPeriod,
    this.ownCurve,
  });

  final List<LatLng> points;

  final Color coreColor;
  final double coreWidth;

  final Color glowColor;
  final double glowMinWidth;
  final double glowMaxWidth;
  final double maxGlowOpacityOuter;
  final double maxGlowOpacityMiddle;

  final GlowBlink? blink;
  final Duration? ownPeriod;
  final Curve? ownCurve;

  @override
  State<GlowingPolylineLayer> createState() => _GlowingPolylineLayerState();
}

class _GlowingPolylineLayerState extends State<GlowingPolylineLayer> with SingleTickerProviderStateMixin {
  GlowBlink? _owned;

  late Animation<double> _t;

  ///
  @override
  void initState() {
    super.initState();
    if (widget.blink != null) {
      _t = widget.blink!.t;
    } else {
      _owned = GlowBlink(
        vsync: this,
        period: widget.ownPeriod ?? const Duration(seconds: 2),
        curve: widget.ownCurve ?? Curves.easeInOut,
      );
      _t = _owned!.t;
    }
  }

  ///
  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  ///
  (double width, double opacity) _glow(
    double t, {
    required double minW,
    required double maxW,
    required double maxOpacity,
  }) {
    final double pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    final double w = _lerp(minW, maxW, pulse);
    final double a = _lerp(0.25, maxOpacity, pulse);
    return (w, a);
  }

  ///
  double _lerp(double a, double b, double t) => a + (b - a) * t;

  ///
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (BuildContext context, _) {
        final (double wOuter, double aOuter) = _glow(
          _t.value,
          minW: widget.glowMinWidth,
          maxW: widget.glowMaxWidth,
          maxOpacity: widget.maxGlowOpacityOuter,
        );
        final (double wMid, double aMid) = _glow(
          _t.value,
          minW: widget.glowMinWidth * 0.6,
          maxW: widget.glowMaxWidth * 0.75,
          maxOpacity: widget.maxGlowOpacityMiddle,
        );

        // ignore: always_specify_types
        return PolylineLayer(
          polylines: <Polyline<Object>>[
            // ignore: always_specify_types
            Polyline(points: widget.points, color: widget.glowColor.withOpacity(aOuter), strokeWidth: wOuter),
            // ignore: always_specify_types
            Polyline(points: widget.points, color: widget.glowColor.withOpacity(aMid), strokeWidth: wMid),
            // ignore: always_specify_types
            Polyline(
              points: widget.points,
              color: widget.coreColor,
              strokeWidth: widget.coreWidth,
              borderColor: Colors.white.withOpacity(0.25),
              borderStrokeWidth: widget.coreWidth * 0.4,
            ),
          ],
        );
      },
    );
  }
}
