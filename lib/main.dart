import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/controllers_mixin.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

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
      ),
    );
  }
}
