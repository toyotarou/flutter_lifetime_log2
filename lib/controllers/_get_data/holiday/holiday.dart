import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../utility/utility.dart';

part 'holiday.freezed.dart';

part 'holiday.g.dart';

@freezed
class HolidayState with _$HolidayState {
  const factory HolidayState({@Default(<String>[]) List<String> holidayList}) = _HolidayState;
}

@riverpod
class Holiday extends _$Holiday {
  final Utility utility = Utility();

  ///
  @override
  HolidayState build() => const HolidayState();

  //============================================== api

  ///
  Future<HolidayState> fetchAllHolidayData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<String> list = <String>[];

      final dynamic value = await client.post(path: APIPath.getholiday);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        list.add(item.toString());
      }

      return state.copyWith(holidayList: list);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（holiday）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllHolidayData() async {
    try {
      final HolidayState newState = await fetchAllHolidayData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
