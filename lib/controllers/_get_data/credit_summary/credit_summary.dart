import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/credit_summary_model.dart';
import '../../../utils/ui_utils.dart';

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

      // ignore: always_specify_types
      await client.post(path: APIPath.getCreditSummary).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final CreditSummaryModel val = CreditSummaryModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map['${val.year}-${val.month}'] ??= <CreditSummaryModel>[]).add(val);
        }
      });

      return state.copyWith(creditSummaryList: list, creditSummaryMap: map);
    } catch (e) {
      UiUtils.showError('予期せぬエラーが発生しました');
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
