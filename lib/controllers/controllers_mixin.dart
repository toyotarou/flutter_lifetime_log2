import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_get_data/credit_summary/credit_summary.dart';
import '_get_data/directions/directions.dart';
import '_get_data/fund/fund.dart';
import '_get_data/geoloc/geoloc.dart';
import '_get_data/gold/gold.dart';
import '_get_data/holiday/holiday.dart';
import '_get_data/lifetime/lifetime.dart';
import '_get_data/lifetime_item/lifetime_item.dart';
import '_get_data/money/money.dart';
import '_get_data/money_spend/money_spend.dart';
import '_get_data/money_spend_item/money_spend_item.dart';
import '_get_data/salary/salary.dart';
import '_get_data/stock/stock.dart';
import '_get_data/temple/temple.dart';
import '_get_data/time_place/time_place.dart';
import '_get_data/toushi_shintaku/toushi_shintaku.dart';
import '_get_data/transportation/transportation.dart';
import '_get_data/walk/walk.dart';
import '_get_data/weather/weather.dart';
import '_get_data/work_time/work_time.dart';

import 'app_param/app_param.dart';

import 'bank_input/bank_input.dart';
import 'lifetime_input/lifetime_input.dart';
import 'money_input/money_input.dart';
import 'spend_input/spend_input.dart';
import 'stock_input/stock_input.dart';
import 'toushi_shintaku_input/toushi_shintaku_input.dart';
import 'walk_input/walk_input.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  LifetimeState get lifetimeState => ref.watch(lifetimeProvider);

  Lifetime get lifetimeNotifier => ref.read(lifetimeProvider.notifier);

  //==========================================//

  LifetimeItemState get lifetimeItemState => ref.watch(lifetimeItemProvider);

  LifetimeItem get lifetimeItemNotifier => ref.read(lifetimeItemProvider.notifier);

  //==========================================//

  HolidayState get holidayState => ref.watch(holidayProvider);

  Holiday get holidayNotifier => ref.read(holidayProvider.notifier);

  //==========================================//

  WalkState get walkState => ref.watch(walkProvider);

  Walk get walkNotifier => ref.read(walkProvider.notifier);

  //==========================================//

  MoneyState get moneyState => ref.watch(moneyProvider);

  Money get moneyNotifier => ref.read(moneyProvider.notifier);

  //==========================================//

  LifetimeInputState get lifetimeInputState => ref.watch(lifetimeInputProvider);

  LifetimeInput get lifetimeInputNotifier => ref.read(lifetimeInputProvider.notifier);

  //==========================================//

  WalkInputState get walkInputState => ref.watch(walkInputProvider);

  WalkInput get walkInputNotifier => ref.read(walkInputProvider.notifier);

  //==========================================//

  MoneyInputState get moneyInputState => ref.watch(moneyInputProvider);

  MoneyInput get moneyInputNotifier => ref.read(moneyInputProvider.notifier);

  //==========================================//

  GeolocState get geolocState => ref.watch(geolocProvider);

  Geoloc get geolocNotifier => ref.read(geolocProvider.notifier);

  //==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

  //==========================================//

  TransportationState get transportationState => ref.watch(transportationProvider);

  Transportation get transportationNotifier => ref.read(transportationProvider.notifier);

  //==========================================//

  BankInputState get bankInputState => ref.watch(bankInputProvider);

  BankInput get bankInputNotifier => ref.read(bankInputProvider.notifier);

  //==========================================//

  MoneySpendState get moneySpendState => ref.watch(moneySpendProvider);

  MoneySpend get moneySpendNotifier => ref.read(moneySpendProvider.notifier);

  //==========================================//

  SpendInputState get spendInputState => ref.watch(spendInputProvider);

  SpendInput get spendInputNotifier => ref.read(spendInputProvider.notifier);

  //==========================================//

  WorkTimeState get workTimeState => ref.watch(workTimeProvider);

  WorkTime get workTimeNotifier => ref.read(workTimeProvider.notifier);

  //==========================================//

  WeatherState get weatherState => ref.watch(weatherProvider);

  Weather get weatherNotifier => ref.read(weatherProvider.notifier);

  //==========================================//

  MoneySpendItemState get moneySpendItemState => ref.watch(moneySpendItemProvider);

  MoneySpendItem get moneySpendItemNotifier => ref.read(moneySpendItemProvider.notifier);

  //==========================================//

  SalaryState get salaryState => ref.watch(salaryProvider);

  Salary get salaryNotifier => ref.read(salaryProvider.notifier);

  //==========================================//

  StockInputState get stockInputState => ref.watch(stockInputProvider);

  StockInput get stockInputNotifier => ref.read(stockInputProvider.notifier);

  //==========================================//

  GoldState get goldState => ref.watch(goldProvider);

  Gold get goldNotifier => ref.read(goldProvider.notifier);

  //==========================================//

  StockState get stockState => ref.watch(stockProvider);

  Stock get stockNotifier => ref.read(stockProvider.notifier);

  //==========================================//

  ToushiShintakuState get toushiShintakuState => ref.watch(toushiShintakuProvider);

  ToushiShintaku get toushiShintakuNotifier => ref.read(toushiShintakuProvider.notifier);

  //==========================================//

  CreditSummaryState get creditSummaryState => ref.watch(creditSummaryProvider);

  CreditSummary get creditSummaryNotifier => ref.read(creditSummaryProvider.notifier);

  //==========================================//

  FundState get fundState => ref.watch(fundProvider);

  Fund get fundNotifier => ref.read(fundProvider.notifier);

  //==========================================//

  TimePlaceState get timePlaceState => ref.watch(timePlaceProvider);

  TimePlace get timePlaceNotifier => ref.read(timePlaceProvider.notifier);

  //==========================================//

  ToushiShintakuInputState get toushiShintakuInputState => ref.watch(toushiShintakuInputProvider);

  ToushiShintakuInput get toushiShintakuInputNotifier => ref.read(toushiShintakuInputProvider.notifier);

  //==========================================//

  Directions get directionsNotifier => ref.read(directionsProvider.notifier);

  //==========================================//
}
