import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/amazon_purchase_model.dart';
import '../../models/common/scroll_line_chart_model.dart';
import '../../models/common/work_history_model.dart';
import '../../models/credit_summary_model.dart';
import '../../models/fortune_model.dart';
import '../../models/fund_model.dart';
import '../../models/geoloc_model.dart';
import '../../models/gold_model.dart';
import '../../models/lifetime_model.dart';
import '../../models/money_model.dart';
import '../../models/money_spend_model.dart';
import '../../models/municipal_model.dart';
import '../../models/salary_model.dart';
import '../../models/stamp_rally_model.dart';
import '../../models/stock_model.dart';
import '../../models/tarot_history_model.dart';
import '../../models/tarot_model.dart';
import '../../models/temple_model.dart';
import '../../models/time_place_model.dart';
import '../../models/toushi_shintaku_history_model.dart';
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
    @Default(<String, LifetimeModel>{}) Map<String, LifetimeModel> keepLifetimeMap,
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
    @Default(<String, List<TimePlaceModel>>{}) Map<String, List<TimePlaceModel>> keepTimePlaceMap,
    @Default(<String, List<AmazonPurchaseModel>>{}) Map<String, List<AmazonPurchaseModel>> keepAmazonPurchaseMap,
    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> keepStampRallyMetroAllStationMap,
    @Default(<MunicipalModel>[]) List<MunicipalModel> keepTokyoMunicipalList,
    @Default(<String, MunicipalModel>{}) Map<String, MunicipalModel> keepTokyoMunicipalMap,
    @Default(<String, WorkHistoryModel>{}) Map<String, WorkHistoryModel> keepWorkHistoryModelMap,
    @Default(<String, String>{}) Map<String, String> keepTrainMap,
    @Default(<String, FortuneModel>{}) Map<String, FortuneModel> keepFortuneMap,

    @Default(<String, List<ToushiShintakuHistoryModel>>{})
    Map<String, List<ToushiShintakuHistoryModel>> keepToushiShintakuHistoryMap,

    @Default(<String, List<ToushiShintakuHistoryModel>>{})
    Map<String, List<ToushiShintakuHistoryModel>> keepToushiShintakuHistoryCostDateMap,

    ///
    @Default(<StationModel>[]) List<StationModel> keepStationList,

    @Default(<String, List<String>>{}) Map<String, List<String>> keepTempleDateTimeBadgeMap,

    @Default(<String, String>{}) Map<String, String> keepTempleDateTimeNameMap,

    @Default(<String, List<Map<String, dynamic>>>{})
    Map<String, List<Map<String, dynamic>>> keepAllDateLifetimeSummaryMap,

    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> keepStampRallyMetro20AnniversaryMap,

    @Default(<String, List<StampRallyModel>>{}) Map<String, List<StampRallyModel>> keepStampRallyMetroPokepokeMap,

    @Default(<int, Map<String, int>>{}) Map<int, Map<String, int>> keepCreditSummaryTotalMap,

    @Default(<List<List<List<double>>>>[]) List<List<List<List<double>>>> keepAllPolygonsList,

    @Default(<ScrollLineChartModel>[]) List<ScrollLineChartModel> keepMoneySumList,

    @Default(<Map<String, String>>[]) List<Map<String, String>> keepNenkinKikinDataList,
    @Default(<Map<String, String>>[]) List<Map<String, String>> keepInsuranceDataList,

    @Default(<String, GeolocModel>{}) Map<String, GeolocModel> keepNearestTempleNameGeolocModelMap,

    @Default(<String, TarotModel>{}) Map<String, TarotModel> keepTarotMap,

    @Default(<String, TarotHistoryModel>{}) Map<String, TarotHistoryModel> keepTarotHistoryMap,

    @Default(<String, List<MoneySpendModel>>{}) Map<String, List<MoneySpendModel>> keepOhakamairiDataMap,

    ///
    @Default('') String homeTabYearMonth,

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

    @Default('') String yearlyAllSpendSelectedYear,

    @Default('') String yearlyAllSpendSelectedPrice,

    @Default('') String selectedToushiGraphYear,

    @Default('') String selectedGeolocTime,

    @Default(110.0) double weeklyHistoryHeaderHeight,

    @Default('') String weeklyHistorySelectedDate,

    @Default(0) int selectedCrossCalendarYear,

    @Default(56) double gutterWidth,

    @Default(true) bool isDisplayMunicipalNameOnLifetimeGeolocMap,

    WorkHistoryModel? selectedWorkHistoryModel,

    int? bottomNavigationSelectedIndex,

    int? selectedStampRallyMapPolylineIndex,

    @Default('') String selectedGeolocPointTime,

    @Default(<GeolocModel>[]) List<GeolocModel> routePolylinePartsGeolocList,

    @Default(false) bool isDisplayGhostGeolocPolyline,

    @Default('') String selectedGhostPolylineDate,

    @Default(<int>[]) List<int> selectedMoneySpendPickupListIndexList,
    @Default(0) int selectedMoneySpendPickupListSum,
    @Default(<String>[]) List<String> selectedMoneySpendPickupItemTextList,

    @Default('') String selectedSameDay,

    @Default(false) bool isShowAssetsDetailGraph,

    @Default(true) bool isShowBarChartMidashi,
  }) = _AppParamState;
}

@riverpod
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() {
    return AppParamState(
      selectedCrossCalendarYear: DateTime.now().year,
      homeTabYearMonth: '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}',
    );
  }

  ///
  /// HomeScreen から渡される元データを一括反映する。
  /// 1項目ずつ setKeepXxx すると、その回数だけ appParamState を watch している全ウィジェットが再構築されるため、
  /// 変化のあった項目だけをまとめて 1 回の state 更新で反映する（変化がなければ何もしない）。
  void syncKeepSourceData({
    required List<String> holidayList,
    required Map<String, WalkModel> walkModelMap,
    required Map<String, MoneyModel> moneyMap,
    required Map<String, LifetimeModel> lifetimeMap,
    required List<LifetimeItemModel> lifetimeItemList,
    required Map<String, List<GeolocModel>> geolocMap,
    required Map<String, TempleModel> templeMap,
    required Map<String, TransportationModel> transportationMap,
    required Map<String, List<MoneySpendModel>> moneySpendMap,
    required Map<String, WorkTimeModel> workTimeMap,
    required Map<String, Map<String, String>> workTimeDateMap,
    required Map<String, WeatherModel> weatherMap,
    required Map<String, MoneySpendItemModel> moneySpendItemMap,
    required Map<String, List<SalaryModel>> salaryMap,
    required Map<String, GoldModel> goldMap,
    required Map<String, List<StockModel>> stockMap,
    required Map<String, List<ToushiShintakuModel>> toushiShintakuMap,
    required List<StationModel> stationList,
    required Map<String, List<CreditSummaryModel>> creditSummaryMap,
    required Map<int, List<FundModel>> fundRelationMap,
    required Map<String, List<StockModel>> stockTickerMap,
    required Map<int, List<ToushiShintakuModel>> toushiShintakuRelationalMap,
    required Map<String, List<TimePlaceModel>> timePlaceMap,
    required Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap,
    required Map<String, List<StampRallyModel>> stampRallyMetroAllStationMap,
    required List<MunicipalModel> tokyoMunicipalList,
    required Map<String, MunicipalModel> tokyoMunicipalMap,
    required List<ScrollLineChartModel> moneySumList,
    required Map<String, String> trainMap,
    required Map<String, FortuneModel> fortuneMap,
    required Map<String, TarotModel> tarotMap,
    required Map<String, TarotHistoryModel> tarotHistoryMap,
    required Map<String, List<ToushiShintakuHistoryModel>> toushiShintakuHistoryMap,
    required Map<String, List<ToushiShintakuHistoryModel>> toushiShintakuHistoryCostDateMap,
  }) {
    final AppParamState s = state;

    // freezed の Map / List の getter は呼ぶたびに EqualUnmodifiableXxxView で包み直すため identical() は使えない。
    // その View の == は「中身のインスタンスが同一か」で比較する（要素の深い比較はしない）ので軽量。

    // geoloc は月単位で mergeKeepGeolocMap により先行反映されているため、
    // 元データ側（geolocState）の方が件数が少ない場合は上書きしない（取得済みデータを消さない）
    final bool geolocChanged =
        s.keepGeolocMap != geolocMap && geolocMap.length >= s.keepGeolocMap.length;

    final bool changed =
        s.keepHolidayList != holidayList ||
        s.keepWalkModelMap != walkModelMap ||
        s.keepMoneyMap != moneyMap ||
        s.keepLifetimeMap != lifetimeMap ||
        s.keepLifetimeItemList != lifetimeItemList ||
        geolocChanged ||
        s.keepTempleMap != templeMap ||
        s.keepTransportationMap != transportationMap ||
        s.keepMoneySpendMap != moneySpendMap ||
        s.keepWorkTimeMap != workTimeMap ||
        s.keepWorkTimeDateMap != workTimeDateMap ||
        s.keepWeatherMap != weatherMap ||
        s.keepMoneySpendItemMap != moneySpendItemMap ||
        s.keepSalaryMap != salaryMap ||
        s.keepGoldMap != goldMap ||
        s.keepStockMap != stockMap ||
        s.keepToushiShintakuMap != toushiShintakuMap ||
        s.keepStationList != stationList ||
        s.keepCreditSummaryMap != creditSummaryMap ||
        s.keepFundRelationMap != fundRelationMap ||
        s.keepStockTickerMap != stockTickerMap ||
        s.keepToushiShintakuRelationalMap != toushiShintakuRelationalMap ||
        s.keepTimePlaceMap != timePlaceMap ||
        s.keepAmazonPurchaseMap != amazonPurchaseMap ||
        s.keepStampRallyMetroAllStationMap != stampRallyMetroAllStationMap ||
        s.keepTokyoMunicipalList != tokyoMunicipalList ||
        s.keepTokyoMunicipalMap != tokyoMunicipalMap ||
        s.keepMoneySumList != moneySumList ||
        s.keepTrainMap != trainMap ||
        s.keepFortuneMap != fortuneMap ||
        s.keepTarotMap != tarotMap ||
        s.keepTarotHistoryMap != tarotHistoryMap ||
        s.keepToushiShintakuHistoryMap != toushiShintakuHistoryMap ||
        s.keepToushiShintakuHistoryCostDateMap != toushiShintakuHistoryCostDateMap;

    if (!changed) {
      return;
    }

    state = s.copyWith(
      keepHolidayList: holidayList,
      keepWalkModelMap: walkModelMap,
      keepMoneyMap: moneyMap,
      keepLifetimeMap: lifetimeMap,
      keepLifetimeItemList: lifetimeItemList,
      keepGeolocMap: geolocChanged ? geolocMap : s.keepGeolocMap,
      keepTempleMap: templeMap,
      keepTransportationMap: transportationMap,
      keepMoneySpendMap: moneySpendMap,
      keepWorkTimeMap: workTimeMap,
      keepWorkTimeDateMap: workTimeDateMap,
      keepWeatherMap: weatherMap,
      keepMoneySpendItemMap: moneySpendItemMap,
      keepSalaryMap: salaryMap,
      keepGoldMap: goldMap,
      keepStockMap: stockMap,
      keepToushiShintakuMap: toushiShintakuMap,
      keepStationList: stationList,
      keepCreditSummaryMap: creditSummaryMap,
      keepFundRelationMap: fundRelationMap,
      keepStockTickerMap: stockTickerMap,
      keepToushiShintakuRelationalMap: toushiShintakuRelationalMap,
      keepTimePlaceMap: timePlaceMap,
      keepAmazonPurchaseMap: amazonPurchaseMap,
      keepStampRallyMetroAllStationMap: stampRallyMetroAllStationMap,
      keepTokyoMunicipalList: tokyoMunicipalList,
      keepTokyoMunicipalMap: tokyoMunicipalMap,
      keepMoneySumList: moneySumList,
      keepTrainMap: trainMap,
      keepFortuneMap: fortuneMap,
      keepTarotMap: tarotMap,
      keepTarotHistoryMap: tarotHistoryMap,
      keepToushiShintakuHistoryMap: toushiShintakuHistoryMap,
      keepToushiShintakuHistoryCostDateMap: toushiShintakuHistoryCostDateMap,
    );
  }

  ///
  /// HomeScreen で元データから算出した派生データを一括反映する。
  /// null の項目は「再計算していない（変化なし）」として現在値を維持する。
  void syncKeepDerivedData({
    Map<String, List<String>>? templeDateTimeBadgeMap,
    Map<String, String>? templeDateTimeNameMap,
    Map<String, List<Map<String, dynamic>>>? allDateLifetimeSummaryMap,
    Map<String, List<StampRallyModel>>? stampRallyMetro20AnniversaryMap,
    Map<String, List<StampRallyModel>>? stampRallyMetroPokepokeMap,
    Map<int, Map<String, int>>? creditSummaryTotalMap,
    List<List<List<List<double>>>>? allPolygonsList,
    Map<String, List<MoneySpendModel>>? ohakamairiDataMap,
    List<Map<String, String>>? nenkinKikinDataList,
    List<Map<String, String>>? insuranceDataList,
  }) {
    if (templeDateTimeBadgeMap == null &&
        templeDateTimeNameMap == null &&
        allDateLifetimeSummaryMap == null &&
        stampRallyMetro20AnniversaryMap == null &&
        stampRallyMetroPokepokeMap == null &&
        creditSummaryTotalMap == null &&
        allPolygonsList == null &&
        ohakamairiDataMap == null &&
        nenkinKikinDataList == null &&
        insuranceDataList == null) {
      return;
    }

    final AppParamState s = state;

    state = s.copyWith(
      keepTempleDateTimeBadgeMap: templeDateTimeBadgeMap ?? s.keepTempleDateTimeBadgeMap,
      keepTempleDateTimeNameMap: templeDateTimeNameMap ?? s.keepTempleDateTimeNameMap,
      keepAllDateLifetimeSummaryMap: allDateLifetimeSummaryMap ?? s.keepAllDateLifetimeSummaryMap,
      keepStampRallyMetro20AnniversaryMap: stampRallyMetro20AnniversaryMap ?? s.keepStampRallyMetro20AnniversaryMap,
      keepStampRallyMetroPokepokeMap: stampRallyMetroPokepokeMap ?? s.keepStampRallyMetroPokepokeMap,
      keepCreditSummaryTotalMap: creditSummaryTotalMap ?? s.keepCreditSummaryTotalMap,
      keepAllPolygonsList: allPolygonsList ?? s.keepAllPolygonsList,
      keepOhakamairiDataMap: ohakamairiDataMap ?? s.keepOhakamairiDataMap,
      keepNenkinKikinDataList: nenkinKikinDataList ?? s.keepNenkinKikinDataList,
      keepInsuranceDataList: insuranceDataList ?? s.keepInsuranceDataList,
    );
  }

  ///
  void setKeepHolidayList({required List<String> list}) => state = state.copyWith(keepHolidayList: list);

  ///
  void setKeepWalkModelMap({required Map<String, WalkModel> map}) => state = state.copyWith(keepWalkModelMap: map);

  ///
  void setKeepMoneyMap({required Map<String, MoneyModel> map}) => state = state.copyWith(keepMoneyMap: map);

  ///
  void setKeepLifetimeMap({required Map<String, LifetimeModel> map}) => state = state.copyWith(keepLifetimeMap: map);

  ///
  void setKeepLifetimeItemList({required List<LifetimeItemModel> list}) =>
      state = state.copyWith(keepLifetimeItemList: list);

  ///
  void setKeepGeolocMap({required Map<String, List<GeolocModel>> map}) => state = state.copyWith(keepGeolocMap: map);

  /// 月単位取得分を既存データに直接マージ（既存の月データを消さない）
  void mergeKeepGeolocMap({required Map<String, List<GeolocModel>> map}) {
    state = state.copyWith(keepGeolocMap: Map<String, List<GeolocModel>>.from(state.keepGeolocMap)..addAll(map));
  }

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
  void setKeepTokyoMunicipalList({required List<MunicipalModel> list}) =>
      state = state.copyWith(keepTokyoMunicipalList: list);

  ///
  void setKeepTokyoMunicipalMap({required Map<String, MunicipalModel> map}) =>
      state = state.copyWith(keepTokyoMunicipalMap: map);

  ///
  void setKeepWorkHistoryModelMap({required Map<String, WorkHistoryModel> map}) =>
      state = state.copyWith(keepWorkHistoryModelMap: map);

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

  ///
  void setKeepTimePlaceMap({required Map<String, List<TimePlaceModel>> map}) =>
      state = state.copyWith(keepTimePlaceMap: map);

  ///
  void setKeepAmazonPurchaseMap({required Map<String, List<AmazonPurchaseModel>> map}) =>
      state = state.copyWith(keepAmazonPurchaseMap: map);

  ///
  void setKeepTempleDateTimeBadgeMap({required Map<String, List<String>> map}) =>
      state = state.copyWith(keepTempleDateTimeBadgeMap: map);

  ///
  void setKeepTempleDateTimeNameMap({required Map<String, String> map}) =>
      state = state.copyWith(keepTempleDateTimeNameMap: map);

  ///
  void setKeepAllDateLifetimeSummaryMap({required Map<String, List<Map<String, dynamic>>> map}) =>
      state = state.copyWith(keepAllDateLifetimeSummaryMap: map);

  ///
  void setKeepStampRallyMetroAllStationMap({required Map<String, List<StampRallyModel>> map}) =>
      state = state.copyWith(keepStampRallyMetroAllStationMap: map);

  ///
  void setKeepStampRallyMetro20AnniversaryMap({required Map<String, List<StampRallyModel>> map}) =>
      state = state.copyWith(keepStampRallyMetro20AnniversaryMap: map);

  ///
  void setKeepStampRallyMetroPokepokeMap({required Map<String, List<StampRallyModel>> map}) =>
      state = state.copyWith(keepStampRallyMetroPokepokeMap: map);

  ///
  void setKeepCreditSummaryTotalMap({required Map<int, Map<String, int>> map}) =>
      state = state.copyWith(keepCreditSummaryTotalMap: map);

  ///
  void setKeepAllPolygonsList({required List<List<List<List<double>>>> list}) =>
      state = state.copyWith(keepAllPolygonsList: list);

  ///
  void setKeepMoneySumList({required List<ScrollLineChartModel> list}) =>
      state = state.copyWith(keepMoneySumList: list);

  ///
  void setKeepNenkinKikinDataList({required List<Map<String, String>> list}) =>
      state = state.copyWith(keepNenkinKikinDataList: list);

  ///
  void setKeepInsuranceDataList({required List<Map<String, String>> list}) =>
      state = state.copyWith(keepInsuranceDataList: list);

  ///
  void setKeepNearestTempleNameGeolocModelMap({required Map<String, GeolocModel> map}) =>
      state = state.copyWith(keepNearestTempleNameGeolocModelMap: map);

  ///
  void setKeepTrainMap({required Map<String, String> map}) => state = state.copyWith(keepTrainMap: map);

  ///
  void setKeepFortuneMap({required Map<String, FortuneModel> map}) => state = state.copyWith(keepFortuneMap: map);

  ///
  void setKeepTarotMap({required Map<String, TarotModel> map}) => state = state.copyWith(keepTarotMap: map);

  ///
  void setKeepTarotHistoryMap({required Map<String, TarotHistoryModel> map}) =>
      state = state.copyWith(keepTarotHistoryMap: map);

  ///
  void setKeepOhakamairiDataMap({required Map<String, List<MoneySpendModel>> map}) =>
      state = state.copyWith(keepOhakamairiDataMap: map);

  ///
  void setKeepToushiShintakuHistoryMap({required Map<String, List<ToushiShintakuHistoryModel>> map}) =>
      state = state.copyWith(keepToushiShintakuHistoryMap: map);

  ///
  void setKeepToushiShintakuHistoryCostDateMap({required Map<String, List<ToushiShintakuHistoryModel>> map}) =>
      state = state.copyWith(keepToushiShintakuHistoryCostDateMap: map);

  //===================================================

  void setHomeTabYearMonth({required String yearmonth}) {
    if (state.homeTabYearMonth == yearmonth) {
      return;
    }
    state = state.copyWith(homeTabYearMonth: yearmonth);
  }

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

  ///
  void setYearlyAllSpendSelectedYear({required String year}) =>
      state = state.copyWith(yearlyAllSpendSelectedYear: year);

  ///
  void setYearlyAllSpendSelectedPrice({required String price}) =>
      state = state.copyWith(yearlyAllSpendSelectedPrice: price);

  ///
  void setSelectedToushiGraphYear({required String year}) => state = state.copyWith(selectedToushiGraphYear: year);

  ///
  void setSelectedGeolocTime({required String time}) => state = state.copyWith(selectedGeolocTime: time);

  ///
  void setWeeklyHistorySelectedDate({required String date}) => state = state.copyWith(weeklyHistorySelectedDate: date);

  ///
  void setSelectedCrossCalendarYear({required int year}) => state = state.copyWith(selectedCrossCalendarYear: year);

  ///
  void setIsDisplayMunicipalNameOnLifetimeGeolocMap({required bool flag}) =>
      state = state.copyWith(isDisplayMunicipalNameOnLifetimeGeolocMap: flag);

  ///
  void setSelectedWorkHistoryModel({WorkHistoryModel? model}) =>
      state = state.copyWith(selectedWorkHistoryModel: model);

  ///
  void setSelectedBottomNavigationIndex({int? index, required int maxCount}) {
    if (index != null && (index < 0 || index >= maxCount)) {
      return;
    }
    state = state.copyWith(bottomNavigationSelectedIndex: index);
  }

  ///
  void setSelectedStampRallyMapPolylineIndex({int? index}) =>
      state = state.copyWith(selectedStampRallyMapPolylineIndex: index);

  ///
  void setSelectedGeolocPointTime({required String time}) => state = state.copyWith(selectedGeolocPointTime: time);

  ///
  void clearRoutePolylinePartsGeolocList() => state = state.copyWith(routePolylinePartsGeolocList: <GeolocModel>[]);

  ///
  void setRoutePolylinePartsGeolocList({required GeolocModel geolocModel}) {
    final List<GeolocModel> list = <GeolocModel>[...state.routePolylinePartsGeolocList];
    list.add(geolocModel);
    state = state.copyWith(routePolylinePartsGeolocList: list);
  }

  ///
  void setIsDisplayGhostGeolocPolyline({required bool flag}) =>
      state = state.copyWith(isDisplayGhostGeolocPolyline: flag);

  ///
  void setSelectedGhostPolylineDate({required String date}) =>
      state = state.copyWith(selectedGhostPolylineDate: (state.selectedGhostPolylineDate == date) ? '' : date);

  ///
  void setSelectedMoneySpendPickupListIndexList({required int index, required int price}) {
    final List<int> list = <int>[...state.selectedMoneySpendPickupListIndexList];
    int sum = state.selectedMoneySpendPickupListSum;

    if (list.contains(index)) {
      list.remove(index);
      sum -= price;
    } else {
      list.add(index);
      sum += price;
    }

    state = state.copyWith(selectedMoneySpendPickupListIndexList: list, selectedMoneySpendPickupListSum: sum);
  }

  ///
  void clearSelectedMoneySpendPickupListIndexList() {
    state = state.copyWith(selectedMoneySpendPickupListIndexList: <int>[], selectedMoneySpendPickupListSum: 0);
  }

  ///
  void setSelectedMoneySpendPickupItemTextList({required String item}) {
    final List<String> list = <String>[...state.selectedMoneySpendPickupItemTextList];

    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }

    state = state.copyWith(selectedMoneySpendPickupItemTextList: list);
  }

  ///
  void clearSelectedMoneySpendPickupItemTextList() =>
      state = state.copyWith(selectedMoneySpendPickupItemTextList: <String>[]);

  ///
  void setSelectedSameDay({required String day}) => state = state.copyWith(selectedSameDay: day);

  ///
  void setIsShowAssetsDetailGraph({required bool flag}) => state = state.copyWith(isShowAssetsDetailGraph: flag);

  ///
  void setIsShowBarChartMidashi({required bool flag}) => state = state.copyWith(isShowBarChartMidashi: flag);
}
