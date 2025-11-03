import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utils/geo_utils.dart';
import '../../utils/ui_utils.dart';
import 'monthly_geoloc_map_date_list_widget.dart';

mixin MonthlyGeolocMapDateListMixin on ConsumerState<MonthlyGeolocMapDateListWidget> {
  ///
  Widget buildContent(BuildContext context) {
    final AppParam appParamNotifier = ref.read(appParamProvider.notifier);
    final AppParamState appParamState = ref.watch(appParamProvider);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => appParamNotifier.clearMonthlyGeolocMapSelectedDateList(),
              child: const Text('clear'),
            ),

            const SizedBox.shrink(),
          ],
        ),

        SizedBox(
          height: MediaQuery.of(context).size.width * 0.7,

          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: appParamState.keepGeolocMap.entries.map((MapEntry<String, List<GeolocModel>> e) {
                      if ('${e.key.split('-')[0]}-${e.key.split('-')[1]}' == appParamState.selectedYearMonth) {
                        final String youbi = DateTime.parse(e.key).youbiStr;

                        Color containerColor =
                            (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(e.key))
                            ? UiUtils.youbiColor(date: e.key, youbiStr: youbi, holiday: appParamState.keepHolidayList)
                            : Colors.transparent;

                        if (appParamState.monthlyGeolocMapSelectedDateList.contains(e.key)) {
                          containerColor = Colors.white.withValues(alpha: 0.2);
                        }

                        Color textColor = (appParamState.monthlyGeolocMapSelectedDateList.contains(e.key))
                            ? Colors.black
                            : Colors.white;

                        if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty &&
                            appParamState.monthlyGeolocMapSelectedDateList.last == e.key) {
                          textColor = Colors.yellowAccent;
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: containerColor,

                            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
                          ),
                          padding: const EdgeInsets.all(5),

                          child: DefaultTextStyle(
                            style: TextStyle(color: textColor),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[Text(e.key.split('-')[2]), Text(e.value.length.toString())],
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const SizedBox.shrink(),

                                          Text(GeoUtils.getBoundingBoxArea(points: e.value)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                GestureDetector(
                                  onTap: () => appParamNotifier.setMonthlyGeolocMapSelectedDateList(date: e.key),
                                  child: const Icon(Icons.location_on),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
