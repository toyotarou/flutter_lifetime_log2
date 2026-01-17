import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../models/transportation_model.dart';

class LifetimeGeolocGhostTempleInfoAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocGhostTempleInfoAlert({super.key});

  @override
  ConsumerState<LifetimeGeolocGhostTempleInfoAlert> createState() => _LifetimeGeolocGhostTempleInfoAlertState();
}

class _LifetimeGeolocGhostTempleInfoAlertState extends ConsumerState<LifetimeGeolocGhostTempleInfoAlert>
    with ControllersMixin<LifetimeGeolocGhostTempleInfoAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(appParamState.selectedGhostPolylineDate), const SizedBox.shrink()],
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              if (appParamState.keepTempleMap[appParamState.selectedGhostPolylineDate] != null) ...<Widget>[
                displayGhostTempleInfoWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGhostTempleInfoWidget() {
    final TempleModel templeModel = appParamState.keepTempleMap[appParamState.selectedGhostPolylineDate]!;

    String startPoint = templeModel.startPoint;

    String endPoint = templeModel.endPoint;

    if (appParamState.keepStationList.isNotEmpty) {
      if (int.tryParse(startPoint) != null) {
        final StationModel? matchedStartStation = appParamState.keepStationList
            .where((StationModel value) => value.id == startPoint.toInt())
            .firstOrNull;

        if (matchedStartStation != null) {
          startPoint = matchedStartStation.stationName;
        }
      }

      if (int.tryParse(endPoint) != null) {
        final StationModel? matchedEndStation = appParamState.keepStationList
            .where((StationModel value) => value.id == endPoint.toInt())
            .firstOrNull;

        if (matchedEndStation != null) {
          endPoint = matchedEndStation.stationName;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(startPoint), const SizedBox.shrink()],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const SizedBox.shrink(), Text(endPoint)],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: context.screenSize.height * 0.3,
          child: displayGhostTempleInfoList(templeDataList: templeModel.templeDataList),
        ),
      ],
    );
  }

  ///
  Widget displayGhostTempleInfoList({required List<TempleDataModel> templeDataList}) {
    final List<Widget> list = <Widget>[];

    for (final TempleDataModel element in templeDataList) {
      list.add(
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
          ),
          padding: const EdgeInsets.only(bottom: 3),
          margin: const EdgeInsets.only(bottom: 3),
          child: Text(element.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        ),
      );
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
