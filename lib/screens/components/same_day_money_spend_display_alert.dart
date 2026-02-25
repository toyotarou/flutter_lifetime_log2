import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_spend_model.dart';

class SameDayMoneySpendDisplayAlert extends ConsumerStatefulWidget {
  const SameDayMoneySpendDisplayAlert({super.key});

  @override
  ConsumerState<SameDayMoneySpendDisplayAlert> createState() => _SameDayMoneySpendDisplayAlertState();
}

class _SameDayMoneySpendDisplayAlertState extends ConsumerState<SameDayMoneySpendDisplayAlert>
    with ControllersMixin<SameDayMoneySpendDisplayAlert> {
  static const int baseIndex = 1000;

  late final PageController _controller;

  // ignore: unused_field
  int _currentIndex = baseIndex;

  late final ScrollController _dayScrollController;

  static const double _dayItemWidth = 50;

  ///
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: baseIndex);

    _dayScrollController = ScrollController();
  }

  ///
  @override
  void dispose() {
    _controller.dispose();
    _dayScrollController.dispose();
    super.dispose();
  }

  ///
  void _scrollDayAvatars(int delta) {
    if (!_dayScrollController.hasClients) {
      return;
    }

    final double current = _dayScrollController.offset;
    final double max = _dayScrollController.position.maxScrollExtent;

    final double next = (current + delta * _dayItemWidth).clamp(0.0, max);

    _dayScrollController.animateTo(next, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  DateTime _monthFromIndex(int index) {
    final DateTime now = DateTime.now();

    final int diff = baseIndex - index;

    return DateTime(now.year, now.month + diff);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('same day money spend'), SizedBox.shrink()],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            SizedBox(height: 50, child: buildDayAvatarRow()),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () => _scrollDayAvatars(-5),
                  child: const Text('◀ 5', style: TextStyle(color: Colors.white)),
                ),

                OutlinedButton(
                  onPressed: () => _scrollDayAvatars(5),
                  child: const Text('5 ▶', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            SizedBox(
              height: context.screenSize.height * 0.5,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (int index) => setState(() => _currentIndex = index),
                itemBuilder: (BuildContext context, int index) {
                  final DateTime month = _monthFromIndex(index);
                  return _buildMonthCard(yearmonth: month.yyyymm);
                },
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () =>
                      _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                  child: const Text('◀ 来月', style: TextStyle(color: Colors.white)),
                ),

                OutlinedButton(
                  onPressed: () =>
                      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                  child: const Text('先月 ▶', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget buildDayAvatarRow() {
    final List<int> days = List<int>.generate(31, (int index) => index + 1);

    return ListView.builder(
      controller: _dayScrollController,
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      itemBuilder: (BuildContext context, int index) {
        final int day = days[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => appParamNotifier.setSelectedSameDay(day: day.toString().padLeft(2, '0')),

            child: CircleAvatar(
              radius: 20,
              backgroundColor: (appParamState.selectedSameDay == day.toString().padLeft(2, '0'))
                  ? Colors.yellowAccent.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.3),
              child: Text(
                day.toString().padLeft(2, '0'),
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _buildMonthCard({required String yearmonth}) {
    int total = 0;

    if (DateTime.parse(
      '$yearmonth-${appParamState.selectedSameDay}',
    ).isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      for (int i = 0; i < appParamState.selectedSameDay.toInt(); i++) {
        final String date = '$yearmonth-${(i + 1).toString().padLeft(2, '0')}';

        appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel element) => total += element.price);
      }
    }

    return Card(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text('使用金額', style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 50),

          if (DateTime.parse(
            '$yearmonth-${appParamState.selectedSameDay}',
          ).isBefore(DateTime.now().subtract(const Duration(days: 1)))) ...<Widget>[
            Text(total.toString().toCurrency()),
          ] else ...<Widget>[const Text('no data', style: TextStyle(color: Colors.yellowAccent))],

          const SizedBox(height: 50),

          Text('$yearmonth-${appParamState.selectedSameDay}', style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),
                  width: context.screenSize.width * 0.3,
                  alignment: Alignment.center,
                  child: const Text('高額消費'),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),

          Expanded(child: displayOver10000Items(yearmonth: yearmonth)),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  ///
  Widget displayOver10000Items({required String yearmonth}) {
    final List<Widget> list = <Widget>[];

    if (DateTime.parse(
      '$yearmonth-${appParamState.selectedSameDay}',
    ).isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      for (int i = 0; i < appParamState.selectedSameDay.toInt(); i++) {
        final String date = '$yearmonth-${(i + 1).toString().padLeft(2, '0')}';

        appParamState.keepMoneySpendMap[date]?.forEach((MoneySpendModel element) {
          if (element.price >= 10000 || element.item == '送金' || element.item == '社会保険') {
            list.add(
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,

                  color: (element.item == '送金' || element.item == '社会保険')
                      ? Colors.orangeAccent.withValues(alpha: 0.5)
                      : Colors.white60,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                  ),

                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 80, child: Text(element.date)),

                      Expanded(child: Text(element.item)),

                      Expanded(
                        child: Align(alignment: Alignment.topRight, child: Text(element.price.toString().toCurrency())),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
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
