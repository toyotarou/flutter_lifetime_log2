import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/walk_model.dart';
import '../../../utility/utility.dart';

part 'walk.freezed.dart';

part 'walk.g.dart';

@freezed
class WalkState with _$WalkState {
  const factory WalkState({
    @Default(<WalkModel>[]) List<WalkModel> walkList,
    @Default(<String, WalkModel>{}) Map<String, WalkModel> walkMap,
  }) = _WalkState;
}

@riverpod
class Walk extends _$Walk {
  final Utility utility = Utility();

  ///
  @override
  WalkState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const WalkState();
  }

  //============================================== api

  ///
  Future<WalkState> fetchAllWalkData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<WalkModel> list = <WalkModel>[];
      final Map<String, WalkModel> map = <String, WalkModel>{};

      final dynamic value = await client.post(path: APIPath.getWalkRecord2);

      for (final dynamic item in value as List<dynamic>) {
        final WalkModel val = WalkModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map[val.date] = val;
      }

      return state.copyWith(walkList: list, walkMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（walk）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllWalkData() async {
    try {
      final WalkState newState = await fetchAllWalkData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
