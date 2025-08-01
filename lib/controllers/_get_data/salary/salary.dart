import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/salary_model.dart';
import '../../../utility/utility.dart';

part 'salary.freezed.dart';

part 'salary.g.dart';

@freezed
class SalaryState with _$SalaryState {
  const factory SalaryState({
    @Default(<SalaryModel>[]) List<SalaryModel> salaryList,
    @Default(<String, SalaryModel>{}) Map<String, SalaryModel> salaryMap,
  }) = _SalaryState;
}

@riverpod
class Salary extends _$Salary {
  final Utility utility = Utility();

  ///
  @override
  SalaryState build() => const SalaryState();

  //============================================== api

  ///
  Future<SalaryState> fetchAllSalaryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<SalaryModel> list = <SalaryModel>[];
      final Map<String, SalaryModel> map = <String, SalaryModel>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getAllWeather).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final List<String> exData = value['data'][i].toString().split('|');

          final SalaryModel val = SalaryModel(
            date: exData[0].trim(),
            yearmonth: exData[1].trim(),
            salary: exData[2].trim().toInt(),
            company: exData[3].trim(),
          );

          list.add(val);

          map[val.yearmonth] = val;
        }
      });

      return state.copyWith(salaryList: list, salaryMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllSalaryData() async {
    try {
      final SalaryState newState = await fetchAllSalaryData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
