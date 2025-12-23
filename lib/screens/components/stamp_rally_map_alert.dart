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
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../parts/glow_blink.dart';
import '../parts/glowing_polyline_layer.dart';
import '../parts/icon_toolchip_display_overlay.dart';

class StampRallyMapAlert extends ConsumerStatefulWidget {
  const StampRallyMapAlert({super.key, required this.type});

  final String type;

  @override
  ConsumerState<StampRallyMapAlert> createState() => _StampRallyMapAlertState();
}

class _StampRallyMapAlertState extends ConsumerState<StampRallyMapAlert>
    with ControllersMixin<StampRallyMapAlert>, SingleTickerProviderStateMixin {
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

  late GlowBlink sharedBlink;
  bool _blinkRunning = true;

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
  List<MapEntry<String, List<StampRallyModel>>> get _validEntries {
    return _currentStampMap.entries.where((MapEntry<String, List<StampRallyModel>> e) => e.key != 'null').toList();
  }

  ///
  List<MapEntry<String, List<StampRallyModel>>> get _validEntriesSorted {
    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntries;

    entries.sort((MapEntry<String, List<StampRallyModel>> a, MapEntry<String, List<StampRallyModel>> b) {
      final DateTime? da = _tryParseKeyAsDate(a.key);
      final DateTime? db = _tryParseKeyAsDate(b.key);

      if (da != null && db != null) {
        final int cmp = da.compareTo(db);
        if (cmp != 0) {
          return cmp;
        }
        return a.key.compareTo(b.key);
      }

      if (da != null && db == null) {
        return -1;
      }
      if (da == null && db != null) {
        return 1;
      }

      return a.key.compareTo(b.key);
    });

    return entries;
  }

  ///
  Map<String, Color> get _routeColorByKey {
    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntriesSorted;

    final Map<String, Color> map = <String, Color>{};
    for (int i = 0; i < entries.length; i++) {
      map[entries[i].key] = twentyFourColor[i % 24];
    }
    return map;
  }

  ///
  DateTime? _tryParseKeyAsDate(String key) {
    final String k = key.trim();
    if (k.isEmpty) {
      return null;
    }

    final String normalized = k.replaceAll('/', '-');

    try {
      return DateTime.parse(normalized);
    } catch (_) {
      if (normalized.length >= 10) {
        final String head = normalized.substring(0, 10);
        try {
          return DateTime.parse(head);
        } catch (_) {
          return null;
        }
      }
      return null;
    }
  }

  ///
  @override
  void initState() {
    super.initState();

    twentyFourColor = utility.getTwentyFourColor();

    // ignore: always_specify_types
    globalKeyList = List.generate(1000, (int index) => GlobalKey());

    sharedBlink = GlowBlink(vsync: this, curve: Curves.easeInOutCubic);

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
  void dispose() {
    sharedBlink.dispose();
    super.dispose();
  }

  ///
  void _stopBlink() {
    sharedBlink.stop();
    setState(() => _blinkRunning = false);
  }

  ///
  void _startBlink() {
    sharedBlink.restartFromZero();
    setState(() => _blinkRunning = true);
  }

  ///
  void _selectRoute(int index) {
    appParamNotifier.setSelectedStampRallyMapPolylineIndex(index: index);

    if (_blinkRunning) {
      sharedBlink.restartFromZero();
    }

    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntriesSorted;
    if (index < 0 || index >= entries.length) {
      return;
    }

    final List<LatLng> points = _sortedLatLngList(entries[index].value);
    _focusOnPolyline(points);
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();
    makeStampMarkerList();

    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntriesSorted;

    final int? selectedIndex =
        appParamState.selectedStampRallyMapPolylineIndex ?? (entries.isEmpty ? null : entries.length - 1);

    // ignore: always_specify_types
    final List<Polyline<Object>> nonGlowingPolylines = <Polyline<Object>>[];

    List<LatLng>? glowingPoints;
    Color? glowingColor;
    double glowingWidth = 5;

    for (int i = 0; i < entries.length; i++) {
      final List<LatLng> points = _sortedLatLngList(entries[i].value);

      final Color color = _routeColorByKey[entries[i].key] ?? twentyFourColor[i % 24];

      const double strokeWidth = 5;

      if (selectedIndex != null && i == selectedIndex) {
        glowingPoints = points;
        glowingColor = color;
        glowingWidth = strokeWidth;
      } else {
        nonGlowingPolylines.add(Polyline<Object>(points: points, color: color, strokeWidth: strokeWidth));
      }
    }

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

              if (appParamState.keepAllPolygonsList.isNotEmpty) ...<Widget>[
                // ignore: always_specify_types
                PolygonLayer(
                  polygons: makeAreaPolygons(
                    allPolygonsList: appParamState.keepAllPolygonsList,
                    twentyFourColor: utility.getTwentyFourColor(),
                  ),
                ),
              ],

              // ignore: always_specify_types
              if (nonGlowingPolylines.isNotEmpty) PolylineLayer(polylines: nonGlowingPolylines),

              if (glowingPoints != null && glowingColor != null)
                (_blinkRunning
                    ? GlowingPolylineLayer(
                        points: glowingPoints,
                        coreColor: glowingColor.withOpacity(0.95),
                        glowColor: glowingColor,
                        coreWidth: glowingWidth,
                        blink: sharedBlink,
                      )
                    // ignore: always_specify_types
                    : PolylineLayer(
                        polylines: <Polyline<Object>>[
                          Polyline<Object>(
                            points: glowingPoints,
                            color: glowingColor.withOpacity(0.95),
                            strokeWidth: glowingWidth,
                            borderColor: Colors.black.withOpacity(0.2),
                            borderStrokeWidth: glowingWidth * 0.4,
                          ),
                        ],
                      )),

              for (int i = 0; i < stampMarkerList.length; i++) MarkerLayer(markers: stampMarkerList[i]),
            ],
          ),

          if (appParamState.selectedStampRallyMapPolylineIndex != null) ...<Widget>[
            Positioned(
              bottom: 60,
              right: 5,
              left: 5,
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: displaySelectedPolylineStations(),
              ),
            ),

            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent.withOpacity(0.5),

                child: IconButton(
                  onPressed: _blinkRunning ? _stopBlink : _startBlink,
                  icon: Icon(_blinkRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                ),
              ),
            ),
          ],

          Positioned(left: 0, right: 0, bottom: 8, child: _buildRouteButtons(entries, selectedIndex)),

          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  Widget displaySelectedPolylineStations() {
    final List<Widget> list = <Widget>[];

    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntriesSorted
      ..sort(
        (MapEntry<String, List<StampRallyModel>> a, MapEntry<String, List<StampRallyModel>> b) =>
            a.key.compareTo(b.key),
      );

    int stampRallyMapPolylineIndex = 0;
    for (final MapEntry<String, List<StampRallyModel>> entry in entries) {
      final String key = entry.key;

      if (stampRallyMapPolylineIndex == appParamState.selectedStampRallyMapPolylineIndex) {
        if (key == 'null') {
          continue;
        }

        final List<StampRallyModel> value = List<StampRallyModel>.from(entry.value);

        switch (widget.type) {
          case 'metro_all_station':
            value.sort((StampRallyModel a, StampRallyModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));

          case 'metro_20_anniversary':
          case 'metro_pokepoke':
            value.sort((StampRallyModel a, StampRallyModel b) => a.time.compareTo(b.time));
        }

        final Set<String> stationNames = <String>{};

        int stampIconGuideNum = 0;
        for (final StampRallyModel element in value) {
          if (!stationNames.add(element.stationName)) {
            continue;
          }

          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),

              child: Row(
                children: <Widget>[
                  Text((stampIconGuideNum + 1).toString().padLeft(2, '0')),
                  const Text('：'),
                  Text(element.stationName),
                ],
              ),
            ),
          );

          stampIconGuideNum++;
        }
      }

      stampRallyMapPolylineIndex++;
    }

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list),
    );
  }

  ///
  Widget _buildRouteButtons(List<MapEntry<String, List<StampRallyModel>>> entries, int? selectedIndex) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> buttons = <Widget>[
      for (int i = 0; i < entries.length; i++)
        _routeButton(
          label: entries[i].key,
          isSelected: selectedIndex != null && i == selectedIndex,
          onTap: () => _selectRoute(i),
        ),
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(spacing: 8, children: buttons),
        ),
      ),
    );
  }

  ///
  Widget _routeButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        backgroundColor: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.pinkAccent.withOpacity(0.2),
        foregroundColor: isSelected ? Colors.black : Colors.white,
      ),
      child: Text(label),
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

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      appParamNotifier.setCurrentZoom(zoom: newZoom);
    }
  }

  ///
  void makeStampMarkerList() {
    stampMarkerList.clear();

    int allIndex = 0;

    final List<MapEntry<String, List<StampRallyModel>>> entries = _validEntriesSorted
      ..sort(
        (MapEntry<String, List<StampRallyModel>> a, MapEntry<String, List<StampRallyModel>> b) =>
            a.key.compareTo(b.key),
      );

    for (int i = 0; i < entries.length; i++) {
      final String key = entries[i].key;
      final List<StampRallyModel> value = entries[i].value;

      final Color iconColor = _routeColorByKey[key] ?? twentyFourColor[i % 24];

      final List<Marker> list = <Marker>[];

      final List<StampRallyModel> value2 = List<StampRallyModel>.from(value);

      switch (widget.type) {
        case 'metro_all_station':
          value2.sort((StampRallyModel a, StampRallyModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));

        case 'metro_20_anniversary':
        case 'metro_pokepoke':
          value2.sort((StampRallyModel a, StampRallyModel b) => a.time.compareTo(b.time));
      }

      final Set<String> stationNames = <String>{};

      int stampIconGuideNum = 0;
      for (final StampRallyModel element in value2) {
        if (!stationNames.add(element.stationName)) {
          continue;
        }

        list.add(
          Marker(
            point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
            child: GestureDetector(
              onTap: () {
                iconToolChipDisplayOverlay(
                  type: 'stamp_rally_map_alert_icon',
                  context: context,
                  buttonKey: globalKeyList[allIndex],
                  displayDuration: const Duration(seconds: 2),
                  stampRallyModel: element,
                );
              },

              child: SizedBox(
                key: globalKeyList[allIndex],
                width: 30,
                height: 30,
                child: Stack(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.stamp, color: iconColor),

                    if (i == appParamState.selectedStampRallyMapPolylineIndex) ...<Widget>[
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: Center(
                            child: Text((stampIconGuideNum + 1).toString(), style: const TextStyle(fontSize: 10)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );

        allIndex++;
        stampIconGuideNum++;
      }

      stampMarkerList.add(list);
    }
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

  ///
  void _focusOnPolyline(List<LatLng> points) {
    final List<LatLng> safePoints = points.where((LatLng p) => p.latitude.isFinite && p.longitude.isFinite).toList();

    if (safePoints.isEmpty) {
      return;
    }

    final LatLngBounds bounds = LatLngBounds.fromPoints(safePoints);
    final LatLng center = bounds.center;

    const double eps = 1e-8;
    final bool isAlmostPoint = (bounds.north - bounds.south).abs() < eps && (bounds.east - bounds.west).abs() < eps;

    final EdgeInsets padding = EdgeInsets.fromLTRB(24, 24, 24, 120 + (appParamState.currentPaddingIndex * 10));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (isAlmostPoint || safePoints.length == 1) {
        const double pointZoom = 19.0;

        final double current = mapController.camera.zoom;
        final double targetZoom = current.isFinite ? max(current, pointZoom) : pointZoom;

        final double clamped = targetZoom.clamp(3.0, 20.0);

        mapController.move(center, clamped);
        return;
      }

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: padding);
      mapController.fitCamera(cameraFit);

      final double z = mapController.camera.zoom;
      if (!z.isFinite) {
        mapController.move(center, 16.0);
        return;
      }

      final double clamped = z.clamp(3.0, 19.0);
      if (clamped != z) {
        mapController.move(center, clamped);
      }
    });
  }
}
