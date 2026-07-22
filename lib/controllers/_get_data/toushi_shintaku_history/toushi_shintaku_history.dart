import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/toushi_shintaku_history_model.dart';
import '../../../utility/utility.dart';

part 'toushi_shintaku_history.freezed.dart';

part 'toushi_shintaku_history.g.dart';

@freezed
class ToushiShintakuHistoryState with _$ToushiShintakuHistoryState {
  const factory ToushiShintakuHistoryState({
    @Default(<ToushiShintakuHistoryModel>[]) List<ToushiShintakuHistoryModel> toushiShintakuHistoryList,

    @Default(<String, List<ToushiShintakuHistoryModel>>{})
    Map<String, List<ToushiShintakuHistoryModel>> toushiShintakuHistoryMap,

    @Default(<String, List<ToushiShintakuHistoryModel>>{})
    Map<String, List<ToushiShintakuHistoryModel>> toushiShintakuHistoryCostDateMap,
  }) = _ToushiShintakuHistoryState;
}

@riverpod
class ToushiShintakuHistory extends _$ToushiShintakuHistory {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuHistoryState build() => const ToushiShintakuHistoryState();

  //============================================== api

  ///
  Future<ToushiShintakuHistoryState> fetchAllToushiShintakuHistoryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<ToushiShintakuHistoryModel> list = <ToushiShintakuHistoryModel>[];
      final Map<String, List<ToushiShintakuHistoryModel>> map = <String, List<ToushiShintakuHistoryModel>>{};
      final Map<String, List<ToushiShintakuHistoryModel>> map2 = <String, List<ToushiShintakuHistoryModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getToushiShintakuDealHistory).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final ToushiShintakuHistoryModel val = ToushiShintakuHistoryModel.fromJson(
            // ignore: avoid_dynamic_calls
            value['data'][i] as Map<String, dynamic>,
          );

          list.add(val);

          (map['${val.relationalId}'] ??= <ToushiShintakuHistoryModel>[]).add(val);

          (map2[val.costChangeDate] ??= <ToushiShintakuHistoryModel>[]).add(val);
        }
      });

      return state.copyWith(
        toushiShintakuHistoryList: list,
        toushiShintakuHistoryMap: map,
        toushiShintakuHistoryCostDateMap: map2,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllToushiShintakuHistoryData() async {
    try {
      final ToushiShintakuHistoryState newState = await fetchAllToushiShintakuHistoryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
