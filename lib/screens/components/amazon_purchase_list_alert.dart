import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/amazon_purchase_model.dart';
import '../../utility/utility.dart';

class AmazonPurchaseListAlert extends ConsumerStatefulWidget {
  const AmazonPurchaseListAlert({super.key});

  @override
  ConsumerState<AmazonPurchaseListAlert> createState() => _AmazonPurchaseListAlertState();
}

class _AmazonPurchaseListAlertState extends ConsumerState<AmazonPurchaseListAlert>
    with ControllersMixin<AmazonPurchaseListAlert> {
  Utility utility = Utility();

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('amazon purchase list'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayAmazonPurchaseList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayAmazonPurchaseList() {
    final List<Widget> list = <Widget>[];

    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    appParamState.keepAmazonPurchaseMap.forEach((String key, List<AmazonPurchaseModel> value) {
      for (final AmazonPurchaseModel element in value) {
        final Color color = twentyFourColor[element.month.toInt() - 1];

        list.add(
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),

            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${element.year}-${element.month}-${element.day}'),
                      const SizedBox.shrink(),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircleAvatar(
                          radius: 15,

                          backgroundColor: color.withValues(alpha: 0.2),
                          child: Text(element.month, style: const TextStyle(fontSize: 12)),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(element.item),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[const SizedBox.shrink(), Text(element.price.toString().toCurrency())],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
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
}
