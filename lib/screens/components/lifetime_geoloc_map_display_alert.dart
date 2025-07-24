import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_model.dart';

class LifetimeGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocMapDisplayAlert({super.key, required this.date, this.geolocList, this.templeMap});

  final String date;
  final List<GeolocModel>? geolocList;
  final TempleModel? templeMap;

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
