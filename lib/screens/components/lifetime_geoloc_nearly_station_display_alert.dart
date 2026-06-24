import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';

class LifetimeGeolocNearlyStationDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocNearlyStationDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<LifetimeGeolocNearlyStationDisplayAlert> createState() =>
      _LifetimeGeolocNearlyStationDisplayAlertState();
}

class _LifetimeGeolocNearlyStationDisplayAlertState extends ConsumerState<LifetimeGeolocNearlyStationDisplayAlert>
    with ControllersMixin<LifetimeGeolocNearlyStationDisplayAlert> {
  final MapController mapController = MapController();

  List<Marker> markerList = <Marker>[];
  List<Color> fortyEightColor = <Color>[];
  final Utility utility = Utility();

  StreamSubscription<dynamic>? _mapReadySubscription;
  Timer? _zoomDebounce;
  ProviderSubscription<AppParamState>? _appParamSub;

  bool _cacheBuilt = false;
  String _cacheKey = '';
  List<StationModel> _visibleStations = <StationModel>[];
  bool _showStations = true;

  // 親のoverlayを復活させるために保存しておく
  OverlayState? _savedOverlayState;
  List<OverlayEntry>? _cachedFirstEntries;

  @override
  AppParamState get appParamState => ref.read(appParamProvider);

  ///
  @override
  void initState() {
    super.initState();

    _appParamSub = ref.listenManual<AppParamState>(appParamProvider, (AppParamState? prev, AppParamState next) {
      if (!mounted) {
        return;
      }
      if (prev?.keepStationList != next.keepStationList || prev?.keepGeolocMap != next.keepGeolocMap) {
        _updateVisibleStations();
      }
      setState(() {});
    });

    fortyEightColor = utility.getFortyEightColor();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      // OverlayStateを保存（dispose時の復活に使う）
      _savedOverlayState = Overlay.of(context);

      // 親のoverlayを非表示にする
      _hideParentOverlay();

      _mapReadySubscription = mapController.mapEventStream.take(1).listen((_) {
        if (mounted) {
          _fitBounds();
          _updateVisibleStations();
        }
      });
    });
  }

  ///
  @override
  void dispose() {
    // このalertが閉じたら親のoverlayを復活させる
    _restoreParentOverlay();

    try {
      _zoomDebounce?.cancel();
      _mapReadySubscription?.cancel();
      _appParamSub?.close();
    } catch (e) {
      debugPrint('dispose error: $e');
    }
    super.dispose();
  }

  ///
  void _hideParentOverlay() {
    final List<OverlayEntry>? entries = ref.read(appParamProvider).firstEntries;
    if (entries == null) {
      return;
    }
    // dispose時にrefが使えないため、ここでキャッシュしておく
    _cachedFirstEntries = List<OverlayEntry>.from(entries);
    for (final OverlayEntry e in entries) {
      try {
        e.remove();
      } catch (_) {}
    }
  }

  ///
  void _restoreParentOverlay() {
    final OverlayState? overlayState = _savedOverlayState;
    final List<OverlayEntry>? entries = _cachedFirstEntries;
    if (overlayState == null || entries == null || entries.isEmpty) {
      return;
    }
    // dispose は finalizeTree フェーズ中に呼ばれるため、
    // 同期的な insert は失敗する。次フレームに遅延させる。
    Future<void>(() {
      if (!overlayState.mounted) {
        return;
      }
      for (final OverlayEntry e in entries) {
        try {
          overlayState.insert(e);
        } catch (_) {}
      }
    });
  }

  ///
  @override
  void didUpdateWidget(covariant LifetimeGeolocNearlyStationDisplayAlert oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date) {
      _cacheBuilt = false;
      _cacheKey = '';
    }
  }

  ///
  List<GeolocModel> get _sortedGeolocList {
    final List<GeolocModel>? list = appParamState.keepGeolocMap[widget.date];
    if (list == null || list.isEmpty) {
      return <GeolocModel>[];
    }
    return <GeolocModel>[...list]..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time));
  }

  ///
  void _fitBounds() {
    final List<GeolocModel> list = _sortedGeolocList;
    if (list.isEmpty) {
      return;
    }

    final List<LatLng> points = list
        .map((GeolocModel g) => LatLng(g.latitude.toDouble(), g.longitude.toDouble()))
        .toList();

    final LatLngBounds bounds = LatLngBounds.fromPoints(points);
    mapController.rotate(0);
    mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)));
  }

  ///
  String _buildCacheKey() {
    final int geolocLen = appParamState.keepGeolocMap[widget.date]?.length ?? 0;
    final int polygonsLen = appParamState.keepAllPolygonsList.length;
    return '${widget.date}_${geolocLen}_$polygonsLen';
  }

  ///
  void _rebuildCachesIfNeeded() {
    final String key = _buildCacheKey();
    if (_cacheBuilt && key == _cacheKey) {
      return;
    }
    _cacheKey = key;
    _cacheBuilt = true;
    _makeMarkers();
  }

  ///
  void _makeMarkers() {
    markerList.clear();

    final List<GeolocModel> sortedList = _sortedGeolocList;
    if (sortedList.isEmpty) {
      return;
    }

    for (int index = 0; index < sortedList.length; index++) {
      final GeolocModel current = sortedList[index];
      double bearingDegrees = 0.0;

      if (index >= 1) {
        final GeolocModel previous = sortedList[index - 1];
        bearingDegrees = _bearingDegrees(
          from: LatLng(previous.latitude.toDouble(), previous.longitude.toDouble()),
          to: LatLng(current.latitude.toDouble(), current.longitude.toDouble()),
        );
      }

      markerList.add(
        Marker(
          point: LatLng(current.latitude.toDouble(), current.longitude.toDouble()),
          width: 40,
          height: 40,
          child: Center(
            child: Transform.rotate(
              angle: bearingDegrees * pi / 180.0,
              child: const Icon(Icons.navigation, color: Colors.black, size: 22),
            ),
          ),
        ),
      );
    }
  }

  ///
  void _updateVisibleStations() {
    final List<GeolocModel> geolocList = _sortedGeolocList;
    if (geolocList.isEmpty || appParamState.keepStationList.isEmpty) {
      if (mounted) {
        setState(() {
          _visibleStations = <StationModel>[];
        });
      }
      return;
    }

    const Distance distCalc = Distance();
    const double thresholdMeters = 500;

    final List<LatLng> geolocPoints = geolocList
        .map((GeolocModel g) => LatLng(g.latitude.toDouble(), g.longitude.toDouble()))
        .toList();

    final Set<String> seenNames = <String>{};
    final List<StationModel> filtered = appParamState.keepStationList.where((StationModel station) {
      final double? lat = double.tryParse(station.lat);
      final double? lng = double.tryParse(station.lng);
      if (lat == null || lng == null) {
        return false;
      }
      if (!seenNames.add(station.stationName)) {
        return false;
      }
      final LatLng stationPoint = LatLng(lat, lng);
      return geolocPoints.any((LatLng g) => distCalc.as(LengthUnit.Meter, stationPoint, g) <= thresholdMeters);
    }).toList();

    if (mounted) {
      setState(() {
        _visibleStations = filtered;
      });
    }
  }

  ///
  // ignore: always_specify_types
  List<Polyline> _makeRoutePolylines() {
    final TransportationModel? transport = appParamState.keepTransportationMap[widget.date];
    if (transport == null || transport.spotDataModelListMap.isEmpty) {
      // ignore: always_specify_types
      return <Polyline>[];
    }
    // ignore: always_specify_types
    final List<Polyline> polylines = <Polyline>[];
    for (int i = 0; i < transport.spotDataModelListMap.length; i++) {
      final List<SpotDataModel>? spots = transport.spotDataModelListMap[i];
      if (spots == null || spots.isEmpty) {
        continue;
      }
      final List<LatLng> points = <LatLng>[];
      for (final SpotDataModel spot in spots) {
        final double? lat = double.tryParse(spot.lat);
        final double? lng = double.tryParse(spot.lng);
        if (lat != null && lng != null) {
          points.add(LatLng(lat, lng));
        }
      }
      if (points.length < 2) {
        continue;
      }
      polylines.add(
        // ignore: always_specify_types
        Polyline(
          points: points,
          color: transport.oufuku ? fortyEightColor[0] : fortyEightColor[i % 48],
          strokeWidth: 5,
        ),
      );
    }
    return polylines;
  }

  ///
  double _bearingDegrees({required LatLng from, required LatLng to}) {
    final double fromLatRad = from.latitude * pi / 180.0;
    final double fromLonRad = from.longitude * pi / 180.0;
    final double toLatRad = to.latitude * pi / 180.0;
    final double toLonRad = to.longitude * pi / 180.0;
    final double deltaLonRad = toLonRad - fromLonRad;
    final double y = sin(deltaLonRad) * cos(toLatRad);
    final double x = cos(fromLatRad) * sin(toLatRad) - sin(fromLatRad) * cos(toLatRad) * cos(deltaLonRad);
    double bearingDeg = atan2(y, x) * 180.0 / pi;
    bearingDeg = (bearingDeg + 360.0) % 360.0;
    return bearingDeg;
  }

  ///
  @override
  Widget build(BuildContext context) {
    _rebuildCachesIfNeeded();

    final List<GeolocModel> list = _sortedGeolocList;
    final GeolocModel? first = list.isNotEmpty ? list[0] : null;

    // ignore: always_specify_types
    final List<Polyline> routePolylines = _makeRoutePolylines();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: first != null
                  ? LatLng(first.latitude.toDouble(), first.longitude.toDouble())
                  : const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: 12,
              onPositionChanged: (MapCamera camera, bool hasGesture) {
                if (!hasGesture) {
                  return;
                }
                _zoomDebounce?.cancel();
                _zoomDebounce = Timer(const Duration(milliseconds: 80), () {
                  if (!mounted) {
                    return;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) {
                      return;
                    }
                    appParamNotifier.setCurrentZoom(zoom: camera.zoom);
                  });
                });
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
                  polygons: makeAreaPolygons(
                    allPolygonsList: appParamState.keepAllPolygonsList,
                    fortyEightColor: fortyEightColor,
                  ),
                ),
              ],
              MarkerLayer(markers: markerList),
              if (routePolylines.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolylineLayer(polylines: routePolylines),
              ],
              if (_showStations && _visibleStations.isNotEmpty)
                MarkerLayer(
                  markers: _visibleStations.map((StationModel station) {
                    final double lat = double.parse(station.lat);
                    final double lng = double.parse(station.lng);
                    return Marker(
                      point: LatLng(lat, lng),
                      width: 60,
                      height: 40,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.train, color: Colors.red, size: 16),
                          Text(
                            station.stationName,
                            style: const TextStyle(fontSize: 8, color: Colors.red, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setState(() {
                    _showStations = !_showStations;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.train, size: 14, color: _showStations ? Colors.red : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _showStations ? '駅:ON' : '駅:OFF',
                          style: TextStyle(
                            fontSize: 12,
                            color: _showStations ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _fitBounds,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.fit_screen, size: 14, color: Colors.blueGrey),
                        SizedBox(width: 4),
                        Text(
                          '範囲リセット',
                          style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
