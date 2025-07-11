import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/lifetime_item_model.dart';
import '../../models/lifetime_model.dart';

class LifetimeInputAlert extends ConsumerStatefulWidget {
  const LifetimeInputAlert({super.key, this.dateLifetime, required this.date});

  final String date;
  final LifetimeModel? dateLifetime;

  @override
  ConsumerState<LifetimeInputAlert> createState() => _LifetimeInputAlertState();
}

class _LifetimeInputAlertState extends ConsumerState<LifetimeInputAlert> with ControllersMixin<LifetimeInputAlert> {
  final List<TextEditingController> _lifetimeItemTecs = <TextEditingController>[];

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i <= 23; i++) {
      _lifetimeItemTecs.add(TextEditingController(text: ''));
    }

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
        _lifetimeItemTecs.add(TextEditingController(text: dispValList[i]));
      }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[Text(widget.date), const SizedBox.shrink()],
                ),

                Divider(thickness: 5, color: Colors.white.withValues(alpha: 0.4)),

                Expanded(child: Container()),

                Divider(thickness: 2, color: Colors.white.withValues(alpha: 0.4)),

                displayLifetimeInputItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayLifetimeInputItem() {
    return SizedBox(
      height: 200,
      child: Wrap(
        children: appParamState.keepLifetimeItemList.map((LifetimeItemModel e) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            child: ChoiceChip(
              label: Text(e.item, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.black.withValues(alpha: 0.1),
              selectedColor: Colors.greenAccent.withValues(alpha: 0.4),

              selected: e.item == lifetimeInputState.selectedInputChoiceChip,
              onSelected: (bool isSelected) async {
                lifetimeInputNotifier.setSelectedInputChoiceChip(item: e.item);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
