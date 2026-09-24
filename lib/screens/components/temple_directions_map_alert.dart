import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/_get_data/directions/directions.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/direction_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';

class TempleDirectionsMapAlert extends ConsumerStatefulWidget {
  const TempleDirectionsMapAlert({super.key, required this.fromSpot, required this.toSpot});

  final SpotDataModel fromSpot;
  final SpotDataModel toSpot;

  @override
  ConsumerState<TempleDirectionsMapAlert> createState() => _TempleDirectionsMapAlertState();
}

class _TempleDirectionsMapAlertState extends ConsumerState<TempleDirectionsMapAlert>
    with ControllersMixin<TempleDirectionsMapAlert> {
  List<Map<String, Map<String, String>>> stepLocationList = <Map<String, Map<String, String>>>[];

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  bool isLoading = false;

  /// Directions API でルートを取得している間だけ true（成功・失敗どちらでも終了時に false）
  bool _isFetchingRoute = true;

  double? currentZoom;

  Utility utility = Utility();

  List<LatLng> latLngList = <LatLng>[];

  List<Marker> directionGoalMarkerList = <Marker>[];

  List<Color> fortyEightColor = <Color>[];

  List<List<List<List<double>>>>? _areaPolygonsSource;
  List<Polygon<Object>> _areaPolygons = <Polygon<Object>>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    Future(() async {
      try {
        await directionsNotifier.fetch(
          origin: widget.fromSpot.address,
          destination: widget.toSpot.address,
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );
      } catch (e) {
        // 取得失敗時は従来どおりルート描画を行わない（以前は未捕捉の例外だった）
        debugPrint('TempleDirectionsMapAlert directions fetch error: $e');
        return;
      } finally {
        if (mounted) {
          setState(() => _isFetchingRoute = false);
        }
      }

      /// 修正: 通信待ちの間に画面が閉じられていると ref / setState が例外になるため中断する
      if (!mounted) {
        return;
      }

      final DirectionsModel? state = ref.read(directionsProvider);

      if (state != null) {
        final List<Map<String, Map<String, String>>> list = <Map<String, Map<String, String>>>[];

        // ignore: always_specify_types
        final steps = state.routes.expand((r) => r.legs).expand((l) => l.steps);

        // ignore: always_specify_types
        for (final step in steps) {
          list.add(<String, Map<String, String>>{
            'start': <String, String>{
              'latitude': step.startLocation.lat.toString(),
              'longitude': step.startLocation.lng.toString(),
            },
            'end': <String, String>{
              'latitude': step.endLocation.lat.toString(),
              'longitude': step.endLocation.lng.toString(),
            },
          });
        }

        setState(() => stepLocationList = list);
      }
    });

    fortyEightColor = utility.getFortyEightColor();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        /// 修正: 2秒待つ間に画面が閉じられていたら何もしない（dispose 後の setState を防ぐ）
        if (!mounted) {
          return;
        }

        setDefaultBoundsMap();

        setState(() => isLoading = false);
      });
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ref.watch(directionsProvider);

    makeMinMaxLatLng();

    makeDirectionGoalMarker();

    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                  urlTemplate: 'https://tile.openstreetmap.jp/{z}/{x}/{y}.png',
                  tileProvider: CachedTileProvider(),
                  userAgentPackageName: 'com.example.app',
                ),

                if (appParamState.keepAllPolygonsList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(
                    polygons: _getAreaPolygons(),
                  ),
                ],

                if (stepLocationList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(polylines: makeTransportationPolyline()),
                ],

                MarkerLayer(markers: directionGoalMarkerList),
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

                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 12),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.redAccent.withValues(alpha: 0.4),
                                child: const Text('START', style: TextStyle(color: Colors.white, fontSize: 8)),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.fromSpot.name),
                                    Text(widget.fromSpot.address),
                                    Text(
                                      '${widget.fromSpot.lat} / ${widget.fromSpot.lng}',

                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.redAccent.withValues(alpha: 0.4),
                                child: const Text('GOAL', style: TextStyle(color: Colors.white, fontSize: 8)),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: <Widget>[
                                    Text(widget.toSpot.name),
                                    Text(widget.toSpot.address),
                                    Text(
                                      '${widget.toSpot.lat} / ${widget.toSpot.lng}',
                                      style: const TextStyle(fontSize: 10),
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
                ],
              ),
            ),

            if (isLoading || _isFetchingRoute) ...<Widget>[const Center(child: CircularProgressIndicator())],
          ],
        ),
      ),
    );
  }

  ///
  /// 行政区域ポリゴンは重い（全ポリゴンの toString による重複排除を含む）ため、元リストが変わった時だけ作り直す
  /// （地図移動のたびに setCurrentZoom で再ビルドされるため）
  List<Polygon<Object>> _getAreaPolygons() {
    final List<List<List<List<double>>>> allPolygonsList = appParamState.keepAllPolygonsList;
    if (_areaPolygonsSource != allPolygonsList) {
      _areaPolygonsSource = allPolygonsList;
      _areaPolygons = makeAreaPolygons(allPolygonsList: allPolygonsList, fortyEightColor: fortyEightColor);
    }
    return _areaPolygons;
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    latLngList.clear();

    for (final Map<String, Map<String, String>> element in stepLocationList) {
      element.forEach((String key, Map<String, String> value) {
        latList.add((value['latitude'] != null) ? value['latitude'].toString().toDouble() : 0);
        lngList.add((value['longitude'] != null) ? value['longitude'].toString().toDouble() : 0);

        latLngList.add(LatLng(value['latitude'].toString().toDouble(), value['longitude'].toString().toDouble()));
      });
    }

    latList = latList.toSet().toList();
    lngList = lngList.toSet().toList();

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void setDefaultBoundsMap() {
    if (stepLocationList.isNotEmpty) {
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
  // ignore: always_specify_types
  List<Polyline> makeTransportationPolyline() {
    // ignore: always_specify_types
    return <Polyline<Object>>[Polyline(points: latLngList, color: fortyEightColor[0], strokeWidth: 5)];
  }

  ///
  void makeDirectionGoalMarker() {
    directionGoalMarkerList.clear();

    if (stepLocationList.isNotEmpty) {
      final Map<String, Map<String, String>> stepLocationListLast = stepLocationList.last;

      if (stepLocationListLast['end'] != null) {
        directionGoalMarkerList.add(
          Marker(
            point: LatLng(
              stepLocationListLast['end']!['latitude']!.toDouble(),

              stepLocationListLast['end']!['longitude']!.toDouble(),
            ),

            child: Icon(Icons.flag, color: fortyEightColor[0]),
          ),
        );
      }
    }
  }
}
