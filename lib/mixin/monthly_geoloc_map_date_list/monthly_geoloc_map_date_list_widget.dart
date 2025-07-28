import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import 'monthly_geoloc_map_date_list_mixin.dart';

class MonthlyGeolocMapDateListWidget extends ConsumerStatefulWidget {
  const MonthlyGeolocMapDateListWidget({super.key});

  @override
  ConsumerState<MonthlyGeolocMapDateListWidget> createState() => _MonthlyGeolocMapDateListWidgetState();
}

class _MonthlyGeolocMapDateListWidgetState extends ConsumerState<MonthlyGeolocMapDateListWidget>
    with ControllersMixin<MonthlyGeolocMapDateListWidget>, MonthlyGeolocMapDateListMixin {
  ///
  @override
  Widget build(BuildContext context) => buildContent(context);
}
