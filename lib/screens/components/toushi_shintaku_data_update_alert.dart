import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/toushi_shintaku_model.dart';

class ToushiShintakuDataUpdateAlert extends ConsumerStatefulWidget {
  const ToushiShintakuDataUpdateAlert({
    super.key,
    required this.date,
    required this.todayDataList,
    this.referenceDataMapEntry,
    required this.referenceNameAndToushiShintakuModelListMap,
  });

  final String date;
  final List<ToushiShintakuModel> todayDataList;
  final MapEntry<String, List<ToushiShintakuModel>>? referenceDataMapEntry;
  final Map<String, List<ToushiShintakuModel>> referenceNameAndToushiShintakuModelListMap;

  @override
  ConsumerState<ToushiShintakuDataUpdateAlert> createState() => _ToushiShintakuDataUpdateAlertState();
}

class _ToushiShintakuDataUpdateAlertState extends ConsumerState<ToushiShintakuDataUpdateAlert>
    with ControllersMixin<ToushiShintakuDataUpdateAlert> {
  ///
  @override
  void initState() {
    super.initState();

    final Map<String, int> map = <String, int>{};
    for (final ToushiShintakuModel element in widget.todayDataList) {
      map[element.id.toString()] = 0;
    }

    // ignore: always_specify_types
    Future(() {
      toushiShintakuInputNotifier.setAllInputValue(map: map);
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
  String textModify({required String text}) => text.replaceAll('円', '');

  ///
  Widget displayDateToushiShintakuList() {
    final List<Widget> list = <Widget>[];

    for (final ToushiShintakuModel element in widget.todayDataList) {
      String displayRelationalId = '';
      if (widget.referenceNameAndToushiShintakuModelListMap[element.name] != null &&
          widget.referenceNameAndToushiShintakuModelListMap[element.name]!.length == 1) {
        // ignore: always_specify_types
        Future(() {
          toushiShintakuInputNotifier.setInputValue(
            relationalId: widget.referenceNameAndToushiShintakuModelListMap[element.name]![0].relationalId,
            id: element.id,
          );
        });

        displayRelationalId = widget.referenceNameAndToushiShintakuModelListMap[element.name]![0].relationalId
            .toString();
      }

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (displayRelationalId != '') ...<Widget>[SizedBox(width: 50, child: Text(displayRelationalId))],

              if (displayRelationalId == '') ...<Widget>[
                SizedBox(
                  width: 50,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),

                    alignment: Alignment.center,
                    child: const Text('-----'),
                  ),
                ),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(element.name),
                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(textModify(text: element.shutokuSougaku)),
                        const Icon(Icons.search),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
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
  Future<void> updateData() async {
    // ignore: avoid_print
    print(toushiShintakuInputState.relationalIdMap);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../controllers/controllers_mixin.dart';
// import '../../extensions/extensions.dart';
// import '../../models/toushi_shintaku_model.dart';
// import '../parts/lifetime_log_overlay.dart';
//
// class ToushiShintakuDataUpdateAlert extends ConsumerStatefulWidget {
//   const ToushiShintakuDataUpdateAlert({
//     super.key,
//     required this.date,
//
//     required this.toushiShintakuNameRelationalIdMap,
//     this.referenceData,
//     required this.todayData,
//   });
//
//   final String date;
//
//   final Map<String, List<int>> toushiShintakuNameRelationalIdMap;
//   final MapEntry<String, List<ToushiShintakuModel>>? referenceData;
//   final List<ToushiShintakuModel> todayData;
//
//   @override
//   ConsumerState<ToushiShintakuDataUpdateAlert> createState() => _ToushiShintakuDataUpdateAlertState();
// }
//
// class _ToushiShintakuDataUpdateAlertState extends ConsumerState<ToushiShintakuDataUpdateAlert>
//     with ControllersMixin<ToushiShintakuDataUpdateAlert> {
//   List<FocusNode> focusNodeList = <FocusNode>[];
//
//   final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
//   final List<OverlayEntry> _secondEntries = <OverlayEntry>[];
//
//   ///
//   @override
//   void initState() {
//     super.initState();
//
//     // ignore: always_specify_types
//     focusNodeList = List.generate(20, (int index) => FocusNode());
//   }
//
//   ///
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//
//       body: SafeArea(
//         child: DefaultTextStyle(
//           style: const TextStyle(color: Colors.white),
//
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(widget.date),
//
//                     ElevatedButton(
//                       onPressed: () {
//                         updateData();
//                       },
//
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
//
//                       child: const Text('input'),
//                     ),
//                   ],
//                 ),
//
//                 Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
//
//                 Expanded(child: displayDateToushiShintakuList()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   String textModify({required String text}) => text.replaceAll('円', '');
//
//   ///
//   Widget displayDateToushiShintakuList() {
//     final List<Widget> list = <Widget>[];
//
//     if (widget.todayData.isNotEmpty) {
//       for (int i = 0; i < 20; i++) {
//         if (i < widget.todayData.length) {
//           final List<int>? relationalIdOnReference = widget.toushiShintakuNameRelationalIdMap[widget.todayData[i].name];
//
//           if (relationalIdOnReference != null && relationalIdOnReference.length == 1) {
//             // ignore: always_specify_types
//             Future(() {
//               toushiShintakuInputNotifier.setInputValue(
//                 pos: i,
//                 id: widget.todayData[i].id,
//                 relationalId: relationalIdOnReference[0],
//               );
//             });
//           }
//
//           list.add(
//             Container(
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
//               ),
//               padding: const EdgeInsets.all(5),
//
//               child: DefaultTextStyle(
//                 style: const TextStyle(fontSize: 12),
//                 child: Row(
//                   children: <Widget>[
//                     SizedBox(width: 40, child: Text(toushiShintakuInputState.relationalIdList[i])),
//
//                     const SizedBox(width: 5),
//
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(widget.todayData[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
//
//                           const SizedBox(height: 5),
//
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(textModify(text: widget.todayData[i].shutokuSougaku).trim()),
//
//                               GestureDetector(
//                                 onTap: () {
//                                   callFirstBox(
//                                     pos: i,
//                                     date: widget.date,
//                                     name: widget.todayData[i].name,
//                                     shutokuSougaku: textModify(text: widget.todayData[i].shutokuSougaku).trim(),
//                                     referenceData: widget.referenceData,
//                                     id: widget.todayData[i].id,
//                                   );
//                                 },
//
//                                 child: Icon(Icons.search),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       }
//     }
//
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (BuildContext context, int index) => list[index],
//             childCount: list.length,
//           ),
//         ),
//       ],
//     );
//   }
//
//   ///
//   void callFirstBox({
//     required int pos,
//     required String date,
//     required String name,
//     required String shutokuSougaku,
//     MapEntry<String, List<ToushiShintakuModel>>? referenceData,
//     required int id,
//   }) {
//     appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);
//
//     addFirstOverlay(
//       context: context,
//       setStateCallback: setState,
//       width: MediaQuery.of(context).size.width * 0.5,
//       height: MediaQuery.of(context).size.height * 0.8,
//       color: Colors.blueGrey.withOpacity(0.3),
//       initialPosition: const Offset(80, 100),
//
//       widget: DefaultTextStyle(
//         style: const TextStyle(fontSize: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(name),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[const SizedBox.shrink(), Text(shutokuSougaku)],
//             ),
//
//             Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
//
//             SizedBox(
//               height: context.screenSize.height * 0.65,
//               child: displayToushiShintakuNameRelationalIdList(
//                 pos: pos,
//                 name: widget.todayData[pos].name,
//                 shutokuSougaku: textModify(text: widget.todayData[pos].shutokuSougaku).trim(),
//                 referenceData: widget.referenceData,
//                 id: id,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       firstEntries: _firstEntries,
//       secondEntries: _secondEntries,
//       onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
//     );
//   }
//
//   ///
//   Future<void> updateData() async {
//     print(toushiShintakuInputState.relationalIdMapList);
//   }
//
//   ///
//   Widget displayToushiShintakuNameRelationalIdList({
//     required int pos,
//     required String name,
//     required String shutokuSougaku,
//     MapEntry<String, List<ToushiShintakuModel>>? referenceData,
//     required int id,
//   }) {
//     final List<Widget> list = <Widget>[];
//
//     if (widget.referenceData != null) {
//       final List<ToushiShintakuModel> sortedData = widget.referenceData!.value
//         ..sort(
//           (ToushiShintakuModel a, ToushiShintakuModel b) => textModify(text: a.shutokuSougaku)
//               .replaceAll(',', '')
//               .trim()
//               .toInt()
//               .compareTo(textModify(text: b.shutokuSougaku).replaceAll(',', '').trim().toInt()),
//         );
//
//       for (final ToushiShintakuModel element in sortedData) {
//         list.add(
//           GestureDetector(
//             onTap: () =>
//                 toushiShintakuInputNotifier.setInputValue(pos: pos, relationalId: element.relationalId, id: id),
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               padding: const EdgeInsets.all(5),
//
//               decoration: BoxDecoration(
//                 color: (textModify(text: element.shutokuSougaku).trim() == shutokuSougaku)
//                     ? Colors.yellowAccent.withValues(alpha: 0.1)
//                     : Colors.black.withValues(alpha: 0.3),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(element.name),
//
//                   const SizedBox(height: 5),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                     children: <Widget>[
//                       const SizedBox.shrink(),
//                       Text(textModify(text: element.shutokuSougaku).trim()),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     }
//
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (BuildContext context, int index) => list[index],
//             childCount: list.length,
//           ),
//         ),
//       ],
//     );
//   }
// }
