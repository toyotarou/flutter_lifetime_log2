import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/time_place_model.dart';
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

  final AutoScrollController autoScrollController = AutoScrollController();
  final List<Widget> walkDataList = <Widget>[];

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  String thumbnailTrainRouteDate = '';

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    autoScrollController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/frame_arrow.png',
              color: Colors.orangeAccent.withValues(alpha: 0.4),
              colorBlendMode: BlendMode.srcIn,
            ),
          ),

          CarouselSlider.builder(
            itemCount: _itemCount,
            initialPage: _initialIndex,
            slideTransform: const CubeTransform(),
            onSlideChanged: (int index) => setState(() => currentIndex = index),
            slideBuilder: (int index) => makeMonthlyWalkDataSlide(index),
          ),
        ],
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
                          /// 一気ボタン / s
                          Row(
                            children: <Widget>[
                              IconButton(
                                tooltip: '一気に下',
                                onPressed: () {
                                  if (!autoScrollController.hasClients) {
                                    return;
                                  }

                                  final double max = autoScrollController.position.maxScrollExtent;
                                  autoScrollController.jumpTo(max);
                                },
                                icon: const Icon(Icons.vertical_align_bottom),
                              ),

                              IconButton(
                                tooltip: '一気に上',
                                onPressed: () {
                                  if (!autoScrollController.hasClients) {
                                    return;
                                  }

                                  autoScrollController.jumpTo(0.0);
                                },
                                icon: const Icon(Icons.vertical_align_top),
                              ),
                            ],
                          ),

                          /// 一気ボタン / e

                          /// 押しっぱなしボタン / s
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (_) => _startRepeating(() => _scrollBy(_moveAmount)),
                                onTapUp: (_) => _stopRepeating(),
                                onTapCancel: _stopRepeating,
                                child: const SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(child: Icon(Icons.arrow_downward)),
                                ),
                              ),

                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (_) => _startRepeating(() => _scrollBy(-_moveAmount)),
                                onTapUp: (_) => _stopRepeating(),
                                onTapCancel: _stopRepeating,
                                child: const SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(child: Icon(Icons.arrow_upward)),
                                ),
                              ),
                            ],
                          ),

                          /// 押しっぱなしボタン / e
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
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!autoScrollController.hasClients) {
      return;
    }

    final ScrollPosition pos = autoScrollController.position;
    final double newOffset = (autoScrollController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    autoScrollController.jumpTo(newOffset);
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
          child: Stack(
            children: <Widget>[
              if (geolocModelList != null &&
                  geolocModelList.isNotEmpty &&
                  boundingBoxArea.substring(0, 3) != '0.0') ...<Widget>[
                Positioned(
                  left: 10,
                  top: 40,
                  child: buildGeolocThumbMap(geolocList: geolocModelList, date: date),
                ),
              ],

              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: utility.getYoubiColor(date: date, youbiStr: youbi, holiday: appParamState.keepHolidayList),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 100),
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
                                  child: const Text(
                                    'StationRoute',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),

                                onExpansionChanged: (bool expanded) {
                                  if (expanded) {
                                    setState(() => thumbnailTrainRouteDate = date);
                                  } else {
                                    setState(() => thumbnailTrainRouteDate = '');
                                  }
                                },

                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: transportation.stationRouteList.map((String e) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),

                                        child: Row(
                                          children: <Widget>[
                                            Expanded(child: Text(e)),
                                            const SizedBox(),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 10),

                                  displayExpensesList(date: date),
                                ],
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

                                      final List<String> templeGeolocNearlyDateList = utility
                                          .getTempleGeolocNearlyDateList(
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
                                        Icon(
                                          (boundingBoxArea.substring(0, 3) == '0.0') ? Icons.home_outlined : Icons.map,
                                          color: Colors.white.withValues(alpha: 0.3),
                                        ),
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
                                  Icon(
                                    FontAwesomeIcons.toriiGate,
                                    size: 20,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
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
            ],
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

  ///
  LatLngBounds? buildBoundsFromGeoloc(List<GeolocModel> list) {
    if (list.isEmpty) {
      return null;
    }

    double? minLat, maxLat, minLng, maxLng;

    for (final GeolocModel e in list) {
      final double lat = double.tryParse(e.latitude) ?? 0;
      final double lng = double.tryParse(e.longitude) ?? 0;

      minLat = (minLat == null) ? lat : (lat < minLat ? lat : minLat);
      maxLat = (maxLat == null) ? lat : (lat > maxLat ? lat : maxLat);
      minLng = (minLng == null) ? lng : (lng < minLng ? lng : minLng);
      maxLng = (maxLng == null) ? lng : (lng > maxLng ? lng : maxLng);
    }

    const double pad = 0.0005;

    return LatLngBounds(
      LatLng((minLat ?? 0) - pad, (minLng ?? 0) - pad),
      LatLng((maxLat ?? 0) + pad, (maxLng ?? 0) + pad),
    );
  }

  ///
  Widget buildGeolocThumbMap({required List<GeolocModel> geolocList, required String date}) {
    const double thumbWidth = 140;
    const double thumbHeight = 80;
    const double thumbRadius = 6;

    const double boundsPadLatLng = 0.0005;
    const double cameraFitPaddingPx = 8;

    const double mapDarkenOpacity = 0.35;

    const double markerSize = 8;
    const double markerFillOpacity = 0.3;

    const Color markerFillColorBase = Color(0xFFFBB6CE);

    const int tileKeepBuffer = 0;
    const String tileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    const String userAgentPackageName = 'your.app.package';

    final List<LatLng> points = geolocList
        .map((GeolocModel e) {
          final double? lat = double.tryParse(e.latitude);
          final double? lng = double.tryParse(e.longitude);

          if (lat == null || lng == null) {
            return null;
          }
          if (!lat.isFinite || !lng.isFinite) {
            return null;
          }
          if (lat < -90 || lat > 90) {
            return null;
          }
          if (lng < -180 || lng > 180) {
            return null;
          }

          return LatLng(lat, lng);
        })
        .whereType<LatLng>()
        .toList();

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final LatLng p in points) {
      if (p.latitude < minLat) {
        minLat = p.latitude;
      }
      if (p.latitude > maxLat) {
        maxLat = p.latitude;
      }
      if (p.longitude < minLng) {
        minLng = p.longitude;
      }
      if (p.longitude > maxLng) {
        maxLng = p.longitude;
      }
    }

    final LatLngBounds bounds = LatLngBounds(
      LatLng(minLat - boundsPadLatLng, minLng - boundsPadLatLng),
      LatLng(maxLat + boundsPadLatLng, maxLng + boundsPadLatLng),
    );

    final List<Marker> markers = points.map((LatLng p) {
      return Marker(
        point: p,
        width: markerSize,
        height: markerSize,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: markerFillColorBase.withValues(alpha: markerFillOpacity),
          ),
        ),
      );
    }).toList();

    // ignore: always_specify_types
    List<Polyline>? thumbnailTrainRoutePolyline;

    if (thumbnailTrainRouteDate != '' && thumbnailTrainRouteDate == date) {
      thumbnailTrainRoutePolyline = makeThumbnailTrainRoutePolyline();
    }

    return SizedBox(
      width: thumbWidth,
      height: thumbHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(thumbRadius),
        child: FlutterMap(
          options: MapOptions(
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
            initialCameraFit: CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(cameraFitPaddingPx)),
            backgroundColor: Colors.black,
          ),
          children: <Widget>[
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(mapDarkenOpacity), BlendMode.darken),
              child: TileLayer(
                urlTemplate: tileUrlTemplate,
                userAgentPackageName: userAgentPackageName,
                keepBuffer: tileKeepBuffer,
              ),
            ),

            MarkerLayer(markers: markers),

            // ignore: always_specify_types
            if (thumbnailTrainRoutePolyline != null) ...<Widget>[
              // ignore: always_specify_types
              PolylineLayer(polylines: thumbnailTrainRoutePolyline),
            ],
          ],
        ),
      ),
    );
  }

  ///
  List<Polyline<Object>>? makeThumbnailTrainRoutePolyline() {
    // ignore: always_specify_types
    final List<Polyline> polylines = <Polyline>[];

    if (thumbnailTrainRouteDate != '') {
      if (appParamState.keepTransportationMap[thumbnailTrainRouteDate] != null) {
        final List<Color> fortyEightColor = utility.getFortyEightColor();

        final TransportationModel? transportationModel = appParamState.keepTransportationMap[thumbnailTrainRouteDate];

        if (transportationModel != null) {
          for (int i = 0; i < transportationModel.spotDataModelListMap.length; i++) {
            final List<SpotDataModel>? spots = transportationModel.spotDataModelListMap[i];
            if (spots == null || spots.isEmpty) {
              continue;
            }

            polylines.add(
              // ignore: always_specify_types
              Polyline(
                points: spots.map((SpotDataModel t) => LatLng(t.lat.toDouble(), t.lng.toDouble())).toList(),
                color: (transportationModel.oufuku) ? fortyEightColor[0] : fortyEightColor[i % 48],
                strokeWidth: 3,
              ),
            );
          }
        }
      }
    }

    return polylines;
  }

  ///
  Widget displayExpensesList({required String date}) {
    final List<Widget> list = <Widget>[];

    appParamState.keepTimePlaceMap[date]?.forEach((TimePlaceModel element) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text(element.time)),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.place),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[const SizedBox.shrink(), Text(element.price.toString().toCurrency())],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Column(children: list);
  }
}
