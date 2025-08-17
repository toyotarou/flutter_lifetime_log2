import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/invest_model.dart';
import '../../../utility/utility.dart';

part 'invest_records.freezed.dart';

part 'invest_records.g.dart';

@freezed
class InvestRecordsState with _$InvestRecordsState {
  const factory InvestRecordsState({
    @Default(<InvestRecordModel>[]) List<InvestRecordModel> investRecordList,
    @Default(<int, List<InvestRecordModel>>{}) Map<int, List<InvestRecordModel>> investRecordMap,
  }) = _InvestRecordsState;
}

@Riverpod(keepAlive: true)
class InvestRecords extends _$InvestRecords {
  final Utility utility = Utility();

  @override
  InvestRecordsState build() => const InvestRecordsState();

  //============================================== api

  ///
  Future<InvestRecordsState> fetchAllInvestRecords() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<InvestRecordModel> list = <InvestRecordModel>[];
      final Map<int, List<InvestRecordModel>> map = <int, List<InvestRecordModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllInvestRecords).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final InvestRecordModel val = InvestRecordModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map[val.relationalId] ??= <InvestRecordModel>[]).add(val);

          // map['${val.year}-${val.month}-${val.day}'] = val;
        }
      });

      return state.copyWith(investRecordList: list, investRecordMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllInvestRecordsData() async {
    try {
      final InvestRecordsState newState = await fetchAllInvestRecords();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
