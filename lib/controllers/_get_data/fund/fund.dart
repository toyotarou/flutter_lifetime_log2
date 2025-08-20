import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/fund_model.dart';
import '../../../utility/utility.dart';

part 'fund.freezed.dart';

part 'fund.g.dart';

@freezed
class FundState with _$FundState {
  const factory FundState({
    @Default(<FundModel>[]) List<FundModel> fundList,
    @Default(<String, List<FundModel>>{}) Map<String, List<FundModel>> fundMap,
    @Default(<int, List<FundModel>>{}) Map<int, List<FundModel>> fundRelationMap,
  }) = _FundState;
}

@riverpod
class Fund extends _$Fund {
  final Utility utility = Utility();

  ///
  @override
  FundState build() => const FundState();

  //============================================== api

  ///
  Future<FundState> fetchAllFundData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<FundModel> list = <FundModel>[];
      final Map<String, List<FundModel>> map = <String, List<FundModel>>{};
      final Map<int, List<FundModel>> map2 = <int, List<FundModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getFund).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final FundModel val = FundModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map[val.name] ??= <FundModel>[]).add(val);

          (map2[val.relationalId.toInt()] ??= <FundModel>[]).add(val);
        }
      });

      return state.copyWith(fundList: list, fundMap: map, fundRelationMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllFundData() async {
    try {
      final FundState newState = await fetchAllFundData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
