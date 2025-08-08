import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../models/temple_photo_model.dart';

class TemplePhotoListDisplayAlert extends ConsumerStatefulWidget {
  const TemplePhotoListDisplayAlert({super.key, required this.temple});

  final TempleDataModel temple;

  @override
  ConsumerState<TemplePhotoListDisplayAlert> createState() => _TemplePhotoListDisplayAlertState();
}

class _TemplePhotoListDisplayAlertState extends ConsumerState<TemplePhotoListDisplayAlert>
    with ControllersMixin<TemplePhotoListDisplayAlert> {
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
                  children: <Widget>[Text(widget.temple.name), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayTemplePhotoList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayTemplePhotoList() {
    final List<Widget> list = <Widget>[];

    print(widget.temple.name);
    print(widget.temple.templePhotoModelMap);

    if (widget.temple.templePhotoModelMap != null) {
      widget.temple.templePhotoModelMap!.forEach((TemplePhotoModel element) {
        final List<Widget> list2 = <Widget>[];
        element.templephotos.forEach((element2) {
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
        });

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
      });
    }

    //
    //
    //
    //
    //
    // appParamState.keepTemplePhotoMap.forEach((String key, List<TemplePhotoModel> value) {
    //   if (key == widget.temple.name) {
    //     for (final TemplePhotoModel element in value) {
    //       final List<Widget> list2 = <Widget>[];
    //       for (final String element2 in element.templephotos) {
    //         list2.add(
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 5),
    //             width: 90,
    //             child: CachedNetworkImage(
    //               imageUrl: element2,
    //               placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
    //               errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
    //             ),
    //           ),
    //         );
    //       }
    //
    //       list.add(
    //         Container(
    //           decoration: BoxDecoration(
    //             border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
    //           ),
    //           padding: const EdgeInsets.all(5),
    //
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Container(
    //                 decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),
    //
    //                 margin: const EdgeInsets.symmetric(vertical: 5),
    //                 padding: const EdgeInsets.all(3),
    //
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: <Widget>[Text(element.date.yyyymmdd), const SizedBox.shrink()],
    //                 ),
    //               ),
    //
    //               const SizedBox(height: 10),
    //
    //               SingleChildScrollView(
    //                 scrollDirection: Axis.horizontal,
    //
    //                 child: Row(children: list2),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     }
    //   }
    // });
    //
    //
    //
    //
    //
    //
    //

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
