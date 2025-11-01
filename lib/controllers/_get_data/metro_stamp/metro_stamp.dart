import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/metro_stamp_model.dart';
import '../../../utility/utility.dart';

part 'metro_stamp.freezed.dart';

part 'metro_stamp.g.dart';

@freezed
class MetroStampState with _$MetroStampState {
  const factory MetroStampState({
    @Default(<String, String>{}) Map<String, String> trainMap,
    @Default(<MetroStampModel>[]) List<MetroStampModel> metroStampList,
    @Default(<String, List<MetroStampModel>>{}) Map<String, List<MetroStampModel>> metroStampMap,
    @Default(<String, List<MetroStampModel>>{}) Map<String, List<MetroStampModel>> dateMetroStampMap,
  }) = _MetroStampState;
}

@Riverpod(keepAlive: true)
class MetroStamp extends _$MetroStamp {
  final Utility utility = Utility();

  ///
  @override
  MetroStampState build() => const MetroStampState();

  //============================================== api

  ///
  Future<MetroStampState> fetchAllMetroStampData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getStationStamp);

      final List<MetroStampModel> list = <MetroStampModel>[];

      final Map<String, String> map = <String, String>{};
      final Map<String, List<MetroStampModel>> map2 = <String, List<MetroStampModel>>{};
      final Map<String, List<MetroStampModel>> map3 = <String, List<MetroStampModel>>{};

      final List<String> keepTrain = <String>[];
      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final MetroStampModel val = MetroStampModel.fromJson(value['data'][i] as Map<String, dynamic>);

        map2[val.imageFolder] = <MetroStampModel>[];
        map3[val.stampGetDate.replaceAll('/', '-')] = <MetroStampModel>[];

        if (!keepTrain.contains(val.imageFolder)) {
          map[val.imageFolder] = val.trainName;
        }

        keepTrain.add(val.imageFolder);
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final MetroStampModel val = MetroStampModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map2[val.imageFolder]?.add(val);

        map3[val.stampGetDate.replaceAll('/', '-')]?.add(val);
      }

      return state.copyWith(trainMap: map, metroStampList: list, metroStampMap: map2, dateMetroStampMap: map3);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllMetroStampData() async {
    try {
      final MetroStampState newState = await fetchAllMetroStampData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
