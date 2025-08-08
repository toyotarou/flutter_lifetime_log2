import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../models/temple_photo_model.dart';
import '../../models/transportation_model.dart';
import '../../utility/utility.dart';

class TemplePhotoListDisplayAlert extends ConsumerStatefulWidget {
  const TemplePhotoListDisplayAlert({super.key, required this.temple});

  final TempleDataModel temple;

  @override
  ConsumerState<TemplePhotoListDisplayAlert> createState() => _TemplePhotoListDisplayAlertState();
}

class _TemplePhotoListDisplayAlertState extends ConsumerState<TemplePhotoListDisplayAlert>
    with ControllersMixin<TemplePhotoListDisplayAlert> {
  Utility utility = Utility();

  List<MapEntry<StationModel, double>> nearStationList = <MapEntry<StationModel, double>>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    Future(() {
      if (appParamState.selectedTemple != null) {
        final List<StationModel> roughFiltered = utility.filterByBoundingBox(
          stationList: appParamState.keepStationList,
          baseLat: appParamState.selectedTemple!.latitude.toDouble(),
          baseLng: appParamState.selectedTemple!.longitude.toDouble(),
          radiusKm: 3,
        );

        final List<MapEntry<StationModel, double>> list = roughFiltered
            .map((StationModel station) {
              final double d = utility.calculateDistance(
                LatLng(
                  appParamState.selectedTemple!.latitude.toDouble(),
                  appParamState.selectedTemple!.longitude.toDouble(),
                ),
                LatLng(station.lat.toDouble(), station.lng.toDouble()),
              );

              // ignore: always_specify_types
              return MapEntry(station, d);
            })
            .where((MapEntry<StationModel, double> entry) => entry.value <= 3 * 1000)
            .toList();

        list.sort((MapEntry<StationModel, double> a, MapEntry<StationModel, double> b) => a.value.compareTo(b.value));

        setState(() {
          nearStationList = list;
        });
      }
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      right: 5,
                      child: Text(widget.temple.rank, style: const TextStyle(fontSize: 35, color: Color(0xFFFBB6CE))),
                    ),

                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[Text(widget.temple.name), const SizedBox.shrink()],
                        ),

                        Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                      ],
                    ),
                  ],
                ),

                displayNearStationList(),

                Expanded(child: displayTemplePhotoList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayNearStationList() {
    return Container(
      width: double.infinity,
      height: 200,

      decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1)),
      child: SingleChildScrollView(
        child: Column(
          children: nearStationList.map((MapEntry<StationModel, double> e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(e.key.stationName),
                Text(e.value.toString()),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  ///
  Widget displayTemplePhotoList() {
    final List<Widget> list = <Widget>[];

    if (widget.temple.templePhotoModelList != null) {
      for (final TemplePhotoModel element in widget.temple.templePhotoModelList!) {
        final List<Widget> list2 = <Widget>[];
        for (final String element2 in element.templephotos) {
          list2.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: 90,
              child: CachedNetworkImage(
                imageUrl: element2,
                placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
                errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
              ),
            ),
          );
        }

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),

                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(3),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(element.date), const SizedBox.shrink()],
                  ),
                ),

                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(children: list2),
                ),
              ],
            ),
          ),
        );
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
}
