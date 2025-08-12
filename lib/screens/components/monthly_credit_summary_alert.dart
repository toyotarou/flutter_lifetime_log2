import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class MonthlyCreditSummaryAlert extends ConsumerStatefulWidget {
  const MonthlyCreditSummaryAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyCreditSummaryAlert> createState() => _MonthlyCreditSummaryAlertState();
}

class _MonthlyCreditSummaryAlertState extends ConsumerState<MonthlyCreditSummaryAlert>
    with ControllersMixin<MonthlyCreditSummaryAlert> {
  Map<String, List<int>> creditSummaryMap = {};

  ///
  @override
  void initState() {
    super.initState();

    appParamState.keepCreditSummaryMap[widget.yearmonth]?.forEach((element) {
      (creditSummaryMap[element.item] ??= <int>[]).add(element.price);
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
                  children: <Widget>[Text(widget.yearmonth), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayCreditSummaryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayCreditSummaryList() {
    final List<Widget> list = <Widget>[];

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
