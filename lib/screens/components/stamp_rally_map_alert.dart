import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/stamp_rally_model.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../parts/icon_toolchip_display_overlay.dart';

class StampRallyMapAlert extends ConsumerStatefulWidget {
  const StampRallyMapAlert({super.key, required this.type});

  final String type;

  @override
  ConsumerState<StampRallyMapAlert> createState() => _StampRallyMapAlertState();
}

class _StampRallyMapAlertState extends ConsumerState<StampRallyMapAlert> with ControllersMixin<StampRallyMapAlert> {
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

  List<List<Marker>> stampMarkerList = <List<Marker>>[];

  Utility utility = Utility();

  List<Color> twentyFourColor = <Color>[];

  List<GlobalKey> globalKeyList = <GlobalKey>[];

  ///
  Map<String, List<StampRallyModel>> get _currentStampMap {
    switch (widget.type) {
      case 'metro_all_station':
        return appParamState.keepStampRallyMetroAllStationMap;
      case 'metro_20_anniversary':
        return appParamState.keepStampRallyMetro20AnniversaryMap;
      case 'metro_pokepoke':
        return appParamState.keepStampRallyMetroPokepokeMap;
      default:
        return <String, List<StampRallyModel>>{};
    }
  }

  ///
  @override
  void initState() {
    super.initState();

    twentyFourColor = utility.getTwentyFourColor();

    // ignore: always_specify_types
    globalKeyList = List.generate(1000, (int index) => GlobalKey());

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

    makeStampMarkerList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(zenpukujiLat, zenpukujiLng),
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

              // ignore: always_specify_types
              PolylineLayer(polylines: makeTransportationPolyline()),

              for (int i = 0; i < stampMarkerList.length; i++) MarkerLayer(markers: stampMarkerList[i]),
            ],
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

    _currentStampMap.forEach((String key, List<StampRallyModel> value) {
      if (key != 'null') {
        for (final StampRallyModel element in value) {
          latList.add(element.lat.toDouble());
          lngList.add(element.lng.toDouble());
        }
      }
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

  ///
  void makeStampMarkerList() {
    stampMarkerList.clear();

    int i = 0;
    int j = 0;

    _currentStampMap.forEach((String key, List<StampRallyModel> value) {
      if (key != 'null') {
        final List<Marker> list = <Marker>[];

        for (final StampRallyModel element in value) {
          final int markerIndex = j;

          list.add(
            Marker(
              point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
              child: GestureDetector(
                onTap: () {
                  iconToolChipDisplayOverlay(
                    type: 'stamp_rally_map_alert_icon',
                    context: context,
                    buttonKey: globalKeyList[markerIndex],
                    message: element.stationName,
                    displayDuration: const Duration(seconds: 2),
                  );
                },
                child: Container(
                  key: globalKeyList[markerIndex],
                  child: Icon(FontAwesomeIcons.stamp, color: twentyFourColor[i % 24]),
                ),
              ),
            ),
          );

          j++;
        }

        stampMarkerList.add(list);
        i++;
      }
    });
  }

  ///
  // ignore: always_specify_types
  List<Polyline<Object>> makeTransportationPolyline() {
    final List<MapEntry<String, List<StampRallyModel>>> validEntries = _currentStampMap.entries
        .where((MapEntry<String, List<StampRallyModel>> e) => e.key != 'null')
        .toList();

    return <Polyline<Object>>[
      for (int i = 0; i < validEntries.length; i++)
        Polyline<Object>(
          points: _sortedLatLngList(validEntries[i].value),
          color: twentyFourColor[i % 24],
          strokeWidth: 5,
        ),
    ];
  }

  ///
  List<LatLng> _sortedLatLngList(List<StampRallyModel> list) {
    final List<StampRallyModel> sorted = List<StampRallyModel>.from(list);

    sorted.sort((StampRallyModel a, StampRallyModel b) {
      if (widget.type == 'metro_all_station') {
        return a.stampGetOrder.compareTo(b.stampGetOrder);
      } else {
        return a.time.compareTo(b.time);
      }
    });

    return sorted.map((StampRallyModel t) => LatLng(t.lat.toDouble(), t.lng.toDouble())).toList();
  }
}
