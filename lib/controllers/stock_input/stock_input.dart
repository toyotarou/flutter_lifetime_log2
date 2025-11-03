import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../models/walk_model.dart';
import '../../utils/ui_utils.dart';

part 'stock_input.freezed.dart';

part 'stock_input.g.dart';

@freezed
class StockInputState with _$StockInputState {
  const factory StockInputState({
    @Default(<WalkModel>[]) List<WalkModel> walkList,
    @Default(<String, WalkModel>{}) Map<String, WalkModel> walkMap,
  }) = _StockInputState;
}

@riverpod
class StockInput extends _$StockInput {
  ///
  @override
  StockInputState build() => const StockInputState();

  ///
  Future<void> inputStockRecord({required String date, required Map<String, String> data}) async {
    final HttpClient client = ref.read(httpClientProvider);

    final Map<String, dynamic> uploadData = <String, dynamic>{};
    uploadData['date'] = date;
    uploadData['data'] = data;

    // ignore: always_specify_types
    await client.post(path: APIPath.insertDailyStockData, body: uploadData).then((value) {}).catchError((error, _) {
      UiUtils.showError('予期せぬエラーが発生しました');
    });
  }
}
