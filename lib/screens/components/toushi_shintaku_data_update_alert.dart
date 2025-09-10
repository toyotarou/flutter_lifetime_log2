import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/toushi_shintaku_model.dart';
import '../parts/lifetime_log_overlay.dart';

class ToushiShintakuDataUpdateAlert extends ConsumerStatefulWidget {
  const ToushiShintakuDataUpdateAlert({
    super.key,
    required this.date,

    required this.toushiShintakuNameRelationalIdMap,
    this.referenceData,
    required this.todayData,
  });

  final String date;

  final Map<String, List<int>> toushiShintakuNameRelationalIdMap;
  final MapEntry<String, List<ToushiShintakuModel>>? referenceData;
  final List<ToushiShintakuModel> todayData;

  @override
  ConsumerState<ToushiShintakuDataUpdateAlert> createState() => _ToushiShintakuDataUpdateAlertState();
}

class _ToushiShintakuDataUpdateAlertState extends ConsumerState<ToushiShintakuDataUpdateAlert>
    with ControllersMixin<ToushiShintakuDataUpdateAlert> {
  List<TextEditingController> tecs = <TextEditingController>[];

  List<FocusNode> focusNodeList = <FocusNode>[];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 20; i++) {
      tecs.add(TextEditingController(text: ''));
    }

    // ignore: always_specify_types
    focusNodeList = List.generate(20, (int index) => FocusNode());
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
                    Text(widget.date),

                    ElevatedButton(
                      onPressed: () {
                        updateData();
                      },

                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                      child: const Text('input'),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayDateToushiShintakuList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayDateToushiShintakuList() {
    final List<Widget> list = <Widget>[];

    if (widget.todayData.isNotEmpty) {
      for (int i = 0; i < 20; i++) {
        if (i < widget.todayData.length) {
          final List<int>? relationalIdOnReference = widget.toushiShintakuNameRelationalIdMap[widget.todayData[i].name];

          if (relationalIdOnReference != null && relationalIdOnReference.length == 1) {
            tecs[i].text = relationalIdOnReference[0].toString();

            // ignore: always_specify_types
            Future(() {
              toushiShintakuInputNotifier.setInputValue(
                pos: i,
                id: widget.todayData[i].id,
                relationalId: relationalIdOnReference[0],
              );
            });
          }

          list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(5),

              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,

                      child: TextField(
                        style: const TextStyle(fontSize: 12),

                        keyboardType: TextInputType.number,
                        controller: tecs[i],
                        decoration: const InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          border: InputBorder.none,
                        ),

                        onChanged: (String value) async {
                          await toushiShintakuInputNotifier.setInputValue(
                            pos: i,
                            id: widget.todayData[i].id,
                            relationalId: value.toInt(),
                          );
                        },

                        onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        focusNode: focusNodeList[i],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.todayData[i].name,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: (tecs[i].text != '') ? Colors.white : Colors.yellowAccent),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(widget.todayData[i].shutokuSougaku.replaceAll('円', '').trim()),

                              GestureDetector(
                                onTap: () {
                                  callFirstBox(
                                    pos: i,
                                    date: widget.date,
                                    name: widget.todayData[i].name,
                                    shutokuSougaku: widget.todayData[i].shutokuSougaku.replaceAll('円', '').trim(),
                                    referenceData: widget.referenceData,
                                  );
                                },

                                child: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  ///
  void callFirstBox({
    required int pos,
    required String date,
    required String name,
    required String shutokuSougaku,
    MapEntry<String, List<ToushiShintakuModel>>? referenceData,
  }) {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.8,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: const Offset(80, 100),

      widget: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const SizedBox.shrink(), Text(shutokuSougaku)],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            SizedBox(
              height: context.screenSize.height * 0.65,
              child: displayToushiShintakuNameRelationalIdList(
                pos: pos,
                name: widget.todayData[pos].name,
                shutokuSougaku: widget.todayData[pos].shutokuSougaku.replaceAll('円', '').trim(),
                referenceData: widget.referenceData,
              ),
            ),
          ],
        ),
      ),

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }

  ///
  Future<void> updateData() async {
    print(toushiShintakuInputState.relationalIdMapList);
  }

  ///
  Widget displayToushiShintakuNameRelationalIdList({
    required int pos,
    required String name,
    required String shutokuSougaku,
    MapEntry<String, List<ToushiShintakuModel>>? referenceData,
  }) {
    final List<Widget> list = <Widget>[];

    if (widget.referenceData != null) {
      final List<ToushiShintakuModel> sortedData = widget.referenceData!.value
        ..sort(
          (ToushiShintakuModel a, ToushiShintakuModel b) => a.shutokuSougaku
              .replaceAll('円', '')
              .replaceAll(',', '')
              .trim()
              .toInt()
              .compareTo(b.shutokuSougaku.replaceAll('円', '').replaceAll(',', '').trim().toInt()),
        );

      for (final ToushiShintakuModel element in sortedData) {
        list.add(
          GestureDetector(
            onTap: () {
              if (widget.referenceData != null) {
                for (final ToushiShintakuModel element2 in widget.referenceData!.value) {
                  if (element2.shutokuSougaku.replaceAll('円', '').trim() == shutokuSougaku) {
                    if (element2.name == name) {
                      toushiShintakuInputNotifier.setInputValue(
                        pos: pos,
                        relationalId: element2.relationalId,
                        id: element.id,
                      );
                    }
                  }
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(5),

              decoration: BoxDecoration(
                color: (element.shutokuSougaku.replaceAll('円', '').trim() == shutokuSougaku)
                    ? Colors.yellowAccent.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(element.name),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      const SizedBox.shrink(),
                      Text(element.shutokuSougaku.replaceAll('円', '').trim()),
                    ],
                  ),
                ],
              ),
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
