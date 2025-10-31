import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../extensions/extensions.dart';
import '../models/bounding_box_info_model.dart';
import '../models/geoloc_model.dart';
import '../models/temple_model.dart';
import '../models/transportation_model.dart';

class Utility {
  /// 背景取得
  // ignore: always_specify_types
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/images/bg.jpg',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  ///
  void showError(String msg) {
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  ///
  Color getYoubiColor({required String date, required String youbiStr, required List<String> holiday}) {
    Color color = Colors.black.withValues(alpha: 0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withValues(alpha: 0.2);

      case 'Saturday':
        color = Colors.blueAccent.withValues(alpha: 0.2);

      default:
        color = Colors.black.withValues(alpha: 0.2);
    }

    if (holiday.contains(date)) {
      color = Colors.greenAccent.withValues(alpha: 0.2);
    }

    return color;
  }

  ///
  Color getLifetimeRowBgColor({required String value, required bool textDisplay}) {
    final double opa = (!textDisplay) ? 0.4 : 0.2;

    switch (value) {
      case '自宅':
      case '実家':
        return Colors.white.withValues(alpha: opa);

      case '睡眠':
        return Colors.yellowAccent.withValues(alpha: opa);

      case '移動':
        return Colors.green.withValues(alpha: opa);

      case '仕事':
        return Colors.indigo.withValues(alpha: opa);

      case '外出':
      case '旅行':
      case 'イベント':
        return Colors.pinkAccent.withValues(alpha: opa);

      case 'ボクシング':
      case '俳句会':
      case '勉強':
        return Colors.purpleAccent.withValues(alpha: opa);

      case '飲み会':
        return Colors.orangeAccent.withValues(alpha: opa);

      case '歩き':
        return Colors.lightBlueAccent.withValues(alpha: opa);

      case '緊急事態':
        return Colors.redAccent.withValues(alpha: opa);
    }

    return Colors.transparent;
  }

  ///
  List<Color> getTwentyFourColor() {
    return <Color>[
      const Color(0xFFE53935), // 赤 (100%)
      const Color(0xFF1E88E5), // 青 (100%)
      const Color(0xFF43A047), // 緑 (100%)
      const Color(0xFFFFA726), // オレンジ (100%)
      const Color(0xFF8E24AA), // 紫 (100%)
      const Color(0xFF00ACC1), // シアン (100%)
      const Color(0xFFFDD835), // 黄 (100%)
      const Color(0xFF6D4C41), // 茶 (100%)
      const Color(0xFFD81B60), // ピンク (100%)
      const Color(0xFF3949AB), // インディゴ (100%)
      const Color(0xFF00897B), // ティール (100%)
      const Color(0xCCFF7043), // 明るいオレンジ (80%)
      const Color(0xFF7CB342), // ライムグリーン (100%)
      const Color(0xFF5E35B1), // ディープパープル (100%)
      const Color(0xCC26C6DA), // ライトシアン (80%)
      const Color(0xCCFFEE58), // 明るい黄 (80%)
      const Color(0xFFBDBDBD), // グレー (100%)
      const Color(0xCCEF5350), // 明るい赤 (80%)
      const Color(0xCC42A5F5), // 明るい青 (80%)
      const Color(0xCC66BB6A), // 明るい緑 (80%)
      const Color(0x99FFB74D), // 明るいオレンジ (60%)
      const Color(0xCCAB47BC), // 明るい紫 (80%)
      const Color(0xCC26A69A), // 明るいティール (80%)
      const Color(0xCCFF8A65), // サーモン (80%)
    ];
  }

  ///
  Color getTrainColor({required String trainName}) {
    final Map<String, Color> trainColorMap = <String, Color>{
      '東京メトロ銀座線': const Color(0xFFF19A38),
      '東京メトロ丸ノ内線': const Color(0xFFE24340),
      '東京メトロ日比谷線': const Color(0xFFB5B5AD),
      '東京メトロ東西線': const Color(0xFF4499BB),
      '東京メトロ千代田線': const Color(0xFF54B889),
      '東京メトロ有楽町線': const Color(0xFFBDA577),
      '東京メトロ半蔵門線': const Color(0xFF8B76D0),
      '東京メトロ南北線': const Color(0xFF4DA99B),
      '東京メトロ副都心線': const Color(0xFF93613A),
    };

    return (trainColorMap[trainName] != null)
        ? trainColorMap[trainName]!.withOpacity(0.6)
        : Colors.black.withOpacity(0.3);
  }

  /// 銀行名取得
  Map<String, String> getBankName() {
    final Map<String, String> bankNames = <String, String>{};

    bankNames['bank_a'] = 'みずほ';
    bankNames['bank_b'] = '住友547';
    bankNames['bank_c'] = '住友259';
    bankNames['bank_d'] = 'UFJ';
    bankNames['bank_e'] = '楽天';

    bankNames['pay_a'] = 'Suica1';
    bankNames['pay_b'] = 'PayPay';
    bankNames['pay_c'] = 'PASUMO';
    bankNames['pay_d'] = 'Suica2';
    bankNames['pay_e'] = 'メルカリ';
    bankNames['pay_f'] = '楽天キャッシュ';

    return bankNames;
  }

  ///
  BoundingBoxInfoModel getBoundingBoxInfo(List<GeolocModel> points) {
    final List<double> lats = points.map((GeolocModel p) => double.tryParse(p.latitude) ?? 0).toList();
    final List<double> lngs = points.map((GeolocModel p) => double.tryParse(p.longitude) ?? 0).toList();

    final double maxLat = lats.reduce((double a, double b) => a > b ? a : b);
    final double minLat = lats.reduce((double a, double b) => a < b ? a : b);
    final double maxLng = lngs.reduce((double a, double b) => a > b ? a : b);
    final double minLng = lngs.reduce((double a, double b) => a < b ? a : b);

    final LatLng southWest = LatLng(minLat, minLng);
    final LatLng northWest = LatLng(maxLat, minLng);
    final LatLng southEast = LatLng(minLat, maxLng);

    const Distance distance = Distance();
    final double northSouth = distance.as(LengthUnit.Meter, southWest, northWest);
    final double eastWest = distance.as(LengthUnit.Meter, southWest, southEast);

    final double areaKm2 = (northSouth * eastWest) / 1_000_000;

    return BoundingBoxInfoModel(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng, areaKm2: areaKm2);
  }

  ///
  String getBoundingBoxArea({required List<GeolocModel> points}) {
    if (points.isEmpty) {
      return '0.0000 km²';
    }

    final BoundingBoxInfoModel info = getBoundingBoxInfo(points);
    final NumberFormat numberFormat = NumberFormat('#,##0.0000');
    return '${numberFormat.format(info.areaKm2)} km²';
  }

  ///
  List<LatLng> getBoundingBoxPoints(List<GeolocModel> points) {
    final BoundingBoxInfoModel info = getBoundingBoxInfo(points);

    return <LatLng>[
      LatLng(info.minLat, info.minLng),
      LatLng(info.maxLat, info.minLng),
      LatLng(info.maxLat, info.maxLng),
      LatLng(info.minLat, info.maxLng),
    ];
  }

  ///
  double calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }

  ///
  String getTempleReachTimeFromTemplePhotoList({required String date, required TempleDataModel temple}) {
    String ret = '-';

    List<String> photoList = <String>[];

    if (temple.templePhotoModelList != null) {
      for (final TemplePhotoModel element in temple.templePhotoModelList!) {
        if (element.date == date) {
          photoList = element.templephotos;
        }
      }
    }

    if (photoList.isNotEmpty) {
      final String firstPhoto = photoList.first;

      final List<String> exFirstPhoto = firstPhoto.split('/');
      final List<String> exFirstPhotoLast = exFirstPhoto[exFirstPhoto.length - 1].split('_');
      final String hour = exFirstPhotoLast[1].substring(0, 2);
      final String minute = exFirstPhotoLast[1].substring(2, 4);
      ret = '$hour:$minute';
    }

    return ret;
  }

  ///
  List<StationModel> filterByBoundingBox({
    required List<StationModel> stationList,

    required double baseLat,
    required double baseLng,
    required double radiusKm,
  }) {
    const double earthRadiusKm = 111.0;
    final double latRange = radiusKm / earthRadiusKm;
    final double lngRange = radiusKm / (earthRadiusKm * cos(baseLat * pi / 180.0));

    return stationList.where((StationModel station) {
      final double latDiff = (station.lat.toDouble() - baseLat).abs();
      final double lngDiff = (station.lng.toDouble() - baseLng).abs();
      return latDiff <= latRange && lngDiff <= lngRange;
    }).toList();
  }

  ///
  int getListSum<T>(List<T> list, int Function(T) selector) {
    // ignore: always_specify_types
    return list.fold<int>(0, (int sum, element) => sum + selector(element));
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
