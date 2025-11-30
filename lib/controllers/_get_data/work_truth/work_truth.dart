import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/work_truth_model.dart';
import '../../../utility/utility.dart';

part 'work_truth.freezed.dart';

part 'work_truth.g.dart';

@freezed
class WorkTruthState with _$WorkTruthState {
  const factory WorkTruthState({@Default(<String, WorkTruthModel>{}) Map<String, WorkTruthModel> workTruthModelMap}) =
      _WorkTruthState;
}

@riverpod
class WorkTruth extends _$WorkTruth {
  final Utility utility = Utility();

  ///
  @override
  WorkTruthState build() => const WorkTruthState();

  //============================================== api

  ///
  Future<WorkTruthState> fetchAllWorkTruthData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      Map<String, WorkTruthModel> map = {};

      // ignore: always_specify_types
      await client.post(path: APIPath.getWorkTruth).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final WorkTruthModel val = WorkTruthModel.fromJson(value['data'][i] as Map<String, dynamic>);

          map['${val.year}-${val.month}'] = val;
        }
      });

      return state.copyWith(workTruthModelMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllWorkTruthData() async {
    try {
      final WorkTruthState newState = await fetchAllWorkTruthData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
