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
  // 駅名 -> 路線番号 は TransportationState.stationNameTrainNumberMap を使うため不要になった
  // （keepStationList は重複駅の絞り込み後のリストなので、駅によっては路線が拾えず「バス」になっていた）
  // List<StationModel>? _stationTrainMapSource;
  // Map<String, Set<String>> _stationTrainMap = <String, Set<String>>{};

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

    // if (_stationTrainMapSource != state.keepStationList) {
    //   _stationTrainMapSource = state.keepStationList;
    //
    //   final Map<String, Set<String>> map = <String, Set<String>>{};
    //   for (final StationModel station in state.keepStationList) {
    //     map.putIfAbsent(station.stationName, () => <String>{}).add(station.trainNumber);
    //   }
    //   _stationTrainMap = map;
    // }
    //
    // final Map<String, Set<String>> stationTrainMap = _stationTrainMap;

    // flutter_train_boarding と同じく、重複駅の絞り込みをしない全駅から作った 駅名 -> 路線番号リスト を使う
    final Map<String, List<String>> stationTrainMap = transportationState.stationNameTrainNumberMap;

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

        // final Set<String> aTrainNumbers = stationTrainMap[spotA.name] ?? <String>{};
        // final Set<String> bTrainNumbers = stationTrainMap[spotB.name] ?? <String>{};
        final Set<String> aTrainNumbers = (stationTrainMap[spotA.name] ?? <String>[]).toSet();
        final Set<String> bTrainNumbers = (stationTrainMap[spotB.name] ?? <String>[]).toSet();
        final List<String> commonTrainNumbers = aTrainNumbers.intersection(bTrainNumbers).toList();

        // flutter_train_boarding と同じ、駅データでは路線が拾えない区間の固定名
        final String? specialRouteName = _getSpecialRouteName(spotA.name, spotB.name);

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
                child: (specialRouteName != null)
                    ? Text(specialRouteName)
                    : commonTrainNumbers.isEmpty
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

  ///
  /// flutter_train_boarding（polyline_station_info_alert.dart の displayPolylineTrain）と同じ固定区間
  String? _getSpecialRouteName(String a, String b) {
    bool isPair(String x, String y) => (a == x && b == y) || (a == y && b == x);

    if (isPair('上野', '長野')) {
      return '北陸新幹線';
    }
    if (isPair('東京', '新大阪')) {
      return '東海道新幹線';
    }
    if (isPair('宮島口', '宮島') || isPair('宮島', '広島港')) {
      return '西日本宮島フェリー';
    }
    return null;
  }
}
