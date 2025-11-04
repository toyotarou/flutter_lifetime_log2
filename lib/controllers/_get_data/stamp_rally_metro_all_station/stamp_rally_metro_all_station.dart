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

      final List<String> keepTrain = <String>[];
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final StampRallyModel val = StampRallyModel(
          ///
          // ignore: avoid_dynamic_calls
          stationCode: value['data'][i]['station_code'].toString(),
          // ignore: avoid_dynamic_calls
          stationName: value['data'][i]['station_name'].toString(),
          // ignore: avoid_dynamic_calls
          stampGetDate: value['data'][i]['stamp_get_date'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          lat: value['data'][i]['lat'].toString(),
          // ignore: avoid_dynamic_calls
          lng: value['data'][i]['lng'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          trainCode: value['data'][i]['train_code'].toString(),
          // ignore: avoid_dynamic_calls
          trainName: value['data'][i]['train_name'].toString(),

          ///
          // ignore: avoid_dynamic_calls
          imageFolder: value['data'][i]['image_folder'].toString(),
          // ignore: avoid_dynamic_calls
          imageCode: value['data'][i]['image_code'].toString(),
          // ignore: avoid_dynamic_calls
          posterPosition: value['data'][i]['poster_position'].toString(),
          // ignore: avoid_dynamic_calls
          stampGetOrder: value['data'][i]['stamp_get_order'].toString().toInt(),

          ///
          stamp: '',
          time: '',
        );

        list.add(val);

        (map2[val.imageFolder] ??= <StampRallyModel>[]).add(val);

        (map3[val.stampGetDate.replaceAll('/', '-')] ??= <StampRallyModel>[]).add(val);

        if (!keepTrain.contains(val.imageFolder)) {
          map[val.imageFolder] = val.trainName;
        }

        keepTrain.add(val.imageFolder);
      }

      return state.copyWith(trainMap: map, stationStampList: list, stationStampMap: map2, dateStationStampMap: map3);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
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
