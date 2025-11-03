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
        // ignore: avoid_dynamic_calls
        final StampRallyModel val = StampRallyModel.fromJson(value['data'][i] as Map<String, dynamic>);

        map2[val.imageFolder!] = <StampRallyModel>[];
        map3[val.stampGetDate!.replaceAll('/', '-')] = <StampRallyModel>[];

        if (!keepTrain.contains(val.imageFolder)) {
          map[val.imageFolder!] = val.trainName;
        }

        keepTrain.add(val.imageFolder!);
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StampRallyModel val = StampRallyModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map2[val.imageFolder]?.add(val);

        map3[val.stampGetDate!.replaceAll('/', '-')]?.add(val);
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
