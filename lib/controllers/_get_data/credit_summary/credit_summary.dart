import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/credit_summary_model.dart';
import '../../../utility/utility.dart';

part 'credit_summary.freezed.dart';

part 'credit_summary.g.dart';

@freezed
class CreditSummaryState with _$CreditSummaryState {
  const factory CreditSummaryState({
    @Default(<CreditSummaryModel>[]) List<CreditSummaryModel> creditSummaryList,
    @Default(<String, List<CreditSummaryModel>>{}) Map<String, List<CreditSummaryModel>> creditSummaryMap,
  }) = _CreditSummaryState;
}

@riverpod
class CreditSummary extends _$CreditSummary {
  final Utility utility = Utility();

  ///
  @override
  CreditSummaryState build() => const CreditSummaryState();

  //============================================== api

  ///
  Future<CreditSummaryState> fetchAllCreditSummaryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<CreditSummaryModel> list = <CreditSummaryModel>[];
      final Map<String, List<CreditSummaryModel>> map = <String, List<CreditSummaryModel>>{};

      final dynamic value = await client.post(path: APIPath.getCreditSummary);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final CreditSummaryModel val = CreditSummaryModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        (map['${val.year}-${val.month}'] ??= <CreditSummaryModel>[]).add(val);
      }

      return state.copyWith(creditSummaryList: list, creditSummaryMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（credit_summary）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllCreditSummaryData() async {
    try {
      final CreditSummaryState newState = await fetchAllCreditSummaryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
