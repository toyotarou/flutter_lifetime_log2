import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stamp_rally_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'stamp_rally_map_alert.dart';
import 'stamp_rally_stamp_display_alert.dart';

class StampRallyMetroAllStationListAlert extends ConsumerStatefulWidget {
  const StampRallyMetroAllStationListAlert({super.key});

  @override
  ConsumerState<StampRallyMetroAllStationListAlert> createState() => _StampRallyMetroAllStationListAlertState();
}

class _StampRallyMetroAllStationListAlertState extends ConsumerState<StampRallyMetroAllStationListAlert>
    with ControllersMixin<StampRallyMetroAllStationListAlert> {
  Utility utility = Utility();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('東京メトロ　全駅スタンプラリー'),
                    GestureDetector(
                      onTap: () {
                        LifetimeDialog(
                          context: context,
                          widget: const StampRallyMapAlert(type: 'metro_all_station'),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('全${appParamState.keepStampRallyMetroAllStationMap.length}回'),
                          const Icon(Icons.map),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayStampRallyModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayStampRallyModelList() {
    final List<Widget> list = <Widget>[];

    final List<MapEntry<String, List<StampRallyModel>>> sortedEntries =
        appParamState.keepStampRallyMetroAllStationMap.entries.toList()..sort(
          (MapEntry<String, List<StampRallyModel>> a, MapEntry<String, List<StampRallyModel>> b) =>
              a.key.compareTo(b.key),
        );

    for (final MapEntry<String, List<StampRallyModel>> entry in sortedEntries) {
      final String key = entry.key;

      final List<StampRallyModel> value = entry.value;

      final String youbiStr = DateTime.parse(key).youbiStr;

      list.add(
        Container(
          decoration: BoxDecoration(
            color: utility.getYoubiColor(date: key, youbiStr: youbiStr, holiday: appParamState.keepHolidayList),
          ),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text('$key ${youbiStr.substring(0, 3)}'),
        ),
      );

      value.sort((StampRallyModel a, StampRallyModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));

      final Set<String> stationNames = <String>{};
      final List<Widget> list2 = <Widget>[];

      for (final StampRallyModel element in value) {
        if (stationNames.add(element.stationName)) {
          final String stamp =
              'http://toyohide.work/BrainLog/station_stamp/${element.imageFolder}/${element.imageCode}.png';

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      LifetimeDialog(
                        context: context,
                        widget: StampRallyStampDisplayAlert(imageUrl: stamp),
                      );
                    },

                    child: SizedBox(
                      width: 80,
                      child: Opacity(
                        opacity: 0.6,
                        child: Hero(
                          tag: stamp,

                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/no_image.png',
                            image: stamp,
                            imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) =>
                                Image.asset('assets/images/no_image.png'),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(width: 10),

                              Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: utility.getTrainColor(trainName: element.trainName),
                                    radius: 22,
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: DefaultTextStyle(
                                        style: const TextStyle(fontSize: 10),
                                        child: Column(
                                          children: <Widget>[
                                            const Spacer(),
                                            Text(element.imageFolder),
                                            Text(element.imageCode),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    element.trainName.replaceAll('東京メトロ', ''),
                                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(element.stationName),
                                    Text(element.posterPosition, style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }

      list.add(Column(children: list2));
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
