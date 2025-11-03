import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/metro_stamp_20_anniversary_model.dart';
import '../../utils/ui_utils.dart';

class MetroStampRally20AnniversaryListAlert extends ConsumerStatefulWidget {
  const MetroStampRally20AnniversaryListAlert({super.key});

  @override
  ConsumerState<MetroStampRally20AnniversaryListAlert> createState() => _MetroStampRally20AnniversaryListAlertState();
}

class _MetroStampRally20AnniversaryListAlertState extends ConsumerState<MetroStampRally20AnniversaryListAlert>
    with ControllersMixin<MetroStampRally20AnniversaryListAlert> {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('stamp rally list'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayMetroStamp20AnniversaryModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayMetroStamp20AnniversaryModelList() {
    final List<Widget> list = <Widget>[];

    final List<MapEntry<String, List<MetroStamp20AnniversaryModel>>> sortedEntries =
        appParamState.keepMetroStamp20AnniversaryMap.entries.toList()..sort(
          (
            MapEntry<String, List<MetroStamp20AnniversaryModel>> a,
            MapEntry<String, List<MetroStamp20AnniversaryModel>> b,
          ) => a.key.compareTo(b.key),
        );

    for (final MapEntry<String, List<MetroStamp20AnniversaryModel>> entry in sortedEntries) {
      final String key = entry.key;

      final List<MetroStamp20AnniversaryModel> value = entry.value;

      final String youbiStr = DateTime.parse(key).youbiStr;

      list.add(
        Container(
          decoration: BoxDecoration(
            color: UiUtils.youbiColor(date: key, youbiStr: youbiStr, holiday: appParamState.keepHolidayList),
          ),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text('$key ${youbiStr.substring(0, 3)}'),
        ),
      );

      value.sort((MetroStamp20AnniversaryModel a, MetroStamp20AnniversaryModel b) => a.time.compareTo(b.time));

      final Set<String> stationNames = <String>{};

      for (final MetroStamp20AnniversaryModel element in value) {
        if (stationNames.add(element.stationName)) {
          final String stamp = 'assets/stamps/metro_stamp_20_${element.stamp}.png';

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    child: Opacity(
                      opacity: 0.6,

                      child: Hero(tag: stamp, child: Image.asset(stamp)),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[Text(element.stationName), Text(element.time)],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
