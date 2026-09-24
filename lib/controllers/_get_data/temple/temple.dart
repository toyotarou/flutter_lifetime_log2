import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
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
  TempleState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const TempleState();
  }

  //============================================== api

  ///
  Future<TempleState> fetchAllTempleData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TempleModel> list = <TempleModel>[];
      final Map<String, TempleModel> map = <String, TempleModel>{};

      // 3つのAPIは互いに独立しているので並行して取得する
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        client.post(path: APIPath.getTempleLatLng),
        client.post(path: APIPath.getTempleDatePhoto),
        client.post(path: APIPath.getAllTemple),
      ]);

      //---------------------------------------------------------------------------//
      final dynamic value2 = results[0];

      final Map<String, Map<String, String>> latlngMap1 = <String, Map<String, String>>{};

      // ignore: avoid_dynamic_calls
      for (final dynamic row in value2['list'] as List<dynamic>) {
        // ignore: avoid_dynamic_calls
        latlngMap1[row['temple'].toString()] = <String, String>{
          // ignore: avoid_dynamic_calls
          'temple': row['temple'].toString(),
          // ignore: avoid_dynamic_calls
          'address': row['address'].toString(),
          // ignore: avoid_dynamic_calls
          'latitude': row['lat'].toString(),
          // ignore: avoid_dynamic_calls
          'longitude': row['lng'].toString(),
          // ignore: avoid_dynamic_calls
          'rank': row['rank'].toString(),
        };
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//
      final dynamic value3 = results[1];

      final Map<String, List<TemplePhotoModel>> photoMap1 = <String, List<TemplePhotoModel>>{};

      // ignore: avoid_dynamic_calls
      for (final dynamic item in value3['data'] as List<dynamic>) {
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

      final dynamic value = results[2];

      // ignore: avoid_dynamic_calls
      final List<dynamic> templeRows = value['list'] as List<dynamic>;

      ///////////////////////////
      // 寺ごとの出現回数
      final Map<String, int> countMap1 = <String, int>{};

      for (final dynamic row in templeRows) {
        // ignore: avoid_dynamic_calls
        final String templeName = row['temple'].toString();

        countMap1[templeName] = (countMap1[templeName] ?? 0) + 1;
      }

      ///////////////////////////

      // latlngMap1 に存在する寺だけ TempleDataModel を作る
      TempleDataModel? buildTempleDataModel(String name) {
        final Map<String, String>? latlng = latlngMap1[name];

        if (latlng == null) {
          return null;
        }

        return TempleDataModel(
          name: latlng['temple']!,
          address: latlng['address']!,
          latitude: latlng['latitude']!,
          longitude: latlng['longitude']!,
          rank: latlng['rank']!,
          count: countMap1[name] ?? 0,
          templePhotoModelList: photoMap1[name],
        );
      }

      for (final dynamic row in templeRows) {
        // ignore: avoid_dynamic_calls
        final String templeName = row['temple'].toString();

        final List<TempleDataModel> templeDataList = <TempleDataModel>[];

        final TempleDataModel? mainTemple = buildTempleDataModel(templeName);

        if (mainTemple != null) {
          templeDataList.add(mainTemple);
        }

        // ignore: avoid_dynamic_calls
        if (row['memo'] != null) {
          // ignore: avoid_dynamic_calls
          final List<String> exMemo = row['memo'].toString().split('、');

          for (final String element in exMemo) {
            final TempleDataModel? memoTemple = buildTempleDataModel(element);

            if (memoTemple != null) {
              templeDataList.add(memoTemple);
            }
          }
        }

        final TempleModel templeModel = TempleModel(
          // ignore: avoid_dynamic_calls
          date: row['date'].toString(),
          // ignore: avoid_dynamic_calls
          startPoint: row['start_point'].toString(),
          // ignore: avoid_dynamic_calls
          endPoint: row['end_point'].toString(),
          templeDataList: templeDataList,
        );

        list.add(templeModel);

        map[templeModel.date] = templeModel;
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(templeList: list, templeMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（temple）', error: e);
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
