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
    return Column(
      children: specialStampGuideList.map((String e) {
        return Text(e);
      }).toList(),
    );
  }
}
