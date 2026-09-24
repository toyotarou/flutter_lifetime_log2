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

      // 2つのAPIは互いに独立しているので並行して取得する
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        client.post(path: APIPath.getAllDailySpend),
        client.post(path: APIPath.getAllCredit),
      ]);

      //---------------------------------------------------------------------------//

      final List<dynamic> dailySpendData = (results[0] as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in dailySpendData) {
        final DailySpendModel val = DailySpendModel.fromJson(item as Map<String, dynamic>);

        final MoneySpendModel moneySpend = MoneySpendModel(
          '${val.year}-${val.month}-${val.day}',
          val.koumoku,
          val.price,
          'dailySpend',
        );

        list.add(moneySpend);

        (map[moneySpend.date] ??= <MoneySpendModel>[]).add(moneySpend);
      }

      //---------------------------------------------------------------------------//

      final List<dynamic> creditData = (results[1] as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in creditData) {
        final CreditModel val = CreditModel.fromJson(item as Map<String, dynamic>);

        final MoneySpendModel moneySpend = MoneySpendModel(
          '${val.year}-${val.month}-${val.day}',
          val.item,
          val.price.toInt(),
          'credit',
        );

        list.add(moneySpend);

        (map[moneySpend.date] ??= <MoneySpendModel>[]).add(moneySpend);
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(moneySpendList: list, moneySpendMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（money_spend）', error: e);
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
