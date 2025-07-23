import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class LifetimeGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocMapDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<LifetimeGeolocMapDisplayAlert> createState() => _LifetimeGeolocMapDisplayAlertState();
}

class _LifetimeGeolocMapDisplayAlertState extends ConsumerState<LifetimeGeolocMapDisplayAlert>
    with ControllersMixin<LifetimeGeolocMapDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
