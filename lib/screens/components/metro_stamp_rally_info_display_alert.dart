import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/metro_stamp_model.dart';
import '../../utils/ui_utils.dart';
import '../parts/lifetime_dialog.dart';
import 'metro_stamp_display_alert.dart';

class MetroStampRallyInfoDisplayAlert extends ConsumerStatefulWidget {
  const MetroStampRallyInfoDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<MetroStampRallyInfoDisplayAlert> createState() => _MetroStampRallyInfoDisplayAlertState();
}

class _MetroStampRallyInfoDisplayAlertState extends ConsumerState<MetroStampRallyInfoDisplayAlert>
    with ControllersMixin<MetroStampRallyInfoDisplayAlert> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[const Text('stamp rally info'), Text(widget.date)],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayStationStampModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayStationStampModelList() {
    final List<Widget> list = <Widget>[];

    final List<MetroStampModel>? stamps = appParamState.keepDateMetroStampMap[widget.date];

    if (stamps != null) {
      stamps.sort((MetroStampModel a, MetroStampModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));

      for (final MetroStampModel element in stamps) {
        final String stamp =
            'http://toyohide.work/BrainLog/station_stamp/${element.imageFolder}/${element.imageCode}.png';

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),

            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    LifetimeDialog(
                      context: context,
                      widget: MetroStampDisplayAlert(imageUrl: stamp),
                    );
                  },

                  child: SizedBox(
                    width: 80,
                    child: Opacity(
                      opacity: 0.6,

                      child: Hero(
                        tag: stamp,

                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/no_image.png',
                          image: stamp,
                          imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) =>
                              Image.asset('assets/images/no_image.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(width: 10),

                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: UiUtils.trainColor(trainName: element.trainName),
                                  radius: 22,
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: DefaultTextStyle(
                                      style: const TextStyle(fontSize: 10),
                                      child: Column(
                                        children: <Widget>[
                                          const Spacer(),
                                          Text(element.imageFolder),
                                          Text(element.imageCode),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Text(
                                  element.trainName.replaceAll('東京メトロ', ''),
                                  style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8)),
                                ),
                              ],
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(element.stationName),
                                  Text(element.posterPosition, style: const TextStyle(fontSize: 8)),
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
