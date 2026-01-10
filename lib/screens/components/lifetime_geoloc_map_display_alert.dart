import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/_get_data/lat_lng_address/lat_lng_address.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/lat_lng_address.dart';
import '../../models/stamp_rally_model.dart';
import '../../models/temple_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../parts/icon_toolchip_display_overlay.dart';
import '../parts/lifetime_dialog.dart';
import '../parts/lifetime_log_overlay.dart';
import 'temple_list_display_alert.dart';
import 'time_place_display_alert.dart';

class LifetimeGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocMapDisplayAlert({super.key, required this.date, this.geolocList});

  final String date;
  final List<GeolocModel>? geolocList;

  @override
  ConsumerState<LifetimeGeolocMapDisplayAlert> createState() => _LifetimeGeolocMapDisplayAlertState();
}

class _LifetimeGeolocMapDisplayAlertState extends ConsumerState<LifetimeGeolocMapDisplayAlert>
    with ControllersMixin<LifetimeGeolocMapDisplayAlert> {
  bool isLoading = false;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> markerList = <Marker>[];

  Utility utility = Utility();

  List<Marker> transportationGoalMarkerList = <Marker>[];

  List<Marker> templeMarkerList = <Marker>[];

  List<Color> fortyEightColor = <Color>[];

  double currentZoom2 = 13.0;

  final double baseZoom2 = 13.0;

  final double timeContainerWidth = 40;

  List<Marker> displayTimeMarkerList = <Marker>[];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<Marker> stampRallyMetroAllStationMarkerList = <Marker>[];

  List<GlobalKey> globalKeyList = <GlobalKey>[];

  List<Marker> stampRallyMetro20AnniversaryMarkerList = <Marker>[];

  List<Marker> stampRallyMetroPokepokeMarkerList = <Marker>[];

  Set<String> dateMunicipalNameSet = <String>{};

  String nearestTempleGeolocTime = '-----';

  ///
  @override
  void initState() {
    super.initState();

    fortyEightColor = utility.getFortyEightColor();

    // ignore: always_specify_types
    globalKeyList = List.generate(1000, (int index) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      if (widget.geolocList != null) {
        final LatLngBounds bounds = LatLngBounds.fromPoints(
          widget.geolocList!.map((GeolocModel geolocModel) {
            dateMunicipalNameSet.add(
              findMunicipalityForPoint(
                    geolocModel.latitude.toDouble(),
                    geolocModel.longitude.toDouble(),
                    appParamState.keepTokyoMunicipalList,
                  ) ??
                  '',
            );

            return LatLng(geolocModel.latitude.toDouble(), geolocModel.longitude.toDouble());
          }).toList(),
        );

        final double latDiff = (bounds.north - bounds.south).abs();

        final double lngDiff = (bounds.east - bounds.west).abs();

        final double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

        double zoom;

        if (maxDiff < 0.1) {
          zoom = 15;
        } else if (maxDiff < 1) {
          zoom = 12;
        } else if (maxDiff < 5) {
          zoom = 10;
        } else {
          zoom = 5;
        }

        setState(() => currentZoom2 = zoom);
      }

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        setDefaultBoundsMap();

        setState(() => isLoading = false);
      });
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

    makeMarker();

    makeTransportationGoalMarker();

    makeTempleMarker();

    makeDisplayTimeMarker();

    makeStampRallyMetroAllStationMarker();

    makeStampRallyMetro20AnniversaryMarker();

    makeStampRallyMetroPokepokeMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: (widget.geolocList != null)
                  ? LatLng(widget.geolocList![0].latitude.toDouble(), widget.geolocList![0].longitude.toDouble())
                  : const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: currentZoomEightTeen,
              onPositionChanged: (MapCamera position, bool isMoving) {
                if (isMoving) {
                  appParamNotifier.setCurrentZoom(zoom: position.zoom);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),

              if (appParamState.keepAllPolygonsList.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolygonLayer(
                  polygons: makeAreaPolygons(
                    allPolygonsList: appParamState.keepAllPolygonsList,
                    fortyEightColor: fortyEightColor,
                  ),
                ),
              ],

              MarkerLayer(markers: markerList),

              if (appParamState.keepTransportationMap[widget.date] != null &&
                  appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolylineLayer(polylines: makeTransportationPolyline()),
              ],

              MarkerLayer(markers: transportationGoalMarkerList),

              MarkerLayer(markers: templeMarkerList),

              MarkerLayer(markers: displayTimeMarkerList),

              MarkerLayer(markers: stampRallyMetroAllStationMarkerList),

              MarkerLayer(markers: stampRallyMetro20AnniversaryMarkerList),

              MarkerLayer(markers: stampRallyMetroPokepokeMarkerList),
            ],
          ),

          Positioned(
            top: 5,
            right: 5,
            left: 5,

            child: Column(
              children: <Widget>[
                Container(
                  width: context.screenSize.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 180,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(widget.date, style: const TextStyle(fontSize: 20)),

                                const SizedBox(width: 10),

                                Text(DateTime.parse(widget.date).youbiStr.substring(0, 3)),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text('size:'),

                                  Text(
                                    appParamState.currentZoom.toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (appParamState.keepTempleMap[widget.date] != null) ...<Widget>[
                        const SizedBox(height: 10),
                        displayTempleNameList(),
                      ],

                      Row(
                        children: <Widget>[
                          if (appParamState.keepTransportationMap[widget.date] != null &&
                              appParamState
                                  .keepTransportationMap[widget.date]!
                                  .stationRouteList
                                  .isNotEmpty) ...<Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: appParamState.keepTransportationMap[widget.date]!.stationRouteList
                                  .map((String e) => Text(e, style: const TextStyle(fontSize: 12)))
                                  .toList(),
                            ),
                          ],

                          if (!appParamState.isDisplayMunicipalNameOnLifetimeGeolocMap) ...<Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () =>
                                      appParamNotifier.setIsDisplayMunicipalNameOnLifetimeGeolocMap(flag: true),
                                  child: Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.8)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (appParamState.keepTempleMap[widget.date] != null) ...<Widget>[
                        const SizedBox(height: 10),

                        Text(nearestTempleGeolocTime, style: const TextStyle(color: Colors.yellowAccent)),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          if (appParamState.isDisplayMunicipalNameOnLifetimeGeolocMap) ...<Widget>[
                            Container(
                              width: context.screenSize.width * 0.6,
                              height: context.screenSize.height * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 10, left: 10),

                                      child: SingleChildScrollView(child: displayDateMunicipalNameWidget()),
                                    ),
                                  ),

                                  Column(
                                    children: <Widget>[
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () =>
                                            appParamNotifier.setIsDisplayMunicipalNameOnLifetimeGeolocMap(flag: false),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: GestureDetector(
                            onTap: () {
                              appParamNotifier.setSelectedGeolocTime(time: '');

                              setDefaultBoundsMap();
                            },
                            child: const Icon(FontAwesomeIcons.expand),
                          ),
                        ),

                        if (appParamState.keepTempleMap[widget.date] != null) ...<Widget>[
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: GestureDetector(
                              onTap: () {
                                closeAllOverlays(ref: ref);

                                appParamNotifier.setSelectedTempleDirection(direction: '');

                                LifetimeDialog(
                                  context: context,
                                  widget: TempleListDisplayAlert(
                                    date: widget.date,
                                    temple: appParamState.keepTempleMap[widget.date],
                                  ),

                                  paddingTop: context.screenSize.height * 0.2,
                                  paddingRight: context.screenSize.width * 0.3,

                                  clearBarrierColor: true,
                                );
                              },
                              child: const Icon(FontAwesomeIcons.toriiGate),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],

          if (appParamState.selectedGeolocTime != '') ...<Widget>[
            Positioned(
              bottom: 10,
              right: 5,
              left: 5,
              height: 150,

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),

                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(5),
                child: displayLatLngAddressList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  ///
  Widget displayDateMunicipalNameWidget() {
    final List<Widget> list = <Widget>[];

    cityTownNames.split('\n').forEach((String element) {
      if (element != '') {
        if (dateMunicipalNameSet.contains(element)) {
          list.add(
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),

              child: Text(element, style: const TextStyle(fontSize: 10)),
            ),
          );
        }
      }
    });

    return Wrap(children: list);
  }

  ///
  void makeDisplayTimeMarker() {
    final double scaleFactor = currentZoom2 / baseZoom2;

    displayTimeMarkerList.clear();

    String keepTime = '';
    widget.geolocList
      ?..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time))
      ..forEach((GeolocModel element) {
        if (keepTime != element.time.split(':')[0]) {
          displayTimeMarkerList.add(
            Marker(
              point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
              width: (30 + 8 + timeContainerWidth + timeContainerWidth) * scaleFactor,
              height: 40,

              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  SizedBox(width: timeContainerWidth),

                  Icon(Icons.location_on, size: 30 * scaleFactor, color: Colors.red),

                  Container(
                    width: timeContainerWidth * scaleFactor,

                    height: 20 * scaleFactor,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      color: Colors.white,
                    ),

                    padding: const EdgeInsets.all(1),

                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${element.time.split(':')[0]}:${element.time.split(':')[1]}',

                            style: const TextStyle(fontWeight: FontWeight.bold),
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

        keepTime = element.time.split(':')[0];
      });
  }

  ///
  Widget displayTempleNameList() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < appParamState.keepTempleMap[widget.date]!.templeDataList.length; i++) {
      list.add(
        Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 5, right: 10, left: 5, bottom: 15),

              padding: const EdgeInsets.only(top: 3, bottom: 3, right: 20, left: 10),
              decoration: BoxDecoration(color: const Color(0xFFFBB6CE).withValues(alpha: 0.5)),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Text(
                      (i + 1).toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    appParamState.keepTempleMap[widget.date]!.templeDataList[i].name,
                    style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 3,
              bottom: 3,
              child: Text(
                appParamState.keepTempleMap[widget.date]!.templeDataList[i].rank,

                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFFBB6CE),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,

            child: Text(
              appParamState.keepTempleMap[widget.date]!.templeDataList.length.toString().padLeft(2, '0'),

              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: list),
          ),
        ),
      ],
    );
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    widget.geolocList
      ?..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time))
      ..forEach((GeolocModel element) {
        latList.add(element.latitude.toDouble());
        lngList.add(element.longitude.toDouble());
      });

    if (appParamState.keepTempleMap[widget.date] != null &&
        appParamState.keepTempleMap[widget.date]!.templeDataList.length > 1) {
      latList.clear();
      lngList.clear();

      for (final TempleDataModel element in appParamState.keepTempleMap[widget.date]!.templeDataList) {
        latList.add(element.latitude.toDouble());
        lngList.add(element.longitude.toDouble());
      }
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (widget.geolocList!.isNotEmpty) {
      mapController.rotate(0);

      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit = CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10),
      );

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      appParamNotifier.setCurrentZoom(zoom: newZoom);

      if (appParamState.keepTimePlaceMap[widget.date] != null) {
        LifetimeDialog(
          context: context,
          widget: TimePlaceDisplayAlert(date: widget.date),
          paddingTop: context.screenSize.height * 0.65,
          clearBarrierColor: true,
        );
      }

      callFirstBox();
    }
  }

  ///
  void makeMarker() {
    markerList.clear();

    widget.geolocList
      ?..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time))
      ..forEach((GeolocModel element) {
        markerList.add(
          Marker(
            point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
            width: 40,
            height: 40,

            child: const Icon(Icons.ac_unit, color: Colors.black),
          ),
        );
      });
  }

  ///
  void callFirstBox() {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    final Completer<void> completer = Completer<void>();

    completer.future.then((_) {
      if (mounted) {
        final NavigatorState nav = Navigator.of(context, rootNavigator: true);

        if (nav.canPop()) {
          nav.pop();
        }
      }
    });

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: context.screenSize.width * 0.25,
      height: context.screenSize.height * 0.25,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(context.screenSize.width * 0.75, context.screenSize.height * 0.45),

      widget: SizedBox(
        height: context.screenSize.height * 0.2,

        child: displayTimeGeolocList(
          onCloseDialogFromOverlay: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        ),
      ),

      fixedFlag: true,

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }

  ///
  Widget displayTimeGeolocList({required VoidCallback onCloseDialogFromOverlay}) {
    final List<Widget> list = <Widget>[];

    String keepTime = '';
    widget.geolocList
      ?..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time))
      ..forEach((GeolocModel element) {
        if (keepTime != element.time.split(':')[0]) {
          final String time = '${element.time.split(':')[0]}:${element.time.split(':')[1]}';

          list.add(
            GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedGeolocTime(time: time);

                appParamNotifier.setCurrentZoom(zoom: 18);

                mapController.move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), 18);

                mapController.rotate(0);

                if (appParamState.keepTimePlaceMap[widget.date] != null) {
                  onCloseDialogFromOverlay();
                }
              },

              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.4))),

                child: Text(time, style: const TextStyle(fontSize: 12)),
              ),
            ),
          );
        }

        keepTime = element.time.split(':')[0];
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

  ///
  // ignore: always_specify_types
  List<Polyline> makeTransportationPolyline() {
    return <Polyline<Object>>[
      for (int i = 0; i < appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap.length; i++)
        // ignore: always_specify_types
        Polyline(
          points: appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap[i]!
              .map((SpotDataModel t) => LatLng(t.lat.toDouble(), t.lng.toDouble()))
              .toList(),
          color: (appParamState.keepTransportationMap[widget.date]!.oufuku)
              ? fortyEightColor[0]
              : fortyEightColor[i % 48],
          strokeWidth: 5,
        ),
    ];
  }

  ///
  void makeTransportationGoalMarker() {
    transportationGoalMarkerList.clear();

    if (appParamState.keepTransportationMap[widget.date] != null &&
        appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap.isNotEmpty) {
      for (int i = 0; i < appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap.length; i++) {
        final SpotDataModel lastValue = appParamState.keepTransportationMap[widget.date]!.spotDataModelListMap[i]!.last;

        transportationGoalMarkerList.add(
          Marker(
            point: LatLng(lastValue.lat.toDouble(), lastValue.lng.toDouble()),
            child: Icon(
              Icons.flag,
              color: (appParamState.keepTransportationMap[widget.date]!.oufuku)
                  ? fortyEightColor[0]
                  : fortyEightColor[i % 48],
            ),
          ),
        );
      }
    }
  }

  ///
  void makeTempleMarker() {
    templeMarkerList.clear();
    if (appParamState.keepTempleMap[widget.date] != null) {
      for (int i = 0; i < appParamState.keepTempleMap[widget.date]!.templeDataList.length; i++) {
        final TempleDataModel templeDataModel = appParamState.keepTempleMap[widget.date]!.templeDataList[i];

        templeMarkerList.add(
          Marker(
            key: globalKeyList[i],

            point: LatLng(templeDataModel.latitude.toDouble(), templeDataModel.longitude.toDouble()),
            child: GestureDetector(
              onTap: () {
                if (appParamState.keepNearestTempleNameGeolocModelMap[templeDataModel.name] != null) {
                  setState(() {
                    nearestTempleGeolocTime =
                        appParamState.keepNearestTempleNameGeolocModelMap[templeDataModel.name]!.time;
                  });
                }

                iconToolChipDisplayOverlay(
                  type: 'lifetime_geoloc_map_display_alert_icon',
                  context: context,
                  buttonKey: globalKeyList[i],
                  displayDuration: const Duration(seconds: 2),
                  templeDataModel: templeDataModel,
                );
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 5, right: 5),
                    child: const Icon(FontAwesomeIcons.toriiGate, color: Color(0xFFFBB6CE)),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  ///
  Widget displayLatLngAddressList() {
    final List<Widget> list = <Widget>[];

    if (appParamState.selectedGeolocTime != '') {
      final List<GeolocModel>? searchedGeoloc = widget.geolocList
          ?.where((GeolocModel element) {
            return '${element.year}-${element.month}-${element.day}' == widget.date;
          })
          .where((GeolocModel element2) {
            return '${element2.time.split(':')[0]}:${element2.time.split(':')[1]}' == appParamState.selectedGeolocTime;
          })
          .toList();

      final List<String> addressList = <String>[];
      if (searchedGeoloc != null) {
        final AsyncValue<LatLngAddressControllerState> latLngAddressControllerState = ref.watch(
          latLngAddressControllerProvider(latitude: searchedGeoloc[0].latitude, longitude: searchedGeoloc[0].longitude),
        );

        final List<LatLngAddressDetailModel>? latLngAddressList = latLngAddressControllerState.value?.latLngAddressList;

        latLngAddressList?.forEach(
          (LatLngAddressDetailModel element) => addressList.add('${element.prefecture}${element.city}${element.town}'),
        );
      }

      list.add(Text(appParamState.selectedGeolocTime));

      for (final String element in addressList) {
        list.add(Text(element, style: const TextStyle(fontSize: 12)));
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
  void makeStampRallyMetroAllStationMarker() {
    stampRallyMetroAllStationMarkerList = _buildStampMarkerList(
      data: appParamState.keepStampRallyMetroAllStationMap[widget.date],
      keyOffset: 100,
      colorOf: (_) => Colors.indigo,
    );
  }

  ///
  void makeStampRallyMetro20AnniversaryMarker() {
    stampRallyMetro20AnniversaryMarkerList = _buildStampMarkerList(
      data: appParamState.keepStampRallyMetro20AnniversaryMap[widget.date],
      keyOffset: 200,
      colorOf: (_) => Colors.indigo,
    );
  }

  ///
  void makeStampRallyMetroPokepokeMarker() {
    stampRallyMetroPokepokeMarkerList = _buildStampMarkerList(
      data: appParamState.keepStampRallyMetroPokepokeMap[widget.date],
      keyOffset: 300,
      colorOf: (_) => Colors.indigo,
    );
  }

  ///
  List<Marker> _buildStampMarkerList({
    required List<StampRallyModel>? data,
    required int keyOffset,
    required Color Function(StampRallyModel) colorOf,
  }) {
    if (data == null || data.isEmpty) {
      return <Marker>[];
    }

    final List<Marker> list = <Marker>[];

    for (int i = 0; i < data.length; i++) {
      final StampRallyModel element = data[i];
      final int keyIndex = i + keyOffset;

      list.add(
        Marker(
          key: globalKeyList[keyIndex],
          point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
          child: GestureDetector(
            onTap: () {
              iconToolChipDisplayOverlay(
                type: 'lifetime_geoloc_map_display_alert_icon',
                context: context,
                buttonKey: globalKeyList[keyIndex],
                displayDuration: const Duration(seconds: 2),
                stampRallyModel: element,
              );
            },
            child: Icon(FontAwesomeIcons.stamp, size: 20, color: colorOf(element)),
          ),
        ),
      );
    }

    return list;
  }
}
