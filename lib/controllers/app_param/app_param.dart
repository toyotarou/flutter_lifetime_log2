import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/geoloc_model.dart';
import '../../models/lifetime_item_model.dart';
import '../../models/money_model.dart';
import '../../models/temple_model.dart';
import '../../models/transportation_model.dart';
import '../../models/walk_model.dart';
import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default(<String>[]) List<String> keepHolidayList,
    @Default(<String, WalkModel>{}) Map<String, WalkModel> keepWalkModelMap,
    @Default(<String, MoneyModel>{}) Map<String, MoneyModel> keepMoneyMap,
    @Default(<LifetimeItemModel>[]) List<LifetimeItemModel> keepLifetimeItemList,
    @Default(<String, List<GeolocModel>>{}) Map<String, List<GeolocModel>> keepGeolocMap,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> keepTempleMap,
    @Default(<String, TransportationModel>{}) Map<String, TransportationModel> keepTransportationMap,

    ///
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,
  }) = _AppParamState;
}

@riverpod
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setKeepHolidayList({required List<String> list}) => state = state.copyWith(keepHolidayList: list);

  ///
  void setKeepWalkModelMap({required Map<String, WalkModel> map}) => state = state.copyWith(keepWalkModelMap: map);

  ///
  void setKeepMoneyMap({required Map<String, MoneyModel> map}) => state = state.copyWith(keepMoneyMap: map);

  ///
  void setKeepLifetimeItemList({required List<LifetimeItemModel> list}) =>
      state = state.copyWith(keepLifetimeItemList: list);

  ///
  void setKeepGeolocMap({required Map<String, List<GeolocModel>> map}) => state = state.copyWith(keepGeolocMap: map);

  ///
  void setKeepTempleMap({required Map<String, TempleModel> map}) => state = state.copyWith(keepTempleMap: map);

  ///
  void setKeepGeoSpotModelMap({required Map<String, TransportationModel> map}) =>
      state = state.copyWith(keepTransportationMap: map);

  //===================================================

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  //===================================================
}
