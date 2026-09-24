import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/common/scroll_line_chart_model.dart';
import '../../../utility/utility.dart';

part 'money_sum.freezed.dart';

part 'money_sum.g.dart';

@freezed
class MoneySumState with _$MoneySumState {
  const factory MoneySumState({
    @Default(<ScrollLineChartModel>[]) List<ScrollLineChartModel> moneySumList,
    @Default(<String, ScrollLineChartModel>{}) Map<String, ScrollLineChartModel> moneySumMap,
  }) = _MoneySumState;
}

@riverpod
class MoneySum extends _$MoneySum {
  final Utility utility = Utility();

  ///
  @override
  MoneySumState build() => const MoneySumState();

  //============================================== api

  ///
  Future<MoneySumState> fetchAllMoneySumData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<ScrollLineChartModel> list = <ScrollLineChartModel>[];
      final Map<String, ScrollLineChartModel> map = <String, ScrollLineChartModel>{};

      final dynamic value = await client.post(path: APIPath.getAllMoneySum);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final ScrollLineChartModel val = ScrollLineChartModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map[val.date] = val;
      }

      return state.copyWith(moneySumList: list, moneySumMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（money_sum）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMoneySumData() async {
    try {
      final MoneySumState newState = await fetchAllMoneySumData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
