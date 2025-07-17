import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/lifetime_item_model.dart';
import '../models/lifetime_model.dart';
import '../models/money_model.dart';
import '../models/walk_model.dart';
import '../utility/utility.dart';
import 'page/monthly_lifetime_display_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget, {this.highlight = false});

  String label;
  Widget widget;
  bool highlight;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.walkMap,
    required this.moneyMap,
    required this.lifetimeItemList,
    required this.holidayList,
  });

  final List<String> holidayList;
  final Map<String, WalkModel> walkMap;
  final Map<String, MoneyModel> moneyMap;
  final List<LifetimeItemModel> lifetimeItemList;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final List<TabInfo> _tabs = <TabInfo>[];

  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appParamNotifier.setKeepHolidayList(list: widget.holidayList);
      appParamNotifier.setKeepWalkModelMap(map: widget.walkMap);
      appParamNotifier.setKeepMoneyMap(map: widget.moneyMap);
      appParamNotifier.setKeepLifetimeItemList(list: widget.lifetimeItemList);
    });

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            //-------------------------//これを消すと「←」が出てくる（消さない）
            leading: const Icon(Icons.check_box_outline_blank, color: Colors.transparent),

            //-------------------------//これを消すと「←」が出てくる（消さない）
            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.blueAccent,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(
                  child: Text(
                    tab.label,
                    style: TextStyle(fontSize: 14, color: tab.highlight ? Colors.greenAccent : Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            utility.getBackGround(),

            Container(
              width: context.screenSize.width,
              height: context.screenSize.height,
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
            ),

            Column(
              children: <Widget>[
                Expanded(child: TabBarView(children: _tabs.map((TabInfo tab) => tab.widget).toList())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  void _makeTab() {
    final List<String> yearmonthList = <String>[];

    lifetimeState.lifetimeList.toList()
      ..sort((LifetimeModel a, LifetimeModel b) => '${a.year}-${a.month}'.compareTo('${b.year}-${b.month}') * -1)
      ..forEach((LifetimeModel element) {
        if (!yearmonthList.contains('${element.year}-${element.month}')) {
          yearmonthList.add('${element.year}-${element.month}');
        }
      });

    for (final String element in yearmonthList) {
      _tabs.add(TabInfo(element, MonthlyLifetimeDisplayPage(yearmonth: element)));
    }
  }
}
