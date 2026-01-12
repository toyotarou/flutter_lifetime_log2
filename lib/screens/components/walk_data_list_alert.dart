import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/transportation_model.dart';
import '../../models/walk_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'lifetime_geoloc_map_display_alert.dart';

class WalkDataListAlert extends ConsumerStatefulWidget {
  const WalkDataListAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<WalkDataListAlert> createState() => _WalkDataListAlertState();
}

class _WalkDataListAlertState extends ConsumerState<WalkDataListAlert> with ControllersMixin<WalkDataListAlert> {
  static const int _itemCount = 100000;
  static const int _initialIndex = _itemCount ~/ 2;

  late final DateTime _baseMonth;
  int currentIndex = _initialIndex;

  Utility utility = Utility();

  bool todayStockExists = false;
  bool todayToushiShintakuRelationalIdBlankExists = false;

  //  final Map<int, int> monthlyGraphAssetsMap = <int, int>{};

  final AutoScrollController autoScrollController = AutoScrollController();
  final List<Widget> walkDataList = <Widget>[];

  ///
  @override
  void initState() {
    super.initState();

    _baseMonth = DateTime.parse('${widget.yearmonth}-01');
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CarouselSlider.builder(
        itemCount: _itemCount,
        initialPage: _initialIndex,
        slideTransform: const CubeTransform(),
        onSlideChanged: (int index) => setState(() => currentIndex = index),
        slideBuilder: (int index) => makeMonthlyWalkDataSlide(index),
      ),
    );
  }

  ///
  Widget makeMonthlyWalkDataSlide(int index) {
    final DateTime genDate = monthForIndex(index: index, baseMonth: _baseMonth);

    final bool hasData = appParamState.keepWalkModelMap.containsKey(
      '${genDate.year}-${genDate.month.toString().padLeft(2, '0')}-01',
    );

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.2)),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 18, right: 10, left: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(top: 20, right: 5, left: 5, child: Center(child: Text(genDate.yyyymm))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  autoScrollController.scrollToIndex(
                                    walkDataList.length,
                                    preferPosition: AutoScrollPosition.end,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                icon: const Icon(Icons.arrow_downward),
                              ),
                              IconButton(
                                onPressed: () {
                                  autoScrollController.scrollToIndex(
                                    0,
                                    preferPosition: AutoScrollPosition.begin,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                icon: const Icon(Icons.arrow_upward),
                              ),
                            ],
                          ),

                          const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  if (hasData) ...<Widget>[Expanded(child: displayWalkDataList(genDate: genDate))] else ...<Widget>[
                    const Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('no data', style: TextStyle(color: Colors.yellowAccent)),
                              SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayWalkDataList({required DateTime genDate}) {
    walkDataList.clear();

    final int endDay = DateTime(genDate.year, genDate.month + 1, 0).day;

    for (int day = 1; day <= endDay; day++) {
      final String date = '${genDate.yyyymm}-${day.toString().padLeft(2, '0')}';

      final WalkModel? value = appParamState.keepWalkModelMap[date];

      final TransportationModel? transportation = appParamState.keepTransportationMap[date];

      final List<GeolocModel>? geolocModelList = appParamState.keepGeolocMap[date];

      String boundingBoxArea = '';
      if (geolocModelList != null) {
        boundingBoxArea = utility.getBoundingBoxArea(points: geolocModelList);
      }

      final String youbi = DateTime.parse(date).youbiStr;

      walkDataList.add(
        AutoScrollTag(
          // ignore: always_specify_types
          key: ValueKey(day),
          index: day,
          controller: autoScrollController,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (boundingBoxArea.split('.')[0] != '0' && transportation != null) ? 120 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Text(day.toString().padLeft(2, '0')),
                            const SizedBox(width: 10),
                            Text(DateTime.parse(date).youbiStr.substring(0, 3)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text((value != null) ? value.step.toString().toCurrency() : '0'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text((value != null) ? value.distance.toString().toCurrency() : '0'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(alignment: Alignment.topRight, child: Text(boundingBoxArea)),
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (boundingBoxArea.split('.')[0] != '0' && transportation != null) ...<Widget>[
                        Expanded(
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            title: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              color: Colors.black.withValues(alpha: 0.2),
                              child: const Text('StationRoute', style: TextStyle(fontSize: 12, color: Colors.white)),
                            ),
                            children: transportation.stationRouteList.map((String e) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ] else ...<Widget>[const Expanded(child: SizedBox.shrink())],

                      Container(
                        width: 40,
                        alignment: Alignment.topRight,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            if (appParamState.keepGeolocMap[date] != null) ...<Widget>[
                              GestureDetector(
                                onTap: () {
                                  appParamNotifier.setSelectedGeolocTime(time: '');

                                  final List<String> templeGeolocNearlyDateList = utility.getTempleGeolocNearlyDateList(
                                    date: date,
                                    templeMap: appParamState.keepTempleMap,
                                  );

                                  LifetimeDialog(
                                    context: context,
                                    widget: LifetimeGeolocMapDisplayAlert(
                                      date: date,
                                      geolocList: appParamState.keepGeolocMap[date],
                                      templeGeolocNearlyDateList: templeGeolocNearlyDateList,
                                    ),
                                    executeFunctionWhenDialogClose: true,
                                    from: 'LifetimeGeolocMapDisplayAlert',
                                    ref: ref,
                                  );
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.map, color: Colors.white.withValues(alpha: 0.3)),
                                    const SizedBox(height: 5),
                                    Text(
                                      appParamState.keepGeolocMap[date]!.length.toString(),
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (appParamState.keepTempleMap[date] != null) ...<Widget>[
                              const SizedBox(height: 10),
                              Icon(FontAwesomeIcons.toriiGate, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                            ],

                            if (appParamState.keepStampRallyMetroAllStationMap[date] != null ||
                                appParamState.keepStampRallyMetro20AnniversaryMap[date] != null ||
                                appParamState.keepStampRallyMetroPokepokeMap[date] != null) ...<Widget>[
                              const SizedBox(height: 10),
                              Icon(FontAwesomeIcons.stamp, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return CustomScrollView(
      controller: autoScrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => walkDataList[index],
            childCount: walkDataList.length,
          ),
        ),
      ],
    );
  }
}
