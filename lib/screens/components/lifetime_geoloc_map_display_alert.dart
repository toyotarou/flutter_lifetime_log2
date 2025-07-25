import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';

class LifetimeGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocMapDisplayAlert({
    super.key,
    required this.date,
    this.geolocList,
    this.temple,
    this.transportation,
  });

  final String date;
  final List<GeolocModel>? geolocList;
  final TempleModel? temple;
  final TransportationModel? transportation;

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

  ///
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: (widget.geolocList != null)
                  ? LatLng(widget.geolocList![0].latitude.toDouble(), widget.geolocList![0].longitude.toDouble())
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

              if (widget.transportation != null && widget.transportation!.spotDataModelListMap.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolylineLayer(polylines: makeTransportationPolyline()),
              ],

              MarkerLayer(markers: transportationGoalMarkerList),

              MarkerLayer(markers: templeMarkerList),
            ],
          ),

          Positioned(
            top: 5,
            right: 5,
            left: 5,

            child: Container(
              width: context.screenSize.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(widget.date, style: const TextStyle(fontSize: 20))],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 70, child: Text('size:')),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        appParamState.currentZoom.toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    widget.geolocList?.forEach((GeolocModel element) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
    });

    if (widget.temple != null) {
      latList.clear();
      lngList.clear();

      for (final TempleDataModel element in widget.temple!.templeDataList) {
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

  ///
  void makeMarker() {
    markerList.clear();

    widget.geolocList?.forEach((GeolocModel element) {
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
  // ignore: always_specify_types
  List<Polyline> makeTransportationPolyline() {
    final List<Color> twelveColor = utility.getTwelveColor();

    return <Polyline<Object>>[
      for (int i = 0; i < widget.transportation!.spotDataModelListMap.length; i++)
        // ignore: always_specify_types
        Polyline(
          points: widget.transportation!.spotDataModelListMap[i]!.map((SpotDataModel t) {
            return LatLng(t.lat.toDouble(), t.lng.toDouble());
          }).toList(),
          color: twelveColor[i],
          strokeWidth: 5,
        ),
    ];
  }

  ///
  void makeTransportationGoalMarker() {
    transportationGoalMarkerList.clear();

    final List<Color> twelveColor = utility.getTwelveColor();

    if (widget.transportation != null && widget.transportation!.spotDataModelListMap.isNotEmpty) {
      for (int i = 0; i < widget.transportation!.spotDataModelListMap.length; i++) {
        final SpotDataModel lastValue = widget.transportation!.spotDataModelListMap[i]!.last;

        transportationGoalMarkerList.add(
          Marker(
            point: LatLng(lastValue.lat.toDouble(), lastValue.lng.toDouble()),
            child: Icon(Icons.flag, color: twelveColor[i]),
          ),
        );
      }
    }
  }

  ///
  void makeTempleMarker() {
    templeMarkerList.clear();

    if (widget.temple != null) {
      for (final TempleDataModel element in widget.temple!.templeDataList) {
        templeMarkerList.add(
          Marker(
            point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
            child: const Icon(FontAwesomeIcons.toriiGate, color: Color(0xFFFBB6CE)),
          ),
        );
      }
    }
  }
}
