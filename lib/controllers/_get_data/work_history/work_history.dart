import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/common/work_history_model.dart';
import '../../../models/work_contract_model.dart';
import '../../../models/work_truth_model.dart';
import '../../../utility/utility.dart';

part 'work_history.freezed.dart';

part 'work_history.g.dart';

@freezed
class WorkHistoryState with _$WorkHistoryState {
  const factory WorkHistoryState({
    @Default(<String, WorkHistoryModel>{}) Map<String, WorkHistoryModel> workHistoryModelMap,
  }) = _WorkHistoryState;
}

@riverpod
class WorkHistory extends _$WorkHistory {
  final Utility utility = Utility();

  ///
  @override
  WorkHistoryState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const WorkHistoryState();
  }

  //============================================== api

  ///
  Future<WorkHistoryState> fetchAllWorkHistoryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      // 2つのAPIは互いに独立しているので並行して取得する
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        client.post(path: APIPath.getWorkContract),
        client.post(path: APIPath.getWorkTruth),
      ]);

      //--------------------------------------------------------// contract
      final List<WorkContractModel> workContractList = <WorkContractModel>[];
      final Map<String, WorkContractModel> workContractMap = <String, WorkContractModel>{};
      final Map<String, WorkContractModel> workContractMap2 = <String, WorkContractModel>{};

      final List<dynamic> contractData = (results[0] as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in contractData) {
        final WorkContractModel val = WorkContractModel.fromJson(item as Map<String, dynamic>);

        workContractList.add(val);

        workContractMap2['${val.year}-${val.month}'] = val;
      }

      workContractList.sort((WorkContractModel a, WorkContractModel b) {
        final String aKey = '${a.year}-${a.month.padLeft(2, '0')}';
        final String bKey = '${b.year}-${b.month.padLeft(2, '0')}';
        return aKey.compareTo(bKey);
      });

      // 契約データが0件の場合は first が例外になるため、月ごとの補完処理をスキップする（契約名は空文字になる）
      if (workContractList.isNotEmpty) {
        final WorkContractModel first = workContractList.first;

        final DateTime firstDate = DateTime(first.year.toInt(), first.month.toInt());

        final int diffDays = DateTime.now().difference(firstDate).inDays;

        // 処理済みの年月（contains を O(1) にするため Set を使う）
        final Set<String> yearMonthSet = <String>{};

        WorkContractModel? lastRecord;
        for (int i = 0; i < diffDays; i++) {
          final String yearMonth = firstDate.add(Duration(days: i)).yyyymm;

          if (!yearMonthSet.add(yearMonth)) {
            continue;
          }

          if (workContractMap2[yearMonth] != null) {
            lastRecord = workContractMap2[yearMonth];
          }

          if (lastRecord != null) {
            workContractMap[yearMonth] = lastRecord;
          }
        }
      }
      //--------------------------------------------------------// contract

      final Map<String, WorkHistoryModel> map = <String, WorkHistoryModel>{};

      final List<dynamic> truthData = (results[1] as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in truthData) {
        final WorkTruthModel val = WorkTruthModel.fromJson(item as Map<String, dynamic>);

        final String contract = workContractMap['${val.year}-${val.month}']?.name ?? '';

        map['${val.year}-${val.month}'] = WorkHistoryModel(
          year: val.year,
          month: val.month,
          workTruthName: val.name,
          workContractName: contract,
        );
      }

      return state.copyWith(workHistoryModelMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（work_history）', error: e);
      rethrow;
    }
  }

  ///
  Future<Map<String, WorkHistoryModel>> getAllWorkHistoryData() async {
    try {
      final WorkHistoryState newState = await fetchAllWorkHistoryData();

      state = newState;

      return newState.workHistoryModelMap;
    } catch (_) {
      return <String, WorkHistoryModel>{};
    }
  }

  //============================================== api
}
