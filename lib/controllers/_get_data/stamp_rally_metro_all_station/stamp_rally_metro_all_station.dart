import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/stamp_rally_model.dart';
import '../../../utility/utility.dart';

part 'stamp_rally_metro_all_station.freezed.dart';

part 'stamp_rally_metro_all_station.g.dart';

@freezed
class StampRallyMetroAllStationState with _$StampRallyMetroAllStationState {
  const factory StampRallyMetroAllStationState({
    @Default(<String, String>{}) Map<String, String> trainMap,
    @Default(<StampRallyModel>[]) List<StampRallyModel> stationStampList,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> stationStampMap,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> dateStationStampMap,
  }) = _StampRallyMetroAllStationState;
}

@Riverpod(keepAlive: true)
class StampRallyMetroAllStation extends _$StampRallyMetroAllStation {
  final Utility utility = Utility();

  ///
  @override
  StampRallyMetroAllStationState build() => const StampRallyMetroAllStationState();

  //============================================== api

  ///
  Future<StampRallyMetroAllStationState> fetchAllStampRallyMetroAllStationData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<StampRallyModel> list = <StampRallyModel>[];

      final Map<String, String> map = <String, String>{};
      final Map<String, List<StampRallyModel>> map2 = <String, List<StampRallyModel>>{};
      final Map<String, List<StampRallyModel>> map3 = <String, List<StampRallyModel>>{};

      final dynamic value = await client.post(path: APIPath.getStationStamp);

      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic row in data) {
        final StampRallyModel val = StampRallyModel(
          ///
          // ignore: avoid_dynamic_calls
          stationCode: row['station_code'].toString(),
          // ignore: avoid_dynamic_calls
          stationName: row['station_name'].toString(),
          // ignore: avoid_dynamic_calls
          stampGetDate: row['stamp_get_date'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          lat: row['lat'].toString(),
          // ignore: avoid_dynamic_calls
          lng: row['lng'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          trainCode: row['train_code'].toString(),
          // ignore: avoid_dynamic_calls
          trainName: row['train_name'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          imageFolder: row['image_folder'].toString(),
          // ignore: avoid_dynamic_calls
          imageCode: row['image_code'].toString(),
          // ignore: avoid_dynamic_calls
          posterPosition: row['poster_position'].toString(),
          // ignore: avoid_dynamic_calls
          stampGetOrder: row['stamp_get_order'].toString().toInt(),

          ///
          stamp: '',
          time: '',
        );

        list.add(val);

        (map2[val.imageFolder] ??= <StampRallyModel>[]).add(val);

        (map3[val.stampGetDate.replaceAll('/', '-')] ??= <StampRallyModel>[]).add(val);

        // 最初に出現した imageFolder の trainName だけを保持する
        if (!map.containsKey(val.imageFolder)) {
          map[val.imageFolder] = val.trainName;
        }
      }

      return state.copyWith(trainMap: map, stationStampList: list, stationStampMap: map2, dateStationStampMap: map3);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（stamp_rally_metro_all_station）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllStampRallyMetroAllStationData() async {
    try {
      final StampRallyMetroAllStationState newState = await fetchAllStampRallyMetroAllStationData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
