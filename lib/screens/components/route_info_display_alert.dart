import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../models/transportation_model.dart';

class RouteInfoDisplayAlert extends ConsumerStatefulWidget {
  const RouteInfoDisplayAlert({super.key, required this.date, this.spotDataModelList, required this.oufuku});

  final String date;
  final List<SpotDataModel>? spotDataModelList;
  final bool oufuku;

  @override
  ConsumerState<RouteInfoDisplayAlert> createState() => _RouteInfoDisplayAlertState();
}

class _RouteInfoDisplayAlertState extends ConsumerState<RouteInfoDisplayAlert>
    with ControllersMixin<RouteInfoDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    final List<SpotDataModel>? spots = widget.spotDataModelList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: (spots == null || spots.length < 2)
                      ? const Center(child: Text('表示するルート情報がありません'))
                      : _buildRouteList(spots),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildRouteList(List<SpotDataModel> spots) {
    final AppParamState state = appParamState;

    final Map<String, Set<String>> stationTrainMap = <String, Set<String>>{};
    for (final StationModel station in state.keepStationList) {
      stationTrainMap.putIfAbsent(station.stationName, () => <String>{}).add(station.trainNumber);
    }

    final List<Widget> list = <Widget>[];

    if (widget.oufuku) {
      list.add(
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[Text('往復', style: TextStyle(color: Colors.yellowAccent))],
        ),
      );
    }

    for (int i = 0; i < spots.length; i++) {
      list.add(Text(spots[i].name));

      if (i < spots.length - 1) {
        final SpotDataModel spotA = spots[i];
        final SpotDataModel spotB = spots[i + 1];

        final Set<String> aTrainNumbers = stationTrainMap[spotA.name] ?? <String>{};
        final Set<String> bTrainNumbers = stationTrainMap[spotB.name] ?? <String>{};
        final List<String> commonTrainNumbers = aTrainNumbers.intersection(bTrainNumbers).toList();

        list.add(
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10), child: Icon(Icons.arrow_downward_sharp)),
                  if (widget.oufuku)
                    const Padding(padding: EdgeInsets.only(bottom: 10), child: Icon(Icons.arrow_upward_sharp)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: commonTrainNumbers.isEmpty
                    ? const Text('バス')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: commonTrainNumbers.map((String e) {
                          final String trainName = state.keepTrainMap[e] ?? 'バス';
                          return Text(trainName);
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      }
    }

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
