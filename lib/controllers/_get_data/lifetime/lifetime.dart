import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/lifetime_model.dart';
import '../../../utility/utility.dart';

part 'lifetime.freezed.dart';

part 'lifetime.g.dart';

@freezed
class LifetimeState with _$LifetimeState {
  const factory LifetimeState({
    @Default(<LifetimeModel>[]) List<LifetimeModel> lifetimeList,
    @Default(<String, LifetimeModel>{}) Map<String, LifetimeModel> lifetimeMap,
  }) = _LifetimeState;
}

@riverpod
class Lifetime extends _$Lifetime {
  final Utility utility = Utility();

  ///
  @override
  LifetimeState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const LifetimeState();
  }

  //============================================== api

  ///
  Future<LifetimeState> fetchAllLifetimeData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<LifetimeModel> list = <LifetimeModel>[];
      final Map<String, LifetimeModel> map = <String, LifetimeModel>{};

      final dynamic value = await client.post(path: APIPath.getAllLifetimeRecord);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final LifetimeModel val = LifetimeModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map['${val.year}-${val.month}-${val.day}'] = val;
      }

      return state.copyWith(lifetimeList: list, lifetimeMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（lifetime）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllLifetimeData() async {
    try {
      final LifetimeState newState = await fetchAllLifetimeData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
