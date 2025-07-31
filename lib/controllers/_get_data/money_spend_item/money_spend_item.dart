import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
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
      // ignore: always_specify_types
      await client.post(path: APIPath.getMoneySpendItem).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final MoneySpendItemModel val = MoneySpendItemModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          map[val.name] = val;
        }
      });

      return state.copyWith(
        moneySpendItemList: <MoneySpendItemModel>[],
        moneySpendItemMap: <String, MoneySpendItemModel>{},
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
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
