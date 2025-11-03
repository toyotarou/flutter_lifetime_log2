import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/stock_model.dart';
import '../../../utils/ui_utils.dart';

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
  ///
  @override
  StockState build() => const StockState();

  //============================================== api

  ///
  Future<StockState> fetchAllStockData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<StockModel> list = <StockModel>[];
      final Map<String, List<StockModel>> map = <String, List<StockModel>>{};
      final Map<String, List<StockModel>> map2 = <String, List<StockModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllStockData).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final StockModel val = StockModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}-${val.day}'] ??= <StockModel>[]).add(val);

          (map2[val.ticker] ??= <StockModel>[]).add(val);
        }
      });

      return state.copyWith(stockList: list, stockMap: map, stockTickerMap: map2);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
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
