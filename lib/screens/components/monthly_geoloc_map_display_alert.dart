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

  ///
  @override
  Widget build(BuildContext context) {
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

              // MarkerLayer(markers: markerList),
              //
              // if (widget.transportation != null && widget.transportation!.spotDataModelListMap.isNotEmpty) ...<Widget>[
              //   // ignore: always_specify_types
              //   PolylineLayer(polylines: makeTransportationPolyline()),
              // ],
              //
              // MarkerLayer(markers: transportationGoalMarkerList),
              //
              // MarkerLayer(markers: templeMarkerList),
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
                                height: MediaQuery.of(context).size.width * 0.8,
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

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(onTap: () {}, child: const Icon(FontAwesomeIcons.expand)),
                        ),
                      ],
                    ),

                    const SizedBox.shrink(),
                  ],
                ),

                if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),

                  Text(
                    appParamState.monthlyGeolocMapSelectedDateList.last,

                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
}
