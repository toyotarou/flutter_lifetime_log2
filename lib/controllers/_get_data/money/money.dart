import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/money_model.dart';
import '../../../utility/utility.dart';

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
  final Utility utility = Utility();

  ///
  @override
  MoneyState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const MoneyState();
  }

  //============================================== api

  ///
  Future<MoneyState> fetchAllMoneyData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<MoneyModel> list = <MoneyModel>[];
      final Map<String, MoneyModel> map = <String, MoneyModel>{};

      final Map<String, List<Map<String, int>>> map2 = <String, List<Map<String, int>>>{};

      // exValue[12] 〜 exValue[22] に対応するキー（順番が重要）
      const List<String> bankKeys = <String>[
        'bank_a',
        'bank_b',
        'bank_c',
        'bank_d',
        'bank_e',
        'pay_a',
        'pay_b',
        'pay_c',
        'pay_d',
        'pay_e',
        'pay_f',
      ];

      for (final String key in bankKeys) {
        map2[key] = <Map<String, int>>[];
      }

      const List<int> kind = <int>[10000, 5000, 2000, 1000, 500, 100, 50, 10, 5, 1];

      final dynamic value = await client.post(path: APIPath.getAllMoney);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final List<String> exValue = item.toString().split('|');

        ////////////////////////////////////////////

        final List<int> prices = <int>[];

        for (int j = 2; j <= 11; j++) {
          prices.add(exValue[j].toInt() * kind[j - 2]);
        }

        // 銀行・電子マネーの金額（exValue[12] 〜 exValue[22]）は一度だけパースして使い回す
        final List<int> bankValues = <int>[];

        for (int k = 12; k <= 22; k++) {
          bankValues.add(exValue[k].toInt());
        }

        prices.addAll(bankValues);

        final int sum = utility.getListSum<int>(prices, (int e) => e);

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

        for (int k = 0; k < bankKeys.length; k++) {
          map2[bankKeys[k]]?.add(<String, int>{val.date: bankValues[k]});
        }
      }

      return state.copyWith(moneyList: list, moneyMap: map, bankMoneyMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（money）', error: e);
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
