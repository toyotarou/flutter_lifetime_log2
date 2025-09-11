import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../models/toushi_shintaku_model.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_log_overlay.dart';

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
  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  ///
  @override
  void initState() {
    super.initState();

    final Map<String, int> map = <String, int>{};

    for (final ToushiShintakuModel element in widget.todayDataList) {
      int defaultRelationalId = 0;
      if (widget.referenceNameAndToushiShintakuModelListMap[element.name] != null &&
          widget.referenceNameAndToushiShintakuModelListMap[element.name]!.length == 1) {
        defaultRelationalId = widget.referenceNameAndToushiShintakuModelListMap[element.name]![0].relationalId;
      }

      map[element.id.toString()] = defaultRelationalId;
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

    int i = 0;
    for (final ToushiShintakuModel element in widget.todayDataList) {
      String displayRelationalId = '';

      if (element.relationalId > 0) {
        displayRelationalId = element.relationalId.toString();
      } else {
        if (toushiShintakuInputState.relationalIdMap[element.id.toString()] != null &&
            toushiShintakuInputState.relationalIdMap[element.id.toString()] != 0) {
          displayRelationalId = toushiShintakuInputState.relationalIdMap[element.id.toString()].toString();
        }
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
              if (displayRelationalId != '')
                SizedBox(width: 50, child: Text(displayRelationalId))
              else
                SizedBox(
                  width: 50,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 2, right: 10),
                    decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),

                    alignment: Alignment.center,
                    child: const Text('-----'),
                  ),
                ),

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
                        GestureDetector(
                          onTap: () => callFirstBox(
                            pos: i,
                            id: element.id,
                            name: element.name,
                            shutokuSougaku: textModify(text: element.shutokuSougaku).trim(),
                          ),
                          child: Icon(
                            Icons.search,

                            color: (displayRelationalId == '') ? Colors.yellowAccent : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      i++;
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
  void callFirstBox({required int pos, required int id, required String name, required String shutokuSougaku}) {
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
                id: id,
                name: name,
                shutokuSougaku: textModify(text: shutokuSougaku).trim(),
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
  Widget displayToushiShintakuNameRelationalIdList({
    required int pos,
    required int id,
    required String name,
    required String shutokuSougaku,
  }) {
    final List<Widget> list = <Widget>[];

    if (widget.referenceDataMapEntry != null) {
      final List<ToushiShintakuModel> sortedData = widget.referenceDataMapEntry!.value
        ..sort(
          (ToushiShintakuModel a, ToushiShintakuModel b) => textModify(text: a.shutokuSougaku)
              .replaceAll(',', '')
              .trim()
              .toInt()
              .compareTo(textModify(text: b.shutokuSougaku).replaceAll(',', '').trim().toInt()),
        );

      for (final ToushiShintakuModel element in sortedData) {
        bool shutokuSougakuMatchFlag = false;

        if (textModify(text: element.shutokuSougaku).trim() == shutokuSougaku) {
          shutokuSougakuMatchFlag = true;
        }

        bool shutokuSougakuAroundFlag = false;
        if (!shutokuSougakuMatchFlag) {
          final int ss1 = textModify(text: shutokuSougaku).replaceAll(',', '').trim().toInt();
          final int ss2 = textModify(text: element.shutokuSougaku).replaceAll(',', '').trim().toInt();

          if ((ss1 - ss2) < 50000 && element.name == name) {
            shutokuSougakuAroundFlag = true;
          }
        }

        list.add(
          GestureDetector(
            onTap: () => toushiShintakuInputNotifier.setInputValue(relationalId: element.relationalId, id: id),

            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(5),

              decoration: BoxDecoration(
                color: shutokuSougakuMatchFlag
                    ? Colors.yellowAccent.withValues(alpha: 0.1)
                    : shutokuSougakuAroundFlag
                    ? Colors.blueAccent.withValues(alpha: 0.1)
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
                      Text(textModify(text: element.shutokuSougaku).trim()),
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

  ///
  Future<void> updateData() async {
    bool errFlg = false;
    toushiShintakuInputState.relationalIdMap.forEach((String key, int value) {
      if (value == 0) {
        errFlg = true;
      }
    });

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
          // ignore: use_build_context_synchronously
          context: context,
          title: '登録できません。',
          content: '値を正しく入力してください。',
        ),
      );

      return;
    }

    toushiShintakuInputNotifier.updateToushiShintakuRelationalId(updateData: toushiShintakuInputState.relationalIdMap)
    // ignore: always_specify_types
    .then((value) {
      if (mounted) {
        context.findAncestorStateOfType<AppRootState>()?.restartApp();
      }
    });
  }
}
