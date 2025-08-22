import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/controllers_mixin.dart';
import 'screens/home_screen.dart';

void main() async {
  await dotenv.load();

  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Key _appKey = UniqueKey();

  ///
  void restartApp() => setState(() => _appKey = UniqueKey());

  ///
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MyApp(key: _appKey, onRestart: restartApp),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.onRestart});

  // ignore: unreachable_from_main
  final VoidCallback onRestart;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with ControllersMixin<MyApp> {
  ///
  @override
  void initState() {
    super.initState();

    lifetimeNotifier.getAllLifetimeData();
    holidayNotifier.getAllHolidayData();
    walkNotifier.getAllWalkData();
    moneyNotifier.getAllMoneyData();
    lifetimeItemNotifier.getAllLifetimeItemData();
    geolocNotifier.getAllGeolocData();
    templeNotifier.getAllTempleData();
    transportationNotifier.getAllTransportationData();
    moneySpendNotifier.getAllMoneySpendData();
    workTimeNotifier.getAllWorkTimeData();
    weatherNotifier.getAllWeatherData();
    moneySpendItemNotifier.getAllMoneySpendItemData();
    salaryNotifier.getAllSalaryData();
    goldNotifier.getAllGoldData();
    stockNotifier.getAllStockData();
    toushiShintakuNotifier.getAllToushiShintakuData();
    creditSummaryNotifier.getAllCreditSummaryData();
    fundNotifier.getAllFundData();
    timePlaceNotifier.getAllTimePlaceData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const <Locale>[Locale('en'), Locale('ja')],
      theme: ThemeData.dark(useMaterial3: false),
      themeMode: ThemeMode.dark,
      title: 'LIFETIME LOG',
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: HomeScreen(
          holidayList: holidayState.holidayList,
          walkMap: walkState.walkMap,
          moneyMap: moneyState.moneyMap,
          lifetimeItemList: lifetimeItemState.lifetimeItemList,
          geolocMap: geolocState.geolocMap,
          templeMap: templeState.templeMap,
          transportationMap: transportationState.transportationMap,
          moneySpendMap: moneySpendState.moneySpendMap,
          workTimeMap: workTimeState.workTimeMap,
          workTimeDateMap: workTimeState.workTimeDateMap,
          weatherMap: weatherState.weatherMap,
          moneySpendItemMap: moneySpendItemState.moneySpendItemMap,
          salaryMap: salaryState.salaryMap,
          goldMap: goldState.goldMap,
          stockMap: stockState.stockMap,
          toushiShintakuMap: toushiShintakuState.toushiShintakuMap,
          stationList: transportationState.stationList,
          creditSummaryMap: creditSummaryState.creditSummaryMap,
          fundRelationMap: fundState.fundRelationMap,
          stockTickerMap: stockState.stockTickerMap,
          toushiShintakuRelationalMap: toushiShintakuState.toushiShintakuRelationalMap,
          timePlaceMap: timePlaceState.timePlaceMap,
        ),
      ),
    );
  }
}
