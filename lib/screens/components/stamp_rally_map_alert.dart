import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../utility/tile_provider.dart';

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

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: FlutterMap(
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

        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: CachedTileProvider(),
            userAgentPackageName: 'com.example.app',
          ),
        ],
      ),
    );
  }
}
