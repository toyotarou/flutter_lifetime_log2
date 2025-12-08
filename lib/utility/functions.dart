import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../extensions/extensions.dart';
import '../models/lifetime_model.dart';
import '../models/municipal_model.dart';

///
List<String> generateFullMonthDays() {
  final DateTime base = DateTime(2024);

  final DateTime end = DateTime(2024, 12, 31);

  final List<String> out = <String>[];

  for (DateTime d = base; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
    out.add('${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}');
  }

  return out;
}

///
List<String> getLifetimeData({required LifetimeModel lifetimeModel}) {
  return <String>[
    lifetimeModel.hour00,
    lifetimeModel.hour01,
    lifetimeModel.hour02,
    lifetimeModel.hour03,
    lifetimeModel.hour04,
    lifetimeModel.hour05,
    lifetimeModel.hour06,
    lifetimeModel.hour07,
    lifetimeModel.hour08,
    lifetimeModel.hour09,
    lifetimeModel.hour10,
    lifetimeModel.hour11,
    lifetimeModel.hour12,
    lifetimeModel.hour13,
    lifetimeModel.hour14,
    lifetimeModel.hour15,
    lifetimeModel.hour16,
    lifetimeModel.hour17,
    lifetimeModel.hour18,
    lifetimeModel.hour19,
    lifetimeModel.hour20,
    lifetimeModel.hour21,
    lifetimeModel.hour22,
    lifetimeModel.hour23,
  ];
}

///
Map<int, T> getDuplicateConsecutiveMap<T>(List<T> list) {
  if (list.isEmpty) {
    return const <int, Never>{};
  }

  final Map<int, T> result = <int, T>{};

  // ignore: always_specify_types
  var last = list[0];

  result[0] = last;

  for (int i = 1; i < list.length; i++) {
    // ignore: always_specify_types
    final current = list[i];

    if (current != last) {
      result[i] = current;
      last = current;
    }
  }

  return result;
}

///
List<Map<String, dynamic>> getStartEndTitleList({required Map<int, String> data}) {
  final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];

  final List<int> keys = data.keys.toList()..sort();

  for (int i = 0; i < keys.length; i++) {
    final int startHour = keys[i];
    final String title = data[startHour] ?? '';

    final int endHour = (i < keys.length - 1) ? keys[i + 1] : 24;

    result.add(<String, dynamic>{'startHour': startHour, 'endHour': endHour, 'title': title});
  }

  return result;
}

///
Map<String, String> getWeeklyHistoryDisplayWeekDate({required String date}) {
  final Map<String, String> map = <String, String>{};

  for (int i = 0; i < 7; i++) {
    final String youbi = DateTime.parse(date).add(Duration(days: i)).youbiStr;
    final String ymd = DateTime.parse(date).add(Duration(days: i)).yyyymmdd;

    map[youbi] = ymd;
  }

  return map;
}

///////////////////////////////////////////////////////////////////////////

const double _eps = 1e-12;

///
String? findMunicipalityForPoint(double lat, double lng, List<MunicipalModel> tokyoMunicipalList) {
  for (final MunicipalModel m in tokyoMunicipalList) {
    if (spotInMunicipality(lat, lng, m)) {
      return m.name;
    }
  }

  return null;
}

///
bool spotInMunicipality(double lat, double lng, MunicipalModel muni) {
  for (final List<List<List<double>>> polygon in muni.polygons) {
    if (polygon.isEmpty) {
      continue;
    }

    final List<List<double>> outerRing = polygon.first;

    if (!_pointInRingOrOnEdge(lat, lng, outerRing)) {
      continue;
    }

    bool inAnyHole = false;

    for (int i = 1; i < polygon.length; i++) {
      final List<List<double>> holeRing = polygon[i];

      if (_pointInRingOrOnEdge(lat, lng, holeRing)) {
        inAnyHole = true;

        break;
      }
    }

    if (!inAnyHole) {
      return true;
    }
  }

  return false;
}

///
bool _pointInRingOrOnEdge(double lat, double lng, List<List<double>> ring) {
  for (int i = 0; i < ring.length; i++) {
    final List<double> a = ring[i];

    final List<double> b = ring[(i + 1) % ring.length];

    final double aLng = a[0], aLat = a[1];

    final double bLng = b[0], bLat = b[1];

    if (_pointOnSegment(lat, lng, aLat, aLng, bLat, bLng)) {
      return true;
    }
  }

  return _rayCasting(lat, lng, ring);
}

///
bool _pointOnSegment(double pLat, double pLng, double aLat, double aLng, double bLat, double bLng) {
  final double minLat = (aLat < bLat) ? aLat : bLat;

  final double maxLat = (aLat > bLat) ? aLat : bLat;

  final double minLng = (aLng < bLng) ? aLng : bLng;

  final double maxLng = (aLng > bLng) ? aLng : bLng;

  final bool withinBox =
      (pLat >= minLat - _eps) && (pLat <= maxLat + _eps) && (pLng >= minLng - _eps) && (pLng <= maxLng + _eps);

  if (!withinBox) {
    return false;
  }

  final double vLat = bLat - aLat;

  final double vLng = bLng - aLng;

  final double wLat = pLat - aLat;

  final double wLng = pLng - aLng;

  final double cross = (vLng * wLat) - (vLat * wLng);

  if (cross.abs() > 1e-10) {
    return false;
  }

  final double vLen2 = vLat * vLat + vLng * vLng;

  if (vLen2 < 1e-20) {
    final double d2 = wLat * wLat + wLng * wLng;

    return d2 < 1e-20;
  }

  final double t = (wLat * vLat + wLng * vLng) / vLen2;

  return t >= -_eps && t <= 1 + _eps;
}

///
bool _rayCasting(double lat, double lng, List<List<double>> ring) {
  bool inside = false;

  for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final double xiLat = ring[i][1], xiLng = ring[i][0];

    final double xjLat = ring[j][1], xjLng = ring[j][0];

    final bool crossesVertically = (xiLat > lat) != (xjLat > lat);

    if (!crossesVertically) {
      continue;
    }

    final double t = (lat - xiLat) / (xjLat - xiLat);

    final double intersectionLng = xiLng + t * (xjLng - xiLng);

    if (intersectionLng > lng) {
      inside = !inside;
    }
  }

  return inside;
}

/////////////////////
///
// ignore: always_specify_types
Polygon? getColorPaintPolygon({required List<List<List<double>>> polygon, required Color color}) {
  if (polygon.isEmpty) {
    return null;
  }

  /////////////////////////////////////
  final List<LatLng> outer = polygon.first.map((List<double> element) => LatLng(element[1], element[0])).toList();
  /////////////////////////////////////

  /////////////////////////////////////
  final List<List<LatLng>> holes = <List<LatLng>>[];

  for (int i = 1; i < polygon.length; i++) {
    holes.add(polygon[i].map((List<double> element4) => LatLng(element4[1], element4[0])).toList());
  }
  /////////////////////////////////////

  // ignore: always_specify_types
  return Polygon(
    points: outer,
    holePointsList: holes.isEmpty ? null : holes,
    isFilled: true,
    color: color.withValues(alpha: 0.3),
    borderColor: color.withValues(alpha: 0.8),
    borderStrokeWidth: 1.5,
  );
}
