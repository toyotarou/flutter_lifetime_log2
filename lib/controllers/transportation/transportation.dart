import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/transportation_model.dart';
import '../../utility/utility.dart';

part 'transportation.freezed.dart';

part 'transportation.g.dart';

@freezed
class TransportationState with _$TransportationState {
  const factory TransportationState({
    @Default(<TransportationModel>[]) List<TransportationModel> transportationList,
    @Default(<String, TransportationModel>{}) Map<String, TransportationModel> transportationMap,
  }) = _TransportationState;
}

@riverpod
class Transportation extends _$Transportation {
  final Utility utility = Utility();

  ///
  @override
  TransportationState build() => const TransportationState();

  //============================================== api

  ///
  Future<TransportationState> fetchAllTransportationData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<TransportationModel> list = <TransportationModel>[];

      final Map<String, TransportationModel> map = <String, TransportationModel>{};

      //---------------------------------------------------------------------------//

      final dynamic value3 = await client.post(path: APIPath.getBusStopAddress);

      final Map<String, BusStopModel> busStopMap1 = <String, BusStopModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value3['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final BusStopModel val = BusStopModel.fromJson(value3['data'][i] as Map<String, dynamic>);

        busStopMap1[val.name] = val;
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value4 = await client.post(path: APIPath.getDupSpot);

      final Map<String, Map<String, String>> dupMap1 = <String, Map<String, String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value4['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final DupSpotModel val = DupSpotModel.fromJson(value4['data'][i] as Map<String, dynamic>);

        dupMap1[val.name] = <String, String>{val.area: ''};
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value2 = await client.getByPath(path: 'http://49.212.175.205:3000/api/v1/station');

      final Map<String, StationModel> stationMap1 = <String, StationModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value2.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StationModel val = StationModel.fromJson(value2[i] as Map<String, dynamic>);

        if (dupMap1[val.stationName] != null) {
          if (dupMap1[val.stationName]![val.prefecture] != null) {
            stationMap1[val.stationName] = val;
          }
        }
      }

      //---------------------------------------------------------------------------//

      //---------------------------------------------------------------------------//

      final dynamic value = await client.post(path: APIPath.gettrainrecord);

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TrainBoardingModel val = TrainBoardingModel.fromJson(value['data'][i] as Map<String, dynamic>);

        final List<String> exStation = val.station.split('\n');

        final Map<int, List<SpotDataModel>> spotDataModelListMap = <int, List<SpotDataModel>>{};

        final Map<int, int> rootSpotCountMap = <int, int>{};

        for (int j = 0; j < exStation.length; j++) {
          final List<String> exElement = exStation[j].split('-');

          rootSpotCountMap[j] = exElement.length;

          final List<SpotDataModel> spotDataModelList = <SpotDataModel>[];

          for (int k = 0; k < exElement.length; k++) {
            if (stationMap1[exElement[k]] != null) {
              spotDataModelList.add(
                SpotDataModel(
                  name: stationMap1[exElement[k]]!.stationName,
                  address: stationMap1[exElement[k]]!.address,
                  lat: stationMap1[exElement[k]]!.lat,
                  lng: stationMap1[exElement[k]]!.lng,
                ),
              );
            } else if (busStopMap1[exElement[k]] != null) {
              spotDataModelList.add(
                SpotDataModel(
                  name: busStopMap1[exElement[k]]!.name,
                  address: busStopMap1[exElement[k]]!.address,
                  lat: busStopMap1[exElement[k]]!.latitude,
                  lng: busStopMap1[exElement[k]]!.longitude,
                ),
              );
            }
          }

          spotDataModelListMap[j] = spotDataModelList;
        }

        list.add(
          TransportationModel(
            date: val.date.yyyymmdd,
            // ignore: avoid_bool_literals_in_conditional_expressions
            oufuku: (val.oufuku == '1') ? true : false,
            spotDataModelListMap: spotDataModelListMap,
            rootSpotCountMap: rootSpotCountMap,
          ),
        );

        map[val.date.yyyymmdd] = TransportationModel(
          date: val.date.yyyymmdd,
          // ignore: avoid_bool_literals_in_conditional_expressions
          oufuku: (val.oufuku == '1') ? true : false,
          spotDataModelListMap: spotDataModelListMap,
          rootSpotCountMap: rootSpotCountMap,
        );
      }

      //---------------------------------------------------------------------------//

      return state.copyWith(transportationList: list, transportationMap: <String, TransportationModel>{});
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
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
