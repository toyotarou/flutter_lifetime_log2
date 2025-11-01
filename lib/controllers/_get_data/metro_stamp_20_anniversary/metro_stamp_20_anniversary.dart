import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../extensions/extensions.dart';
import '../../../models/metro_stamp_20_anniversary_model.dart';
import '../../../utility/utility.dart';

part 'metro_stamp_20_anniversary.freezed.dart';

part 'metro_stamp_20_anniversary.g.dart';

@freezed
class MetroStamp20AnniversaryState with _$MetroStamp20AnniversaryState {
  const factory MetroStamp20AnniversaryState({
    @Default(<MetroStamp20AnniversaryModel>[]) List<MetroStamp20AnniversaryModel> metroStamp20AnniversaryModelList,
    @Default(<String, List<MetroStamp20AnniversaryModel>>{})
    Map<String, List<MetroStamp20AnniversaryModel>> metroStamp20AnniversaryModelMap,
  }) = _MetroStamp20AnniversaryState;
}

@riverpod
class MetroStamp20Anniversary extends _$MetroStamp20Anniversary {
  final Utility utility = Utility();

  ///
  @override
  MetroStamp20AnniversaryState build() => const MetroStamp20AnniversaryState();

  //============================================== api

  ///
  Future<MetroStamp20AnniversaryState> fetchAllMetroStamp20AnniversayData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<MetroStamp20AnniversaryModel> list = <MetroStamp20AnniversaryModel>[];

      final Map<String, List<MetroStamp20AnniversaryModel>> map = <String, List<MetroStamp20AnniversaryModel>>{};

      // ignore: always_specify_types
      await client.getByPath(path: 'http://49.212.175.205:3000/api/v1/stampRallyMetro20').then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value.length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final MetroStamp20AnniversaryModel val = MetroStamp20AnniversaryModel.fromJson(
            // ignore: avoid_dynamic_calls
            value[i] as Map<String, dynamic>,
          );

          list.add(val);

          (map[val.getDate] ??= <MetroStamp20AnniversaryModel>[]).add(val);
        }
      });

      return state.copyWith(metroStamp20AnniversaryModelList: <MetroStamp20AnniversaryModel>[], metroStamp20AnniversaryModelMap: <String, List<MetroStamp20AnniversaryModel>>{});
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMetroStamp20AnniversayData() async {
    try {
      final MetroStamp20AnniversaryState newState = await fetchAllMetroStamp20AnniversayData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
