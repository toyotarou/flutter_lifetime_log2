import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/_get_data/amazon_purchase/amazon_purchase.dart';
import '../controllers/_get_data/credit_summary/credit_summary.dart';
import '../controllers/_get_data/fortune/fortune.dart';
import '../controllers/_get_data/fund/fund.dart';
import '../controllers/_get_data/geoloc/geoloc.dart';
import '../controllers/_get_data/gold/gold.dart';
import '../controllers/_get_data/holiday/holiday.dart';
import '../controllers/_get_data/lifetime/lifetime.dart';
import '../controllers/_get_data/lifetime_item/lifetime_item.dart';
import '../controllers/_get_data/money/money.dart';
import '../controllers/_get_data/money_spend/money_spend.dart';
import '../controllers/_get_data/money_spend_item/money_spend_item.dart';
import '../controllers/_get_data/money_sum/money_sum.dart';
import '../controllers/_get_data/salary/salary.dart';
import '../controllers/_get_data/stamp_rally_metro_20_anniversary/stamp_rally_metro_20_anniversary.dart';
import '../controllers/_get_data/stamp_rally_metro_all_station/stamp_rally_metro_all_station.dart';
import '../controllers/_get_data/stamp_rally_metro_pokepoke/stamp_rally_metro_pokepoke.dart';
import '../controllers/_get_data/stock/stock.dart';
import '../controllers/_get_data/tarot/tarot.dart';
import '../controllers/_get_data/tarot_history/tarot_history.dart';
import '../controllers/_get_data/temple/temple.dart';
import '../controllers/_get_data/time_place/time_place.dart';
import '../controllers/_get_data/tokyo_municipal/tokyo_municipal.dart';
import '../controllers/_get_data/toushi_shintaku/toushi_shintaku.dart';
import '../controllers/_get_data/toushi_shintaku_history/toushi_shintaku_history.dart';
import '../controllers/_get_data/transportation/transportation.dart';
import '../controllers/_get_data/walk/walk.dart';
import '../controllers/_get_data/weather/weather.dart';
import '../controllers/_get_data/work_time/work_time.dart';
import '../controllers/app_param/app_param.dart';
import '../controllers/controllers_mixin.dart';
import '../data/http/client.dart';
import '../enums/stamp_rally_kind.dart';
import '../extensions/extensions.dart';
import '../main.dart';
import '../models/credit_summary_model.dart';
import '../models/geoloc_model.dart';
import '../models/lifetime_model.dart';
import '../models/money_model.dart';
import '../models/money_spend_model.dart';
import '../models/municipal_model.dart';
import '../models/stamp_rally_model.dart';
import '../models/temple_model.dart';
import '../models/transportation_model.dart';
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
import 'components/monthly_weather_display_alert.dart';
import 'components/ohakamairi_data_display_alert.dart';
import 'components/salary_list_alert.dart';
import 'components/spend_each_year_display_alert.dart';
import 'components/stamp_rally_list_alert.dart';
import 'components/walk_data_list_alert.dart';
import 'components/work_info_monthly_display_alert.dart';
import 'page/monthly_lifetime_display_page.dart';
import 'parts/error_dialog.dart';
import 'parts/lifetime_dialog.dart';

///
const List<dynamic> bottomNavigationMenuIcons = <dynamic>[
  FontAwesomeIcons.sun,
  Icons.money,
  FontAwesomeIcons.squareFontAwesomeStroke,
  Icons.list,
  Icons.map,
  Icons.work,
  FontAwesomeIcons.umbrella,
  FontAwesomeIcons.wind,
];

class TabInfo {
  const TabInfo(this.label, this.widget, {this.highlight = false});

  final String label;
  final Widget widget;
  final bool highlight;
}

/// ホーム画面
///
/// 以前は MyApp で全 Provider を watch してコンストラクタ引数で受け取っていたが、
/// どれか 1 つのデータが届くたびに MaterialApp ごと再構築されていたため、
/// HomeScreen 自身が必要な Provider を watch する形に変更した。
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final Utility utility = Utility();

  /// タブ（年月）一覧。元データ（lifetimeList）と「今月」が変わらない限り使い回す
  List<TabInfo> _tabs = <TabInfo>[];
  List<LifetimeModel>? _tabsSourceList;
  String _tabsSourceNowYm = '';

  TabController? _tabController;
  bool _postFrameSyncQueued = false;

  /// 派生データの入力値（前回計算時）。入力が変わっていない派生データは再計算しない
  final Map<String, List<Object?>> _derivedInputs = <String, List<Object?>>{};

  ///
  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // データ系 Provider を購読（どれかが更新されたら再構築 → フレーム後に appParam へ同期）
    _watchSourceProviders();

    // ボトムメニューの選択状態だけを購読（appParamState 全体を watch しない）
    final int? bottomSelected = ref.watch(
      appParamProvider.select((AppParamState s) => s.bottomNavigationSelectedIndex),
    );

    _makeTab();
    _scheduleDataSync();

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
          _attachTabController(DefaultTabController.of(tabScopeContext));

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
                // API 通信中はくるくるを表示する（actions を指定すると endDrawer のボタンが自動で付かないため明示する）
                actions: const <Widget>[_ApiLoadingIndicator(), EndDrawerButton()],
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
              bottomSelected: bottomSelected,
              onTap: (int index) {
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

  //==========================================================================//
  // データ同期
  //==========================================================================//

  /// HomeScreen が依存するデータ系 Provider を購読する
  void _watchSourceProviders() {
    ref.watch(holidayProvider);
    ref.watch(walkProvider);
    ref.watch(moneyProvider);
    ref.watch(lifetimeProvider);
    ref.watch(lifetimeItemProvider);
    ref.watch(geolocProvider);
    ref.watch(templeProvider);
    ref.watch(transportationProvider);
    ref.watch(moneySpendProvider);
    ref.watch(workTimeProvider);
    ref.watch(weatherProvider);
    ref.watch(moneySpendItemProvider);
    ref.watch(salaryProvider);
    ref.watch(goldProvider);
    ref.watch(stockProvider);
    ref.watch(toushiShintakuProvider);
    ref.watch(creditSummaryProvider);
    ref.watch(fundProvider);
    ref.watch(timePlaceProvider);
    ref.watch(amazonPurchaseProvider);
    ref.watch(tokyoMunicipalProvider);
    ref.watch(stampRallyMetroAllStationProvider);
    ref.watch(stampRallyMetro20AnniversaryProvider);
    ref.watch(stampRallyMetroPokepokeProvider);
    ref.watch(moneySumProvider);
    ref.watch(fortuneProvider);
    ref.watch(tarotProvider);
    ref.watch(tarotHistoryProvider);
    ref.watch(toushiShintakuHistoryProvider);
  }

  /// build 中に Provider を変更できないため、フレーム後にまとめて同期する（同一フレーム内の重複はまとめる）
  void _scheduleDataSync() {
    if (_postFrameSyncQueued) {
      return;
    }

    _postFrameSyncQueued = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameSyncQueued = false;

      if (!mounted) {
        return;
      }

      _syncDataAfterFrame();
    });
  }

  ///
  void _syncDataAfterFrame() {
    final LifetimeState lifetime = ref.read(lifetimeProvider);
    final GeolocState geoloc = ref.read(geolocProvider);
    final TempleState temple = ref.read(templeProvider);
    final TransportationState transportation = ref.read(transportationProvider);
    final MoneySpendState moneySpend = ref.read(moneySpendProvider);
    final WorkTimeState workTime = ref.read(workTimeProvider);
    final StockState stock = ref.read(stockProvider);
    final ToushiShintakuState toushiShintaku = ref.read(toushiShintakuProvider);
    final CreditSummaryState creditSummary = ref.read(creditSummaryProvider);
    final TokyoMunicipalState tokyoMunicipal = ref.read(tokyoMunicipalProvider);
    final StampRallyMetroAllStationState stampAll = ref.read(stampRallyMetroAllStationProvider);
    final StampRallyMetro20AnniversaryState stamp20 = ref.read(stampRallyMetro20AnniversaryProvider);
    final StampRallyMetroPokepokeState stampPoke = ref.read(stampRallyMetroPokepokeProvider);
    final ToushiShintakuHistoryState toushiHistory = ref.read(toushiShintakuHistoryProvider);

    //------------------------------------------------ 元データ（変化があった場合のみ 1 回で反映）
    try {
      appParamNotifier.syncKeepSourceData(
        holidayList: ref.read(holidayProvider).holidayList,
        walkModelMap: ref.read(walkProvider).walkMap,
        moneyMap: ref.read(moneyProvider).moneyMap,
        lifetimeMap: lifetime.lifetimeMap,
        lifetimeItemList: ref.read(lifetimeItemProvider).lifetimeItemList,
        geolocMap: geoloc.geolocMap,
        templeMap: temple.templeMap,
        transportationMap: transportation.transportationMap,
        moneySpendMap: moneySpend.moneySpendMap,
        workTimeMap: workTime.workTimeMap,
        workTimeDateMap: workTime.workTimeDateMap,
        weatherMap: ref.read(weatherProvider).weatherMap,
        moneySpendItemMap: ref.read(moneySpendItemProvider).moneySpendItemMap,
        salaryMap: ref.read(salaryProvider).salaryMap,
        goldMap: ref.read(goldProvider).goldMap,
        stockMap: stock.stockMap,
        toushiShintakuMap: toushiShintaku.toushiShintakuMap,
        stationList: transportation.stationList,
        creditSummaryMap: creditSummary.creditSummaryMap,
        fundRelationMap: ref.read(fundProvider).fundRelationMap,
        stockTickerMap: stock.stockTickerMap,
        toushiShintakuRelationalMap: toushiShintaku.toushiShintakuRelationalMap,
        timePlaceMap: ref.read(timePlaceProvider).timePlaceMap,
        amazonPurchaseMap: ref.read(amazonPurchaseProvider).amazonPurchaseMap,
        stampRallyMetroAllStationMap: stampAll.dateStationStampMap,
        tokyoMunicipalList: tokyoMunicipal.tokyoMunicipalList,
        tokyoMunicipalMap: tokyoMunicipal.tokyoMunicipalMap,
        moneySumList: ref.read(moneySumProvider).moneySumList,
        trainMap: transportation.trainMap,
        fortuneMap: ref.read(fortuneProvider).fortuneMap,
        tarotMap: ref.read(tarotProvider).tarotMap,
        tarotHistoryMap: ref.read(tarotHistoryProvider).tarotHistoryMap,
        toushiShintakuHistoryMap: toushiHistory.toushiShintakuHistoryMap,
        toushiShintakuHistoryCostDateMap: toushiHistory.toushiShintakuHistoryCostDateMap,
      );
    } catch (e) {
      debugPrint('syncKeepSourceData error: $e');
    }

    //------------------------------------------------ 派生データ（入力が変わったものだけ再計算）
    Map<String, List<String>>? templeDateTimeBadgeMap;
    Map<String, String>? templeDateTimeNameMap;
    Map<String, List<Map<String, dynamic>>>? allDateLifetimeSummaryMap;
    Map<String, List<StampRallyModel>>? stampRallyMetro20AnniversaryMap;
    Map<String, List<StampRallyModel>>? stampRallyMetroPokepokeMap;
    Map<int, Map<String, int>>? creditSummaryTotalMap;
    List<List<List<List<double>>>>? allPolygonsList;
    Map<String, List<MoneySpendModel>>? ohakamairiDataMap;
    List<Map<String, String>>? nenkinKikinDataList;
    List<Map<String, String>>? insuranceDataList;

    if (_inputsChanged('temple', <Object?>[temple.templeMap])) {
      try {
        final (Map<String, List<String>>, Map<String, String>) result = _makeTempleDateTimeMaps(temple.templeMap);
        templeDateTimeBadgeMap = result.$1;
        templeDateTimeNameMap = result.$2;
      } catch (e) {
        debugPrint('temple derived error: $e');
      }
    }

    if (_inputsChanged('lifetime', <Object?>[lifetime.lifetimeMap])) {
      allDateLifetimeSummaryMap = _makeAllDateLifetimeSummaryMap(lifetime.lifetimeMap);
    }

    final List<Object?> stampCommonInputs = <Object?>[
      stampAll.dateStationStampMap,
      geoloc.geolocMap,
      transportation.stationList,
      transportation.trainMap,
    ];

    if (_inputsChanged('stamp20', <Object?>[...stampCommonInputs, stamp20.dateStationStampMap])) {
      try {
        stampRallyMetro20AnniversaryMap = makeStampRallyDisplayDataMap(
          stampRallyMetroAllStationMap: stampAll.dateStationStampMap,
          type: 'Metro20Anniversary',
          stampRallyMetro20AnniversaryMapSrc: stamp20.dateStationStampMap,
          stampRallyMetroPokepokeMapSrc: <String, List<StampRallyModel>>{},
          geolocMap: geoloc.geolocMap,
          stationList: transportation.stationList,
          trainMap: transportation.trainMap,
          utility: utility,
        );
      } catch (e) {
        debugPrint('stampRallyMetro20AnniversaryMap error: $e');
      }
    }

    if (_inputsChanged('stampPoke', <Object?>[...stampCommonInputs, stampPoke.dateStationStampMap])) {
      try {
        stampRallyMetroPokepokeMap = makeStampRallyDisplayDataMap(
          stampRallyMetroAllStationMap: stampAll.dateStationStampMap,
          type: 'MetroPokepoke',
          stampRallyMetro20AnniversaryMapSrc: <String, List<StampRallyModel>>{},
          stampRallyMetroPokepokeMapSrc: stampPoke.dateStationStampMap,
          geolocMap: geoloc.geolocMap,
          stationList: transportation.stationList,
          trainMap: transportation.trainMap,
          utility: utility,
        );
      } catch (e) {
        debugPrint('stampRallyMetroPokepokeMap error: $e');
      }
    }

    // クレジット集計は表示中タブの「年」にも依存するため、タブ切替で年が変わった場合も再計算する
    final String homeTabYear = ref.read(appParamProvider).homeTabYearMonth.split('-').first;

    if (_inputsChanged('credit', <Object?>[creditSummary.creditSummaryMap, homeTabYear])) {
      creditSummaryTotalMap = _makeCreditSummaryTotalMap(
        creditSummaryMap: creditSummary.creditSummaryMap,
        homeTabYear: homeTabYear,
      );
    }

    if (_inputsChanged('polygons', <Object?>[tokyoMunicipal.tokyoMunicipalList])) {
      allPolygonsList = <List<List<List<double>>>>[
        for (final MunicipalModel element in tokyoMunicipal.tokyoMunicipalList) ...element.polygons,
      ];
    }

    if (_inputsChanged('moneySpend', <Object?>[moneySpend.moneySpendMap])) {
      ohakamairiDataMap = <String, List<MoneySpendModel>>{};
      nenkinKikinDataList = <Map<String, String>>[];
      insuranceDataList = <Map<String, String>>[];

      moneySpend.moneySpendMap.forEach((String key, List<MoneySpendModel> value) {
        final List<MoneySpendModel> ohakamairi = <MoneySpendModel>[];

        for (final MoneySpendModel element in value) {
          if (element.item == 'お線香代') {
            ohakamairi.add(element);
          }

          if (element.price == 55880) {
            insuranceDataList!.add(<String, String>{'date': key, 'price': element.price.toString()});
          }

          if (element.item == '国民年金基金') {
            nenkinKikinDataList!.add(<String, String>{'date': key, 'price': element.price.toString()});
          }
        }

        if (ohakamairi.isNotEmpty) {
          ohakamairiDataMap![key] = ohakamairi;
        }
      });
    }

    if (!mounted) {
      return;
    }

    appParamNotifier.syncKeepDerivedData(
      templeDateTimeBadgeMap: templeDateTimeBadgeMap,
      templeDateTimeNameMap: templeDateTimeNameMap,
      allDateLifetimeSummaryMap: allDateLifetimeSummaryMap,
      stampRallyMetro20AnniversaryMap: stampRallyMetro20AnniversaryMap,
      stampRallyMetroPokepokeMap: stampRallyMetroPokepokeMap,
      creditSummaryTotalMap: creditSummaryTotalMap,
      allPolygonsList: allPolygonsList,
      ohakamairiDataMap: ohakamairiDataMap,
      nenkinKikinDataList: nenkinKikinDataList,
      insuranceDataList: insuranceDataList,
    );
  }

  /// 前回計算時と入力が同じなら false。変わっていれば記録して true
  bool _inputsChanged(String key, List<Object?> inputs) {
    final List<Object?>? prev = _derivedInputs[key];

    if (prev != null && prev.length == inputs.length) {
      bool same = true;

      for (int i = 0; i < inputs.length; i++) {
        final Object? a = prev[i];
        final Object? b = inputs[i];

        // freezed の Map / List は getter のたびに View で包み直されるが、View の == は中身のインスタンス同一性で比較する。
        // 文字列は値で比較される。いずれも要素の深い比較はしないので軽量。
        if (a != b) {
          same = false;
          break;
        }
      }

      if (same) {
        return false;
      }
    }

    _derivedInputs[key] = inputs;
    return true;
  }

  /// お寺の写真ファイル名（例: .../20240101_1234xx.jpg）から、日付ごとの到着時刻バッジとお寺名を作る
  (Map<String, List<String>>, Map<String, String>) _makeTempleDateTimeMaps(Map<String, TempleModel> templeMap) {
    final Map<String, List<String>> templeDateTimeBadgeMap = <String, List<String>>{};
    final Map<String, String> templeDateTimeNameMap = <String, String>{};

    templeMap.forEach((String key, TempleModel value) {
      final List<String> tempBadgeList = <String>[];
      final Map<String, String> tempNameMap = <String, String>{};
      final String keyWithoutHyphen = key.replaceAll('-', '');

      try {
        for (final TempleDataModel element in value.templeDataList) {
          final List<TemplePhotoModel>? photoModelList = element.templePhotoModelList;
          if (photoModelList == null) {
            continue;
          }

          for (final TemplePhotoModel element2 in photoModelList) {
            final String? hourMinute = _getTemplePhotoHourMinute(
              photos: element2.templephotos,
              keyWithoutHyphen: keyWithoutHyphen,
            );

            if (hourMinute != null) {
              tempBadgeList.add(hourMinute);
              tempNameMap['$key|$hourMinute'] = element2.temple;
            }
          }
        }
      } catch (e) {
        debugPrint('templeMap processing error for key $key: $e');
        return;
      }

      if (tempBadgeList.isNotEmpty) {
        templeDateTimeBadgeMap[key] = tempBadgeList;
        templeDateTimeNameMap.addAll(tempNameMap);
      }
    });

    return (templeDateTimeBadgeMap, templeDateTimeNameMap);
  }

  /// 写真リストの先頭（ソート順）ファイル名から "HH:mm" を取り出す。該当しなければ null
  String? _getTemplePhotoHourMinute({required List<String> photos, required String keyWithoutHyphen}) {
    if (photos.isEmpty) {
      return null;
    }

    final List<String> sortedPhotos = List<String>.from(photos)..sort();
    final String fileName = sortedPhotos.first;
    if (fileName.isEmpty) {
      return null;
    }

    final String lastPart = fileName.split('/').last;
    if (lastPart.isEmpty) {
      return null;
    }

    final List<String> exFileNameLast = lastPart.split('_');
    if (exFileNameLast.first != keyWithoutHyphen || exFileNameLast.length < 2) {
      return null;
    }

    final String timePart = exFileNameLast.last.split('.').first;
    if (timePart.length < 4) {
      return null;
    }

    return '${timePart.substring(0, 2)}:${timePart.substring(2, 4)}';
  }

  ///
  Map<String, List<Map<String, dynamic>>> _makeAllDateLifetimeSummaryMap(Map<String, LifetimeModel> lifetimeMap) {
    final Map<String, List<Map<String, dynamic>>> result = <String, List<Map<String, dynamic>>>{};

    lifetimeMap.forEach((String key, LifetimeModel value) {
      try {
        final List<String> lifetimeData = getLifetimeData(lifetimeModel: value);
        final Map<int, String> duplicateConsecutiveMap = getDuplicateConsecutiveMap(lifetimeData);
        result[key] = getStartEndTitleList(data: duplicateConsecutiveMap);
      } catch (e) {
        debugPrint('lifetimeMap processing error for key $key: $e');
      }
    });

    return result;
  }

  /// 表示中タブの年について、月ごと・項目ごとのクレジット合計を作る
  Map<int, Map<String, int>> _makeCreditSummaryTotalMap({
    required Map<String, List<CreditSummaryModel>> creditSummaryMap,
    required String homeTabYear,
  }) {
    final Map<int, Map<String, int>> creditSummaryTotalMap = <int, Map<String, int>>{};

    if (homeTabYear.isEmpty) {
      return creditSummaryTotalMap;
    }

    final List<String> creditItemList = utility.getCreditItemList();

    creditSummaryMap.forEach((String key, List<CreditSummaryModel> value) {
      final List<String> keyParts = key.split('-');
      if (keyParts.length < 2 || keyParts[0] != homeTabYear) {
        return;
      }

      final int? monthInt = int.tryParse(keyParts[1]);
      if (monthInt == null) {
        return;
      }

      // 項目の並び順は creditItemList の順を維持する
      final Map<String, int> creditCategoryTotalMap = <String, int>{};

      for (final String item in creditItemList) {
        bool found = false;
        int total = 0;

        for (final CreditSummaryModel element in value) {
          if (element.item == item) {
            found = true;
            total += element.price;
          }
        }

        if (found) {
          creditCategoryTotalMap[item] = total;
        }
      }

      creditSummaryTotalMap[monthInt] = creditCategoryTotalMap;
    });

    return creditSummaryTotalMap;
  }

  //==========================================================================//
  // タブ
  //==========================================================================//

  ///
  void _attachTabController(TabController newController) {
    if (newController == _tabController) {
      return;
    }

    _tabController?.removeListener(_onTabChanged);
    _tabController = newController;
    newController.addListener(_onTabChanged);

    final int index = newController.index;

    if (index >= 0 && index < _tabs.length) {
      final String ym = _tabs[index].label;

      // build() 中のプロバイダー変更は禁止なので、フレーム後に遅延実行
      Future<void>(() {
        if (mounted) {
          appParamNotifier.setHomeTabYearMonth(yearmonth: ym);
          _fetchGeolocAround(ym);
          _scheduleDataSync();
        }
      });
    }
  }

  ///
  void _onTabChanged() {
    final TabController? c = _tabController;

    if (c == null || c.indexIsChanging) {
      return;
    }

    final int index = c.index;

    if (index >= 0 && index < _tabs.length) {
      final String ym = _tabs[index].label;

      if (ym.isNotEmpty) {
        appParamNotifier.setHomeTabYearMonth(yearmonth: ym);
        _fetchGeolocAround(ym);

        // 表示年が変わるとクレジット集計が変わるため同期を予約（入力が同じなら何もしない）
        _scheduleDataSync();
      }
    }
  }

  /// 指定月 + 前後1ヶ月のgeoloc を取得（取得済みの月はスキップされる）
  void _fetchGeolocAround(String yearmonth) {
    final List<String> parts = yearmonth.split('-');
    if (parts.length < 2) {
      return;
    }

    final int year = int.tryParse(parts[0]) ?? 0;
    final int month = int.tryParse(parts[1]) ?? 0;
    if (year == 0 || month == 0) {
      return;
    }

    // DateTime の月繰り上がり/繰り下がりを利用して前後の月を求める
    final DateTime prev = DateTime(year, month - 1);
    final DateTime next = DateTime(year, month + 1);

    geolocNotifier.getGeolocDataByYearmonth(yearmonth);
    geolocNotifier.getGeolocDataByYearmonth(prev.yyyymm);
    geolocNotifier.getGeolocDataByYearmonth(next.yyyymm);
  }

  /// lifetimeList から年月タブを作る（元データと「今月」が変わらなければ前回のタブを使い回す）
  void _makeTab() {
    final List<LifetimeModel> lifetimeList = ref.read(lifetimeProvider).lifetimeList;
    final String nowYm = DateTime.now().yyyymm;

    if (lifetimeList == _tabsSourceList && nowYm == _tabsSourceNowYm) {
      return;
    }

    _tabsSourceList = lifetimeList;
    _tabsSourceNowYm = nowYm;

    if (lifetimeList.isEmpty) {
      _tabs = <TabInfo>[];
      return;
    }

    try {
      final Set<String> yearmonthSet = <String>{nowYm};

      for (final LifetimeModel element in lifetimeList) {
        yearmonthSet.add('${element.year}-${element.month}');
      }

      // 新しい年月が先頭（year / month はゼロ埋め文字列なので文字列比較で年月順になる）
      final List<String> yearmonthList = yearmonthSet.toList()..sort((String a, String b) => b.compareTo(a));

      _tabs = <TabInfo>[
        for (final String element in yearmonthList)
          TabInfo(element, MonthlyLifetimeDisplayPage(key: ValueKey<String>(element), yearmonth: element)),
      ];
    } catch (e) {
      debugPrint('_makeTab error: $e');
      _tabs = <TabInfo>[];
    }
  }

  ///
  Object getBottomMenuContents({required int index}) {
    // コールバック内なので watch ではなく read で参照する
    final AppParamState appParamState = ref.read(appParamProvider);

    try {
      switch (index) {
        case 0:
          if (appParamState.keepGoldMap.isEmpty ||
              appParamState.keepStockMap.isEmpty ||
              appParamState.keepToushiShintakuMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: _notReadyContent('資産情報が作成されていません。'),
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
                  content: _notReadyContent('appParamState.keepMoneySpendItemMapが作成されていません。'),
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
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: _notReadyContent('appParamState.keepWalkModelMapが作成されていません。'),
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
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: _notReadyContent('appParamState.keepWorkTimeMapが作成されていません。'),
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
              widget: WorkInfoMonthlyDisplayAlert(yearmonth: yearmonth),
            );
          }

        case 6:
          if (appParamState.keepWeatherMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: _notReadyContent('appParamState.keepWeatherMapが作成されていません。'),
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
              widget: MonthlyWeatherDisplayAlert(yearmonth: yearmonth),
            );
          }

        case 7:
          if (appParamState.keepOhakamairiDataMap.isEmpty) {
            // ignore: always_specify_types
            Future.delayed(Duration.zero, () {
              if (mounted) {
                error_dialog(
                  context: context,
                  title: '表示できません。',
                  content: _notReadyContent('appParamState.keepOhakamairiDataMapが作成されていません。'),
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
              widget: OhakamairiDataDisplayAlert(yearmonth: yearmonth),
            );
          }
      }
    } catch (e) {
      debugPrint('getBottomMenuContents error: $e');
    }

    return const SizedBox.shrink();
  }

  /// データ未取得時のメッセージ。まだ API 通信中なら「読み込み中」と案内する
  String _notReadyContent(String message) {
    if (ref.read(httpClientProvider).inFlightCount.value > 0) {
      return 'データを読み込み中です。しばらくしてからもう一度お試しください。';
    }

    return message;
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

                    final Set<String> yearSet = <String>{
                      for (final String key in ref.read(lifetimeProvider).lifetimeMap.keys) key.split('-').first,
                    };

                    final List<String> years = yearSet.toList()..sort();

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
                    final AppParamState appParamState = ref.read(appParamProvider);

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
                    FaIcon(FontAwesomeIcons.coins),
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
                    FaIcon(FontAwesomeIcons.amazon),
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
                    FaIcon(FontAwesomeIcons.stamp),
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
                    FaIcon(FontAwesomeIcons.stamp),
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
                    FaIcon(FontAwesomeIcons.stamp),
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
}

/////////////////////////////////////////////////////////////////////////////////

/// API 通信中（起動時の一括取得・月切替時の位置情報取得など）だけ表示する小さなくるくる
class _ApiLoadingIndicator extends ConsumerWidget {
  const _ApiLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<int>(
      valueListenable: ref.watch(httpClientProvider).inFlightCount,
      builder: (BuildContext context, int count, Widget? child) {
        if (count <= 0) {
          return const SizedBox.shrink();
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        );
      },
    );
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

                child: (index == 7)
                    ? Opacity(opacity: 0.5, child: Image.asset('assets/images/toyoda_kamon.png', width: 25, height: 25))
                    : (bottomNavigationMenuIcons[index] is FaIconData)
                        ? FaIcon(bottomNavigationMenuIcons[index] as FaIconData, color: Colors.white.withValues(alpha: 0.3))
                        : Icon(bottomNavigationMenuIcons[index] as IconData, color: Colors.white.withValues(alpha: 0.3)),
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

    // 駅コード → 駅 のマップ（ループ内で毎回 where 検索しない）
    final Map<int, StationModel> stationById = <int, StationModel>{};
    for (final StationModel station in stationList) {
      stationById.putIfAbsent(station.id, () => station);
    }

    // 最寄り時刻の手動補正（ループ外で 1 回だけ取得）
    final Map<String, String>? adjustTypeMap = utility.getStampNearestGeolocTimeAdjustMap()[type];

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

          final StationModel? stationModel = stationById[stationCodeInt];

          if (stationModel == null) {
            continue;
          }

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

          final String? adjustedTime = adjustTypeMap?[element.stationCode];
          if (adjustedTime != null) {
            nearestGeolocTime = adjustedTime;
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
