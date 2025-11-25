import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stamp_rally_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'stamp_rally_map_alert.dart';
import 'stamp_rally_stamp_alert.dart';

///
enum StampRallyListAlertKind {
  metro20Anniversary, // 東京メトロ 20周年スタンプラリー
  metroPokepoke, // 東京メトロ ポケポケ
  metroAllStation, // 東京メトロ 全駅スタンプラリー
}

///
class StampRallyListAlert extends ConsumerStatefulWidget {
  const StampRallyListAlert({super.key, required this.kind});

  final StampRallyListAlertKind kind;

  @override
  ConsumerState<StampRallyListAlert> createState() => _StampRallyListAlertState();
}

class _StampRallyListAlertState extends ConsumerState<StampRallyListAlert> with ControllersMixin<StampRallyListAlert> {
  final Utility utility = Utility();

  ///
  String get _title {
    switch (widget.kind) {
      case StampRallyListAlertKind.metro20Anniversary:
        return '東京メトロ　20周年スタンプラリー';
      case StampRallyListAlertKind.metroPokepoke:
        return '東京メトロ　ポケポケ';
      case StampRallyListAlertKind.metroAllStation:
        return '東京メトロ　全駅スタンプラリー';
    }
  }

  ///
  Map<String, List<StampRallyModel>> get _stampMap {
    switch (widget.kind) {
      case StampRallyListAlertKind.metro20Anniversary:
        return appParamState.keepStampRallyMetro20AnniversaryMap;
      case StampRallyListAlertKind.metroPokepoke:
        return appParamState.keepStampRallyMetroPokepokeMap;
      case StampRallyListAlertKind.metroAllStation:
        return appParamState.keepStampRallyMetroAllStationMap;
    }
  }

  ///
  String? get _mapAlertType {
    switch (widget.kind) {
      case StampRallyListAlertKind.metroAllStation:
        return 'metro_all_station';
      case StampRallyListAlertKind.metro20Anniversary:
        return 'metro_20_anniversary';
      case StampRallyListAlertKind.metroPokepoke:
        return 'metro_pokepoke';
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final int totalCount = _stampMap.length;

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_title),

                        if (widget.kind == StampRallyListAlertKind.metroAllStation ||
                            widget.kind == StampRallyListAlertKind.metroPokepoke) ...<Widget>[
                          Icon(Icons.add_box, color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(width: 10),
                        ],
                      ],
                    ),
                    GestureDetector(
                      onTap: _mapAlertType == null
                          ? null
                          : () {
                              LifetimeDialog(
                                context: context,
                                widget: StampRallyMapAlert(type: _mapAlertType!),
                              );
                            },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('全$totalCount回'),
                          Icon(Icons.map, color: Colors.white.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Expanded(child: _displayStampRallyModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayStampRallyModelList() {
    final List<Widget> list = <Widget>[];

    final List<MapEntry<String, List<StampRallyModel>>> sortedEntries = _stampMap.entries.toList()
      ..sort(
        (MapEntry<String, List<StampRallyModel>> a, MapEntry<String, List<StampRallyModel>> b) =>
            a.key.compareTo(b.key),
      );

    for (final MapEntry<String, List<StampRallyModel>> entry in sortedEntries) {
      final String key = entry.key;

      if (key == 'null') {
        continue;
      }

      final List<StampRallyModel> value = List<StampRallyModel>.from(entry.value);

      final String youbiStr = DateTime.parse(key).youbiStr;

      list.add(
        Container(
          decoration: BoxDecoration(
            color: utility.getYoubiColor(date: key, youbiStr: youbiStr, holiday: appParamState.keepHolidayList),
          ),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: Text('$key ${youbiStr.substring(0, 3)}'),
        ),
      );

      switch (widget.kind) {
        case StampRallyListAlertKind.metro20Anniversary:
          value.sort((StampRallyModel a, StampRallyModel b) {
            final int t = a.time.compareTo(b.time);
            if (t != 0) {
              return t;
            }
            return a.stampGetOrder.compareTo(b.stampGetOrder);
          });

        case StampRallyListAlertKind.metroPokepoke:
          value.sort((StampRallyModel a, StampRallyModel b) => a.time.compareTo(b.time));

        case StampRallyListAlertKind.metroAllStation:
          value.sort((StampRallyModel a, StampRallyModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));
      }

      final Set<String> stationNames = <String>{};

      for (final StampRallyModel element in value) {
        if (!stationNames.add(element.stationName)) {
          continue;
        }

        final String stampUrl = _buildStampImageUrl(element);

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
                      widget: StampRallyStampAlert(imageUrl: stampUrl),
                    );
                  },
                  child: SizedBox(
                    width: (widget.kind == StampRallyListAlertKind.metroPokepoke) ? 40 : 80,
                    child: Opacity(
                      opacity: 0.6,
                      child: Hero(
                        tag: stampUrl,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/no_image.png',
                          image: stampUrl,
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
  String _buildStampImageUrl(StampRallyModel element) {
    switch (widget.kind) {
      case StampRallyListAlertKind.metroAllStation:
        return 'http://toyohide.work/BrainLog/station_stamp/${element.imageFolder}/${element.imageCode}.png';

      case StampRallyListAlertKind.metro20Anniversary:
        return 'http://toyohide.work/BrainLog/public/metro_stamp_20_anniversary/metro_stamp_20_${element.stamp}.png';

      case StampRallyListAlertKind.metroPokepoke:
        return 'http://toyohide.work/BrainLog/metro_stamp_pokepoke/stamp${element.stamp}.png';
    }
  }
}
