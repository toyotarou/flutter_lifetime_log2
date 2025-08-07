import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/temple_photo_model.dart';
import '../../../utility/utility.dart';

part 'temple_photo.freezed.dart';

part 'temple_photo.g.dart';

@freezed
class TemplePhotoState with _$TemplePhotoState {
  const factory TemplePhotoState({
    @Default(<TemplePhotoModel>[]) List<TemplePhotoModel> templePhotoList,
    @Default(<String, List<TemplePhotoModel>>{}) Map<String, List<TemplePhotoModel>> templePhotoMap,
  }) = _TemplePhotoState;
}

@riverpod
class TemplePhoto extends _$TemplePhoto {
  final Utility utility = Utility();

  ///
  @override
  TemplePhotoState build() => const TemplePhotoState();

  //============================================== api

  ///
  Future<TemplePhotoState> fetchAllTemplePhotoData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TemplePhotoModel> list = <TemplePhotoModel>[];

      final Map<String, List<TemplePhotoModel>> map = <String, List<TemplePhotoModel>>{};

      // ignore: always_specify_types
      await client.post(path: APIPath.getTempleDatePhoto).then((value) {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          // ignore: avoid_dynamic_calls
          final TemplePhotoModel val = TemplePhotoModel.fromJson(value['data'][i] as Map<String, dynamic>);

          list.add(val);

          (map[val.temple] ??= <TemplePhotoModel>[]).add(val);
        }
      });

      return state.copyWith(templePhotoList: list, templePhotoMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTemplePhotoData() async {
    try {
      final TemplePhotoState newState = await fetchAllTemplePhotoData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
