import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/controllers_mixin.dart';
import '../enums/stamp_rally_kind.dart';
import '../extensions/extensions.dart';
import '../main.dart';
import '../models/amazon_purchase_model.dart';
import '../models/credit_summary_model.dart';
import '../models/fund_model.dart';
import '../models/geoloc_model.dart';
import '../models/gold_model.dart';
import '../models/lifetime_model.dart';
import '../models/money_model.dart';
import '../models/money_spend_model.dart';
import '../models/municipal_model.dart';
import '../models/salary_model.dart';
import '../models/stamp_rally_model.dart';
import '../models/stock_model.dart';
import '../models/temple_model.dart';
import '../models/time_place_model.dart';
import '../models/toushi_shintaku_model.dart';
import '../models/transportation_model.dart';
import '../models/walk_model.dart';
import '../models/weather_model.dart';
import '../models/work_time_model.dart';
import '../models/work_truth_model.dart';
import '../utility/functions.dart';
import '../utility/utility.dart';
import 'components/amazon_purchase_list_alert.dart';
import 'components/bank_data_input_alert.dart';
import 'components/lifetime_item_search_alert.dart';
import 'components/lifetime_summary_alert.dart';
import 'components/money_count_list_alert.dart';
import 'components/money_in_possession_display_alert.dart';
import 'components/salary_list_alert.dart';
import 'components/spend_each_year_display_alert.dart';

// import 'components/stamp_rally_metro_20_anniversary_list_alert.dart';
// import 'components/stamp_rally_metro_all_station_list_alert.dart';
// import 'components/stamp_rally_metro_pokepoke_list_alert.dart';
//
//
//

import 'components/stamp_rally_list_alert.dart';
import 'page/monthly_lifetime_display_page.dart';
import 'parts/lifetime_dialog.dart';

class TabInfo {
  TabInfo(this.label, this.widget, {this.highlight = false});

  String label;
  Widget widget;
  bool highlight;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.walkMap,
    required this.moneyMap,
    required this.lifetimeMap,
    required this.lifetimeItemList,
    required this.holidayList,
    required this.geolocMap,
    required this.templeMap,
    required this.transportationMap,
    required this.moneySpendMap,
    required this.workTimeMap,
    required this.workTimeDateMap,
    required this.weatherMap,
    required this.moneySpendItemMap,
    required this.salaryMap,
    required this.goldMap,
    required this.stockMap,
    required this.toushiShintakuMap,
    required this.stationList,
    required this.trainMap,
    required this.creditSummaryMap,
    required this.fundRelationMap,
    required this.stockTickerMap,
    required this.toushiShintakuRelationalMap,
    required this.timePlaceMap,
    required this.amazonPurchaseMap,
    required this.tokyoMunicipalMap,
    required this.stampRallyMetroAllStationMap,
    required this.stampRallyMetro20AnniversaryMap,
    required this.stampRallyMetroPokepokeMap,
    required this.tokyoMunicipalList,
    required this.workTruthModelMap,
  });

  final List<String> holidayList;
  final Map<String, WalkModel> walkMap;
  final Map<String, MoneyModel> moneyMap;
  final Map<String, LifetimeModel> lifetimeMap;
  final List<LifetimeItemModel> lifetimeItemList;
  final Map<String, List<GeolocModel>> geolocMap;
  final Map<String, TempleModel> templeMap;
  final Map<String, TransportationModel> transportationMap;
  final Map<String, List<MoneySpendModel>> moneySpendMap;
  final Map<String, WorkTimeModel> workTimeMap;
  final Map<String, Map<String, String>> workTimeDateMap;
  final Map<String, WeatherModel> weatherMap;
  final Map<String, MoneySpendItemModel> moneySpendItemMap;
  final Map<String, List<SalaryModel>> salaryMap;
  final Map<String, GoldModel> goldMap;
  final Map<String, List<StockModel>> stockMap;
  final Map<String, List<ToushiShintakuModel>> toushiShintakuMap;
  final List<StationModel> stationList;
  final Map<String, String> trainMap;
  final Map<String, List<CreditSummaryModel>> creditSummaryMap;
  final Map<int, List<FundModel>> fundRelationMap;
  final Map<String, List<StockModel>> stockTickerMap;
  final Map<int, List<ToushiShintakuModel>> toushiShintakuRelationalMap;
  final Map<String, List<TimePlaceModel>> timePlaceMap;
  final Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap;
  final Map<String, List<StampRallyModel>> stampRallyMetroAllStationMap;
  final Map<String, List<StampRallyModel>> stampRallyMetro20AnniversaryMap;
  final Map<String, List<StampRallyModel>> stampRallyMetroPokepokeMap;
  final List<MunicipalModel> tokyoMunicipalList;
  final Map<String, MunicipalModel> tokyoMunicipalMap;
  final Map<String, WorkTruthModel> workTruthModelMap;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final List<TabInfo> _tabs = <TabInfo>[];
  final Utility utility = Utility();

  TabController? _tabController;

  ///
  void _onTabChanged() {
    final TabController? c = _tabController;

    if (c != null && !c.indexIsChanging) {
      final int index = c.index;

      final String ym = _tabs.isInRange(index) ? _tabs[index].label : '';

      if (ym.isNotEmpty) {
        appParamNotifier.setHomeTabYearMonth(yearmonth: ym);
      }
    }
  }

  ///
  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      appParamNotifier.setKeepHolidayList(list: widget.holidayList);
      appParamNotifier.setKeepWalkModelMap(map: widget.walkMap);
      appParamNotifier.setKeepMoneyMap(map: widget.moneyMap);
      appParamNotifier.setKeepLifetimeMap(map: widget.lifetimeMap);
      appParamNotifier.setKeepLifetimeItemList(list: widget.lifetimeItemList);
      appParamNotifier.setKeepGeolocMap(map: widget.geolocMap);
      appParamNotifier.setKeepTempleMap(map: widget.templeMap);
      appParamNotifier.setKeepGeoSpotModelMap(map: widget.transportationMap);
      appParamNotifier.setKeepMoneySpendMap(map: widget.moneySpendMap);
      appParamNotifier.setKeepWorkTimeMap(map: widget.workTimeMap);
      appParamNotifier.setKeepWorkTimeDateMap(map: widget.workTimeDateMap);
      appParamNotifier.setKeepWeatherMap(map: widget.weatherMap);
      appParamNotifier.setKeepMoneySpendItemMap(map: widget.moneySpendItemMap);
      appParamNotifier.setKeepSalaryMap(map: widget.salaryMap);
      appParamNotifier.setKeepGoldMap(map: widget.goldMap);
      appParamNotifier.setKeepStockMap(map: widget.stockMap);
      appParamNotifier.setKeepToushiShintakuMap(map: widget.toushiShintakuMap);
      appParamNotifier.setKeepStationList(list: widget.stationList);
      appParamNotifier.setKeepCreditSummaryMap(map: widget.creditSummaryMap);
      appParamNotifier.setKeepFundRelationMap(map: widget.fundRelationMap);
      appParamNotifier.setKeepStockTickerMap(map: widget.stockTickerMap);
      appParamNotifier.setKeepToushiShintakuRelationalMap(map: widget.toushiShintakuRelationalMap);
      appParamNotifier.setKeepTimePlaceMap(map: widget.timePlaceMap);
      appParamNotifier.setKeepAmazonPurchaseMap(map: widget.amazonPurchaseMap);
      appParamNotifier.setKeepStampRallyMetroAllStationMap(map: widget.stampRallyMetroAllStationMap);
      appParamNotifier.setKeepTokyoMunicipalList(list: widget.tokyoMunicipalList);
      appParamNotifier.setKeepTokyoMunicipalMap(map: widget.tokyoMunicipalMap);
      appParamNotifier.setKeepWorkTruthModelMap(map: widget.workTruthModelMap);

      //===========================================//

      ///////////////////////

      final Map<String, List<String>> templeDateTimeBadgeMap = <String, List<String>>{};

      final Map<String, String> templeDateTimeNameMap = <String, String>{};

      widget.templeMap.forEach((String key, TempleModel value) {
        for (final TempleDataModel element in value.templeDataList) {
          element.templePhotoModelList?.forEach((TemplePhotoModel element2) {
            element2.templephotos.sort();

            final String fileName = element2.templephotos.first;
            final List<String> exFileName = fileName.split('/');
            final List<String> exFileNameLast = exFileName.last.split('_');

            if (exFileNameLast.first == key.replaceAll('-', '')) {
              final List<String> exFileNameLastLast = exFileNameLast.last.split('.');

              if (exFileNameLastLast.first.length >= 4) {
                final String fileHourMinute = exFileNameLastLast.first.substring(0, 4);
                final String hour = fileHourMinute.substring(0, 2);
                final String minute = fileHourMinute.substring(2);

                (templeDateTimeBadgeMap[key] ??= <String>[]).add('$hour:$minute');

                templeDateTimeNameMap['$key|$hour:$minute'] = element2.temple;
              }
            }
          });
        }
      });

      ///////////////////////

      ///////////////////////

      final Map<String, List<Map<String, dynamic>>> allDateLifetimeSummaryMap = <String, List<Map<String, dynamic>>>{};

      widget.lifetimeMap.forEach((String key, LifetimeModel value) {
        final List<String> lifetimeData = getLifetimeData(lifetimeModel: value);

        final Map<int, String> duplicateConsecutiveMap = getDuplicateConsecutiveMap(lifetimeData);

        final List<Map<String, dynamic>> startEndTitleList = getStartEndTitleList(data: duplicateConsecutiveMap);

        allDateLifetimeSummaryMap[key] = startEndTitleList;
      });

      ///////////////////////

      ///////////////////////

      final Map<String, List<StampRallyModel>> stampRallyMetro20AnniversaryMap = makeStampRallyDisplayDataMap(
        stampRallyMetroAllStationMap: widget.stampRallyMetroAllStationMap,
        type: 'Metro20Anniversary',
        stampRallyMetro20AnniversaryMapSrc: widget.stampRallyMetro20AnniversaryMap,
        stampRallyMetroPokepokeMapSrc: <String, List<StampRallyModel>>{},
        geolocMap: widget.geolocMap,
        stationList: widget.stationList,
        trainMap: widget.trainMap,
        utility: utility,
      );

      ///////////////////////

      ///////////////////////

      final Map<String, List<StampRallyModel>> stampRallyMetroPokepokeMap = makeStampRallyDisplayDataMap(
        stampRallyMetroAllStationMap: widget.stampRallyMetroAllStationMap,
        type: 'MetroPokepoke',
        stampRallyMetro20AnniversaryMapSrc: <String, List<StampRallyModel>>{},
        stampRallyMetroPokepokeMapSrc: widget.stampRallyMetroPokepokeMap,
        geolocMap: widget.geolocMap,
        stationList: widget.stationList,
        trainMap: widget.trainMap,
        utility: utility,
      );

      ///////////////////////

      ///////////////////////

      final Map<int, Map<String, int>> creditSummaryTotalMap = <int, Map<String, int>>{};

      final Map<int, Map<String, List<int>>> creditSummaryListMap = <int, Map<String, List<int>>>{};

      final List<String> creditItemList = utility.getCreditItemList();

      widget.creditSummaryMap.forEach((String key, List<CreditSummaryModel> value) {
        if (appParamState.homeTabYearMonth.split('-')[0] == key.split('-')[0]) {
          final Map<String, List<int>> creditListMap = <String, List<int>>{};

          for (final String element2 in creditItemList) {
            for (final CreditSummaryModel element in value) {
              if (element2 == element.item) {
                (creditListMap[element2] ??= <int>[]).add(element.price);
              }
            }
          }

          creditSummaryListMap[key.split('-')[1].toInt()] = creditListMap;
        }
      });

      creditSummaryListMap.forEach((int key, Map<String, List<int>> value) {
        final Map<String, int> creditCategoryTotalMap = <String, int>{};
        value.forEach((String key2, List<int> value2) {
          int total = 0;
          for (final int element in value2) {
            total += element;
          }

          creditCategoryTotalMap[key2] = total;
        });

        creditSummaryTotalMap[key] = creditCategoryTotalMap;
      });

      ///////////////////////

      // ignore: always_specify_types
      Future(() {
        appParamNotifier.setKeepTempleDateTimeBadgeMap(map: templeDateTimeBadgeMap);
        appParamNotifier.setKeepTempleDateTimeNameMap(map: templeDateTimeNameMap);
        appParamNotifier.setKeepAllDateLifetimeSummaryMap(map: allDateLifetimeSummaryMap);
        appParamNotifier.setKeepStampRallyMetro20AnniversaryMap(map: stampRallyMetro20AnniversaryMap);
        appParamNotifier.setKeepStampRallyMetroPokepokeMap(map: stampRallyMetroPokepokeMap);
        appParamNotifier.setKeepCreditSummaryTotalMap(map: creditSummaryTotalMap);
      });
      //===========================================//
    });

    return DefaultTabController(
      length: _tabs.length,
      child: Builder(
        builder: (BuildContext tabScopeContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            final TabController newController = DefaultTabController.of(tabScopeContext);
            if (newController != _tabController) {
              _tabController?.removeListener(_onTabChanged);
              _tabController = newController;
              _tabController?.addListener(_onTabChanged);

              if (_tabController != null && _tabs.isInRange(_tabController!.index)) {
                appParamNotifier.setHomeTabYearMonth(yearmonth: _tabs[_tabController!.index].label);
              }
            }
          });

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text('LIFETIME LOG'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => context.findAncestorStateOfType<AppRootState>()?.restartApp(),
                  icon: const Icon(Icons.refresh),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.blueAccent,
                  tabs: _tabs.map((TabInfo tab) {
                    return Tab(
                      child: Text(
                        tab.label,
                        style: TextStyle(fontSize: 14, color: tab.highlight ? Colors.greenAccent : Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                utility.getBackGround(),
                Container(
                  width: context.screenSize.width,
                  height: context.screenSize.height,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                ),
                Column(
                  children: <Widget>[
                    Expanded(child: TabBarView(children: _tabs.map((TabInfo tab) => tab.widget).toList())),
                  ],
                ),
              ],
            ),
            endDrawer: _dispDrawer(),
          );
        },
      ),
    );
  }

  ///
  Widget _dispDrawer() {
    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),

              GestureDetector(
                onTap: () {
                  appParamNotifier.setSelectedCrossCalendarYear(year: DateTime.now().year);

                  final List<String> yList = <String>[];
                  widget.lifetimeMap.forEach((String key, LifetimeModel value) {
                    final List<String> exKey = key.split('-');
                    yList.add(exKey[0]);
                  });

                  final List<String> years = yList.toSet().toList();
                  years.sort();

                  LifetimeDialog(
                    context: context,
                    widget: LifetimeSummaryAlert(years: years),
                  );
                },
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.ac_unit),
                    SizedBox(width: 20),
                    Expanded(child: Text('lifetime summary')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  LifetimeDialog(context: context, widget: const LifetimeItemSearchAlert());
                },
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    SizedBox(width: 20),
                    Expanded(child: Text('lifetime item search')),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  final List<MapEntry<String, MoneyModel>> moneyEntries = appParamState.keepMoneyMap.entries.toList();

                  final int pos = moneyEntries.indexWhere(
                    (MapEntry<String, MoneyModel> entry) => entry.key == '${appParamState.homeTabYearMonth}-01',
                  );

                  LifetimeDialog(
                    context: context,
                    widget: MoneyCountListAlert(initialRowIndex: pos, moneyEntries: moneyEntries),
                  );
                },
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.coins),
                    SizedBox(width: 20),
                    Expanded(child: Text('money count list')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(context: context, widget: const MoneyInPossessionDisplayAlert()),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.money),
                    SizedBox(width: 20),
                    Expanded(child: Text('money in possession')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(context: context, widget: const BankDataInputAlert()),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.monetization_on_sharp),
                    SizedBox(width: 20),
                    Expanded(child: Text('bank money adjust')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(context: context, widget: const SalaryListAlert()),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.diamond),
                    SizedBox(width: 20),
                    Expanded(child: Text('salary list')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(context: context, widget: const SpendEachYearDisplayAlert()),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.ac_unit),
                    SizedBox(width: 20),
                    Expanded(child: Text('spend each year')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(context: context, widget: const AmazonPurchaseListAlert()),
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.amazon),
                    SizedBox(width: 20),
                    Expanded(child: Text('amazon purchase list')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(
                  context: context,
                  widget: const StampRallyListAlert(kind: StampRallyKind.metroAllStation),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stamp),
                    SizedBox(width: 20),
                    Expanded(child: Text('stamp rally metro all station')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(
                  context: context,
                  widget: const StampRallyListAlert(kind: StampRallyKind.metro20Anniversary),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stamp),
                    SizedBox(width: 20),
                    Expanded(child: Text('stamp rally metro 20 anniversary')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => LifetimeDialog(
                  context: context,
                  widget: const StampRallyListAlert(kind: StampRallyKind.metroPokepoke),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stamp),
                    SizedBox(width: 20),
                    Expanded(child: Text('stamp rally metro pokepoke')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _makeTab() {
    _tabs.clear();

    final List<String> yearmonthList = <String>[];

    lifetimeState.lifetimeList.toList()
      ..sort((LifetimeModel a, LifetimeModel b) => '${a.year}-${a.month}'.compareTo('${b.year}-${b.month}') * -1)
      ..forEach((LifetimeModel element) {
        if (!yearmonthList.contains('${element.year}-${element.month}')) {
          yearmonthList.add('${element.year}-${element.month}');
        }
      });

    if (!yearmonthList.contains(DateTime.now().yyyymm)) {
      yearmonthList.add(DateTime.now().yyyymm);
      yearmonthList.sort((String a, String b) => a.compareTo(b) * -1);
    }

    for (final String element in yearmonthList) {
      _tabs.add(TabInfo(element, MonthlyLifetimeDisplayPage(yearmonth: element)));
    }
  }
}

///
Map<String, List<StampRallyModel>> makeStampRallyDisplayDataMap({
  required Map<String, List<StampRallyModel>> stampRallyMetroAllStationMap,
  required String type,
  required Map<String, List<StampRallyModel>> stampRallyMetro20AnniversaryMapSrc,
  required Map<String, List<StampRallyModel>> stampRallyMetroPokepokeMapSrc,
  required Map<String, List<GeolocModel>> geolocMap,
  required List<StationModel> stationList,
  required Map<String, String> trainMap,
  required Utility utility,
}) {
  final Map<String, List<StampRallyModel>> result = <String, List<StampRallyModel>>{};

  // trainMarkMap を作成
  final Map<String, List<Map<String, String>>> trainMarkMap = <String, List<Map<String, String>>>{};
  stampRallyMetroAllStationMap.forEach((String date, List<StampRallyModel> models) {
    for (final StampRallyModel model in models) {
      final Map<String, String> entry = <String, String>{
        'imageFolder': model.imageFolder,
        'imageCode': model.imageCode,
        'stationCode': model.stationCode,
      };
      trainMarkMap.putIfAbsent(model.trainName, () => <Map<String, String>>[]);
      trainMarkMap[model.trainName]!.add(entry);
    }
  });

  late final Map<String, List<StampRallyModel>> targetSourceMap;

  switch (type) {
    case 'Metro20Anniversary':
      targetSourceMap = stampRallyMetro20AnniversaryMapSrc;

    case 'MetroPokepoke':
      targetSourceMap = stampRallyMetroPokepokeMapSrc;

    default:
      targetSourceMap = stampRallyMetro20AnniversaryMapSrc;
  }

  targetSourceMap.forEach((String key, List<StampRallyModel> value) {
    final List<GeolocModel>? oneDayGeolocModelList = geolocMap[key];
    List<GeolocModel> cleaned = <GeolocModel>[];

    if (oneDayGeolocModelList != null && oneDayGeolocModelList.isNotEmpty) {
      cleaned = oneDayGeolocModelList.where((GeolocModel g) {
        final double? lat = double.tryParse(g.latitude.trim().replaceAll(',', '.'));
        final double? lon = double.tryParse(g.longitude.trim().replaceAll(',', '.'));
        return lat != null && lon != null;
      }).toList();
    }

    final List<StampRallyModel> list = <StampRallyModel>[];

    for (final StampRallyModel element in value) {
      final Iterable<StationModel> st = stationList.where(
        (StationModel station) => station.id == element.stationCode.toInt(),
      );

      if (st.isEmpty) {
        continue;
      }

      final StationModel stationModel = st.first;

      String nearestGeolocTime = '';
      if (cleaned.isNotEmpty) {
        final GeolocModel? nearestGeoloc = utility.findNearestGeoloc(
          geolocModelList: cleaned,
          latStr: stationModel.lat,
          lonStr: stationModel.lng,
        );
        if (nearestGeoloc != null) {
          nearestGeolocTime = nearestGeoloc.time;
        }
      }

      nearestGeolocTime = utility.getStampNearestGeolocTimeAdjustMap()[type]?[element.stationCode] ?? nearestGeolocTime;

      final String trainName = trainMap[stationModel.trainNumber] ?? '';

      element.lat = stationModel.lat;
      element.lng = stationModel.lng;
      element.trainCode = stationModel.trainNumber;
      element.trainName = trainName;
      element.time = nearestGeolocTime;

      // imageFolder / imageCode を trainMarkMap から補完
      final List<Map<String, String>>? marks = trainMarkMap[trainName];
      if (marks != null) {
        final Map<String, String> match = marks.firstWhere(
          (Map<String, String> m) => m['stationCode'] == element.stationCode,
          orElse: () => <String, String>{},
        );
        if (match.isNotEmpty) {
          element.imageFolder = match['imageFolder'] ?? '';
          element.imageCode = match['imageCode'] ?? '';
        }
      }

      list.add(element);
    }

    result[key] = list;
  });

  return result;
}
