import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../extensions/extensions.dart';
import '../../../models/stamp_rally_model.dart';
import '../../../utility/utility.dart';

part 'stamp_rally_metro_20_anniversary.freezed.dart';

part 'stamp_rally_metro_20_anniversary.g.dart';

@freezed
class StampRallyMetro20AnniversaryState with _$StampRallyMetro20AnniversaryState {
  const factory StampRallyMetro20AnniversaryState({
    @Default(<StampRallyModel>[]) List<StampRallyModel> stationStampList,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> stationStampMap,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> dateStationStampMap,
  }) = _StampRallyMetro20AnniversaryState;
}

@Riverpod(keepAlive: true)
class StampRallyMetro20Anniversary extends _$StampRallyMetro20Anniversary {
  final Utility utility = Utility();

  ///
  @override
  StampRallyMetro20AnniversaryState build() => const StampRallyMetro20AnniversaryState();

  //============================================== api

  ///
  Future<StampRallyMetro20AnniversaryState> fetchAllStampRallyMetro20AnniversaryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.getByPath(path: 'http://49.212.175.205:3000/api/v1/stampRallyMetro20');

      final List<StampRallyModel> list = <StampRallyModel>[];
      final Map<String, List<StampRallyModel>> map = <String, List<StampRallyModel>>{};
      final Map<String, List<StampRallyModel>> map2 = <String, List<StampRallyModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        final StampRallyModel val = StampRallyModel(
          // ignore: avoid_dynamic_calls
          stationCode: value[i]['station_id'].toString(),
          // ignore: avoid_dynamic_calls
          stationName: value[i]['station_name'].toString(),
          // ignore: avoid_dynamic_calls
          stampGetDate: value[i]['get_date'].toString(),
          // ignore: avoid_dynamic_calls
          stamp: value[i]['stamp'].toString(),

          ///
          lat: '',
          lng: '',
          trainCode: '',
          trainName: '',
          imageFolder: '',
          imageCode: '',
          posterPosition: '',
          stampGetOrder: 0,

          ///
          time: '',
        );

        list.add(val);

        (map[val.stationName] ??= <StampRallyModel>[]).add(val);

        (map2[val.stampGetDate] ??= <StampRallyModel>[]).add(val);
      }

      return state.copyWith(stationStampList: list, stationStampMap: map, dateStationStampMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMetroStamp20AnniversaryData() async {
    try {
      final StampRallyMetro20AnniversaryState newState = await fetchAllStampRallyMetro20AnniversaryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
