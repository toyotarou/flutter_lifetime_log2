import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/credit_summary_model.dart';
import '../../utility/functions.dart';

class MobileSuicaChargeHistoryList extends ConsumerStatefulWidget {
  const MobileSuicaChargeHistoryList({super.key});

  @override
  ConsumerState<MobileSuicaChargeHistoryList> createState() => _MobileSuicaChargeHistoryListState();
}

class _MobileSuicaChargeHistoryListState extends ConsumerState<MobileSuicaChargeHistoryList>
    with ControllersMixin<MobileSuicaChargeHistoryList> {
  late final DateTime _pageOpenTime;

  ///
  @override
  void initState() {
    super.initState();
    _pageOpenTime = DateTime.now();
  }

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('モバイルスイカ　チャージ履歴'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: mobileSuicaChargeHistoryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget mobileSuicaChargeHistoryList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepCreditSummaryMap.forEach((String key, List<CreditSummaryModel> value) {
      for (final CreditSummaryModel element in value) {
        if (element.detail == 'モバイルスイカ') {
          list.add(
            DayFlipCard(
              dayIndex: list.length,
              pageOpenTime: _pageOpenTime,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(key), Text(element.price.toString())],
                ),
              ),
            ),
          );
        }
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
