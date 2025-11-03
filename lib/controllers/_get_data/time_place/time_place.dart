import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/time_place_model.dart';
import '../../../utils/ui_utils.dart';

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

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllTimePlaceRecord).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final TimePlaceModel val = TimePlaceModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}-${val.day}'] ??= <TimePlaceModel>[]).add(val);
        }
      });

      return state.copyWith(timePlaceList: list, timePlaceMap: map);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
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
