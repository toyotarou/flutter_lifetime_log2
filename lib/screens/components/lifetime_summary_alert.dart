import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/functions.dart';
import '../parts/cross_calendar.dart';

class LifetimeSummaryAlert extends ConsumerStatefulWidget {
  const LifetimeSummaryAlert({super.key});

  @override
  ConsumerState<LifetimeSummaryAlert> createState() => _LifetimeSummaryAlertState();
}

class _LifetimeSummaryAlertState extends ConsumerState<LifetimeSummaryAlert>
    with ControllersMixin<LifetimeSummaryAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    final List<String> years = <String>['2023', '2024', '2025'];

    final List<String> monthDays = generateFullMonthDays();

    final List<double> rowHeights = List<double>.generate(
      years.length + 1,
      (int i) => i == 0 ? 48 : context.screenSize.height * 0.2,
    );
    final List<double> colWidths = List<double>.generate(monthDays.length + 1, (int i) => i == 0 ? 96 : 120);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CrossCalendar(
              years: years,
              monthDays: monthDays,
              headerHeight: rowHeights[0],
              leftColWidth: colWidths[0],
              rowHeights: rowHeights,
              colWidths: colWidths,
            ),
          ),
        ],
      ),
    );
  }
}
