import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../extensions/extensions.dart';
import '../../../models/geoloc_model.dart';
import '../../../utility/utility.dart';

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
  final Utility utility = Utility();

  ///
  @override
  GeolocState build() => const GeolocState();

  //============================================== api

  ///
  Future<GeolocState> fetchAllGeolocData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<GeolocModel> list = <GeolocModel>[];
      final Map<String, List<GeolocModel>> map = <String, List<GeolocModel>>{};

      // ignore: always_specify_types
      await client.getByPath(path: 'http://49.212.175.205:3000/api/v1/geoloc').then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value.length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final GeolocModel val = GeolocModel.fromJson(value[i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}-${val.day}'] ??= <GeolocModel>[]).add(val);
        }
      });

      return state.copyWith(geolocList: list, geolocMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllGeolocData() async {
    try {
      final GeolocState newState = await fetchAllGeolocData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
