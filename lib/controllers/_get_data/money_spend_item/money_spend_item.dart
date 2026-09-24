import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/money_spend_model.dart';
import '../../../utility/utility.dart';

part 'money_spend_item.freezed.dart';

part 'money_spend_item.g.dart';

@freezed
class MoneySpendItemState with _$MoneySpendItemState {
  const factory MoneySpendItemState({
    @Default(<MoneySpendItemModel>[]) List<MoneySpendItemModel> moneySpendItemList,
    @Default(<String, MoneySpendItemModel>{}) Map<String, MoneySpendItemModel> moneySpendItemMap,
  }) = _MoneySpendItemState;
}

@riverpod
class MoneySpendItem extends _$MoneySpendItem {
  final Utility utility = Utility();

  ///
  @override
  MoneySpendItemState build() => const MoneySpendItemState();

  //============================================== api

  ///
  Future<MoneySpendItemState> fetchAllMoneySpendItemData() async {
    final HttpClient client = ref.read(httpClientProvider);

    final List<MoneySpendItemModel> list = <MoneySpendItemModel>[];
    final Map<String, MoneySpendItemModel> map = <String, MoneySpendItemModel>{};

    try {
      final dynamic value = await client.post(path: APIPath.getMoneySpendItem);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final MoneySpendItemModel val = MoneySpendItemModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map[val.name] = val;
      }

      return state.copyWith(moneySpendItemList: list, moneySpendItemMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（money_spend_item）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMoneySpendItemData() async {
    try {
      final MoneySpendItemState newState = await fetchAllMoneySpendItemData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
