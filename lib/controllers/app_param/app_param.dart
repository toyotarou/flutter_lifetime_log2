import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/credit_summary_model.dart';
import '../../models/fund_model.dart';
import '../../models/geoloc_model.dart';
import '../../models/gold_model.dart';
import '../../models/invest_model.dart';
import '../../models/lifetime_model.dart';
import '../../models/money_model.dart';
import '../../models/money_spend_model.dart';
import '../../models/salary_model.dart';
import '../../models/stock_model.dart';
import '../../models/temple_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../models/transportation_model.dart';
import '../../models/walk_model.dart';
import '../../models/weather_model.dart';
import '../../models/work_time_model.dart';
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
    @Default(<String, List<MoneySpendModel>>{}) Map<String, List<MoneySpendModel>> keepMoneySpendMap,
    @Default(<String, WorkTimeModel>{}) Map<String, WorkTimeModel> keepWorkTimeMap,
    @Default(<String, Map<String, String>>{}) Map<String, Map<String, String>> keepWorkTimeDateMap,
    @Default(<String, WeatherModel>{}) Map<String, WeatherModel> keepWeatherMap,
    @Default(<String, MoneySpendItemModel>{}) Map<String, MoneySpendItemModel> keepMoneySpendItemMap,
    @Default(<String, List<SalaryModel>>{}) Map<String, List<SalaryModel>> keepSalaryMap,
    @Default(<String, GoldModel>{}) Map<String, GoldModel> keepGoldMap,
    @Default(<String, List<StockModel>>{}) Map<String, List<StockModel>> keepStockMap,
    @Default(<String, List<ToushiShintakuModel>>{}) Map<String, List<ToushiShintakuModel>> keepToushiShintakuMap,
    @Default(<String, List<CreditSummaryModel>>{}) Map<String, List<CreditSummaryModel>> keepCreditSummaryMap,
    @Default(<int, List<FundModel>>{}) Map<int, List<FundModel>> keepFundRelationMap,
    @Default(<String, List<StockModel>>{}) Map<String, List<StockModel>> keepStockTickerMap,
    @Default(<int, List<ToushiShintakuModel>>{}) Map<int, List<ToushiShintakuModel>> keepToushiShintakuRelationalMap,

    ///
    @Default(<StationModel>[]) List<StationModel> keepStationList,

    ///
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,

    Offset? overlayPosition,

    ///
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,

    ///
    @Default('') String selectedYearMonth,
    @Default(<String>[]) List<String> monthlyGeolocMapSelectedDateList,

    @Default(0) int selectedGraphYear,

    ///
    TempleDataModel? selectedTemple,

    ///
    @Default('') String selectedTempleDirection,

    ///
    @Default(false) bool isMonthlySpendSummaryMinusJogai,
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

  ///
  void setKeepMoneySpendMap({required Map<String, List<MoneySpendModel>> map}) =>
      state = state.copyWith(keepMoneySpendMap: map);

  ///
  void setKeepWorkTimeMap({required Map<String, WorkTimeModel> map}) => state = state.copyWith(keepWorkTimeMap: map);

  ///
  void setKeepWorkTimeDateMap({required Map<String, Map<String, String>> map}) =>
      state = state.copyWith(keepWorkTimeDateMap: map);

  ///
  void setKeepWeatherMap({required Map<String, WeatherModel> map}) => state = state.copyWith(keepWeatherMap: map);

  ///
  void setKeepMoneySpendItemMap({required Map<String, MoneySpendItemModel> map}) =>
      state = state.copyWith(keepMoneySpendItemMap: map);

  ///
  void setKeepSalaryMap({required Map<String, List<SalaryModel>> map}) => state = state.copyWith(keepSalaryMap: map);

  ///
  void setKeepGoldMap({required Map<String, GoldModel> map}) => state = state.copyWith(keepGoldMap: map);

  ///
  void setKeepStockMap({required Map<String, List<StockModel>> map}) => state = state.copyWith(keepStockMap: map);

  ///
  void setKeepToushiShintakuMap({required Map<String, List<ToushiShintakuModel>> map}) =>
      state = state.copyWith(keepToushiShintakuMap: map);

  ///
  void setKeepStationList({required List<StationModel> list}) => state = state.copyWith(keepStationList: list);

  ///
  void setKeepCreditSummaryMap({required Map<String, List<CreditSummaryModel>> map}) =>
      state = state.copyWith(keepCreditSummaryMap: map);

  ///
  void setKeepFundRelationMap({required Map<int, List<FundModel>> map}) =>
      state = state.copyWith(keepFundRelationMap: map);

  ///
  void setKeepStockTickerMap({required Map<String, List<StockModel>> map}) =>
      state = state.copyWith(keepStockTickerMap: map);

  ///
  void setKeepToushiShintakuRelationalMap({required Map<int, List<ToushiShintakuModel>> map}) =>
      state = state.copyWith(keepToushiShintakuRelationalMap: map);

  //===================================================

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  //===================================================

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  //===================================================

  ///
  void setSelectedYearMonth({required String yearmonth}) => state = state.copyWith(selectedYearMonth: yearmonth);

  ///
  void setMonthlyGeolocMapSelectedDateList({required String date}) {
    final List<String> list = <String>[...state.monthlyGeolocMapSelectedDateList];

    if (list.contains(date)) {
      list.remove(date);
    } else {
      list.add(date);
    }

    state = state.copyWith(monthlyGeolocMapSelectedDateList: list);
  }

  ///
  void clearMonthlyGeolocMapSelectedDateList() => state = state.copyWith(monthlyGeolocMapSelectedDateList: <String>[]);

  ///
  void setSelectedGraphYear({required int year}) => state = state.copyWith(selectedGraphYear: year);

  ///
  void setSelectedTemple({required TempleDataModel temple}) => state = state.copyWith(selectedTemple: temple);

  ///
  void setSelectedTempleDirection({required String direction}) =>
      state = state.copyWith(selectedTempleDirection: direction);

  ///
  void setIsMonthlySpendSummaryMinusJogai({required bool flag}) =>
      state = state.copyWith(isMonthlySpendSummaryMinusJogai: flag);
}
