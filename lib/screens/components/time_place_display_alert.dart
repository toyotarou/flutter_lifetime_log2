import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/time_place_model.dart';

class TimePlaceDisplayAlert extends ConsumerStatefulWidget {
  const TimePlaceDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<TimePlaceDisplayAlert> createState() => _TimePlaceDisplayAlertState();
}

class _TimePlaceDisplayAlertState extends ConsumerState<TimePlaceDisplayAlert>
    with ControllersMixin<TimePlaceDisplayAlert> {
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
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(thickness: 5, color: Colors.greenAccent.withValues(alpha: 0.4)),

                  Expanded(child: _displayTimePlaceList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayTimePlaceList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepTimePlaceMap[widget.date]?.forEach((TimePlaceModel element) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),

          child: Row(
            children: <Widget>[
              Expanded(child: Text(element.time)),
              Expanded(flex: 3, child: Text(element.place)),
              Expanded(
                child: Container(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency())),
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
