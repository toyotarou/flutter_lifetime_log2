import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/common/year_day_assets_model.dart';
import '../../utility/utility.dart';

class MonthEndAssetsDisplayAlert extends ConsumerStatefulWidget {
  const MonthEndAssetsDisplayAlert({
    super.key,
    required this.date,
    required this.monthEndAssetsList,
    required this.lastYearFinalAssets,
  });

  final String date;

  final List<YearDayAssetsModel> monthEndAssetsList;

  final int lastYearFinalAssets;

  @override
  ConsumerState<MonthEndAssetsDisplayAlert> createState() => _MonthEndAssetsDisplayAlertState();
}

class _MonthEndAssetsDisplayAlertState extends ConsumerState<MonthEndAssetsDisplayAlert> {
  Utility utility = Utility();

  int yearlyTotal = 0;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${widget.date.split('-')[0]} 年 月末資産推移'),

                  Column(
                    children: <Widget>[
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('前年末', style: TextStyle(fontSize: 10)),
                      ),

                      const SizedBox(height: 5),

                      Text(widget.lastYearFinalAssets.toString().toCurrency(), style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Expanded(child: displayMonthEndAssetsList()),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(yearlyTotal.toString().toCurrency(), style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayMonthEndAssetsList() {
    final List<Widget> list = <Widget>[];

    int i = 0;
    int yt = 0;
    for (final YearDayAssetsModel element in widget.monthEndAssetsList) {
      if (i < DateTime.parse(widget.date).month) {
        final int diff = (i == 0)
            ? widget.monthEndAssetsList[i].total - widget.lastYearFinalAssets
            : widget.monthEndAssetsList[i].total - widget.monthEndAssetsList[i - 1].total;

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${element.date.split('-')[0]}-${element.date.split('-')[1]}'),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(element.total.toString().toCurrency()),

                          Text(diff.toString().toCurrency()),
                        ],
                      ),

                      const SizedBox(width: 20),

                      SizedBox(
                        width: 30,
                        child: utility.dispUpDownMark(
                          before: (i == 0) ? widget.lastYearFinalAssets : widget.monthEndAssetsList[i - 1].total,
                          after: widget.monthEndAssetsList[i].total,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        yt += diff;
      }

      i++;
    }

    setState(() => yearlyTotal = yt);

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
