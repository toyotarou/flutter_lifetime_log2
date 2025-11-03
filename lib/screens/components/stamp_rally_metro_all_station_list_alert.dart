import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class StampRallyMetroAllStationListAlert extends ConsumerStatefulWidget {
  const StampRallyMetroAllStationListAlert({super.key});

  @override
  ConsumerState<StampRallyMetroAllStationListAlert> createState() => _StampRallyMetroAllStationListAlertState();
}

class _StampRallyMetroAllStationListAlertState extends ConsumerState<StampRallyMetroAllStationListAlert>
    with ControllersMixin<StampRallyMetroAllStationListAlert> {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('東京メトロ　全駅スタンプラリー'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayStationStampModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayStationStampModelList() {
    final List<Widget> list = <Widget>[];

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
