import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../utility/utility.dart';

part 'stock_name.freezed.dart';

part 'stock_name.g.dart';

@freezed
class StockNameState with _$StockNameState {
  const factory StockNameState({
    @Default(<String, Map<String, String>>{}) Map<String, Map<String, String>> stockNameMap,
  }) = _StockNameState;
}

@riverpod
class StockName extends _$StockName {
  final Utility utility = Utility();

  ///
  @override
  StockNameState build() => const StockNameState();

  //============================================== api

  ///
  Future<StockNameState> fetchAllStockNameData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final Map<String, Map<String, String>> map = <String, Map<String, String>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getStockName).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          final Map<String, String> map2 = <String, String>{
            // ignore: avoid_dynamic_calls
            'ticker': value['data'][i]['ticker'].toString(),
            // ignore: avoid_dynamic_calls
            'name': value['data'][i]['name'].toString(),
            // ignore: avoid_dynamic_calls
            'hoyuu_suuryou': value['data'][i]['hoyuu_suuryou'].toString(),
            // ignore: avoid_dynamic_calls
            'heikin_shutoku_kagaku': value['data'][i]['heikin_shutoku_kagaku'].toString(),
          };

          map[map2['ticker'].toString()] = map2;
        }
      });

      /*




{
    "data": [
        {
            "ticker": "EPI",
            "name": "ウィズダムツリー インド株収益ファンド",
            "hoyuu_suuryou": 5,
            "heikin_shutoku_kagaku": "3,897.60"
        },
        {
            "ticker": "INFY",
            "name": "インフォシス・テクノロジーズ",
            "hoyuu_suuryou": 5,
            "heikin_shutoku_kagaku": "2,653.60"
        },
        {
            "ticker": "JMIA",
            "name": "ジュミア・テクノロジーズ",
            "hoyuu_suuryou": 5,
            "heikin_shutoku_kagaku": "2,490.00"
        }
    ]
}




      */

      return state.copyWith(stockNameMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllStockNameData() async {
    try {
      final StockNameState newState = await fetchAllStockNameData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
