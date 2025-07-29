import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/money_spend_model.dart';
import '../../../utility/utility.dart';

part 'money_spend.freezed.dart';

part 'money_spend.g.dart';

@freezed
class MoneySpendState with _$MoneySpendState {
  const factory MoneySpendState({
    @Default(<MoneySpendModel>[]) List<MoneySpendModel> moneySpendList,
    @Default(<String, List<MoneySpendModel>>{}) Map<String, List<MoneySpendModel>> moneySpendMap,
  }) = _MoneySpendState;
}

@riverpod
class MoneySpend extends _$MoneySpend {
  final Utility utility = Utility();

  ///
  @override
  MoneySpendState build() => const MoneySpendState();

  //============================================== api

  ///
  Future<MoneySpendState> fetchAllMoneySpendData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<MoneySpendModel> list = <MoneySpendModel>[];
      final Map<String, List<MoneySpendModel>> map = <String, List<MoneySpendModel>>{};

      //---------------------------------------------------------------------------//

      final dynamic value = await client.post(path: APIPath.getAllDailySpend);

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final DailySpendModel val = DailySpendModel.fromJson(value['data'][i] as Map<String, dynamic>);

        final MoneySpendModel moneySpend = MoneySpendModel(
          '${val.year}-${val.month}-${val.day}',
          val.koumoku,
          val.price,
          'dailySpend',
        );

        list.add(moneySpend);

        (map['${val.year}-${val.month}-${val.day}'] ??= <MoneySpendModel>[]).add(moneySpend);
      }

      //---------------------------------------------------------------------------//

      final dynamic value2 = await client.post(path: APIPath.getAllCredit);

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value2['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final CreditModel val = CreditModel.fromJson(value2['data'][i] as Map<String, dynamic>);

        final MoneySpendModel moneySpend = MoneySpendModel(
          '${val.year}-${val.month}-${val.day}',
          val.item,
          val.price.toInt(),
          'credit',
        );

        list.add(moneySpend);

        (map['${val.year}-${val.month}-${val.day}'] ??= <MoneySpendModel>[]).add(moneySpend);
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(moneySpendList: list, moneySpendMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMoneySpendData() async {
    try {
      final MoneySpendState newState = await fetchAllMoneySpendData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
