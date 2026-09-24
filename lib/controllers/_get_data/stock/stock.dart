import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/stock_model.dart';
import '../../../utility/utility.dart';

part 'stock.freezed.dart';

part 'stock.g.dart';

@freezed
class StockState with _$StockState {
  const factory StockState({
    @Default(<StockModel>[]) List<StockModel> stockList,
    @Default(<String, List<StockModel>>{}) Map<String, List<StockModel>> stockMap,
    @Default(<String, List<StockModel>>{}) Map<String, List<StockModel>> stockTickerMap,
  }) = _StockState;
}

@riverpod
class Stock extends _$Stock {
  final Utility utility = Utility();

  ///
  @override
  StockState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const StockState();
  }

  //============================================== api

  ///
  Future<StockState> fetchAllStockData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<StockModel> list = <StockModel>[];
      final Map<String, List<StockModel>> map = <String, List<StockModel>>{};
      final Map<String, List<StockModel>> map2 = <String, List<StockModel>>{};

      final dynamic value = await client.post(path: APIPath.getAllStockData);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final StockModel val = StockModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        (map['${val.year}-${val.month}-${val.day}'] ??= <StockModel>[]).add(val);

        (map2[val.ticker] ??= <StockModel>[]).add(val);
      }

      return state.copyWith(stockList: list, stockMap: map, stockTickerMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（stock）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllStockData() async {
    try {
      final StockState newState = await fetchAllStockData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
