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
    @Default(<String, List<SalaryModel>>{}) Map<String, List<SalaryModel>> salaryMap,
  }) = _SalaryState;
}

@riverpod
class Salary extends _$Salary {
  final Utility utility = Utility();

  ///
  @override
  SalaryState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const SalaryState();
  }

  //============================================== api

  ///
  Future<SalaryState> fetchAllSalaryData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<SalaryModel> list = <SalaryModel>[];
      final Map<String, List<SalaryModel>> map = <String, List<SalaryModel>>{};

      final dynamic value = await client.post(path: APIPath.getAllBenefit);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final List<String> exData = item.toString().split('|');

        final SalaryModel val = SalaryModel(
          date: exData[0].trim(),
          yearmonth: exData[1].trim(),
          salary: exData[2].trim().toInt(),
          company: exData[3].trim(),
        );

        list.add(val);

        (map[val.date] ??= <SalaryModel>[]).add(val);
      }

      return state.copyWith(salaryList: list, salaryMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（salary）', error: e);
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
