import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/lifetime_model.dart';
import '../../../utility/utility.dart';

part 'lifetime_item.freezed.dart';

part 'lifetime_item.g.dart';

@freezed
class LifetimeItemState with _$LifetimeItemState {
  const factory LifetimeItemState({@Default(<LifetimeItemModel>[]) List<LifetimeItemModel> lifetimeItemList}) =
      _LifetimeItemState;
}

@riverpod
class LifetimeItem extends _$LifetimeItem {
  final Utility utility = Utility();

  ///
  @override
  LifetimeItemState build() => const LifetimeItemState();

  //============================================== api

  ///
  Future<LifetimeItemState> fetchAllLifetimeItemData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<LifetimeItemModel> list = <LifetimeItemModel>[];

      final dynamic value = await client.post(path: APIPath.getLifetimeRecordItem);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final LifetimeItemModel val = LifetimeItemModel.fromJson(item as Map<String, dynamic>);

        list.add(val);
      }

      return state.copyWith(lifetimeItemList: list);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（lifetime_item）', error: e);
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
