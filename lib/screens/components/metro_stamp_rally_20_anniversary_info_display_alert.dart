import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class MetroStampRally20AnniversaryInfoDisplayAlert extends ConsumerStatefulWidget {
  const MetroStampRally20AnniversaryInfoDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<MetroStampRally20AnniversaryInfoDisplayAlert> createState() =>
      _MetroStampRally20AnniversaryInfoDisplayAlertState();
}

class _MetroStampRally20AnniversaryInfoDisplayAlertState
    extends ConsumerState<MetroStampRally20AnniversaryInfoDisplayAlert>
    with ControllersMixin<MetroStampRally20AnniversaryInfoDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
