import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/toushi_shintaku_history_model.dart';

class AssetsCostDetailDisplayAlert extends ConsumerStatefulWidget {
  const AssetsCostDetailDisplayAlert({super.key, required this.costChangeDate});

  final String costChangeDate;

  @override
  ConsumerState<AssetsCostDetailDisplayAlert> createState() => _AssetsCostDetailDisplayAlertState();
}

class _AssetsCostDetailDisplayAlertState extends ConsumerState<AssetsCostDetailDisplayAlert>
    with ControllersMixin<AssetsCostDetailDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.costChangeDate), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: _displayToushiShintakuHistoryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayToushiShintakuHistoryList() {
    final List<Widget> list = <Widget>[];

    toushiShintakuHistoryState.toushiShintakuHistoryCostDateMap[widget.costChangeDate]?.forEach((
      ToushiShintakuHistoryModel e,
    ) {
      list.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(5)),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Text(e.relationalId.toString(), style: const TextStyle(fontSize: 10)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(e.accountKind), const SizedBox.shrink()],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[const SizedBox.shrink(), Text(e.payMethod)],
                          ),
                        ],
                      ),

                      Text(e.fundName, style: const TextStyle(fontSize: 12)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Text(
                            e.payPrice.toString().toCurrency(),
                            style: const TextStyle(fontSize: 12, color: Colors.yellowAccent),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),

                          Row(
                            children: <Widget>[
                              Text(e.kijunPrice.toString().toCurrency()),
                              const Text(' / '),
                              const Text('10,000'),
                              const Text(' * '),
                              Text(e.suuryou.toString().toCurrency()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(child: Column(children: list));
  }
}
