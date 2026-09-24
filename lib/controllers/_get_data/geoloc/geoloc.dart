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

      final dynamic value = await client.getByPath(path: '$_geolocMonthlyUrl?date=$dateParam');

      // レスポンスは { "data": [...] } 形式
      // ignore: avoid_dynamic_calls
      final List<dynamic> list = value['data'] as List<dynamic>;

      for (final dynamic item in list) {
        final GeolocModel val = GeolocModel.fromJson(item as Map<String, dynamic>);

        (newEntries['${val.year}-${val.month}-${val.day}'] ??= <GeolocModel>[]).add(val);
      }

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

  /// 取得中の日付範囲 → その取得処理（同じ範囲を待つ呼び出し側に同じ Future を返す）
  final Map<String, Future<void>> _loadingRangeRequests = <String, Future<void>>{};

  /// 指定範囲を取得中かどうか（画面側で読み込み中表示を出すかの判定に使う）
  bool isDateRangeLoading(String from, String to) => _loadingRangeRequests.containsKey('$from|$to');

  /// 取得中ならその完了を待つ Future を、取得済みなら完了済みの Future を返す
  Future<void> getGeolocDataByDateRange(String from, String to) {
    if (from.isEmpty || to.isEmpty) {
      return Future<void>.value();
    }

    final String rangeKey = '$from|$to';

    final Future<void>? loading = _loadingRangeRequests[rangeKey];
    if (loading != null) {
      return loading;
    }

    if (_fetchedRanges.contains(rangeKey)) {
      return Future<void>.value();
    }
    _fetchedRanges.add(rangeKey);

    final Future<void> request = _fetchGeolocDataByDateRange(from: from, to: to, rangeKey: rangeKey)
        .whenComplete(() {
          // ブロック本体にする（`=> remove(...)` だと request 自身を返し、whenComplete がそれを待って永久に完了しない）
          _loadingRangeRequests.remove(rangeKey);
        });

    _loadingRangeRequests[rangeKey] = request;

    return request;
  }

  ///
  Future<void> _fetchGeolocDataByDateRange({required String from, required String to, required String rangeKey}) async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final Map<String, List<GeolocModel>> newEntries = <String, List<GeolocModel>>{};

      final dynamic value = await client.getByPath(path: '$_geolocDateRangeUrl?from=$from&to=$to');

      // ignore: avoid_dynamic_calls
      final List<dynamic> list = value['data'] as List<dynamic>;

      for (final dynamic item in list) {
        final GeolocModel val = GeolocModel.fromJson(item as Map<String, dynamic>);
        (newEntries['${val.year}-${val.month}-${val.day}'] ??= <GeolocModel>[]).add(val);
      }

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
