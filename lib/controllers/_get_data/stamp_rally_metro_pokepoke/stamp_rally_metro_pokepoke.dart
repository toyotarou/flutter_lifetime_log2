import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/stamp_rally_model.dart';
import '../../../utility/utility.dart';

part 'stamp_rally_metro_pokepoke.freezed.dart';

part 'stamp_rally_metro_pokepoke.g.dart';

@freezed
class StampRallyMetroPokepokeState with _$StampRallyMetroPokepokeState {
  const factory StampRallyMetroPokepokeState({
    @Default(<StampRallyModel>[]) List<StampRallyModel> stationStampList,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> stationStampMap,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> dateStationStampMap,
  }) = _StampRallyMetroPokepokeState;
}

@Riverpod(keepAlive: true)
class StampRallyMetroPokepoke extends _$StampRallyMetroPokepoke {
  final Utility utility = Utility();

  ///
  @override
  StampRallyMetroPokepokeState build() => const StampRallyMetroPokepokeState();

  //============================================== api

  Future<StampRallyMetroPokepokeState> fetchAllStampRallyMetroPokepokeData() async {
    final HttpClient client = ref.read(httpClientProvider);

    final List<StampRallyModel> list = <StampRallyModel>[];
    final Map<String, List<StampRallyModel>> map = <String, List<StampRallyModel>>{};
    final Map<String, List<StampRallyModel>> map2 = <String, List<StampRallyModel>>{};

    final dynamic value = await client.post(path: APIPath.getMetroStampPokePoke);

    // ignore: avoid_dynamic_calls
    final List<dynamic> data = value['data'] as List<dynamic>;

    for (int i = 0; i < data.length; i++) {
      final dynamic row = data[i];

      final StampRallyModel val = StampRallyModel(
        // ignore: avoid_dynamic_calls
        stationCode: row['station_id'].toString(),
        // ignore: avoid_dynamic_calls
        stationName: row['station_name'].toString(),
        // ignore: avoid_dynamic_calls
        stampGetDate: row['get_date'].toString(),
        // ignore: avoid_dynamic_calls
        stamp: row['stamp'].toString(),
        // ignore: avoid_dynamic_calls
        posterPosition: row['in_out'].toString(),

        lat: '',
        lng: '',
        trainCode: '',
        trainName: '',
        imageFolder: '',
        imageCode: '',
        stampGetOrder: 0,
        time: '',
      );

      list.add(val);

      (map[val.stationName] ??= <StampRallyModel>[]).add(val);
      (map2[val.stampGetDate] ??= <StampRallyModel>[]).add(val);
    }

    return state.copyWith(stationStampList: list, stationStampMap: map, dateStationStampMap: map2);
  }

  ///
  Future<void> getAllStampRallyMetroPokepokeData() async {
    try {
      final StampRallyMetroPokepokeState newState = await fetchAllStampRallyMetroPokepokeData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
