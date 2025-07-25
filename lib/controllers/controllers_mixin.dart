// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'bank_input/bank_input.dart';
import 'geoloc/geoloc.dart';
import 'holiday/holiday.dart';
import 'lifetime/lifetime.dart';
import 'lifetime_input/lifetime_input.dart';
import 'lifetime_item/lifetime_item.dart';
import 'money/money.dart';
import 'money_input/money_input.dart';
import 'temple/temple.dart';
import 'transportation/transportation.dart';
import 'walk/walk.dart';
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
}
