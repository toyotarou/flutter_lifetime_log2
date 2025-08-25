import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../models/toushi_shintaku_model.dart';
import '../parts/error_dialog.dart';

class ToushiShintakuDataUpdateAlert extends ConsumerStatefulWidget {
  const ToushiShintakuDataUpdateAlert({super.key, required this.date, required this.toushiShintakuRelationalIdMap});

  final String date;
  final Map<int, int> toushiShintakuRelationalIdMap;

  @override
  ConsumerState<ToushiShintakuDataUpdateAlert> createState() => _ToushiShintakuDataUpdateAlertState();
}

class _ToushiShintakuDataUpdateAlertState extends ConsumerState<ToushiShintakuDataUpdateAlert>
    with ControllersMixin<ToushiShintakuDataUpdateAlert> {
  final List<TextEditingController> tecs = <TextEditingController>[];

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 20; i++) {
      tecs.add(TextEditingController(text: ''));
    }

    for (int i = 0; i < widget.toushiShintakuRelationalIdMap.entries.length; i++) {
      final List<MapEntry<int, int>> entries = widget.toushiShintakuRelationalIdMap.entries.toList();
      tecs[i].text = (entries[i].value != 0) ? entries[i].value.toString() : '';
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

    int i = 0;
    appParamState.keepToushiShintakuMap[widget.date]
      ?..sort((ToushiShintakuModel a, ToushiShintakuModel b) => a.id.compareTo(b.id))
      ..forEach((ToushiShintakuModel element) {
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
                  Text(element.id.toString()),

                  const SizedBox(width: 10),

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

                      onChanged: (String value) {
                        toushiShintakuInputNotifier.setInputValue(id: element.id, relationalId: value.toInt());
                      },

                      onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                      focusNode: focusNodeList[i],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(child: Text(element.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        );

        i++;
      });

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
    final List<int> updateIdList = toushiShintakuInputState.updateIdList.toSet().toList();

    final Map<String, int> updateData = <String, int>{};

    for (final int element in updateIdList) {
      if (toushiShintakuInputState.toushiShintakuRelationalIdMap[element] != null) {
        updateData[element.toString()] = toushiShintakuInputState.toushiShintakuRelationalIdMap[element]!;
      }
    }

    if (updateData.isEmpty) {
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

    // ignore: always_specify_types
    toushiShintakuInputNotifier.updateToushiShintakuRelationId(updateData: updateData).then((value) {
      if (mounted) {
        context.findAncestorStateOfType<AppRootState>()?.restartApp();
      }
    });
  }
}
