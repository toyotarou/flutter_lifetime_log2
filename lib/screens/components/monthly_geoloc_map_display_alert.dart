import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../mixin/monthly_geoloc_map_date_list/monthly_geoloc_map_date_list_widget.dart';
import '../../models/geoloc_model.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_log_overlay.dart';

class MonthlyGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyGeolocMapDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyGeolocMapDisplayAlert> createState() => _MonthlyGeolocMapDisplayAlertState();
}

class _MonthlyGeolocMapDisplayAlertState extends ConsumerState<MonthlyGeolocMapDisplayAlert>
    with ControllersMixin<MonthlyGeolocMapDisplayAlert> {
  List<GeolocModel> monthlyGeolocList = <GeolocModel>[];

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

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  Utility utility = Utility();

  List<LatLng> latLngList = <LatLng>[];

  List<GeolocModel> selectedGeolocList = <GeolocModel>[];

  List<LatLng> polygonPoints = <LatLng>[];

  double centerLat = 0.0;
  double centerLng = 0.0;

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

    makeMarker();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: (monthlyGeolocList.isNotEmpty)
                  ? LatLng(monthlyGeolocList[0].latitude.toDouble(), monthlyGeolocList[0].longitude.toDouble())
                  : const LatLng(35.718532, 139.586639),
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

              MarkerLayer(markers: markerList),

              if (polygonPoints.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolygonLayer(
                  polygons: <Polygon<Object>>[
                    // ignore: always_specify_types
                    Polygon(
                      points: polygonPoints,
                      color: Colors.purpleAccent.withValues(alpha: 0.2),
                      borderColor: Colors.purpleAccent.withValues(alpha: 0.4),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ],
          ),

          Positioned(
            top: 5,
            right: 5,
            left: 5,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Text(widget.yearmonth),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

                              addFirstOverlay(
                                context: context,
                                setStateCallback: setState,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.4,
                                color: Colors.blueGrey.withOpacity(0.3),
                                initialPosition: Offset(MediaQuery.of(context).size.width * 0.6, 90),
                                widget: const MonthlyGeolocMapDateListWidget(),
                                firstEntries: _firstEntries,
                                secondEntries: _secondEntries,
                                onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),

                                fixedFlag: true,
                              );
                            },
                            child: const Icon(Icons.calendar_month),
                          ),
                        ),

                        if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty) ...<Widget>[
                          const SizedBox(width: 10),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () => setDefaultBoundsMap(),
                              child: const Icon(FontAwesomeIcons.expand),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox.shrink(),
                  ],
                ),

                if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      appParamState.monthlyGeolocMapSelectedDateList.last,

                      style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Wrap(
                          children: appParamState.monthlyGeolocMapSelectedDateList.map((String e) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, right: 5),
                              child: CircleAvatar(
                                radius: 10,

                                backgroundColor: Colors.green[900]!.withValues(alpha: 0.4),

                                child: Text(e.split('-')[2], style: const TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    selectedGeolocList.clear();

    latList.clear();
    lngList.clear();

    latLngList.clear();

    if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty) {
      for (final String element in appParamState.monthlyGeolocMapSelectedDateList) {
        appParamState.keepGeolocMap[element]?.forEach((GeolocModel element2) {
          selectedGeolocList.add(element2);

          latList.add(element2.latitude.toDouble());
          lngList.add(element2.longitude.toDouble());

          latLngList.add(LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()));
        });
      }
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      polygonPoints = utility.getBoundingBoxPoints(selectedGeolocList);

      centerLat = (polygonPoints[0].latitude + polygonPoints[2].latitude) / 2;
      centerLng = (polygonPoints[0].longitude + polygonPoints[2].longitude) / 2;

      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void makeMarker() {
    markerList.clear();

    if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty) {
      final String lastDate = appParamState.monthlyGeolocMapSelectedDateList.last;

      for (final String element in appParamState.monthlyGeolocMapSelectedDateList) {
        appParamState.keepGeolocMap[element]?.forEach((GeolocModel element2) {
          final Color iconColor = ('${element2.year}-${element2.month}-${element2.day}' == lastDate)
              ? Colors.redAccent
              : Colors.black;

          markerList.add(
            Marker(
              point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

              width: 40,
              height: 40,

              child: Icon(Icons.ac_unit, color: iconColor),
            ),
          );
        });
      }
    }

    if (markerList.isEmpty) {
      polygonPoints.clear();
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (latList.isNotEmpty && lngList.isNotEmpty) {
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
    }
  }
}
