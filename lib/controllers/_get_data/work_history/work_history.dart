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
  WorkHistoryState build() => const WorkHistoryState();

  //============================================== api

  ///
  Future<WorkHistoryState> fetchAllWorkHistoryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      //--------------------------------------------------------// contract
      final List<WorkContractModel> workContractList = <WorkContractModel>[];
      final Map<String, WorkContractModel> workContractMap = <String, WorkContractModel>{};
      final Map<String, WorkContractModel> workContractMap2 = <String, WorkContractModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getWorkContract).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final WorkContractModel val = WorkContractModel.fromJson(value['data'][i] as Map<String, dynamic>);

          workContractList.add(val);

          workContractMap2['${val.year}-${val.month}'] = val;
        }
      });

      final WorkContractModel first = workContractList.first;

      final int diffDays = DateTime.now().difference(DateTime(first.year.toInt(), first.month.toInt())).inDays;

      final List<String> yearMonthList = <String>[];

      WorkContractModel? lastRecord;
      for (int i = 0; i < diffDays; i++) {
        final String yearMonth = DateTime(first.year.toInt(), first.month.toInt()).add(Duration(days: i)).yyyymm;

        if (yearMonthList.contains(yearMonth)) {
          continue;
        }

        if (workContractMap2[yearMonth] != null) {
          lastRecord = workContractMap2[yearMonth];
        }

        if (lastRecord != null) {
          workContractMap[yearMonth] = lastRecord;
        }

        yearMonthList.add(yearMonth);
      }
      //--------------------------------------------------------// contract

      final Map<String, WorkHistoryModel> map = <String, WorkHistoryModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getWorkTruth).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final WorkTruthModel val = WorkTruthModel.fromJson(value['data'][i] as Map<String, dynamic>);

          final String contract = (workContractMap['${val.year}-${val.month}'] != null)
              ? workContractMap['${val.year}-${val.month}']!.name
              : '';

          map['${val.year}-${val.month}'] = WorkHistoryModel(
            year: val.year,
            month: val.month,
            workTruthName: val.name,
            workContractName: contract,
          );
        }
      });

      return state.copyWith(workHistoryModelMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllWorkHistoryData() async {
    try {
      final WorkHistoryState newState = await fetchAllWorkHistoryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
