import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../extensions/extensions.dart';
import '../../models/geoloc_model.dart';
import '../../utility/utility.dart';
import 'monthly_geoloc_map_date_list_widget.dart';

mixin MonthlyGeolocMapDateListMixin on ConsumerState<MonthlyGeolocMapDateListWidget> {
  ///
  Widget buildContent(BuildContext context) {
    final AppParam appParamNotifier = ref.read(appParamProvider.notifier);
    final AppParamState appParamState = ref.watch(appParamProvider);

    final Utility utility = Utility();

    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.65,

      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: appParamState.keepGeolocMap.entries.map((MapEntry<String, List<GeolocModel>> e) {
                  if ('${e.key.split('-')[0]}-${e.key.split('-')[1]}' == appParamState.selectedYearMonth) {
                    final String youbi = '${e.key} 00:00:00'.toDateTime().youbiStr;

                    final Color containerColor =
                        (youbi == 'Saturday' || youbi == 'Sunday' || appParamState.keepHolidayList.contains(e.key))
                        ? utility.getYoubiColor(date: e.key, youbiStr: youbi, holiday: appParamState.keepHolidayList)
                        : Colors.transparent;

                    Color textColor = (appParamState.monthlyGeolocMapSelectedDateList.contains(e.key))
                        ? Colors.yellowAccent
                        : Colors.white;

                    if (appParamState.monthlyGeolocMapSelectedDateList.isNotEmpty &&
                        appParamState.monthlyGeolocMapSelectedDateList.last == e.key) {
                      textColor = Colors.redAccent;
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
                            Text(e.key.split('-')[2]),

                            Row(
                              children: <Widget>[
                                Text(e.value.length.toString()),

                                IconButton(
                                  onPressed: () => appParamNotifier.setMonthlyGeolocMapSelectedDateList(date: e.key),
                                  icon: Icon(Icons.location_on, color: textColor.withValues(alpha: 0.4)),
                                ),
                              ],
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
    );
  }
}
