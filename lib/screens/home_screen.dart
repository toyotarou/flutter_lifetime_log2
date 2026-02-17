import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/controllers_mixin.dart';
import '../enums/stamp_rally_kind.dart';
import '../extensions/extensions.dart';
import '../main.dart';
import '../models/amazon_purchase_model.dart';
import '../models/common/scroll_line_chart_model.dart';
import '../models/common/work_history_model.dart';
import '../models/credit_summary_model.dart';
import '../models/fortune_model.dart';
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
import '../utility/functions.dart';
import '../utility/utility.dart';
import 'components/amazon_purchase_list_alert.dart';
import 'components/bank_data_input_alert.dart';
import 'components/lifetime_item_search_alert.dart';
import 'components/lifetime_summary_alert.dart';
import 'components/money_count_list_alert.dart';
import 'components/money_in_possession_display_alert.dart';
import 'components/monthly_assets_display_alert.dart';
import 'components/monthly_geoloc_map_display_alert.dart';
import 'components/monthly_lifetime_display_alert.dart';
import 'components/monthly_money_spend_display_alert.dart';
import 'components/salary_list_alert.dart';
import 'components/spend_each_year_display_alert.dart';
import 'components/stamp_rally_list_alert.dart';
import 'components/walk_data_list_alert.dart';
import 'components/work_info_monthly_display_alert.dart';
import 'page/monthly_lifetime_display_page.dart';
import 'parts/error_dialog.dart';
import 'parts/lifetime_dialog.dart';

///
const List<IconData> bottomNavigationMenuIcons = <IconData>[
  FontAwesomeIcons.sun,
  Icons.money,
  FontAwesomeIcons.squareFontAwesomeStroke,
  Icons.list,
  Icons.map,
  Icons.work,
];

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
    required this.workHistoryModelMap,
    required this.moneySumList,
    required this.fortuneMap,
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
  final Map<String, WorkHistoryModel> workHistoryModelMap;
  final List<ScrollLineChartModel> moneySumList;
  final Map<String, FortuneModel> fortuneMap;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final List<TabInfo> _tabs = <TabInfo>[];
  final Utility utility = Utility();

  TabController? _tabController;

  List<Map<String, String>> insuranceDataList = <Map<String, String>>[];

  List<Map<String, String>> nenkinKikinDataList = <Map<String, String>>[];

  ///
  void _onTabChanged() {
    try {
      final TabController? c = _tabController;

      if (c != null && !c.indexIsChanging) {
        final int index = c.index;

        if (_tabs.isNotEmpty && index >= 0 && index < _tabs.length) {
          final String ym = _tabs[index].label;

          if (ym.isNotEmpty) {
            appParamNotifier.setHomeTabYearMonth(yearmonth: ym);
          }
        }
      }
    } catch (e) {
      debugPrint('_onTabChanged error: $e');
    }
  }

  ///
  @override
  void dispose() {
    try {
      _tabController?.removeListener(_onTabChanged);
    } catch (e) {
      debugPrint('dispose error: $e');
    }
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    try {
      _makeTab();
    } catch (e) {
      debugPrint('_makeTab error: $e');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      try {
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
        appParamNotifier.setKeepWorkHistoryModelMap(map: widget.workHistoryModelMap);
        appParamNotifier.setKeepMoneySumList(list: widget.moneySumList);
        appParamNotifier.setKeepTrainMap(map: widget.trainMap);
        appParamNotifier.setKeepFortuneMap(map: widget.fortuneMap);
      } catch (e) {
        debugPrint('setKeep error: $e');
      }

      //===========================================//

      try {
        final Map<String, List<String>> templeDateTimeBadgeMap = <String, List<String>>{};
        final Map<String, String> templeDateTimeNameMap = <String, String>{};

        widget.templeMap.forEach((String key, TempleModel value) {
          // 一時変数：このキーの処理が全て成功した場合のみ本番に追加
          final List<String> tempBadgeList = <String>[];
          final Map<String, String> tempNameMap = <String, String>{};
          bool hasError = false;

          try {
            final List<TempleDataModel> templeDataList = value.templeDataList;

            for (final TempleDataModel element in templeDataList) {
              final List<TemplePhotoModel>? photoModelList = element.templePhotoModelList;
              if (photoModelList == null) {
                continue;
              }

              for (final TemplePhotoModel element2 in photoModelList) {
                final List<String> photos = element2.templephotos;
                if (photos.isEmpty) {
                  continue;
                }

                final List<String> sortedPhotos = List<String>.from(photos)..sort();
                final String fileName = sortedPhotos.first;

                if (fileName.isEmpty) {
                  continue;
                }

                final List<String> exFileName = fileName.split('/');
                if (exFileName.isEmpty) {
                  continue;
                }

                final String lastPart = exFileName.last;
                if (lastPart.isEmpty) {
                  continue;
                }

                final List<String> exFileNameLast = lastPart.split('_');
                if (exFileNameLast.isEmpty) {
                  continue;
                }

                final String keyWithoutHyphen = key.replaceAll('-', '');
                if (exFileNameLast.first == keyWithoutHyphen) {
                  if (exFileNameLast.length < 2) {
                    continue;
                  }

                  final List<String> exFileNameLastLast = exFileNameLast.last.split('.');
                  if (exFileNameLastLast.isEmpty) {
                    continue;
                  }

                  final String timePart = exFileNameLastLast.first;
                  if (timePart.length >= 4) {
                    final String fileHourMinute = timePart.substring(0, 4);
                    final String hour = fileHourMinute.substring(0, 2);
                    final String minute = fileHourMinute.substring(2);

                    tempBadgeList.add('$hour:$minute');
                    tempNameMap['$key|$hour:$minute'] = element2.temple;
                  }
                }
              }
            }
          } catch (e) {
            hasError = true;
            debugPrint('templeMap processing error for key $key: $e');
          }

          // エラーがなく、データがある場合のみ本番マップに追加
          if (!hasError && tempBadgeList.isNotEmpty) {
            templeDateTimeBadgeMap[key] = tempBadgeList;
            tempNameMap.forEach((String k, String v) {
              templeDateTimeNameMap[k] = v;
            });
          }
        });

        ///////////////////////

        final Map<String, List<Map<String, dynamic>>> allDateLifetimeSummaryMap =
            <String, List<Map<String, dynamic>>>{};

        widget.lifetimeMap.forEach((String key, LifetimeModel value) {
          try {
            final List<String> lifetimeData = getLifetimeData(lifetimeModel: value);
            final Map<int, String> duplicateConsecutiveMap = getDuplicateConsecutiveMap(lifetimeData);
            final List<Map<String, dynamic>> startEndTitleList = getStartEndTitleList(data: duplicateConsecutiveMap);
            allDateLifetimeSummaryMap[key] = startEndTitleList;
          } catch (e) {
            debugPrint('lifetimeMap processing error for key $key: $e');
          }
        });

        ///////////////////////

        Map<String, List<StampRallyModel>> stampRallyMetro20AnniversaryMap = <String, List<StampRallyModel>>{};
        try {
          stampRallyMetro20AnniversaryMap = makeStampRallyDisplayDataMap(
            stampRallyMetroAllStationMap: widget.stampRallyMetroAllStationMap,
            type: 'Metro20Anniversary',
            stampRallyMetro20AnniversaryMapSrc: widget.stampRallyMetro20AnniversaryMap,
            stampRallyMetroPokepokeMapSrc: <String, List<StampRallyModel>>{},
            geolocMap: widget.geolocMap,
            stationList: widget.stationList,
            trainMap: widget.trainMap,
            utility: utility,
          );
        } catch (e) {
          debugPrint('stampRallyMetro20AnniversaryMap error: $e');
        }

        ///////////////////////

        Map<String, List<StampRallyModel>> stampRallyMetroPokepokeMap = <String, List<StampRallyModel>>{};
        try {
          stampRallyMetroPokepokeMap = makeStampRallyDisplayDataMap(
            stampRallyMetroAllStationMap: widget.stampRallyMetroAllStationMap,
            type: 'MetroPokepoke',
            stampRallyMetro20AnniversaryMapSrc: <String, List<StampRallyModel>>{},
            stampRallyMetroPokepokeMapSrc: widget.stampRallyMetroPokepokeMap,
            geolocMap: widget.geolocMap,
            stationList: widget.stationList,
            trainMap: widget.trainMap,
            utility: utility,
          );
        } catch (e) {
          debugPrint('stampRallyMetroPokepokeMap error: $e');
        }

        ///////////////////////

        final Map<int, Map<String, int>> creditSummaryTotalMap = <int, Map<String, int>>{};
        final Map<int, Map<String, List<int>>> creditSummaryListMap = <int, Map<String, List<int>>>{};

        try {
          final List<String> creditItemList = utility.getCreditItemList();
          final String? homeTabYear = appParamState.homeTabYearMonth.split('-').firstOrNull;

          widget.creditSummaryMap.forEach((String key, List<CreditSummaryModel> value) {
            try {
              final String? keyYear = key.split('-').firstOrNull;
              if (homeTabYear != null && keyYear == homeTabYear) {
                final Map<String, List<int>> creditListMap = <String, List<int>>{};

                for (final String element2 in creditItemList) {
                  for (final CreditSummaryModel element in value) {
                    if (element2 == element.item) {
                      (creditListMap[element2] ??= <int>[]).add(element.price);
                    }
                  }
                }

                final List<String> keyParts = key.split('-');
                if (keyParts.length >= 2) {
                  final int? monthInt = int.tryParse(keyParts[1]);
                  if (monthInt != null) {
                    creditSummaryListMap[monthInt] = creditListMap;
                  }
                }
              }
            } catch (e) {
              debugPrint('creditSummaryMap processing error for key $key: $e');
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
        } catch (e) {
          debugPrint('creditSummary processing error: $e');
        }

        ///////////////////////

        final List<List<List<List<double>>>> allPolygonsList = <List<List<List<double>>>>[];

        try {
          for (final MunicipalModel element in widget.tokyoMunicipalList) {
            final List<List<List<List<double>>>> polygons = element.polygons;
            allPolygonsList.addAll(polygons);
          }
        } catch (e) {
          debugPrint('allPolygonsList error: $e');
        }

        ///////////////////////

        if (mounted) {
          // ignore: always_specify_types
          Future(() {
            try {
              appParamNotifier.setKeepTempleDateTimeBadgeMap(map: templeDateTimeBadgeMap);
              appParamNotifier.setKeepTempleDateTimeNameMap(map: templeDateTimeNameMap);
              appParamNotifier.setKeepAllDateLifetimeSummaryMap(map: allDateLifetimeSummaryMap);
              appParamNotifier.setKeepStampRallyMetro20AnniversaryMap(map: stampRallyMetro20AnniversaryMap);
              appParamNotifier.setKeepStampRallyMetroPokepokeMap(map: stampRallyMetroPokepokeMap);
              appParamNotifier.setKeepCreditSummaryTotalMap(map: creditSummaryTotalMap);
              appParamNotifier.setKeepAllPolygonsList(list: allPolygonsList);
            } catch (e) {
              debugPrint('Future setKeep error: $e');
            }
          });
        }
      } catch (e) {
        debugPrint('addPostFrameCallback main error: $e');
      }
      //===========================================//

      try {
        makeNenkinKikinDataList();
      } catch (e) {
        debugPrint('makeNenkinKikinDataList error: $e');
      }
    });

    if (_tabs.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            utility.getBackGround(),
            Container(
              width: context.screenSize.width,
              height: context.screenSize.height,
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Builder(
        builder: (BuildContext tabScopeContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            try {
              final TabController newController = DefaultTabController.of(tabScopeContext);
              if (newController != _tabController) {
                _tabController?.removeListener(_onTabChanged);
                _tabController = newController;
                _tabController?.addListener(_onTabChanged);

                if (_tabController != null && _tabs.isNotEmpty) {
                  final int index = _tabController!.index;
                  if (index >= 0 && index < _tabs.length) {
                    appParamNotifier.setHomeTabYearMonth(yearmonth: _tabs[index].label);
                  }
                }
              }
            } catch (e) {
              debugPrint('TabController setup error: $e');
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
                  onPressed: () {
                    try {
                      context.findAncestorStateOfType<AppRootState>()?.restartApp();
                    } catch (e) {
                      debugPrint('restartApp error: $e');
                    }
                  },
                  icon: const Icon(Icons.refresh),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.blueAccent,
                  padding: EdgeInsets.zero,
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

            ///
            bottomNavigationBar: _ScrollableBottomDialogMenu(
              bottomSelected: appParamState.bottomNavigationSelectedIndex,
              onTap: (int index) async {
                try {
                  appParamNotifier.setSelectedBottomNavigationIndex(
                    index: index,
                    maxCount: bottomNavigationMenuIcons.length,
                  );

                  getBottomMenuContents(index: index);

                  if (mounted) {
                    appParamNotifier.setSelectedBottomNavigationIndex(maxCount: bottomNavigationMenuIcons.length);
                  }
                } catch (e) {
                  debugPrint('bottomNavigationBar onTap error: $e');
                }
              },
            ),

            endDrawer: _dispDrawer(),
          );
        },
      ),
    );
  }

  ///
  Object getBottomMenuContents({required int index}) {
    try {
      switch (index) {
        case 0:
          if (appParamState.keepGoldMap.isEmpty ||
              appParamState.keepStockMap.isEmpty ||
              appParamState.keepToushiShintakuMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(context: context, title: '表示できません。', content: '資産情報が作成されていません。');
              }
            });
          } else {
            appParamNotifier.setKeepNenkinKikinDataList(list: nenkinKikinDataList);
            appParamNotifier.setKeepInsuranceDataList(list: insuranceDataList);

            final String yearmonth = appParamState.homeTabYearMonth;
            if (yearmonth.isEmpty) {
              return const SizedBox.shrink();
            }

            return LifetimeDialog(
              context: context,
              widget: MonthlyAssetsDisplayAlert(yearmonth: yearmonth),
            );
          }

        case 1:
          if (appParamState.keepMoneySpendItemMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: 'appParamState.keepMoneySpendItemMapが作成されていません。',
                );
              }
            });
          } else {
            final String yearmonth = appParamState.homeTabYearMonth;
            if (yearmonth.isEmpty) {
              return const SizedBox.shrink();
            }

            return LifetimeDialog(
              context: context,
              widget: MonthlyMoneySpendDisplayAlert(yearmonth: yearmonth),
            );
          }

        case 2:
          if (appParamState.keepWalkModelMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(context: context, title: '表示できません。', content: 'appParamState.keepWalkModelMapが作成されていません。');
              }
            });
          } else {
            final String yearmonth = appParamState.homeTabYearMonth;
            if (yearmonth.isEmpty) {
              return const SizedBox.shrink();
            }

            return LifetimeDialog(
              context: context,
              widget: WalkDataListAlert(yearmonth: yearmonth),
            );
          }

        case 3:
          final String yearmonth = appParamState.homeTabYearMonth;
          if (yearmonth.isEmpty) {
            return const SizedBox.shrink();
          }

          return LifetimeDialog(
            context: context,
            widget: MonthlyLifetimeDisplayAlert(yearmonth: yearmonth),
          );

        case 4:
          if (DateTime.now().day == 1) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(context: context, title: '表示できません。', content: '今月分のgeolocが存在しません。');
              }
            });
          } else {
            final String yearmonth = appParamState.homeTabYearMonth;
            if (yearmonth.isEmpty) {
              return const SizedBox.shrink();
            }

            appParamNotifier.setSelectedYearMonth(yearmonth: yearmonth);
            appParamNotifier.clearMonthlyGeolocMapSelectedDateList();

            return LifetimeDialog(
              context: context,
              widget: MonthlyGeolocMapDisplayAlert(yearmonth: yearmonth),
              executeFunctionWhenDialogClose: true,
              from: 'MonthlyGeolocMapDisplayAlert',
              ref: ref,
            );
          }

        case 5:
          if (appParamState.keepWorkTimeMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(context: context, title: '表示できません。', content: 'appParamState.keepWorkTimeMapが作成されていません。');
              }
            });
          } else {
            final String yearmonth = appParamState.homeTabYearMonth;
            if (yearmonth.isEmpty) {
              return const SizedBox.shrink();
            }

            return LifetimeDialog(
              context: context,
              widget: WorkInfoMonthlyDisplayAlert(yearmonth: yearmonth),
            );
          }
      }
    } catch (e) {
      debugPrint('getBottomMenuContents error: $e');
    }

    return const SizedBox.shrink();
  }

  ///
  void makeNenkinKikinDataList() {
    try {
      insuranceDataList.clear();
      nenkinKikinDataList.clear();

      widget.moneySpendMap.forEach((String key, List<MoneySpendModel> value) {
        for (final MoneySpendModel element in value) {
          if (element.price == 55880) {
            insuranceDataList.add(<String, String>{'date': key, 'price': element.price.toString()});
          }

          if (element.item == '国民年金基金') {
            nenkinKikinDataList.add(<String, String>{'date': key, 'price': element.price.toString()});
          }
        }
      });
    } catch (e) {
      debugPrint('makeNenkinKikinDataList error: $e');
    }
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
                  try {
                    appParamNotifier.setSelectedCrossCalendarYear(year: DateTime.now().year);

                    final List<String> yList = <String>[];
                    widget.lifetimeMap.forEach((String key, LifetimeModel value) {
                      final List<String> exKey = key.split('-');
                      if (exKey.isNotEmpty) {
                        yList.add(exKey[0]);
                      }
                    });

                    final List<String> years = yList.toSet().toList();
                    years.sort();

                    LifetimeDialog(
                      context: context,
                      widget: LifetimeSummaryAlert(years: years),
                    );
                  } catch (e) {
                    debugPrint('lifetime summary error: $e');
                  }
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
                  try {
                    LifetimeDialog(context: context, widget: const LifetimeItemSearchAlert());
                  } catch (e) {
                    debugPrint('lifetime item search error: $e');
                  }
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
                  try {
                    final Map<String, MoneyModel> keepMoneyMap = appParamState.keepMoneyMap;
                    if (keepMoneyMap.isEmpty) {
                      return;
                    }

                    final List<MapEntry<String, MoneyModel>> moneyEntries = keepMoneyMap.entries.toList();

                    final String homeTabYearMonth = appParamState.homeTabYearMonth;
                    if (homeTabYearMonth.isEmpty) {
                      return;
                    }

                    final int pos = moneyEntries.indexWhere(
                      (MapEntry<String, MoneyModel> entry) => entry.key == '$homeTabYearMonth-01',
                    );

                    LifetimeDialog(
                      context: context,
                      widget: MoneyCountListAlert(initialRowIndex: pos >= 0 ? pos : 0, moneyEntries: moneyEntries),
                    );
                  } catch (e) {
                    debugPrint('money count list error: $e');
                  }
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
                onTap: () {
                  try {
                    LifetimeDialog(context: context, widget: const MoneyInPossessionDisplayAlert());
                  } catch (e) {
                    debugPrint('money in possession error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(context: context, widget: const BankDataInputAlert());
                  } catch (e) {
                    debugPrint('bank money adjust error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(context: context, widget: const SalaryListAlert());
                  } catch (e) {
                    debugPrint('salary list error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    appParamNotifier.setYearlyAllSpendSelectedYear(year: '');
                    appParamNotifier.setYearlyAllSpendSelectedPrice(price: '');

                    LifetimeDialog(context: context, widget: const SpendEachYearDisplayAlert());
                  } catch (e) {
                    debugPrint('spend each year error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(context: context, widget: const AmazonPurchaseListAlert());
                  } catch (e) {
                    debugPrint('amazon purchase list error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(
                      context: context,
                      widget: const StampRallyListAlert(kind: StampRallyKind.metroAllStation),
                    );
                  } catch (e) {
                    debugPrint('stamp rally metro all station error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(
                      context: context,
                      widget: const StampRallyListAlert(kind: StampRallyKind.metro20Anniversary),
                    );
                  } catch (e) {
                    debugPrint('stamp rally metro 20 anniversary error: $e');
                  }
                },
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
                onTap: () {
                  try {
                    LifetimeDialog(
                      context: context,
                      widget: const StampRallyListAlert(kind: StampRallyKind.metroPokepoke),
                    );
                  } catch (e) {
                    debugPrint('stamp rally metro pokepoke error: $e');
                  }
                },
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

    try {
      final List<LifetimeModel> lifetimeList = lifetimeState.lifetimeList;
      if (lifetimeList.isEmpty) {
        return;
      }

      final List<String> yearmonthList = <String>[];

      final List<LifetimeModel> sortedList = List<LifetimeModel>.from(lifetimeList);
      sortedList.sort((LifetimeModel a, LifetimeModel b) {
        final String aKey = '${a.year}-${a.month}';
        final String bKey = '${b.year}-${b.month}';
        return bKey.compareTo(aKey);
      });

      for (final LifetimeModel element in sortedList) {
        final String ym = '${element.year}-${element.month}';
        if (!yearmonthList.contains(ym)) {
          yearmonthList.add(ym);
        }
      }

      final String nowYm = DateTime.now().yyyymm;
      if (!yearmonthList.contains(nowYm)) {
        yearmonthList.add(nowYm);
        yearmonthList.sort((String a, String b) => b.compareTo(a));
      }

      for (final String element in yearmonthList) {
        _tabs.add(TabInfo(element, MonthlyLifetimeDisplayPage(yearmonth: element)));
      }
    } catch (e) {
      debugPrint('_makeTab error: $e');
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////

class _ScrollableBottomDialogMenu extends StatelessWidget {
  const _ScrollableBottomDialogMenu({required this.bottomSelected, required this.onTap});

  final int? bottomSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (bottomNavigationMenuIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 4,
      color: Colors.transparent,
      child: SizedBox(
        height: 88,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bottomNavigationMenuIcons.length,
          itemBuilder: (BuildContext context, int index) {
            if (index < 0 || index >= bottomNavigationMenuIcons.length) {
              return const SizedBox.shrink();
            }

            final bool selected = bottomSelected == index;

            return InkWell(
              onTap: () => onTap(index),
              child: Container(
                width: 70,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: selected ? Colors.yellow.withValues(alpha: 0.2) : Colors.transparent),
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(bottomNavigationMenuIcons[index], color: Colors.white.withValues(alpha: 0.3)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////

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

  try {
    final Map<String, List<Map<String, String>>> trainMarkMap = <String, List<Map<String, String>>>{};

    stampRallyMetroAllStationMap.forEach((String date, List<StampRallyModel> models) {
      for (final StampRallyModel model in models) {
        final Map<String, String> entry = <String, String>{
          'imageFolder': model.imageFolder,
          'imageCode': model.imageCode,
          'stationCode': model.stationCode,
        };
        trainMarkMap.putIfAbsent(model.trainName, () => <Map<String, String>>[]);
        trainMarkMap[model.trainName]?.add(entry);
      }
    });

    Map<String, List<StampRallyModel>> targetSourceMap;

    switch (type) {
      case 'Metro20Anniversary':
        targetSourceMap = stampRallyMetro20AnniversaryMapSrc;

      case 'MetroPokepoke':
        targetSourceMap = stampRallyMetroPokepokeMapSrc;

      default:
        targetSourceMap = stampRallyMetro20AnniversaryMapSrc;
    }

    targetSourceMap.forEach((String key, List<StampRallyModel> value) {
      // このキーの処理全体でエラーが発生したらスキップ
      bool hasError = false;
      final List<StampRallyModel> list = <StampRallyModel>[];

      try {
        final List<GeolocModel>? oneDayGeolocModelList = geolocMap[key];
        List<GeolocModel> cleaned = <GeolocModel>[];

        if (oneDayGeolocModelList != null && oneDayGeolocModelList.isNotEmpty) {
          cleaned = oneDayGeolocModelList.where((GeolocModel g) {
            try {
              final String latStr = g.latitude.trim().replaceAll(',', '.');
              final String lonStr = g.longitude.trim().replaceAll(',', '.');
              final double? lat = double.tryParse(latStr);
              final double? lon = double.tryParse(lonStr);
              return lat != null && lon != null;
            } catch (e) {
              return false;
            }
          }).toList();
        }

        for (final StampRallyModel element in value) {
          // 各エレメントの処理：まず全データを一時変数で計算
          final int? stationCodeInt = int.tryParse(element.stationCode);
          if (stationCodeInt == null) {
            continue;
          }

          final Iterable<StationModel> st = stationList.where((StationModel station) => station.id == stationCodeInt);

          if (st.isEmpty) {
            continue;
          }

          final StationModel stationModel = st.first;

          // 一時変数で全ての値を計算
          String nearestGeolocTime = '';
          if (cleaned.isNotEmpty) {
            try {
              final GeolocModel? nearestGeoloc = utility.findNearestGeoloc(
                geolocModelList: cleaned,
                latStr: stationModel.lat,
                lonStr: stationModel.lng,
              );
              if (nearestGeoloc != null) {
                nearestGeolocTime = nearestGeoloc.time;
              }
            } catch (e) {
              debugPrint('findNearestGeoloc error: $e');
              // 時刻取得エラーは空文字のまま続行
            }
          }

          try {
            final Map<String, Map<String, String>> adjustMap = utility.getStampNearestGeolocTimeAdjustMap();
            final Map<String, String>? typeMap = adjustMap[type];
            if (typeMap != null) {
              final String? adjustedTime = typeMap[element.stationCode];
              if (adjustedTime != null) {
                nearestGeolocTime = adjustedTime;
              }
            }
          } catch (e) {
            debugPrint('getStampNearestGeolocTimeAdjustMap error: $e');
            // 調整マップエラーは無視して続行
          }

          final String trainName = trainMap[stationModel.trainNumber] ?? '';

          String imageFolder = element.imageFolder;
          String imageCode = element.imageCode;

          // imageFolder / imageCode を trainMarkMap から補完
          final List<Map<String, String>>? marks = trainMarkMap[trainName];
          if (marks != null && marks.isNotEmpty) {
            for (final Map<String, String> m in marks) {
              if (m['stationCode'] == element.stationCode) {
                imageFolder = m['imageFolder'] ?? imageFolder;
                imageCode = m['imageCode'] ?? imageCode;
                break;
              }
            }
          }

          // 全ての計算が完了してから、elementを更新してlistに追加
          element.lat = stationModel.lat;
          element.lng = stationModel.lng;
          element.trainCode = stationModel.trainNumber;
          element.trainName = trainName;
          element.time = nearestGeolocTime;
          element.imageFolder = imageFolder;
          element.imageCode = imageCode;

          list.add(element);
        }
      } catch (e) {
        hasError = true;
        debugPrint('targetSourceMap processing error for key $key: $e');
      }

      // エラーがなければ結果に追加（listが空でも追加はOK）
      if (!hasError) {
        result[key] = list;
      }
    });
  } catch (e) {
    debugPrint('makeStampRallyDisplayDataMap error: $e');
  }

  return result;
}
