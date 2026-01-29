import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../models/transportation_model.dart';

class RouteInfoDisplayAlert extends ConsumerStatefulWidget {
  const RouteInfoDisplayAlert({super.key, required this.date, this.spotDataModelList});

  final String date;
  final List<SpotDataModel>? spotDataModelList;

  @override
  ConsumerState<RouteInfoDisplayAlert> createState() => _RouteInfoDisplayAlertState();
}

class _RouteInfoDisplayAlertState extends ConsumerState<RouteInfoDisplayAlert>
    with ControllersMixin<RouteInfoDisplayAlert> {
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

  /// ルート情報をリスト表示するウィジェットを構築
  Widget _buildRouteList(List<SpotDataModel> spots) {
    // 状態を一度取得して、ビルド内での一貫性を確保
    final AppParamState state = appParamState;

    // 駅名から路線番号（Set）へのマップを構築し、検索を高速化 (O(N))
    final Map<String, Set<String>> stationTrainMap = <String, Set<String>>{};
    for (final StationModel station in state.keepStationList) {
      stationTrainMap.putIfAbsent(station.stationName, () => <String>{}).add(station.trainNumber);
    }

    return ListView.builder(
      itemCount: spots.length - 1,
      itemBuilder: (BuildContext context, int i) {
        final SpotDataModel spotA = spots[i];
        final SpotDataModel spotB = spots[i + 1];

        // 両方のスポットを通過する路線の積集合を取得
        final Set<String> aTrainNumbers = stationTrainMap[spotA.name] ?? <String>{};
        final Set<String> bTrainNumbers = stationTrainMap[spotB.name] ?? <String>{};
        final List<String> commonTrainNumbers = aTrainNumbers.intersection(bTrainNumbers).toList();

        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 10, color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text(spotA.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward, size: 10),
                    ),
                    Expanded(
                      child: Text(spotB.name, textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (commonTrainNumbers.isEmpty)
                  const Text('バス')
                else
                  ...commonTrainNumbers.map((String trainNumber) {
                    final String trainName = state.keepTrainMap[trainNumber] ?? 'バス';
                    return Text(trainName);
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
