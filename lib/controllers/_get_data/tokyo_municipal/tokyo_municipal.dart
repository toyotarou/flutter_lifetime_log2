import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/municipal_model.dart';
import '../../../utility/utility.dart';

part 'tokyo_municipal.freezed.dart';

part 'tokyo_municipal.g.dart';

@freezed
class TokyoMunicipalState with _$TokyoMunicipalState {
  const factory TokyoMunicipalState({
    @Default(<MunicipalModel>[]) List<MunicipalModel> tokyoMunicipalList,
    @Default(<String, MunicipalModel>{}) Map<String, MunicipalModel> tokyoMunicipalMap,
  }) = _TokyoMunicipalState;
}

/// geojson 文字列を解析して MunicipalModel のリストを作る
/// （約186KBの JSON デコード＋座標解析を UI スレッド外で行うため、compute から呼べるトップレベル関数にしている）
List<MunicipalModel> _parseTokyoMunicipalGeoJson(String text) {
  final List<MunicipalModel> list = <MunicipalModel>[];

  // ignore: always_specify_types
  final data = jsonDecode(text);

  // ignore: always_specify_types, strict_raw_type
  final List features;
  // ignore: avoid_dynamic_calls
  if (data['type'] == 'FeatureCollection') {
    // ignore: avoid_dynamic_calls, always_specify_types
    features = data['features'] as List;

    // ignore: avoid_dynamic_calls
  } else if (data['type'] == 'Feature') {
    features = <dynamic>[data];
  } else {
    // ignore: avoid_dynamic_calls
    throw Exception('Unsupported root type: ${data['type']}');
  }

  // ignore: always_specify_types
  for (final f in features) {
    // ignore: avoid_dynamic_calls
    final Map<String, dynamic> props = Map<String, dynamic>.from(f['properties'] as Map<String, dynamic>);

    // ignore: avoid_dynamic_calls
    final Map<String, dynamic> geom = Map<String, dynamic>.from(f['geometry'] as Map<String, dynamic>);

    if (geom.isEmpty) {
      continue;
    }

    final String name = (props['N03_004'] ?? props['name'] ?? '') as String;
    if (name.isEmpty) {
      continue;
    }

    final String? type = geom['type'] as String?;

    // ignore: always_specify_types
    final coords = geom['coordinates'];

    int count = 0;

    double? minLat, minLng, maxLat, maxLng;

    final List<List<List<List<double>>>> polygons = <List<List<List<double>>>>[];

    double sumLat = 0, sumLng = 0;

    int ptCnt = 0;

    void addPoint(double lng, double lat) {
      count++;

      minLat = (minLat == null) ? lat : (lat < minLat! ? lat : minLat);

      maxLat = (maxLat == null) ? lat : (lat > maxLat! ? lat : maxLat);

      minLng = (minLng == null) ? lng : (lng < minLng! ? lng : minLng);

      maxLng = (maxLng == null) ? lng : (lng > maxLng! ? lng : maxLng);

      sumLat += lat;

      sumLng += lng;

      ptCnt++;
    }

    if (type == 'Polygon') {
      final List<List<List<double>>> rings = <List<List<double>>>[];

      // ignore: always_specify_types
      for (final ring in (coords as List)) {
        final List<List<double>> rr = <List<double>>[];

        // ignore: always_specify_types
        for (final pt in (ring as List)) {
          // ignore: avoid_dynamic_calls
          final double lng = (pt[0] as num).toDouble();

          // ignore: avoid_dynamic_calls
          final double lat = (pt[1] as num).toDouble();

          addPoint(lng, lat);

          rr.add(<double>[lng, lat]);
        }

        rings.add(rr);
      }

      polygons.add(rings);
    } else if (type == 'MultiPolygon') {
      // ignore: always_specify_types
      for (final poly in (coords as List)) {
        final List<List<List<double>>> rings = <List<List<double>>>[];

        // ignore: always_specify_types
        for (final ring in (poly as List)) {
          final List<List<double>> rr = <List<double>>[];

          // ignore: always_specify_types
          for (final pt in (ring as List)) {
            // ignore: avoid_dynamic_calls
            final double lng = (pt[0] as num).toDouble();

            // ignore: avoid_dynamic_calls
            final double lat = (pt[1] as num).toDouble();

            addPoint(lng, lat);

            rr.add(<double>[lng, lat]);
          }

          rings.add(rr);
        }

        polygons.add(rings);
      }
    } else {
      continue;
    }

    final double centroidLat = ptCnt == 0 ? 0.0 : (sumLat / ptCnt);

    final double centroidLng = ptCnt == 0 ? 0.0 : (sumLng / ptCnt);

    final MunicipalModel val = MunicipalModel(
      name,
      count,
      minLat: minLat ?? 0,
      minLng: minLng ?? 0,
      maxLat: maxLat ?? 0,
      maxLng: maxLng ?? 0,
      polygons: polygons,
      centroidLat: centroidLat,
      centroidLng: centroidLng,
    );

    list.add(val);
  }

  return list;
}

@riverpod
class TokyoMunicipal extends _$TokyoMunicipal {
  final Utility utility = Utility();

  ///
  @override
  TokyoMunicipalState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const TokyoMunicipalState();
  }

  //============================================== api

  ///
  Future<TokyoMunicipalState> fetchAllTokyoMunicipalData() async {
    try {
      final List<MunicipalModel> list = <MunicipalModel>[];

      final Map<String, MunicipalModel> map = <String, MunicipalModel>{};

      //-----------------------------------------------------------------//
      const String kAssetPath = 'assets/json/tokyo_municipal.geojson';

      final String text = await rootBundle.loadString(kAssetPath);
      // デコード・解析は別 isolate で行い、結果のリスト順のまま map を組み立てる（従来と同じ state になる）
      list.addAll(await compute(_parseTokyoMunicipalGeoJson, text));

      for (final MunicipalModel val in list) {
        map[val.name] = val;
      }

      return state.copyWith(tokyoMunicipalList: list, tokyoMunicipalMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（tokyo_municipal）', error: e);
      rethrow;
    }
  }

  ///
  Future<void> getAllTokyoMunicipalData() async {
    try {
      final TokyoMunicipalState newState = await fetchAllTokyoMunicipalData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
