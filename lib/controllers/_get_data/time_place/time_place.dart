import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/time_place_model.dart';
import '../../../utility/utility.dart';

part 'time_place.freezed.dart';

part 'time_place.g.dart';

@freezed
class TimePlaceState with _$TimePlaceState {
  const factory TimePlaceState({
    @Default(<TimePlaceModel>[]) List<TimePlaceModel> timePlaceList,
    @Default(<String, List<TimePlaceModel>>{}) Map<String, List<TimePlaceModel>> timePlaceMap,
  }) = _TimePlaceState;
}

@riverpod
class TimePlace extends _$TimePlace {
  final Utility utility = Utility();

  ///
  @override
  TimePlaceState build() => const TimePlaceState();

  //============================================== api

  ///
  Future<TimePlaceState> fetchAllTimePlaceData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TimePlaceModel> list = <TimePlaceModel>[];
      final Map<String, List<TimePlaceModel>> map = <String, List<TimePlaceModel>>{};

      final dynamic value = await client.post(path: APIPath.getAllTimePlaceRecord);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final TimePlaceModel val = TimePlaceModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        (map['${val.year}-${val.month}-${val.day}'] ??= <TimePlaceModel>[]).add(val);
      }

      return state.copyWith(timePlaceList: list, timePlaceMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（time_place）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTimePlaceData() async {
    try {
      final TimePlaceState newState = await fetchAllTimePlaceData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
