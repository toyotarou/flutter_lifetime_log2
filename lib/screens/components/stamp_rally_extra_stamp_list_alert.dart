import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/stamp_rally_kind.dart';
import '../../utility/utility.dart';

class StampRallyExtraStampListAlert extends ConsumerStatefulWidget {
  const StampRallyExtraStampListAlert({super.key, required this.kind, required this.title});

  final StampRallyKind kind;
  final String title;

  @override
  ConsumerState<StampRallyExtraStampListAlert> createState() => _StampRallyExtraStampListAlertState();
}

class _StampRallyExtraStampListAlertState extends ConsumerState<StampRallyExtraStampListAlert> {
  List<String> specialStampGuideList = <String>[];

  Utility utility = Utility();

  @override
  void initState() {
    super.initState();

    final Map<StampRallyKind, List<String>> specialStampGuideMap = utility.getSpecialStampGuideMap();
    specialStampGuideList = specialStampGuideMap[widget.kind] ?? <String>[];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(widget.title), const Text('Special Prize')],
                    ),
                    const SizedBox.shrink(),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displaySpecialPrizeList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displaySpecialPrizeList() {
    switch (widget.kind) {
      case StampRallyKind.metroAllStation:
        return ListView.builder(
          itemCount: specialStampGuideList.length,
          itemBuilder: (BuildContext context, int index) {
            final String e = specialStampGuideList[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no_image.png',
                    image: 'http://toyohide.work/BrainLog/metro_stamp_all_station/extra/title-$e.png',
                    fit: BoxFit.contain,
                    imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) {
                      return Image.asset('assets/images/no_image.png');
                    },
                  ),
                ),

                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _buildExtraImage(fileName: 'certificate-$e.jpeg', aspectRatio: 1080 / 1920),
                      const SizedBox(width: 8),
                      _buildExtraImage(fileName: 'linemap-$e.jpeg', aspectRatio: 3508 / 2481),
                      const SizedBox(width: 8),
                      _buildExtraImage(fileName: 'wallpaper-$e.jpeg', aspectRatio: 1080 / 1920),
                    ],
                  ),
                ),
              ],
            );
          },
        );

      case StampRallyKind.metroPokepoke:
        return ListView.builder(
          itemCount: specialStampGuideList.length,
          itemBuilder: (BuildContext context, int index) {
            const double height = 200;
            const double aspectRatio = 1290 / 2796;
            const double width = height * aspectRatio;
            final String name = specialStampGuideList[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height,
                      width: width,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no_image.png',
                        image: 'http://toyohide.work/BrainLog/metro_stamp_pokepoke/extra_stamp_$name.jpg',
                        fit: BoxFit.contain,
                        imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) {
                          return Image.asset('assets/images/no_image.png');
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(child: Text(name, maxLines: 3, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            );
          },
        );

      case StampRallyKind.metro20Anniversary:
        return const SizedBox.shrink();
    }
  }

  ///
  Widget _buildExtraImage({required String fileName, required double aspectRatio}) {
    const double height = 200;

    return SizedBox(
      height: height,
      width: height * aspectRatio,
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/no_image.png',
        image: 'http://toyohide.work/BrainLog/metro_stamp_all_station/extra/$fileName',
        fit: BoxFit.contain,
        imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) {
          return Image.asset('assets/images/no_image.png');
        },
      ),
    );
  }
}
