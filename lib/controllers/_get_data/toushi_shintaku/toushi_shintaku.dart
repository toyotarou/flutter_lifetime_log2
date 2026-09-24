import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/toushi_shintaku_model.dart';
import '../../../utility/utility.dart';

part 'toushi_shintaku.freezed.dart';

part 'toushi_shintaku.g.dart';

@freezed
class ToushiShintakuState with _$ToushiShintakuState {
  const factory ToushiShintakuState({
    @Default(<ToushiShintakuModel>[]) List<ToushiShintakuModel> toushiShintakuList,
    @Default(<String, List<ToushiShintakuModel>>{}) Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
    @Default(<int, List<ToushiShintakuModel>>{}) Map<int, List<ToushiShintakuModel>> toushiShintakuRelationalMap,
  }) = _ToushiShintakuState;
}

@riverpod
class ToushiShintaku extends _$ToushiShintaku {
  final Utility utility = Utility();

  ///
  @override
  ToushiShintakuState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const ToushiShintakuState();
  }

  //============================================== api

  ///
  Future<ToushiShintakuState> fetchAllToushiShintakuData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<ToushiShintakuModel> list = <ToushiShintakuModel>[];
      final Map<String, List<ToushiShintakuModel>> map = <String, List<ToushiShintakuModel>>{};
      final Map<int, List<ToushiShintakuModel>> map2 = <int, List<ToushiShintakuModel>>{};

      final dynamic value = await client.post(path: APIPath.getAllToushiShintakuData);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final ToushiShintakuModel val = ToushiShintakuModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        (map['${val.year}-${val.month}-${val.day}'] ??= <ToushiShintakuModel>[]).add(val);

        (map2[val.relationalId] ??= <ToushiShintakuModel>[]).add(val);
      }

      return state.copyWith(toushiShintakuList: list, toushiShintakuMap: map, toushiShintakuRelationalMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（toushi_shintaku）', error: e);
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
