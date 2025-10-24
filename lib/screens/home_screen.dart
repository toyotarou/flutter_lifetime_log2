import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/controllers_mixin.dart';
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
import '../models/salary_model.dart';
import '../models/stock_model.dart';
import '../models/temple_model.dart';
import '../models/time_place_model.dart';
import '../models/toushi_shintaku_model.dart';
import '../models/transportation_model.dart';
import '../models/walk_model.dart';
import '../models/weather_model.dart';
import '../models/work_time_model.dart';
import '../utility/utility.dart';
import 'components/amazon_purchase_list_alert.dart';
import 'components/bank_data_input_alert.dart';
import 'components/lifetime_summary_alert.dart';
import 'components/money_in_possession_display_alert.dart';
import 'components/salary_list_alert.dart';
import 'components/spend_each_year_display_alert.dart';
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
    required this.creditSummaryMap,
    required this.fundRelationMap,
    required this.stockTickerMap,
    required this.toushiShintakuRelationalMap,
    required this.timePlaceMap,
    required this.amazonPurchaseMap,
  });

  final List<String> holidayList;
  final Map<String, WalkModel> walkMap;
  final Map<String, MoneyModel> moneyMap;
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
  final Map<String, List<CreditSummaryModel>> creditSummaryMap;
  final Map<int, List<FundModel>> fundRelationMap;
  final Map<String, List<StockModel>> stockTickerMap;
  final Map<int, List<ToushiShintakuModel>> toushiShintakuRelationalMap;
  final Map<String, List<TimePlaceModel>> timePlaceMap;
  final Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final List<TabInfo> _tabs = <TabInfo>[];

  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appParamNotifier.setKeepHolidayList(list: widget.holidayList);
      appParamNotifier.setKeepWalkModelMap(map: widget.walkMap);
      appParamNotifier.setKeepMoneyMap(map: widget.moneyMap);
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
    });

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
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
                  final List<String> yList = <String>[];
                  lifetimeState.lifetimeMap.forEach((String key, LifetimeModel value) {
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

              const SizedBox(height: 30),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              const SizedBox(height: 30),

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

              const SizedBox(height: 30),

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

              const SizedBox(height: 30),

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

              const SizedBox(height: 30),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              const SizedBox(height: 30),

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

              const SizedBox(height: 30),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              const SizedBox(height: 30),

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
