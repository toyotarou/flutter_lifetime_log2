import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/lifetime_model.dart';
import '../../../utils/ui_utils.dart';

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
  ///
  @override
  LifetimeState build() => const LifetimeState();

  //============================================== api

  ///
  Future<LifetimeState> fetchAllLifetimeData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<LifetimeModel> list = <LifetimeModel>[];
      final Map<String, LifetimeModel> map = <String, LifetimeModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllLifetimeRecord).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final LifetimeModel val = LifetimeModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          map['${val.year}-${val.month}-${val.day}'] = val;
        }
      });

      return state.copyWith(lifetimeList: list, lifetimeMap: map);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
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
