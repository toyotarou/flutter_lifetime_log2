import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../enums/stamp_rally_kind.dart';
import '../../models/stamp_rally_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'stamp_rally_stamp_alert.dart';

class StampRallyDateAlert extends ConsumerStatefulWidget {
  const StampRallyDateAlert({super.key, required this.date, required this.kind});

  /// 対象日付（YYYY-MM-DD）
  final String date;

  /// 20周年 or 全駅 などの種別
  final StampRallyKind kind;

  @override
  ConsumerState<StampRallyDateAlert> createState() => _StampRallyAlertState();
}

class _StampRallyAlertState extends ConsumerState<StampRallyDateAlert> with ControllersMixin<StampRallyDateAlert> {
  final Utility utility = Utility();

  ///
  String get _title {
    switch (widget.kind) {
      case StampRallyKind.metroAllStation:
        return '東京メトロ　全駅スタンプラリー';
      case StampRallyKind.metro20Anniversary:
        return '東京メトロ　20周年スタンプラリー';
      case StampRallyKind.metroPokepoke:
        return '東京メトロ　ポケポケ';
    }
  }

  ///
  Map<String, List<StampRallyModel>> get _stampMap {
    switch (widget.kind) {
      case StampRallyKind.metroAllStation:
        return appParamState.keepStampRallyMetroAllStationMap;
      case StampRallyKind.metro20Anniversary:
        return appParamState.keepStampRallyMetro20AnniversaryMap;
      case StampRallyKind.metroPokepoke:
        return appParamState.keepStampRallyMetroPokepokeMap;
    }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text(_title), const SizedBox.shrink()],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[const SizedBox.shrink(), Text(widget.date)],
                    ),
                  ],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Expanded(child: _displayStampRallyModelList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayStampRallyModelList() {
    final List<Widget> list = <Widget>[];

    final List<StampRallyModel>? stamps = _stampMap[widget.date];

    if (stamps != null) {
      // 並び順だけ種別で切り替え
      switch (widget.kind) {
        case StampRallyKind.metroAllStation:
          stamps.sort((StampRallyModel a, StampRallyModel b) => a.stampGetOrder.compareTo(b.stampGetOrder));

        case StampRallyKind.metro20Anniversary:
        case StampRallyKind.metroPokepoke:
          stamps.sort((StampRallyModel a, StampRallyModel b) => a.time.compareTo(b.time));
      }

      for (final StampRallyModel element in stamps) {
        final String stampUrl = _buildStampImageUrl(element);

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
                      widget: StampRallyStampAlert(imageUrl: stampUrl),
                    );
                  },
                  child: SizedBox(
                    width: (widget.kind == StampRallyKind.metroPokepoke) ? 40 : 80,

                    child: Opacity(
                      opacity: 0.6,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no_image.png',
                        image: stampUrl,
                        imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) =>
                            Image.asset('assets/images/no_image.png'),
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
                                  backgroundColor: utility.getTrainColor(trainName: element.trainName),
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

  ///
  String _buildStampImageUrl(StampRallyModel element) {
    switch (widget.kind) {
      case StampRallyKind.metroAllStation:
        return 'http://toyohide.work/BrainLog/station_stamp/${element.imageFolder}/${element.imageCode}.png';

      case StampRallyKind.metro20Anniversary:
        return 'http://toyohide.work/BrainLog/public/metro_stamp_20_anniversary/metro_stamp_20_${element.stamp}.png';

      case StampRallyKind.metroPokepoke:
        return 'http://toyohide.work/BrainLog/metro_stamp_pokepoke/stamp${element.stamp}.png';
    }
  }
}
