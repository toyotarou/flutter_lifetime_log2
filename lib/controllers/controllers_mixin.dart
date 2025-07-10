// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lifetime/lifetime.dart';
import 'lifetime_item/lifetime_item.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  LifetimeState get lifetimeState => ref.watch(lifetimeProvider);

  Lifetime get lifetimeNotifier => ref.read(lifetimeProvider.notifier);

  //==========================================//

  LifetimeItemState get lifetimeItemState => ref.watch(lifetimeItemProvider);

  LifetimeItem get lifetimeItemNotifier => ref.read(lifetimeItemProvider.notifier);

  //==========================================//
}
