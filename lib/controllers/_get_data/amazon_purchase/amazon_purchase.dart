import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/amazon_purchase_model.dart';
import '../../../utils/ui_utils.dart';

part 'amazon_purchase.freezed.dart';

part 'amazon_purchase.g.dart';

@freezed
class AmazonPurchaseState with _$AmazonPurchaseState {
  const factory AmazonPurchaseState({
    @Default(<AmazonPurchaseModel>[]) List<AmazonPurchaseModel> amazonPurchaseList,
    @Default(<String, List<AmazonPurchaseModel>>{}) Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap,
  }) = _AmazonPurchaseState;
}

@riverpod
class AmazonPurchase extends _$AmazonPurchase {
  ///
  @override
  AmazonPurchaseState build() => const AmazonPurchaseState();

  //============================================== api

  ///
  Future<AmazonPurchaseState> fetchAllAmazonPurchaseData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<AmazonPurchaseModel> list = <AmazonPurchaseModel>[];
      final Map<String, List<AmazonPurchaseModel>> map = <String, List<AmazonPurchaseModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAmazonData).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final AmazonPurchaseModel val = AmazonPurchaseModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}-${val.day}'] ??= <AmazonPurchaseModel>[]).add(val);
        }
      });

      return state.copyWith(amazonPurchaseList: list, amazonPurchaseMap: map);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllAmazonPurchaseData() async {
    try {
      final AmazonPurchaseState newState = await fetchAllAmazonPurchaseData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
