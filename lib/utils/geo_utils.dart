import 'dart:math';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../extensions/extensions.dart';
import '../models/bounding_box_info_model.dart';
import '../models/geoloc_model.dart';
import '../models/transportation_model.dart';

/// 緯度経度・距離・BBox 周りのユーティリティ
class GeoUtils {
  GeoUtils._();

  /// 2点間距離（メートル）
  static double calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }

  /// BBox 情報（min/max と 面積km^2）
  static BoundingBoxInfoModel getBoundingBoxInfo(List<GeolocModel> points) {
    final List<double> lats = points.map((GeolocModel p) => double.tryParse(p.latitude) ?? 0).toList();
    final List<double> lngs = points.map((GeolocModel p) => double.tryParse(p.longitude) ?? 0).toList();

    final double maxLat = lats.reduce(max);
    final double minLat = lats.reduce(min);
    final double maxLng = lngs.reduce(max);
    final double minLng = lngs.reduce(min);

    final LatLng southWest = LatLng(minLat, minLng);
    final LatLng northWest = LatLng(maxLat, minLng);
    final LatLng southEast = LatLng(minLat, maxLng);

    const Distance distance = Distance();
    final double northSouth = distance.as(LengthUnit.Meter, southWest, northWest);
    final double eastWest = distance.as(LengthUnit.Meter, southWest, southEast);

    final double areaKm2 = (northSouth * eastWest) / 1_000_000;

    return BoundingBoxInfoModel(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng, areaKm2: areaKm2);
  }

  /// BBox 面積(km^2)を "0,000.0000 km²" 表示
  static String getBoundingBoxArea({required List<GeolocModel> points}) {
    if (points.isEmpty) {
      return '0.0000 km²';
    }
    final BoundingBoxInfoModel info = getBoundingBoxInfo(points);
    final NumberFormat nf = NumberFormat('#,##0.0000');
    return '${nf.format(info.areaKm2)} km²';
  }

  /// BBox 四隅を返す（SW -> NW -> NE -> SE）
  static List<LatLng> getBoundingBoxPoints(List<GeolocModel> points) {
    final BoundingBoxInfoModel info = getBoundingBoxInfo(points);
    return <LatLng>[
      LatLng(info.minLat, info.minLng),
      LatLng(info.maxLat, info.minLng),
      LatLng(info.maxLat, info.maxLng),
      LatLng(info.minLat, info.maxLng),
    ];
  }

  /// 指定座標に最も近い GeolocModel を返す
  static GeolocModel? findNearestGeoloc({
    required List<GeolocModel> geolocModelList,
    required String latStr,
    required String lonStr,
  }) {
    final double? targetLat = double.tryParse(latStr);
    final double? targetLon = double.tryParse(lonStr);
    if (targetLat == null || targetLon == null || geolocModelList.isEmpty) {
      return null;
    }

    final LatLng target = LatLng(targetLat, targetLon);
    GeolocModel? nearest;
    double best = double.infinity;

    for (final GeolocModel e in geolocModelList) {
      final double? lat = double.tryParse(e.latitude);
      final double? lon = double.tryParse(e.longitude);
      if (lat == null || lon == null) {
        continue;
      }

      final double d = calculateDistance(target, LatLng(lat, lon));
      if (d < best) {
        best = d;
        nearest = e;
        if (d == 0) {
          break;
        }
      }
    }
    return nearest;
  }

  /// 粗いBBoxで事前フィルタ（駅などの大量データ向け）
  static List<StationModel> filterByBoundingBox({
    required List<StationModel> stationList,
    required double baseLat,
    required double baseLng,
    required double radiusKm,
  }) {
    // 緯度1度≒111km 基準の簡易BBox
    const double earthRadiusKm = 111.0;
    final double latRange = radiusKm / earthRadiusKm;
    final double lngRange = radiusKm / (earthRadiusKm * cos(baseLat * pi / 180.0));

    return stationList.where((StationModel station) {
      final double latDiff = (station.lat.toDouble() - baseLat).abs();
      final double lngDiff = (station.lng.toDouble() - baseLng).abs();
      return latDiff <= latRange && lngDiff <= lngRange;
    }).toList();
  }
}
