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
  List<Color> getTwelveColor() {
    return <Color>[
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
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
  int elapsedMonthsByCutoff({required DateTime start, required DateTime end}) {
    if (end.isBefore(start)) {
      return 0;
    }

    final int yearDiff = end.year - start.year;
    final int monthDiff = end.month - start.month;
    int totalMonths = yearDiff * 12 + monthDiff;

    final DateTime cutoffThisMonth = DateTime(end.year, end.month, start.day);

    final bool checkA =
        (cutoffThisMonth.weekday == DateTime.saturday || cutoffThisMonth.weekday == DateTime.sunday) &&
        end.isBefore(DateTime(end.year, end.month, start.day + 1));

    final bool checkB =
        cutoffThisMonth.weekday != DateTime.saturday &&
        cutoffThisMonth.weekday != DateTime.sunday &&
        end.day < start.day;

    if (checkA || checkB) {
      totalMonths -= 1;
    }

    return totalMonths;
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
