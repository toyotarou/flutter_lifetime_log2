import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
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

      // ignore: always_specify_types
      await client.post(path: APIPath.getholiday).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          list.add(value['data'][i].toString());
        }
      });

      return state.copyWith(holidayList: list);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
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
