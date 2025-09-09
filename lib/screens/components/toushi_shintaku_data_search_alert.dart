import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/toushi_shintaku_model.dart';

class ToushiShintakuDataSearchAlert extends ConsumerStatefulWidget {
  const ToushiShintakuDataSearchAlert({
    super.key,
    required this.pos,
    required this.name,
    required this.shutokuSougaku,
    this.referenceData,
    required this.date,
  });

  final int pos;
  final String date;
  final String name;
  final String shutokuSougaku;
  final MapEntry<String, List<ToushiShintakuModel>>? referenceData;

  @override
  ConsumerState<ToushiShintakuDataSearchAlert> createState() => _ToushiShintakuDataSearchAlertState();
}

class _ToushiShintakuDataSearchAlertState extends ConsumerState<ToushiShintakuDataSearchAlert>
    with ControllersMixin<ToushiShintakuDataSearchAlert> {
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
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.name),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[const SizedBox.shrink(), Text(widget.shutokuSougaku)],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  Expanded(child: displayToushiShintakuNameRelationalIdList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayToushiShintakuNameRelationalIdList() {
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
                  if (element2.shutokuSougaku.replaceAll('円', '').trim() == widget.shutokuSougaku) {
                    if (element2.name == widget.name) {
                      print(element.name);
                      print(element.id);
                      print(element2.relationalId);

                      toushiShintakuInputNotifier.setInputValue(
                        pos: widget.pos,
                        relationalId: element2.relationalId,
                        id: element.id,
                      );

                      Navigator.pop(context);
                    }
                  }
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(5),

              decoration: BoxDecoration(
                color: (element.shutokuSougaku.replaceAll('円', '').trim() == widget.shutokuSougaku)
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
