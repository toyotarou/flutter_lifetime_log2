import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/transportation_model.dart';
import '../../../utility/utility.dart';

part 'transportation.freezed.dart';

part 'transportation.g.dart';

@freezed
class TransportationState with _$TransportationState {
  const factory TransportationState({
    @Default(<TransportationModel>[]) List<TransportationModel> transportationList,
    @Default(<String, TransportationModel>{}) Map<String, TransportationModel> transportationMap,

    @Default(<StationModel>[]) List<StationModel> stationList,

    @Default(<String, String>{}) Map<String, String> trainMap,
  }) = _TransportationState;
}

@riverpod
class Transportation extends _$Transportation {
  final Utility utility = Utility();

  ///
  @override
  TransportationState build() {
    // アプリ全体で使う取得済みデータのキャッシュなので、画面の作り直し（再起動ボタン・登録後の再起動）の途中で
    // 監視者が一瞬いなくなっても破棄されないようにする（取得中に破棄されると取得処理がエラーになる）
    ref.keepAlive();

    return const TransportationState();
  }

  //============================================== api

  ///
  Future<TransportationState> fetchAllTransportationData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TransportationModel> list = <TransportationModel>[];

      final Map<String, TransportationModel> map = <String, TransportationModel>{};

      // 5つのAPIは互いに独立しているので並行して取得する（結果の処理順は従来どおり）
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        client.post(path: APIPath.getBusStopAddress),
        client.post(path: APIPath.getDupSpot),
        client.post(path: APIPath.getTrain),
        client.getByPath(path: 'http://49.212.175.205:3000/api/v1/station'),
        client.post(path: APIPath.gettrainrecord),
      ]);

      //---------------------------------------------------------------------------//

      final dynamic value3 = results[0];

      final Map<String, BusStopModel> busStopMap1 = <String, BusStopModel>{};

      // ignore: avoid_dynamic_calls
      for (final dynamic item in value3['data'] as List<dynamic>) {
        final BusStopModel val = BusStopModel.fromJson(item as Map<String, dynamic>);

        busStopMap1[val.name] = val;
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value4 = results[1];

      final Map<String, Map<String, String>> dupMap1 = <String, Map<String, String>>{};

      // ignore: avoid_dynamic_calls
      for (final dynamic item in value4['data'] as List<dynamic>) {
        final DupSpotModel val = DupSpotModel.fromJson(item as Map<String, dynamic>);

        dupMap1[val.name] = <String, String>{val.area: ''};
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value5 = results[2];

      final Map<String, String> trainMap = <String, String>{};

      // ignore: avoid_dynamic_calls
      for (final dynamic item in value5['data'] as List<dynamic>) {
        final TrainModel val = TrainModel.fromJson(item as Map<String, dynamic>);

        trainMap[val.trainNumber] = val.trainName;
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final List<StationModel> stationList = <StationModel>[];

      final dynamic value2 = results[3];

      final Map<String, StationModel> stationMap1 = <String, StationModel>{};

      for (final dynamic item in value2 as List<dynamic>) {
        final StationModel val = StationModel.fromJson(item as Map<String, dynamic>);

        val.trainName = trainMap[val.trainNumber];

        if (dupMap1[val.stationName] != null) {
          if (dupMap1[val.stationName]?[val.prefecture] == null) {
            continue;
          }
        }

        stationMap1[val.stationName] = val;

        stationList.add(val);
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value = results[4];

      // ignore: avoid_dynamic_calls
      for (final dynamic item in value['data'] as List<dynamic>) {
        final TrainBoardingModel val = TrainBoardingModel.fromJson(item as Map<String, dynamic>);

        final List<String> exStation = val.station.split('\n');

        final Map<int, List<SpotDataModel>> spotDataModelListMap = <int, List<SpotDataModel>>{};

        final Map<int, int> rootSpotCountMap = <int, int>{};

        for (int j = 0; j < exStation.length; j++) {
          final List<String> exElement = exStation[j].split('-');

          rootSpotCountMap[j] = exElement.length;

          final List<SpotDataModel> spotDataModelList = <SpotDataModel>[];

          for (final String element in exElement) {
            final String spotName = element.trim();

            final StationModel? station = stationMap1[spotName];

            if (station != null) {
              spotDataModelList.add(
                SpotDataModel(name: station.stationName, address: station.address, lat: station.lat, lng: station.lng),
              );
            }

            final BusStopModel? busStop = busStopMap1[spotName];

            if (busStop != null) {
              spotDataModelList.add(
                SpotDataModel(
                  name: busStop.name,
                  address: busStop.address,
                  lat: busStop.latitude,
                  lng: busStop.longitude,
                ),
              );
            }
          }

          spotDataModelListMap[j] = spotDataModelList;
        }

        final String date = val.date.yyyymmdd;

        list.add(
          TransportationModel(
            date: date,
            // ignore: avoid_bool_literals_in_conditional_expressions
            oufuku: (val.oufuku == '1') ? true : false,
            spotDataModelListMap: spotDataModelListMap,
            rootSpotCountMap: rootSpotCountMap,
            stationRouteList: exStation,
          ),
        );

        map[date] = TransportationModel(
          date: date,
          // ignore: avoid_bool_literals_in_conditional_expressions
          oufuku: (val.oufuku == '1') ? true : false,
          spotDataModelListMap: spotDataModelListMap,
          rootSpotCountMap: rootSpotCountMap,
          stationRouteList: exStation,
        );
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(
        transportationList: list,
        transportationMap: map,
        stationList: stationList,
        trainMap: trainMap,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（transportation）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTransportationData() async {
    try {
      final TransportationState newState = await fetchAllTransportationData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
