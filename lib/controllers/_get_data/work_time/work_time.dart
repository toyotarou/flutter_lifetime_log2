import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/work_time_model.dart';
import '../../../utility/utility.dart';

part 'work_time.freezed.dart';

part 'work_time.g.dart';

@freezed
class WorkTimeState with _$WorkTimeState {
  const factory WorkTimeState({
    @Default(<WorkTimeModel>[]) List<WorkTimeModel> workTimeList,
    @Default(<String, WorkTimeModel>{}) Map<String, WorkTimeModel> workTimeMap,
    @Default(<String, Map<String, String>>{}) Map<String, Map<String, String>> workTimeDateMap,
  }) = _WorkTimeState;
}

@riverpod
class WorkTime extends _$WorkTime {
  final Utility utility = Utility();

  ///
  @override
  WorkTimeState build() => const WorkTimeState();

  //============================================== api

  ///
  Future<WorkTimeState> fetchAllWorkTimeData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<WorkTimeModel> list = <WorkTimeModel>[];
      final Map<String, WorkTimeModel> map = <String, WorkTimeModel>{};
      final Map<String, Map<String, String>> map2 = <String, Map<String, String>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.worktimesummary).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final List<String> exValue = value['data'][i].toString().split(';');

          final List<String> listItem = exValue[exValue.length - 1].split('/');

          final List<WorkTimeDataModel> list2 = <WorkTimeDataModel>[];

          for (final String element in listItem) {
            final List<String> exElement = element.split('|');

            list2.add(
              WorkTimeDataModel(
                day: exElement[0],
                start: exElement[1],
                end: exElement[2],
                workTime: exElement[3],
                restMinute: exElement[4],
                youbiNum: exElement[5],
              ),
            );

            final List<String> exDay = exElement[0].split('(');

            map2['${exValue[0]}-${exDay[0]}'] = <String, String>{'start': exElement[1], 'end': exElement[2]};
          }

          final WorkTimeModel workTimeModel = WorkTimeModel(
            yearmonth: exValue[0],
            totalTime: exValue[1],
            agentName: exValue[2],
            genbaName: exValue[3],
            salary: exValue[4],
            tanka: exValue[5],
            data: list2,
          );

          list.add(workTimeModel);

          map[exValue[0]] = workTimeModel;
        }
      });

      return state.copyWith(workTimeList: list, workTimeMap: map, workTimeDateMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllWorkTimeData() async {
    try {
      final WorkTimeState newState = await fetchAllWorkTimeData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
