import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../models/lifetime_model.dart';
import '../parts/error_dialog.dart';

class LifetimeInputAlert extends ConsumerStatefulWidget {
  const LifetimeInputAlert({super.key, this.dateLifetime, required this.date});

  final String date;
  final LifetimeModel? dateLifetime;

  @override
  ConsumerState<LifetimeInputAlert> createState() => _LifetimeInputAlertState();
}

class _LifetimeInputAlertState extends ConsumerState<LifetimeInputAlert> with ControllersMixin<LifetimeInputAlert> {
  final List<TextEditingController> tecs = <TextEditingController>[];

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i <= 23; i++) {
      tecs.add(TextEditingController(text: ''));
    }

    // ignore: always_specify_types
    Future(() {
      if (widget.dateLifetime != null) {
        final List<String> dispValList = <String>[
          widget.dateLifetime!.hour00,
          widget.dateLifetime!.hour01,
          widget.dateLifetime!.hour02,
          widget.dateLifetime!.hour03,
          widget.dateLifetime!.hour04,
          widget.dateLifetime!.hour05,
          widget.dateLifetime!.hour06,
          widget.dateLifetime!.hour07,
          widget.dateLifetime!.hour08,
          widget.dateLifetime!.hour09,
          widget.dateLifetime!.hour10,
          widget.dateLifetime!.hour11,
          widget.dateLifetime!.hour12,
          widget.dateLifetime!.hour13,
          widget.dateLifetime!.hour14,
          widget.dateLifetime!.hour15,
          widget.dateLifetime!.hour16,
          widget.dateLifetime!.hour17,
          widget.dateLifetime!.hour18,
          widget.dateLifetime!.hour19,
          widget.dateLifetime!.hour20,
          widget.dateLifetime!.hour21,
          widget.dateLifetime!.hour22,
          widget.dateLifetime!.hour23,
        ];

        for (int i = 0; i <= 23; i++) {
          tecs[i].text = dispValList[i];

          lifetimeInputNotifier.setLifetimeStringList(pos: i, item: dispValList[i]);
        }
      }
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

                    Row(
                      children: <Widget>[
                        _displayBetweenInputButton(),

                        const SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () async => inputLifetimeData(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                          child: const Text('input'),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(thickness: 5, color: Colors.white.withValues(alpha: 0.4)),

                Expanded(child: lifetimeInputParts()),

                Divider(thickness: 2, color: Colors.white.withValues(alpha: 0.4)),

                displayLifetimeInputItemList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget lifetimeInputParts() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < tecs.length; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  lifetimeInputNotifier.setItemPos(pos: i);
                },
                child: CircleAvatar(
                  backgroundColor: (i == lifetimeInputState.itemPos)
                      ? Colors.yellowAccent.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),
                  child: Text(i.toString().padLeft(2, '0'), style: const TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (i == lifetimeInputState.itemPos)
                          ? Colors.yellowAccent.withOpacity(0.4)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),

                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    readOnly: true,
                    controller: tecs[i],
                    decoration: const InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      border: InputBorder.none,
                    ),
                  ),
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
  Widget displayLifetimeInputItemList() {
    final List<Widget> list = <Widget>[];

    for (final LifetimeItemModel element in appParamState.keepLifetimeItemList) {
      bool flag = true;

      if (element.item == '俳句会' &&
          DateTime(
            widget.date.split('-')[0].toInt(),
            widget.date.split('-')[1].toInt(),
            widget.date.split('-')[2].toInt(),
          ).isAfter(DateTime(2023, 10, 21))) {
        flag = false;
      }

      if (element.item == '自宅' &&
          DateTime(
            widget.date.split('-')[0].toInt(),
            widget.date.split('-')[1].toInt(),
            widget.date.split('-')[2].toInt(),
          ).isAfter(DateTime(2024, 2, 10))) {
        flag = false;
      }

      if (flag) {
        list.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            child: ChoiceChip(
              label: Text(element.item, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.black.withValues(alpha: 0.1),
              selectedColor: Colors.greenAccent.withValues(alpha: 0.4),
              selected: element.item == lifetimeInputState.selectedInputChoiceChip,
              onSelected: (bool isSelected) async {
                lifetimeInputNotifier.setSelectedInputChoiceChip(item: element.item);
                lifetimeInputNotifier.setLifetimeStringList(pos: lifetimeInputState.itemPos, item: element.item);
                tecs[lifetimeInputState.itemPos].text = element.item;
              },
              showCheckmark: false,
            ),
          ),
        );
      }
    }

    return SizedBox(height: 200, child: Wrap(children: list));
  }

  ///
  Widget _displayBetweenInputButton() {
    final List<String> list = <String>[];

    for (final String element in lifetimeInputState.lifetimeStringList) {
      if (element != '') {
        list.add(element);
      }
    }

    if (list.isEmpty) {
      return const Icon(Icons.check_box_outline_blank, color: Colors.transparent);
    }

    return GestureDetector(
      onTap: () async {
        int endPos = 0;
        for (int i = lifetimeInputState.itemPos + 1; i < tecs.length; i++) {
          if (lifetimeInputState.lifetimeStringList[i] != '') {
            break;
          }

          endPos = i;
        }

        final String lifetimeStringItem = lifetimeInputState.lifetimeStringList[lifetimeInputState.itemPos];

        for (int i = lifetimeInputState.itemPos; i <= endPos; i++) {
          tecs[i].text = lifetimeStringItem;

          lifetimeInputNotifier.setLifetimeStringList(pos: i, item: lifetimeStringItem);
        }
      },
      child: Icon(Icons.download_for_offline_outlined, color: Colors.white.withOpacity(0.6)),
    );
  }

  ///
  Future<void> inputLifetimeData() async {
    final List<String> list = <String>[];

    for (final String element in lifetimeInputState.lifetimeStringList) {
      if (element != '') {
        list.add(element);
      }
    }

    if (tecs.length != list.length) {
      error_dialog(context: context, title: 'input error', content: '入力されていない時間があります。');

      return;
    }

    // ignore: always_specify_types
    await lifetimeInputNotifier.inputLifetime(date: widget.date).then((value) {
      if (mounted) {
        context.findAncestorStateOfType<AppRootState>()?.restartApp();
      }
    });
  }
}
