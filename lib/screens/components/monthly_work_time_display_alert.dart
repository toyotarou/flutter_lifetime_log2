import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/work_time_model.dart';

class MonthlyWorkTimeDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyWorkTimeDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyWorkTimeDisplayAlert> createState() => _MonthlyWorkTimeDisplayAlertState();
}

class _MonthlyWorkTimeDisplayAlertState extends ConsumerState<MonthlyWorkTimeDisplayAlert>
    with ControllersMixin<MonthlyWorkTimeDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.yearmonth), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                displayGenbaName(),

                const SizedBox(height: 10),

                Expanded(child: displayMonthlyWorkTimeList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGenbaName() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.5))),

      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('エージェント'),

                  Text(
                    (appParamState.keepWorkTimeMap[widget.yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[widget.yearmonth]!.agentName
                        : '',
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('現場'),

                  Text(
                    (appParamState.keepWorkTimeMap[widget.yearmonth] != null)
                        ? appParamState.keepWorkTimeMap[widget.yearmonth]!.genbaName
                        : '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayMonthlyWorkTimeList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepWorkTimeMap[widget.yearmonth]?.data.forEach((WorkTimeDataModel element) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: Row(
            children: <Widget>[
              Expanded(child: Text(element.day)),
              Expanded(
                child: Container(alignment: Alignment.topRight, child: Text(element.start)),
              ),
              Expanded(
                child: Container(alignment: Alignment.topRight, child: Text(element.end)),
              ),
            ],
          ),
        ),
      );
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
