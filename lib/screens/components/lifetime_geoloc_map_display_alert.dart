import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/_get_data/lat_lng_address/lat_lng_address.dart';
import '../../controllers/app_param/app_param.dart';
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
import 'lifetime_geoloc_ghost_temple_info_alert.dart';
import 'route_info_display_alert.dart';
import 'temple_list_display_alert.dart';
import 'time_place_display_alert.dart';

class LifetimeGeolocMapDisplayAlert extends ConsumerStatefulWidget {
  const LifetimeGeolocMapDisplayAlert({
    super.key,
    required this.date,
    this.geolocList,
    required this.templeGeolocNearlyDateList,
  });

  final String date;
  final List<GeolocModel>? geolocList;
  final List<String> templeGeolocNearlyDateList;

  @override
  ConsumerState<LifetimeGeolocMapDisplayAlert> createState() => _LifetimeGeolocMapDisplayAlertState();
}

class _LifetimeGeolocMapDisplayAlertState extends ConsumerState<LifetimeGeolocMapDisplayAlert>
    with ControllersMixin<LifetimeGeolocMapDisplayAlert> {
  static const int _maxGlobalKeys = 1000;
  static const int _stampRallyAllStationKeyOffset = 100;
  static const int _stampRally20AnniversaryKeyOffset = 200;
  static const int _stampRallyPokepokeKeyOffset = 300;

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

  List<Marker> displayGhostGeolocDateList = <Marker>[];

  List<Marker> routePolylineInfoMarkerList = <Marker>[];

  String _cacheKey = '';

  bool _cacheBuilt = false;

  StreamSubscription<dynamic>? _mapReadySubscription;

  List<Polyline<Object>> ghostPolylines = <Polyline<Object>>[];

  /// ===== zoom更新のデバウンス用 =====
  Timer? _zoomDebounce;

  /// ref.watch の代わりに ref.read を使用（サブスクリプションを作らない）。
  /// 再描画は initState の ref.listen が担う。
  @override
  AppParamState get appParamState => ref.read(appParamProvider);

  ProviderSubscription<AppParamState>? _appParamSub;

  @override
  void initState() {
    super.initState();

    // ✅ initState では listenManual を使う
    _appParamSub = ref.listenManual<AppParamState>(appParamProvider, (_, __) {
      if (mounted) {
        setState(() {});
      }
    });

    fortyEightColor = utility.getFortyEightColor();

    // ignore: always_specify_types
    globalKeyList = List.generate(_maxGlobalKeys, (int index) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() => isLoading = true);

      final List<GeolocModel>? geolocList = widget.geolocList;
      if (geolocList != null && geolocList.isNotEmpty) {
        final List<LatLng> points = geolocList
            .map((GeolocModel g) => LatLng(g.latitude.toDouble(), g.longitude.toDouble()))
            .toList();

        if (points.isNotEmpty) {
          final LatLngBounds bounds = LatLngBounds.fromPoints(points);

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
      }

      _mapReadySubscription = mapController.mapEventStream.take(1).listen((_) {
        if (mounted) {
          setDefaultBoundsMap();
          setState(() => isLoading = false);
        }
      });
    });
  }

  ///
  @override
  void dispose() {
    try {
      _zoomDebounce?.cancel();
      _mapReadySubscription?.cancel();

      // ✅ listenManual は dispose で close
      _appParamSub?.close();
    } catch (e) {
      debugPrint('dispose error: $e');
    }

    super.dispose();
  }

  ///
  @override
  void didUpdateWidget(covariant LifetimeGeolocMapDisplayAlert oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date ||
        oldWidget.geolocList?.length != widget.geolocList?.length ||
        oldWidget.templeGeolocNearlyDateList.length != widget.templeGeolocNearlyDateList.length) {
      _cacheBuilt = false;
      _cacheKey = '';
    }
  }

  ///
  String _buildCacheKey() {
    final int geolocLen = widget.geolocList?.length ?? 0;

    final int templeLen = appParamState.keepTempleMap[widget.date]?.templeDataList.length ?? 0;

    final TransportationModel? t = appParamState.keepTransportationMap[widget.date];
    final int transLen = t?.spotDataModelListMap.length ?? 0;
    final bool oufuku = t?.oufuku ?? false;

    final int ghostLen = widget.templeGeolocNearlyDateList.length;
    final bool ghostFlag = appParamState.isDisplayGhostGeolocPolyline;

    return <Object>[
      widget.date,
      geolocLen,
      templeLen,
      transLen,
      if (oufuku) 1 else 0,
      ghostLen,
      if (ghostFlag) 1 else 0,
    ].join('_');
  }

  ///
  void _rebuildMunicipalNameSet() {
    dateMunicipalNameSet.clear();
    final List<GeolocModel>? geolocList = widget.geolocList;
    if (geolocList == null || geolocList.isEmpty) {
      return;
    }
    for (final GeolocModel geolocModel in geolocList) {
      final String? municipality = findMunicipalityForPoint(
        geolocModel.latitude.toDouble(),
        geolocModel.longitude.toDouble(),
        appParamState.keepTokyoMunicipalList,
      );
      if (municipality != null && municipality.isNotEmpty) {
        dateMunicipalNameSet.add(municipality);
      }
    }
  }

  ///
  void _rebuildCachesIfNeeded() {
    final String key = _buildCacheKey();
    if (_cacheBuilt && key == _cacheKey) {
      return;
    }
    _cacheKey = key;
    _cacheBuilt = true;

    _rebuildMunicipalNameSet();
    makeMinMaxLatLng();
    makeMarker();
    makeTransportationGoalMarker();
    makeTempleMarker();
    makeDisplayTimeMarker();
    makeStampRallyMetroAllStationMarker();
    makeStampRallyMetro20AnniversaryMarker();
    makeStampRallyMetroPokepokeMarker();
    makeDisplayGhostGeolocDateMarker();
    ghostPolylines = makeGhostGeolocPolyline();
  }

  ///
  @override
  Widget build(BuildContext context) {
    _rebuildCachesIfNeeded();

    final List<GeolocModel>? geolocList = widget.geolocList;
    final GeolocModel? firstGeoloc = (geolocList != null && geolocList.isNotEmpty) ? geolocList[0] : null;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: firstGeoloc != null
                  ? LatLng(firstGeoloc.latitude.toDouble(), firstGeoloc.longitude.toDouble())
                  : const LatLng(zenpukujiLat, zenpukujiLng),
              initialZoom: currentZoomEightTeen,

              /// ✅ ここが落ちてた原因
              /// 初期描画 / fitCamera / move でも呼ばれるので、
              /// provider更新を「ユーザー操作 + デバウンス + 次フレーム」に限定する
              onPositionChanged: (MapCamera position, bool hasGesture) {
                // ユーザー操作でない（初期描画/fit/move等）なら provider 更新しない
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
                    appParamNotifier.setCurrentZoom(zoom: position.zoom);
                  });
                });
              },
            ),
            children: _buildMapLayers(),
          ),
          _buildTopInfoPanel(),
          if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
          if (appParamState.selectedGeolocTime.isNotEmpty) ...<Widget>[_buildBottomAddressPanel()],
        ],
      ),
    );
  }

  ///
  List<Widget> _buildMapLayers() {
    return <Widget>[
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
      if (appParamState.keepTransportationMap[widget.date] case final TransportationModel transport
          when transport.spotDataModelListMap.isNotEmpty) ...<Widget>[
        // ignore: always_specify_types
        PolylineLayer(polylines: makeTransportationPolyline()),
        MarkerLayer(markers: routePolylineInfoMarkerList),
      ],
      if (appParamState.routePolylinePartsGeolocList.isNotEmpty) ...<Widget>[
        // ignore: always_specify_types
        PolylineLayer(polylines: makeRouteGeolocPolyline()),
      ],
      MarkerLayer(markers: transportationGoalMarkerList),
      MarkerLayer(markers: templeMarkerList),
      MarkerLayer(markers: displayTimeMarkerList),
      MarkerLayer(markers: stampRallyMetroAllStationMarkerList),
      MarkerLayer(markers: stampRallyMetro20AnniversaryMarkerList),
      MarkerLayer(markers: stampRallyMetroPokepokeMarkerList),
      if (widget.templeGeolocNearlyDateList.isNotEmpty && appParamState.isDisplayGhostGeolocPolyline) ...<Widget>[
        // ignore: always_specify_types
        PolylineLayer(polylines: ghostPolylines),
        MarkerLayer(markers: displayGhostGeolocDateList),
      ],
    ];
  }

  ///
  Widget _buildTopInfoPanel() {
    final DateTime? parsedDate = DateTime.tryParse(widget.date);
    final String youbi = parsedDate != null ? parsedDate.youbiStr.substring(0, 3) : '';

    return Positioned(
      top: 5,
      right: 5,
      left: 5,
      child: Column(
        children: <Widget>[
          Container(
            width: context.screenSize.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
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
                          Text(youbi),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('size:'),
                            Text(appParamState.currentZoom.toStringAsFixed(2), style: const TextStyle(fontSize: 20)),
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
                    if (appParamState.keepTransportationMap[widget.date] case final TransportationModel dateTransport
                        when dateTransport.stationRouteList.isNotEmpty) ...<Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: dateTransport.stationRouteList
                            .map((String e) => Text(e, style: const TextStyle(fontSize: 12)))
                            .toList(),
                      ),
                    ],
                    if (!appParamState.isDisplayMunicipalNameOnLifetimeGeolocMap) ...<Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => appParamNotifier.setIsDisplayMunicipalNameOnLifetimeGeolocMap(flag: true),
                            child: Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (appParamState.selectedGeolocPointTime.isNotEmpty) ...<Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(appParamState.selectedGeolocPointTime, style: const TextStyle(color: Colors.yellowAccent)),
                      GestureDetector(
                        onTap: () {
                          final List<GeolocModel>? list = _sortedGeolocListByTime();
                          if (list != null) {
                            final int pos = list.indexWhere(
                              (GeolocModel geoloc) => geoloc.time == appParamState.selectedGeolocPointTime,
                            );
                            if (pos != -1) {
                              appParamNotifier.setRoutePolylinePartsGeolocList(geolocModel: list[pos]);
                              if (pos + 1 < list.length) {
                                appParamNotifier.setSelectedGeolocPointTime(time: list[pos + 1].time);
                              }

                              appParamNotifier.setCurrentZoom(zoom: 15);

                              mapController.move(
                                LatLng(list[pos].latitude.toDouble(), list[pos].longitude.toDouble()),
                                15,
                              );
                              mapController.rotate(0);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: <Widget>[
                              Icon(Icons.stacked_line_chart, color: Colors.indigoAccent),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_circle_right_rounded, color: Colors.indigoAccent),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          color: Colors.black.withValues(alpha: 0.3),
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
                                  child: Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.8)),
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
                      color: Colors.black.withValues(alpha: 0.3),
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
                        color: Colors.black.withValues(alpha: 0.3),
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
                    if (widget.templeGeolocNearlyDateList.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),

                      Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (appParamState.isDisplayGhostGeolocPolyline)
                                  ? Colors.yellowAccent.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                appParamNotifier.setIsDisplayGhostGeolocPolyline(
                                  flag: !appParamState.isDisplayGhostGeolocPolyline,
                                );
                              },
                              child: const Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    child: Text('ghost', style: TextStyle(color: Colors.yellowAccent, fontSize: 8)),
                                  ),
                                  Icon(Icons.stacked_line_chart),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                ghostPolylines.length.toString(),
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildBottomAddressPanel() {
    return Positioned(
      bottom: 10,
      right: 5,
      left: 5,
      height: 150,
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(5),
        child: displayLatLngAddressList(),
      ),
    );
  }

  ///
  Widget displayDateMunicipalNameWidget() {
    final List<Widget> list = <Widget>[];

    cityTownNames.split('\n').forEach((String element) {
      if (element.isNotEmpty) {
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
  List<GeolocModel>? _sortedGeolocListByTime() {
    final List<GeolocModel>? geolocList = widget.geolocList;
    if (geolocList == null || geolocList.isEmpty) {
      return null;
    }
    return <GeolocModel>[...geolocList]..sort((GeolocModel a, GeolocModel b) => a.time.compareTo(b.time));
  }

  ///
  void makeDisplayTimeMarker() {
    final double safeZoom = (currentZoom2.isFinite && currentZoom2 > 0) ? currentZoom2 : baseZoom2;
    final double scaleFactorRaw = safeZoom / baseZoom2;
    final double scaleFactor = scaleFactorRaw.clamp(0.6, 2.0);

    displayTimeMarkerList.clear();

    String keepTime = '';
    final List<GeolocModel>? sortedList = _sortedGeolocListByTime();
    if (sortedList == null) {
      return;
    }

    for (final GeolocModel element in sortedList) {
      if (element.time.isEmpty) {
        continue;
      }
      final List<String> timeParts = element.time.split(':');
      final String hour = timeParts[0];
      if (keepTime != hour) {
        final String minute = timeParts.length > 1 ? timeParts[1] : '00';
        displayTimeMarkerList.add(
          Marker(
            point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
            width: (30 + 8 + timeContainerWidth + timeContainerWidth) * scaleFactor,
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: timeContainerWidth * scaleFactor),
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
                      children: <Widget>[Text('$hour:$minute', style: const TextStyle(fontWeight: FontWeight.bold))],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      keepTime = hour;
    }
  }

  ///
  Widget displayTempleNameList() {
    final List<Widget> list = <Widget>[];

    final TempleModel? templeModel = appParamState.keepTempleMap[widget.date];
    if (templeModel == null) {
      return const SizedBox.shrink();
    }

    for (int i = 0; i < templeModel.templeDataList.length; i++) {
      final TempleDataModel templeData = templeModel.templeDataList[i];
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
                    templeData.name,
                    style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 3,
              bottom: 3,
              child: Text(templeData.rank, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
              templeModel.templeDataList.length.toString().padLeft(2, '0'),
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

    final List<GeolocModel>? sortedList = _sortedGeolocListByTime();
    if (sortedList != null) {
      for (final GeolocModel element in sortedList) {
        latList.add(element.latitude.toDouble());
        lngList.add(element.longitude.toDouble());
      }
    }

    final TempleModel? templeModel = appParamState.keepTempleMap[widget.date];
    if (templeModel != null && templeModel.templeDataList.length > 1) {
      latList.clear();
      lngList.clear();

      for (final TempleDataModel element in templeModel.templeDataList) {
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
    final List<GeolocModel>? geolocList = widget.geolocList;
    if (geolocList != null && geolocList.isNotEmpty) {
      mapController.rotate(0);

      // minLng / maxLng が逆になっていたので修正（ここ重要）
      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, minLng), LatLng(maxLat, maxLng)]);

      final CameraFit cameraFit = CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(ref.read(appParamProvider).currentPaddingIndex * 10),
      );

      mapController.fitCamera(cameraFit);

      final double newZoom = mapController.camera.zoom;

      if (mounted) {
        setState(() => currentZoom = newZoom);
      }

      /// ✅ fitCamera直後は onPositionChanged が走り得るので、
      /// provider更新は次フレームにずらして安全化
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        appParamNotifier.setCurrentZoom(zoom: newZoom);
      });

      if (ref.read(appParamProvider).keepTimePlaceMap[widget.date] != null) {
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
  /// 位置情報（GeolocModel）の並びを時刻順に並べ、
  /// 各地点に「移動方向（方位角）」に合わせて回転した矢印アイコンを表示する Marker を作成する。
  ///
  void makeMarker() {
    markerList.clear();

    final List<GeolocModel>? sortedByTime = _sortedGeolocListByTime();
    if (sortedByTime == null) {
      return;
    }

    final String boundingBoxArea = utility.getBoundingBoxArea(points: sortedByTime);

    for (int index = 0; index < sortedByTime.length; index++) {
      final GeolocModel current = sortedByTime[index];

      double bearingDegrees = 0.0;

      if (index >= 1) {
        final GeolocModel previous = sortedByTime[index - 1];

        final LatLng previousPosition = LatLng(previous.latitude.toDouble(), previous.longitude.toDouble());
        final LatLng currentPosition = LatLng(current.latitude.toDouble(), current.longitude.toDouble());

        bearingDegrees = _bearingDegrees(from: previousPosition, to: currentPosition);
      }

      markerList.add(
        Marker(
          point: LatLng(current.latitude.toDouble(), current.longitude.toDouble()),
          width: 40,
          height: 40,
          child: Center(
            child: boundingBoxArea.startsWith('0.0')
                ? const Icon(Icons.ac_unit, color: Colors.black, size: 22)
                : Transform.rotate(
                    angle: bearingDegrees * pi / 180.0,
                    child: const Icon(Icons.navigation, color: Colors.black, size: 22),
                  ),
          ),
        ),
      );
    }
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

    final double bearingRad = atan2(y, x);

    double bearingDeg = bearingRad * 180.0 / pi;

    bearingDeg = (bearingDeg + 360.0) % 360.0;

    return bearingDeg;
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
      color: Colors.blueGrey.withValues(alpha: 0.3),
      initialPosition: Offset(context.screenSize.width * 0.75, context.screenSize.height * 0.5),
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
    final List<GeolocModel>? sortedList = _sortedGeolocListByTime();
    if (sortedList != null) {
      for (final GeolocModel element in sortedList) {
        if (element.time.isEmpty) {
          continue;
        }
        final List<String> timeParts = element.time.split(':');
        final String hour = timeParts[0];
        if (keepTime != hour) {
          final String minute = timeParts.length > 1 ? timeParts[1] : '00';
          final String time = '$hour:$minute';

          list.add(
            GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedGeolocTime(time: time);
                appParamNotifier.setCurrentZoom(zoom: 18);
                mapController.move(LatLng(element.latitude.toDouble(), element.longitude.toDouble()), 18);
                mapController.rotate(0);
                if (ref.read(appParamProvider).keepTimePlaceMap[widget.date] != null) {
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
        keepTime = hour;
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
  // ignore: always_specify_types
  List<Polyline> makeTransportationPolyline() {
    routePolylineInfoMarkerList.clear();

    final TransportationModel? transportationModel = appParamState.keepTransportationMap[widget.date];
    if (transportationModel == null) {
      // ignore: always_specify_types
      return <Polyline>[];
    }

    final List<LatLng?> centerLatLngOfPolylineList = List<LatLng?>.filled(
      transportationModel.spotDataModelListMap.length,
      null,
    );

    // ignore: always_specify_types
    final List<Polyline> polylines = <Polyline>[];
    for (int i = 0; i < transportationModel.spotDataModelListMap.length; i++) {
      final List<SpotDataModel>? spots = transportationModel.spotDataModelListMap[i];
      if (spots == null || spots.isEmpty) {
        continue;
      }

      double latSum = 0.0;
      double lngSum = 0.0;

      for (final SpotDataModel s in spots) {
        latSum += s.lat.toDouble();
        lngSum += s.lng.toDouble();
      }

      final int count = spots.length;

      centerLatLngOfPolylineList[i] = LatLng(latSum / count, lngSum / count);

      polylines.add(
        // ignore: always_specify_types
        Polyline(
          points: spots.map((SpotDataModel t) => LatLng(t.lat.toDouble(), t.lng.toDouble())).toList(),
          color: (transportationModel.oufuku) ? fortyEightColor[0] : fortyEightColor[i % 48],
          strokeWidth: 5,
        ),
      );
    }

    final int loopNum = transportationModel.oufuku ? 1 : centerLatLngOfPolylineList.length;

    for (int i = 0; i < loopNum; i++) {
      final LatLng? center = centerLatLngOfPolylineList[i];
      if (center == null) {
        continue;
      }

      routePolylineInfoMarkerList.add(
        Marker(
          point: center,
          child: GestureDetector(
            onTap: () {
              LifetimeDialog(
                context: context,
                widget: RouteInfoDisplayAlert(
                  date: widget.date,
                  spotDataModelList: transportationModel.spotDataModelListMap[i],
                  oufuku: transportationModel.oufuku,
                ),
                paddingTop: context.screenSize.height * 0.5,
                paddingRight: context.screenSize.width * 0.2,
                clearBarrierColor: true,
              );
            },
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: fortyEightColor[i % 48], shape: BoxShape.circle),
              child: Center(
                child: Text(
                  (i + 1).toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return polylines;
  }

  ///
  void makeTransportationGoalMarker() {
    transportationGoalMarkerList.clear();

    final TransportationModel? transportationModel = appParamState.keepTransportationMap[widget.date];
    if (transportationModel != null && transportationModel.spotDataModelListMap.isNotEmpty) {
      for (int i = 0; i < transportationModel.spotDataModelListMap.length; i++) {
        final List<SpotDataModel>? spots = transportationModel.spotDataModelListMap[i];
        if (spots == null || spots.isEmpty) {
          continue;
        }
        final SpotDataModel lastValue = spots.last;

        transportationGoalMarkerList.add(
          Marker(
            point: LatLng(lastValue.lat.toDouble(), lastValue.lng.toDouble()),
            child: Icon(Icons.flag, color: (transportationModel.oufuku) ? fortyEightColor[0] : fortyEightColor[i % 48]),
          ),
        );
      }
    }
  }

  ///
  void makeTempleMarker() {
    templeMarkerList.clear();
    final TempleModel? templeModel = appParamState.keepTempleMap[widget.date];
    if (templeModel != null) {
      for (int i = 0; i < templeModel.templeDataList.length; i++) {
        final TempleDataModel templeDataModel = templeModel.templeDataList[i];
        if (i >= globalKeyList.length) {
          continue;
        }

        templeMarkerList.add(
          Marker(
            key: globalKeyList[i],
            point: LatLng(templeDataModel.latitude.toDouble(), templeDataModel.longitude.toDouble()),
            child: GestureDetector(
              onTap: () {
                appParamNotifier.clearRoutePolylinePartsGeolocList();

                final GeolocModel? nearestGeoloc =
                    appParamState.keepNearestTempleNameGeolocModelMap[templeDataModel.name];
                if (nearestGeoloc != null) {
                  appParamNotifier.setSelectedGeolocPointTime(time: nearestGeoloc.time);
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

    if (appParamState.selectedGeolocTime.isNotEmpty) {
      final List<GeolocModel>? searchedGeoloc = widget.geolocList
          ?.where((GeolocModel element) {
            final String m = element.month.padLeft(2, '0');
            final String d = element.day.padLeft(2, '0');
            return '${element.year}-$m-$d' == widget.date;
          })
          .where((GeolocModel element2) {
            final List<String> timeParts = element2.time.split(':');
            if (timeParts.length < 2) {
              return false;
            }
            return '${timeParts[0]}:${timeParts[1]}' == appParamState.selectedGeolocTime;
          })
          .toList();

      final List<String> addressList = <String>[];
      if (searchedGeoloc != null && searchedGeoloc.isNotEmpty) {
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
      keyOffset: _stampRallyAllStationKeyOffset,
      colorOf: (_) => Colors.indigo,
    );
  }

  ///
  void makeStampRallyMetro20AnniversaryMarker() {
    stampRallyMetro20AnniversaryMarkerList = _buildStampMarkerList(
      data: appParamState.keepStampRallyMetro20AnniversaryMap[widget.date],
      keyOffset: _stampRally20AnniversaryKeyOffset,
      colorOf: (_) => Colors.indigo,
    );
  }

  ///
  void makeStampRallyMetroPokepokeMarker() {
    stampRallyMetroPokepokeMarkerList = _buildStampMarkerList(
      data: appParamState.keepStampRallyMetroPokepokeMap[widget.date],
      keyOffset: _stampRallyPokepokeKeyOffset,
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
      if (keyIndex >= globalKeyList.length) {
        continue;
      }

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

  ///
  // ignore: always_specify_types
  List<Polyline> makeRouteGeolocPolyline() {
    if (appParamState.routePolylinePartsGeolocList.isEmpty) {
      // ignore: always_specify_types
      return <Polyline>[];
    }
    // ignore: always_specify_types
    return <Polyline>[
      // ignore: always_specify_types
      Polyline(
        points: appParamState.routePolylinePartsGeolocList
            .map((GeolocModel t) => LatLng(t.latitude.toDouble(), t.longitude.toDouble()))
            .toList(),
        color: Colors.indigoAccent.withValues(alpha: 0.1),
        strokeWidth: 10,
      ),
    ];
  }

  ///
  // ignore: always_specify_types
  List<Polyline> makeGhostGeolocPolyline() {
    // ignore: always_specify_types
    final List<Polyline> polylines = <Polyline>[];

    for (int i = 0; i < widget.templeGeolocNearlyDateList.length; i++) {
      final String ghostDate = widget.templeGeolocNearlyDateList[i];
      bool flag = true;

      if (appParamState.selectedGhostPolylineDate.isNotEmpty && appParamState.selectedGhostPolylineDate != ghostDate) {
        flag = false;
      }

      if (flag) {
        final TempleModel? templeModel = appParamState.keepTempleMap[ghostDate];
        if (templeModel == null || templeModel.templeDataList.isEmpty) {
          continue;
        }

        // 解決できなかった場合は null になるため、非 null のみ追加する
        final TempleDataModel? startData = getStartEndTempleDataModel(point: templeModel.startPoint);
        final TempleDataModel? endData = getStartEndTempleDataModel(point: templeModel.endPoint);

        final List<TempleDataModel> polylineTempleDataList = <TempleDataModel>[
          if (startData != null) startData,
          ...templeModel.templeDataList,
          if (endData != null) endData,
        ];

        polylines.add(
          // ignore: always_specify_types
          Polyline(
            points: polylineTempleDataList
                .map((TempleDataModel t) => LatLng(t.latitude.toDouble(), t.longitude.toDouble()))
                .toList(),
            color: fortyEightColor[i % 48].withValues(alpha: 0.5),
            strokeWidth: 20,
          ),
        );
      }
    }

    return polylines;
  }

  ///
  /// startPoint / endPoint の文字列から TempleDataModel を返す。
  /// 解決できない場合（空文字・数値変換失敗・駅未発見）は null を返す。
  TempleDataModel? getStartEndTempleDataModel({required String point}) {
    if (point.isEmpty) {
      return null;
    }

    switch (point) {
      case '自宅':
        return TempleDataModel(
          name: point,
          address: '千葉県船橋市二子町492-25-101',
          latitude: funabashiLat.toString(),
          longitude: funabashiLng.toString(),
          rank: '',
        );

      case '実家':
        return TempleDataModel(
          name: point,
          address: '東京都杉並区善福寺4-22-11',
          latitude: zenpukujiLat.toString(),
          longitude: zenpukujiLng.toString(),
          rank: '',
        );

      default:
        // point.toInt() 拡張は parse 失敗で例外になるため int.tryParse を使用
        final int? stationId = int.tryParse(point);
        if (stationId == null) {
          return null;
        }

        final Iterable<StationModel> matches = appParamState.keepStationList.where(
          (StationModel element) => element.id == stationId,
        );
        if (matches.isEmpty) {
          return null;
        }

        final StationModel stationModel = matches.first;
        return TempleDataModel(
          name: stationModel.stationName,
          address: stationModel.address,
          latitude: stationModel.lat,
          longitude: stationModel.lng,
          rank: '',
        );
    }
  }

  ///
  void makeDisplayGhostGeolocDateMarker() {
    displayGhostGeolocDateList.clear();

    for (int i = 0; i < widget.templeGeolocNearlyDateList.length; i++) {
      final String ghostDate = widget.templeGeolocNearlyDateList[i];
      final TempleModel? templeModel = appParamState.keepTempleMap[ghostDate];
      if (templeModel == null) {
        continue;
      }

      for (int j = 0; j < templeModel.templeDataList.length; j++) {
        bool flag = true;

        if (appParamState.selectedGhostPolylineDate.isNotEmpty &&
            appParamState.selectedGhostPolylineDate != templeModel.date) {
          flag = false;
        }

        if (flag) {
          final DateTime? dt = DateTime.tryParse(templeModel.date);

          //=====================================================//
          if (j == 0) {
            displayGhostGeolocDateList.add(
              Marker(
                point: getZeroFirstCenterLatLng(templeModel: templeModel),

                child: GestureDetector(
                  onTap: () {
                    if (appParamState.selectedGhostPolylineDate.isEmpty) {
                      LifetimeDialog(
                        context: context,
                        widget: const LifetimeGeolocGhostTempleInfoAlert(),
                        paddingRight: context.screenSize.width * 0.3,
                        paddingTop: context.screenSize.height * 0.3,
                        paddingBottom: context.screenSize.height * 0.1,
                        clearBarrierColor: true,
                      );
                    }

                    appParamNotifier.setSelectedGhostPolylineDate(date: templeModel.date);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: fortyEightColor[i % 48]),
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(color: fortyEightColor[i % 48], fontSize: 8, fontWeight: FontWeight.bold),
                      child: Column(
                        children: <Widget>[
                          const Spacer(),
                          Text(dt?.year.toString() ?? ''),
                          Text(dt?.mmdd ?? ''),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          //=====================================================//

          final TempleDataModel templeData = templeModel.templeDataList[j];

          displayGhostGeolocDateList.add(
            Marker(
              point: LatLng(templeData.latitude.toDouble(), templeData.longitude.toDouble()),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          );
        }
      }
    }
  }

  ///
  /// startPoint と最初の寺の中間座標を返す。
  /// startPoint が解決できない場合は最初の寺の座標をそのまま返す。
  /// templeDataList が空の場合は定数座標にフォールバックする。
  LatLng getZeroFirstCenterLatLng({required TempleModel templeModel}) {
    if (templeModel.templeDataList.isEmpty) {
      return const LatLng(zenpukujiLat, zenpukujiLng);
    }

    final TempleDataModel firstTemple = templeModel.templeDataList[0];
    final LatLng firstTempleLatLng = LatLng(firstTemple.latitude.toDouble(), firstTemple.longitude.toDouble());

    final TempleDataModel? startPointData = getStartEndTempleDataModel(point: templeModel.startPoint);
    if (startPointData == null) {
      // startPoint が解決できない場合は最初の寺の座標を返す
      return firstTempleLatLng;
    }

    final double centerLat = (startPointData.latitude.toDouble() + firstTemple.latitude.toDouble()) / 2;
    final double centerLng = (startPointData.longitude.toDouble() + firstTemple.longitude.toDouble()) / 2;

    return LatLng(centerLat, centerLng);
  }
}
