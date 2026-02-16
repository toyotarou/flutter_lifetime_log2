import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/credit_summary_model.dart';

class CreditCalendarDisplayAlert extends ConsumerStatefulWidget {
  const CreditCalendarDisplayAlert({super.key});

  @override
  ConsumerState<CreditCalendarDisplayAlert> createState() => _CreditCalendarDisplayAlertState();
}

class _CreditCalendarDisplayAlertState extends ConsumerState<CreditCalendarDisplayAlert>
    with ControllersMixin<CreditCalendarDisplayAlert> {
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
                  children: <Widget>[Text('クレジットカレンダー'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                const Expanded(child: CreditCalendar()),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
///////////////////////////////////////////////////////////

class CreditCalendar extends ConsumerStatefulWidget {
  const CreditCalendar({super.key});

  @override
  ConsumerState<CreditCalendar> createState() => _CreditCalendarState();
}

class _CreditCalendarState extends ConsumerState<CreditCalendar> with ControllersMixin<CreditCalendar> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  static const double moveAmount = 18;
  static const int tickMs = 16;

  Timer? _repeatTimer;

  Map<String, Map<String, List<CreditSummaryModel>>> creditSummaryDateMap =
      <String, Map<String, List<CreditSummaryModel>>>{};

  List<String> targetYmList = <String>[];

  ///
  @override
  void dispose() {
    _repeatTimer?.cancel();
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  ///
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  Widget _buildGrid() {
    const double colWidth = 200;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: targetYmList.map((String e) {
        int total = 0;
        appParamState.keepCreditSummaryMap[e]?.forEach((CreditSummaryModel element) {
          total += element.price;
        });

        return SizedBox(
          width: colWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: colWidth,

                height: 30,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                  color: Colors.yellowAccent.withValues(alpha: 0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(e), Text(total.toString().toCurrency())],
                ),
              ),
              displayCreditSummaryList(yearmonth: e, colWidth: colWidth),
            ],
          ),
        );
      }).toList(),
    );
  }

  ///
  Widget displayCreditSummaryList({required String yearmonth, required double colWidth}) {
    final List<Widget> list = <Widget>[];

    final List<String> parts = yearmonth.split('-');
    final int y = int.parse(parts[0]);
    final int m = int.parse(parts[1]);

    final DateTime twoMonthsAgo = DateTime(y, m - 2);
    final DateTime lastMonth = DateTime(y, m - 1);

    final int twoMonthsAgoEndDay = DateTime(twoMonthsAgo.year, twoMonthsAgo.month + 1, 0).day;
    final int lastMonthEndDay = DateTime(lastMonth.year, lastMonth.month + 1, 0).day;

    final Map<String, List<CreditSummaryModel>>? yearmonthCreditSummaryDateMap = creditSummaryDateMap[yearmonth];

    void addRow({required String dateText, required bool isValid}) {
      list.add(
        Container(
          width: colWidth,
          height: 100,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            color: isValid ? null : Colors.grey.withOpacity(0.3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: <Widget>[
              if (yearmonthCreditSummaryDateMap != null &&
                  yearmonthCreditSummaryDateMap.containsKey(dateText)) ...<Widget>[
                Column(
                  children: yearmonthCreditSummaryDateMap[dateText]!.map((CreditSummaryModel e) {
                    final Color color = (e.price >= 5000) ? Colors.orangeAccent : Colors.white;

                    return DefaultTextStyle(
                      style: TextStyle(color: color, fontSize: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(e.detail, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Text(e.price.toString().toCurrency()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  dateText,
                  style: TextStyle(color: isValid ? Colors.white.withValues(alpha: 0.6) : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }

    for (int day = 25; day <= 31; day++) {
      final bool isValid = day <= twoMonthsAgoEndDay;

      final String dateText =
          '${twoMonthsAgo.year}-${twoMonthsAgo.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      addRow(dateText: dateText, isValid: isValid);
    }

    for (int day = 1; day <= 31; day++) {
      final bool isValid = day <= lastMonthEndDay;

      final String dateText =
          '${lastMonth.year}-${lastMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      addRow(dateText: dateText, isValid: isValid);
    }

    return SizedBox(
      width: colWidth,
      child: SingleChildScrollView(child: Column(children: list)),
    );
  }

  ///
  Widget _arrowButton({required IconData icon, required VoidCallback onRepeat}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _startRepeating(onRepeat),
      onTapUp: (_) => _stopRepeating(),
      onTapCancel: _stopRepeating,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: Icon(icon, color: Colors.white, size: 30)),
      ),
    );
  }

  ///
  Widget _buildCrossKey() {
    ///
    void scrollUp() => _scrollVerticalBy(-moveAmount);

    void scrollDown() => _scrollVerticalBy(moveAmount);

    void scrollLeft() => _scrollHorizontalBy(-moveAmount);

    void scrollRight() => _scrollHorizontalBy(moveAmount);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _arrowButton(icon: Icons.keyboard_arrow_up, onRepeat: scrollUp),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _arrowButton(icon: Icons.keyboard_arrow_left, onRepeat: scrollLeft),
              const SizedBox(width: 10),
              _arrowButton(icon: Icons.keyboard_arrow_right, onRepeat: scrollRight),
            ],
          ),
          _arrowButton(icon: Icons.keyboard_arrow_down, onRepeat: scrollDown),
        ],
      ),
    );
  }

  ///
  void _scrollVerticalBy(double delta) {
    if (!_verticalController.hasClients) {
      return;
    }

    final ScrollPosition pos = _verticalController.position;
    final double newOffset = (_verticalController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    _verticalController.jumpTo(newOffset);
  }

  ///
  void _scrollHorizontalBy(double delta) {
    if (!_horizontalController.hasClients) {
      return;
    }

    final ScrollPosition pos = _horizontalController.position;
    final double newOffset = (_horizontalController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    _horizontalController.jumpTo(newOffset);
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      makeCreditSummaryDateMap();
    });

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _verticalController,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: _buildGrid(),
          ),
        ),

        Positioned(right: 12, bottom: 12, child: _buildCrossKey()),
      ],
    );
  }

  ///
  void makeCreditSummaryDateMap() {
    final String? lastDate = appParamState.keepCreditSummaryMap.isEmpty
        ? null
        : appParamState.keepCreditSummaryMap.keys.reduce((String a, String b) => a.compareTo(b) > 0 ? a : b);

    if (lastDate == null) {
      return;
    }

    final DateTime last = DateTime.parse('$lastDate-01');
    final DateTime firstDayOfMonth = DateTime(last.year, last.month);

    final Set<String> ymSet = <String>{};
    for (int i = 0; i < 100; i++) {
      ymSet.add(firstDayOfMonth.subtract(Duration(days: i)).yyyymm);
    }

    final List<String> ymList = ymSet.toList()..sort();

    final Map<String, Map<String, List<CreditSummaryModel>>> result = <String, Map<String, List<CreditSummaryModel>>>{};

    final int takeCount = ymList.length >= 3 ? 3 : ymList.length;

    targetYmList = ymList.sublist(ymList.length - takeCount);

    targetYmList.sort((String a, String b) => a.compareTo(b) * -1);

    for (final String ym in targetYmList) {
      final List<CreditSummaryModel> items = appParamState.keepCreditSummaryMap[ym] ?? <CreditSummaryModel>[];

      final Map<String, List<CreditSummaryModel>> byUseDate = <String, List<CreditSummaryModel>>{};
      for (final CreditSummaryModel item in items) {
        (byUseDate[item.useDate] ??= <CreditSummaryModel>[]).add(item);
      }

      result[ym] = byUseDate;
    }

    creditSummaryDateMap = result;
  }
}
