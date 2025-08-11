import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/temple_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'temple_directions_map_alert.dart';
import 'temple_photo_list_display_alert.dart';

class TempleListDisplayAlert extends ConsumerStatefulWidget {
  const TempleListDisplayAlert({super.key, this.temple, required this.date});

  final String date;
  final TempleModel? temple;

  @override
  ConsumerState<TempleListDisplayAlert> createState() => _TempleListDisplayAlertState();
}

class _TempleListDisplayAlertState extends ConsumerState<TempleListDisplayAlert>
    with ControllersMixin<TempleListDisplayAlert> {
  Utility utility = Utility();

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('temple'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayTempleList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayTempleList() {
    final List<Widget> list = <Widget>[];

    if (widget.temple != null) {
      for (int i = 0; i < widget.temple!.templeDataList.length; i++) {
        list.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 3,
                      left: 3,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFFFBB6CE),
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,

                              child: Text((i + 1).toString().padLeft(2, '0'), style: const TextStyle(fontSize: 12)),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            widget.temple!.templeDataList[i].rank,
                            style: const TextStyle(fontSize: 20, color: Color(0xFFFBB6CE)),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox.shrink(),

                            Text(
                              utility.getTempleReachTimeFromTemplePhotoList(
                                date: widget.date,
                                temple: widget.temple!.templeDataList[i],
                              ),

                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        Padding(padding: const EdgeInsets.all(10), child: Text(widget.temple!.templeDataList[i].name)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox.shrink(),
                            GestureDetector(
                              onTap: () {
                                appParamNotifier.setSelectedTemple(temple: widget.temple!.templeDataList[i]);

                                LifetimeDialog(
                                  context: context,
                                  widget: TemplePhotoListDisplayAlert(temple: widget.temple!.templeDataList[i]),
                                  clearBarrierColor: true,
                                );
                              },

                              child: Icon(Icons.photo, color: Colors.white.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (i < widget.temple!.templeDataList.length - 1) ...<Widget>[
                SizedBox(
                  width: double.infinity,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              LifetimeDialog(
                                context: context,
                                widget: TempleDirectionsMapAlert(
                                  origin: widget.temple!.templeDataList[i].address,
                                  destination: widget.temple!.templeDataList[i + 1].address,
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_downward),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: const Color(0xFFFBB6CE),
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.white,

                                  child: Text((i + 1).toString().padLeft(2, '0'), style: const TextStyle(fontSize: 10)),
                                ),
                              ),

                              const SizedBox(width: 5),
                              const Text('-'),
                              const SizedBox(width: 5),

                              CircleAvatar(
                                radius: 8,
                                backgroundColor: const Color(0xFFFBB6CE),
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.white,

                                  child: Text((i + 2).toString().padLeft(2, '0'), style: const TextStyle(fontSize: 10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ],
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
