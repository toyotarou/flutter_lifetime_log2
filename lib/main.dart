import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/controllers_mixin.dart';
import 'screens/home_screen.dart';

void main() => runApp(const AppRoot());

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
  }

  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: HomeScreen(
        holidayList: holidayState.holidayList,
        walkMap: walkState.walkMap,
        moneyMap: moneyState.moneyMap,
        lifetimeItemList: lifetimeItemState.lifetimeItemList,
        geolocMap: geolocState.geolocMap,
        templeMap: templeState.templeMap,
      ),
    );
  }
}
