import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/controllers_mixin.dart';
import 'screens/home_screen.dart';
import 'utility/utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

    // 各データを並行して取得する（取得できたものから順に HomeScreen へ反映される）
    lifetimeNotifier.getAllLifetimeData();
    holidayNotifier.getAllHolidayData();
    walkNotifier.getAllWalkData();
    moneyNotifier.getAllMoneyData();
    lifetimeItemNotifier.getAllLifetimeItemData();
    // geoloc はタブ切り替え時に月単位で取得するため、ここでは呼ばない
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
    amazonPurchaseNotifier.getAllAmazonPurchaseData();
    stampRallyMetroAllStationNotifier.getAllStampRallyMetroAllStationData();
    stampRallyMetro20AnniversaryNotifier.getAllMetroStamp20AnniversaryData();
    stampRallyMetroPokepokeNotifier.getAllStampRallyMetroPokepokeData();
    tokyoMunicipalNotifier.getAllTokyoMunicipalData();
    moneySumNotifier.getAllMoneySumData();
    fortuneNotifier.getAllFortuneData();
    tarotNotifier.getAllTarotData();
    tarothistoryNotifier.getAllTarotHistoryData();
    toushiShintakuHistoryNotifier.getAllToushiShintakuHistoryData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Utility.showError() のスナックバー表示に使う
      scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,

      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const <Locale>[Locale('en'), Locale('ja')],

      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.greenAccent.withOpacity(0.4)),
        ),
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark),
        highlightColor: Colors.grey,
      ),

      themeMode: ThemeMode.dark,
      title: 'LIFETIME LOG',
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        // HomeScreen が必要なデータを自分で watch するため、MyApp（MaterialApp）はデータ更新で再構築されない
        child: const HomeScreen(),
      ),
    );
  }
}
