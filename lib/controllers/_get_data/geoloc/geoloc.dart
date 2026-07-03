import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../models/geoloc_model.dart';
import '../../app_param/app_param.dart';

part 'geoloc.freezed.dart';

part 'geoloc.g.dart';

@freezed
class GeolocState with _$GeolocState {
  const factory GeolocState({
    @Default(<GeolocModel>[]) List<GeolocModel> geolocList,
    @Default(<String, List<GeolocModel>>{}) Map<String, List<GeolocModel>> geolocMap,
  }) = _GeolocState;
}

@riverpod
class Geoloc extends _$Geoloc {
  // 取得済み年月を管理（重複リクエスト防止）
  final Set<String> _fetchedMonths = <String>{};

  ///
  @override
  GeolocState build() => const GeolocState();

  //----------------------------------------------------------------------------------//

  /// 指定年月（例: "2026-07"）のデータだけを取得して既存データにマージする
  static const String _geolocMonthlyUrl = 'http://49.212.175.205:8081/api/getYearMonthGeoloc';

  Future<void> getGeolocDataByYearmonth(String yearmonth) async {
    if (yearmonth.isEmpty) {
      return;
    }
    if (_fetchedMonths.contains(yearmonth)) {
      return;
    }

    // 先に追加してから取得（並行リクエスト防止）
    _fetchedMonths.add(yearmonth);

    final HttpClient client = ref.read(httpClientProvider);

    try {
      final Map<String, List<GeolocModel>> newEntries = <String, List<GeolocModel>>{};

      // date パラメータは月の1日（例: "2026-07-01"）
      final String dateParam = '$yearmonth-01';

      // ignore: always_specify_types
      await client.getByPath(path: '$_geolocMonthlyUrl?date=$dateParam').then((value) {
        // レスポンスは { "data": [...] } 形式
        // ignore: avoid_dynamic_calls
        final List<dynamic> list = value['data'] as List<dynamic>;

        for (int i = 0; i < list.length; i++) {
          final GeolocModel val = GeolocModel.fromJson(list[i] as Map<String, dynamic>);

          (newEntries['${val.year}-${val.month}-${val.day}'] ??= <GeolocModel>[]).add(val);
        }
      });

      // geolocState にマージ
      final Map<String, List<GeolocModel>> merged = Map<String, List<GeolocModel>>.from(state.geolocMap)
        ..addAll(newEntries);
      state = state.copyWith(geolocMap: merged);

      // appParamState.keepGeolocMap にも直接マージ（HomeScreen 経由を待たずに即反映）
      ref.read(appParamProvider.notifier).mergeKeepGeolocMap(map: newEntries);
    } catch (e) {
      // 失敗時はリセットして再試行できるようにする
      _fetchedMonths.remove(yearmonth);
      debugPrint('getGeolocDataByYearmonth error ($yearmonth): $e');
    }
  }

  //----------------------------------------------------------------------------------//

  //----------------------------------------------------------------------------------//

  /// 日付範囲（例: from="2026-06-29" to="2026-07-05"）のデータを取得してマージ
  static const String _geolocDateRangeUrl = 'http://49.212.175.205:8081/api/getDateRangeGeoloc';

  final Set<String> _fetchedRanges = <String>{};

  Future<void> getGeolocDataByDateRange(String from, String to) async {
    if (from.isEmpty || to.isEmpty) {
      return;
    }

    final String rangeKey = '$from|$to';
    if (_fetchedRanges.contains(rangeKey)) {
      return;
    }
    _fetchedRanges.add(rangeKey);

    final HttpClient client = ref.read(httpClientProvider);

    try {
      final Map<String, List<GeolocModel>> newEntries = <String, List<GeolocModel>>{};

      // ignore: always_specify_types
      await client.getByPath(path: '$_geolocDateRangeUrl?from=$from&to=$to').then((value) {
        // ignore: avoid_dynamic_calls
        final List<dynamic> list = value['data'] as List<dynamic>;

        for (int i = 0; i < list.length; i++) {
          final GeolocModel val = GeolocModel.fromJson(list[i] as Map<String, dynamic>);
          (newEntries['${val.year}-${val.month}-${val.day}'] ??= <GeolocModel>[]).add(val);
        }
      });

      final Map<String, List<GeolocModel>> merged = Map<String, List<GeolocModel>>.from(state.geolocMap)
        ..addAll(newEntries);
      state = state.copyWith(geolocMap: merged);

      ref.read(appParamProvider.notifier).mergeKeepGeolocMap(map: newEntries);
    } catch (e) {
      _fetchedRanges.remove(rangeKey);
      debugPrint('getGeolocDataByDateRange error ($from - $to): $e');
    }
  }

  //----------------------------------------------------------------------------------//
}
