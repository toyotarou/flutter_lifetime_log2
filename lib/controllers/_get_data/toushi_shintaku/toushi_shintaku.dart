import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/toushi_shintaku_model.dart';
import '../../../utility/utility.dart';

part 'toushi_shintaku.freezed.dart';

part 'toushi_shintaku.g.dart';

@freezed
class ToushiShintakuState with _$ToushiShintakuState {
  const factory ToushiShintakuState({
    @Default(<ToushiShintakuModel>[]) List<ToushiShintakuModel> toushiShintakuList,
    @Default(<String, List<ToushiShintakuModel>>{}) Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
  }) = _ToushiShintakuState;
}

@riverpod
class ToushiShintaku extends _$ToushiShintaku {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuState build() => const ToushiShintakuState();

  //============================================== api

  ///
  Future<ToushiShintakuState> fetchAllToushiShintakuData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<ToushiShintakuModel> list = <ToushiShintakuModel>[];
      final Map<String, List<ToushiShintakuModel>> map = <String, List<ToushiShintakuModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllToushiShintakuData).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final ToushiShintakuModel val = ToushiShintakuModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}-${val.day}'] ??= <ToushiShintakuModel>[]).add(val);
        }
      });

      return state.copyWith(toushiShintakuList: list, toushiShintakuMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllToushiShintakuData() async {
    try {
      final ToushiShintakuState newState = await fetchAllToushiShintakuData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
