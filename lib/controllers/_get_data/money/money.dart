import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/money_model.dart';
import '../../../utils/iterable_extensions.dart';
import '../../../utils/ui_utils.dart';

part 'money.freezed.dart';

part 'money.g.dart';

@freezed
class MoneyState with _$MoneyState {
  const factory MoneyState({
    @Default(<MoneyModel>[]) List<MoneyModel> moneyList,
    @Default(<String, MoneyModel>{}) Map<String, MoneyModel> moneyMap,
    @Default(<String, List<Map<String, int>>>{}) Map<String, List<Map<String, int>>> bankMoneyMap,
  }) = _MoneyState;
}

@riverpod
class Money extends _$Money {
  ///
  @override
  MoneyState build() => const MoneyState();

  //============================================== api

  ///
  Future<MoneyState> fetchAllMoneyData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<MoneyModel> list = <MoneyModel>[];
      final Map<String, MoneyModel> map = <String, MoneyModel>{};

      final Map<String, List<Map<String, int>>> map2 = <String, List<Map<String, int>>>{};

      map2['bank_a'] = <Map<String, int>>[];
      map2['bank_b'] = <Map<String, int>>[];
      map2['bank_c'] = <Map<String, int>>[];
      map2['bank_d'] = <Map<String, int>>[];
      map2['bank_e'] = <Map<String, int>>[];

      map2['pay_a'] = <Map<String, int>>[];
      map2['pay_b'] = <Map<String, int>>[];
      map2['pay_c'] = <Map<String, int>>[];
      map2['pay_d'] = <Map<String, int>>[];
      map2['pay_e'] = <Map<String, int>>[];
      map2['pay_f'] = <Map<String, int>>[];

      final List<int> kind = <int>[10000, 5000, 2000, 1000, 500, 100, 50, 10, 5, 1];

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllMoney).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final List<String> exValue = value['data'][i].toString().split('|');

          ////////////////////////////////////////////

          final List<int> prices = <int>[];

          for (int j = 2; j <= 11; j++) {
            prices.add(exValue[j].toInt() * kind[j - 2]);
          }

          for (int k = 12; k <= 22; k++) {
            prices.add(exValue[k].toInt());
          }

          final int sum = prices.sumByInt((int e) => e);

          ////////////////////////////////////////////

          final MoneyModel val = MoneyModel(
            date: exValue[0],
            yearmonth: exValue[1],
            yen10000: exValue[2],
            yen5000: exValue[3],
            yen2000: exValue[4],
            yen1000: exValue[5],
            yen500: exValue[6],
            yen100: exValue[7],
            yen50: exValue[8],
            yen10: exValue[9],
            yen5: exValue[10],
            yen1: exValue[11],
            bankA: exValue[12],
            bankB: exValue[13],
            bankC: exValue[14],
            bankD: exValue[15],
            bankE: exValue[16],
            payA: exValue[17],
            payB: exValue[18],
            payC: exValue[19],
            payD: exValue[20],
            payE: exValue[21],
            payF: exValue[22],
            sum: sum.toString(),
          );

          list.add(val);

          map[val.date] = val;

          map2['bank_a']?.add(<String, int>{val.date: exValue[12].toInt()});
          map2['bank_b']?.add(<String, int>{val.date: exValue[13].toInt()});
          map2['bank_c']?.add(<String, int>{val.date: exValue[14].toInt()});
          map2['bank_d']?.add(<String, int>{val.date: exValue[15].toInt()});
          map2['bank_e']?.add(<String, int>{val.date: exValue[16].toInt()});

          map2['pay_a']?.add(<String, int>{val.date: exValue[17].toInt()});
          map2['pay_b']?.add(<String, int>{val.date: exValue[18].toInt()});
          map2['pay_c']?.add(<String, int>{val.date: exValue[19].toInt()});
          map2['pay_d']?.add(<String, int>{val.date: exValue[20].toInt()});
          map2['pay_e']?.add(<String, int>{val.date: exValue[21].toInt()});
          map2['pay_f']?.add(<String, int>{val.date: exValue[22].toInt()});
        }
      });

      return state.copyWith(moneyList: list, moneyMap: map, bankMoneyMap: map2);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMoneyData() async {
    try {
      final MoneyState newState = await fetchAllMoneyData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
