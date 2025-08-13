import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/temple_model.dart';
import '../../../utility/utility.dart';

part 'temple.freezed.dart';

part 'temple.g.dart';

@freezed
class TempleState with _$TempleState {
  const factory TempleState({
    @Default(<TempleModel>[]) List<TempleModel> templeList,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> templeMap,
  }) = _TempleState;
}

@riverpod
class Temple extends _$Temple {
  final Utility utility = Utility();

  ///
  @override
  TempleState build() => const TempleState();

  //============================================== api

  ///
  Future<TempleState> fetchAllTempleData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TempleModel> list = <TempleModel>[];
      final Map<String, TempleModel> map = <String, TempleModel>{};

      //---------------------------------------------------------------------------//
      final dynamic value2 = await client.post(path: APIPath.getTempleLatLng);

      final Map<String, Map<String, String>> latlngMap1 = <String, Map<String, String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value2['list'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        latlngMap1[value2['list'][i]['temple'].toString()] = <String, String>{
          // ignore: avoid_dynamic_calls
          'temple': value2['list'][i]['temple'].toString(),
          // ignore: avoid_dynamic_calls
          'address': value2['list'][i]['address'].toString(),
          // ignore: avoid_dynamic_calls
          'latitude': value2['list'][i]['lat'].toString(),
          // ignore: avoid_dynamic_calls
          'longitude': value2['list'][i]['lng'].toString(),
          // ignore: avoid_dynamic_calls
          'rank': value2['list'][i]['rank'].toString(),
        };
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//
      final dynamic value3 = await client.post(path: APIPath.getTempleDatePhoto);

      final Map<String, List<TemplePhotoModel>> photoMap1 = <String, List<TemplePhotoModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value3['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final dynamic item = value3['data'][i];

        // ignore: avoid_dynamic_calls
        final String temple = item['temple'].toString();
        // ignore: avoid_dynamic_calls
        final String date = item['date'].toString();

        // ignore: avoid_dynamic_calls
        final dynamic rawPhotos = item['templephotos'];

        // ignore: always_specify_types
        final List<String> templephotos = (rawPhotos is List)
            // ignore: always_specify_types
            ? rawPhotos.map((e) => e.toString()).toList()
            : <String>[];

        (photoMap1[temple] ??= <TemplePhotoModel>[]).add(
          TemplePhotoModel(date: date, temple: temple, templephotos: templephotos),
        );
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value = await client.post(path: APIPath.getAllTemple);

      ///////////////////////////
      final Map<String, List<String>> countMap1 = <String, List<String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final String templeName = value['list'][i]['temple'].toString();

        (countMap1[templeName] ??= <String>[]).add(templeName);
      }

      ///////////////////////////

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final String templeName = value['list'][i]['temple'].toString();

        final List<TempleDataModel> templeDataList = <TempleDataModel>[];

        if (latlngMap1[templeName] != null) {
          templeDataList.add(
            TempleDataModel(
              name: latlngMap1[templeName]!['temple']!,
              address: latlngMap1[templeName]!['address']!,
              latitude: latlngMap1[templeName]!['latitude']!,
              longitude: latlngMap1[templeName]!['longitude']!,
              rank: latlngMap1[templeName]!['rank']!,
              count: (countMap1[templeName] != null) ? countMap1[templeName]!.length : 0,
              templePhotoModelList: photoMap1[templeName],
            ),
          );
        }

        // ignore: avoid_dynamic_calls
        if (value['list'][i]['memo'] != null) {
          // ignore: avoid_dynamic_calls
          final List<String> exMemo = value['list'][i]['memo'].toString().split('、');

          for (final String element in exMemo) {
            if (latlngMap1[element] != null) {
              templeDataList.add(
                TempleDataModel(
                  name: latlngMap1[element]!['temple']!,
                  address: latlngMap1[element]!['address']!,
                  latitude: latlngMap1[element]!['latitude']!,
                  longitude: latlngMap1[element]!['longitude']!,
                  rank: latlngMap1[element]!['rank']!,
                  count: (countMap1[element] != null) ? countMap1[element]!.length : 0,
                  templePhotoModelList: photoMap1[element],
                ),
              );
            }
          }
        }

        final TempleModel templeModel = TempleModel(
          // ignore: avoid_dynamic_calls
          date: value['list'][i]['date'].toString(),
          // ignore: avoid_dynamic_calls
          startPoint: value['list'][i]['startPoint'].toString(),
          // ignore: avoid_dynamic_calls
          endPoint: value['list'][i]['endPoint'].toString(),
          templeDataList: templeDataList,
        );

        list.add(templeModel);

        map[templeModel.date] = templeModel;
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(templeList: list, templeMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTempleData() async {
    try {
      final TempleState newState = await fetchAllTempleData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
