import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/temple_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/tile_provider.dart';

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

  List<LatLng> latLngList = <LatLng>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> markerList = <Marker>[];

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
    print(widget.transportation?.spotDataModelListMap);

    makeMinMaxLatLng();

    makeMarker();

    return Scaffold(
      body: Stack(
        children: [
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

              // if (widget.transportation != null && widget.transportation!.spotDataModelListMap.isNotEmpty) ...[
              //   PolylineLayer(polylines: _buildPolylines()),
              // ],
              //
              //

              //
              //
              //
              //
              // var transportationPolylineList = <Polyline<Object>>[];
              //
              //

              //     ///
              //     void makeTransportationPolyline() {
              //   if (widget.transportation != null) {
              //     widget.transportation!.spotDataModelListMap.forEach((key, value) {
              //       var points = <LatLng>[];
              //       value.forEach((element) => points.add(LatLng(element.lat.toDouble(), element.lng.toDouble())));
              //       transportationPolylineList.add(Polyline(points: points, color: Colors.blueAccent, strokeWidth: 5));
              //     });
              //   }
              // }
            ],
          ),

          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    latList = <double>[];

    lngList = <double>[];

    //
    //
    // latLngList = <LatLng>[];

    // if (appParamState.monthGeolocAddMonthButtonLabelList.isNotEmpty) {
    //   for (final String element in appParamState.monthGeolocAddMonthButtonLabelList) {
    //     for (final GeolocModel element2 in geolocState.allGeolocList) {
    //       if ('${element2.year}-${element2.month}' == element) {
    //         gStateList.add(element2);
    //       }
    //     }
    //   }
    // }
    //
    // for (final GeolocModel element in gStateList) {
    //   latList.add(element.latitude.toDouble());
    //   lngList.add(element.longitude.toDouble());
    //
    //   final LatLng latlng = LatLng(element.latitude.toDouble(), element.longitude.toDouble());
    //
    //   latLngList.add(latlng);
    //
    //   latLngGeolocModelMap['${latlng.latitude}|${latlng.longitude}'] = element;
    // }

    widget.geolocList?.forEach((element) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
    });

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (widget.geolocList != null) {
      if (widget.geolocList!.length > 0) {
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

  ///
  void makeMarker() {
    markerList.clear();

    widget.geolocList?.forEach((element) {
      markerList.add(
        Marker(
          point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
          width: 40,
          height: 40,

          child: Icon(Icons.ac_unit, color: Colors.black),
        ),
      );
    });

    // markerList = <Marker>[];
    //
    // for (final GeolocModel element in gStateList) {
    //   final bool isRed = emphasisMarkers.contains(LatLng(element.latitude.toDouble(), element.longitude.toDouble()));
    //
    //   final int? badgeIndex = emphasisMarkersIndices[LatLng(element.latitude.toDouble(), element.longitude.toDouble())];
    //
    //   markerList.add(
    //     Marker(
    //       point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
    //       width: 40,
    //       height: 40,
    //       // ignore: use_if_null_to_convert_nulls_to_bools
    //       child: (appParamState.mapType == MapType.monthly)
    //           ? const Icon(Icons.ac_unit, size: 20, color: Colors.redAccent)
    //           : Stack(
    //         children: <Widget>[
    //           CircleAvatar(
    //             // ignore: use_if_null_to_convert_nulls_to_bools
    //             backgroundColor: isRed
    //                 ? Colors.redAccent.withOpacity(0.5)
    //                 : (appParamState.selectedTimeGeoloc != null &&
    //                 appParamState.selectedTimeGeoloc!.time == element.time)
    //                 ? Colors.redAccent.withOpacity(0.5)
    //
    //             // ignore: use_if_null_to_convert_nulls_to_bools
    //                 : (widget.displayTempMap == true)
    //                 ? Colors.orangeAccent.withOpacity(0.5)
    //                 : Colors.green[900]?.withOpacity(0.5),
    //             child: Text(element.time, style: const TextStyle(color: Colors.white, fontSize: 10)),
    //           ),
    //           if (badgeIndex != null)
    //             Positioned(
    //               top: 0,
    //               left: 0,
    //               child: Container(
    //                 width: 16,
    //                 height: 16,
    //                 alignment: Alignment.center,
    //                 decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //                 child: Text(badgeIndex.toString(), style: const TextStyle(fontSize: 10, color: Colors.black)),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }

  //
  //
  //
  //
  // ///
  // List<Polyline> _buildPolylines() {
  //   return <Polyline<Object>>[
  //     for (int i = 0; i < widget.transportation!.spotDataModelListMap.length; i++)
  //       // ignore: always_specify_types
  //       Polyline(
  //         points: widget.transportation!.spotDataModelListMap[i]!.map((t) {
  //           return LatLng(t.lat.toDouble(), t.lng.toDouble());
  //         }).toList(),
  //         color: Colors.blue,
  //         strokeWidth: 5,
  //       ),
  //   ];
  // }
}
