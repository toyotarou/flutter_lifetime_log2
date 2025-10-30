import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/station_stamp_model.dart';
import '../../../utility/utility.dart';

part 'station_stamp.freezed.dart';

part 'station_stamp.g.dart';

@freezed
class StationStampState with _$StationStampState {
  const factory StationStampState({
    @Default(<String, String>{}) Map<String, String> trainMap,
    @Default(<StationStampModel>[]) List<StationStampModel> stationStampList,
    @Default(<String, List<StationStampModel>>{}) Map<String, List<StationStampModel>> stationStampMap,
    @Default(<String, List<StationStampModel>>{}) Map<String, List<StationStampModel>> dateStationStampMap,
  }) = _StationStampState;
}

@Riverpod(keepAlive: true)
class StationStamp extends _$StationStamp {
  final Utility utility = Utility();

  ///
  @override
  StationStampState build() => const StationStampState();

  //============================================== api

  ///
  Future<StationStampState> fetchAllStationStampData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getStationStamp);

      final List<StationStampModel> list = <StationStampModel>[];

      final Map<String, String> map = <String, String>{};
      final Map<String, List<StationStampModel>> map2 = <String, List<StationStampModel>>{};
      final Map<String, List<StationStampModel>> map3 = <String, List<StationStampModel>>{};

      final List<String> keepTrain = <String>[];
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StationStampModel val = StationStampModel.fromJson(value['data'][i] as Map<String, dynamic>);

        map2[val.imageFolder] = <StationStampModel>[];
        map3[val.stampGetDate.replaceAll('/', '-')] = <StationStampModel>[];

        if (!keepTrain.contains(val.imageFolder)) {
          map[val.imageFolder] = val.trainName;
        }

        keepTrain.add(val.imageFolder);
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StationStampModel val = StationStampModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map2[val.imageFolder]?.add(val);

        map3[val.stampGetDate.replaceAll('/', '-')]?.add(val);
      }

      return state.copyWith(trainMap: map, stationStampList: list, stationStampMap: map2, dateStationStampMap: map3);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllStationStampData() async {
    try {
      final StationStampState newState = await fetchAllStationStampData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
