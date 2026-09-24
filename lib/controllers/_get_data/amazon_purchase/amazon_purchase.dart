import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/amazon_purchase_model.dart';
import '../../../utility/utility.dart';

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
  final Utility utility = Utility();

  ///
  @override
  AmazonPurchaseState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const AmazonPurchaseState();
  }

  //============================================== api

  ///
  Future<AmazonPurchaseState> fetchAllAmazonPurchaseData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<AmazonPurchaseModel> list = <AmazonPurchaseModel>[];
      final Map<String, List<AmazonPurchaseModel>> map = <String, List<AmazonPurchaseModel>>{};

      final dynamic value = await client.post(path: APIPath.getAmazonData);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final AmazonPurchaseModel val = AmazonPurchaseModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        (map['${val.year}-${val.month}-${val.day}'] ??= <AmazonPurchaseModel>[]).add(val);
      }

      return state.copyWith(amazonPurchaseList: list, amazonPurchaseMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（amazon_purchase）', error: e);
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
