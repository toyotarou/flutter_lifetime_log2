import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../extensions/extensions.dart';
import '../../../models/fortune_model.dart';
import '../../../utility/utility.dart';

part 'fortune.freezed.dart';

part 'fortune.g.dart';

@freezed
class FortuneState with _$FortuneState {
  const factory FortuneState({
    @Default(<FortuneModel>[]) List<FortuneModel> fortuneList,
    @Default(<String, FortuneModel>{}) Map<String, FortuneModel> fortuneMap,
  }) = _FortuneState;
}

@riverpod
class Fortune extends _$Fortune {
  final Utility utility = Utility();

  ///
  @override
  FortuneState build() => const FortuneState();

  //============================================== api

  ///
  Future<FortuneState> fetchAllFortuneData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<FortuneModel> list = <FortuneModel>[];
      final Map<String, FortuneModel> map = <String, FortuneModel>{};

      // ignore: always_specify_types
      await client.getByPath(path: 'http://49.212.175.205:5001/fortunes').then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final FortuneModel val = FortuneModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          final DateTime dataDate = DateTime.parse('${val.year}-${val.month}-${val.day}');
          final DateTime borderDate = DateTime(2026, 4, 9);
          final String mapKey = dataDate.isBefore(borderDate)
              ? dataDate.add(const Duration(days: -1)).yyyymmdd
              : dataDate.yyyymmdd;

          map[mapKey] = val;
        }
      });

      return state.copyWith(fortuneList: list, fortuneMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow;
    }
  }

  ///
  Future<void> getAllFortuneData() async {
    try {
      final FortuneState newState = await fetchAllFortuneData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
