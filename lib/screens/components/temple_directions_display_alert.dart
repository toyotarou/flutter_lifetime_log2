import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class TempleDirectionsDisplayAlert extends ConsumerStatefulWidget {
  const TempleDirectionsDisplayAlert({super.key});

  @override
  ConsumerState<TempleDirectionsDisplayAlert> createState() => _TempleDirectionsDisplayAlertState();
}

class _TempleDirectionsDisplayAlertState extends ConsumerState<TempleDirectionsDisplayAlert>
    with ControllersMixin<TempleDirectionsDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
