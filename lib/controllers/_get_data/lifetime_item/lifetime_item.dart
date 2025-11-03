import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/lifetime_model.dart';
import '../../../utils/ui_utils.dart';

part 'lifetime_item.freezed.dart';

part 'lifetime_item.g.dart';

@freezed
class LifetimeItemState with _$LifetimeItemState {
  const factory LifetimeItemState({@Default(<LifetimeItemModel>[]) List<LifetimeItemModel> lifetimeItemList}) =
      _LifetimeItemState;
}

@riverpod
class LifetimeItem extends _$LifetimeItem {
  ///
  @override
  LifetimeItemState build() => const LifetimeItemState();

  //============================================== api

  ///
  Future<LifetimeItemState> fetchAllLifetimeItemData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<LifetimeItemModel> list = <LifetimeItemModel>[];

      // ignore: always_specify_types
      await client.post(path: APIPath.getLifetimeRecordItem).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final LifetimeItemModel val = LifetimeItemModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);
        }
      });

      return state.copyWith(lifetimeItemList: list);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllLifetimeItemData() async {
    try {
      final LifetimeItemState newState = await fetchAllLifetimeItemData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
