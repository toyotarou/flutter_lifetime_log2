import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/money_spend_model.dart';

class OhakamairiDataDisplayAlert extends ConsumerStatefulWidget {
  const OhakamairiDataDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<OhakamairiDataDisplayAlert> createState() => _OhakamairiDataDisplayAlertState();
}

class _OhakamairiDataDisplayAlertState extends ConsumerState<OhakamairiDataDisplayAlert>
    with ControllersMixin<OhakamairiDataDisplayAlert> {
  static const List<String> _weekLabels = <String>['日', '月', '火', '水', '木', '金', '土'];
  static const Color _sunColor = Color(0xFFFF6666);
  static const Color _satColor = Color(0xFF6699FF);
  static const Color _borderColor = Color(0x22FFFFFF);

  // 最初のデータ 2024-11-09 の直前の日曜日
  static final DateTime _startDate = DateTime(2024, 11, 3);

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MoneySpendModel>> dataMap = appParamState.keepOhakamairiDataMap;
    final DateTime today = DateTime.now();
    final DateTime endDate = DateTime(today.year, today.month, today.day);

    final int totalDays = endDate.difference(_startDate).inDays + 1;
    final int totalWeeks = ((totalDays + 6) ~/ 7) + 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'お墓参り',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // 曜日ヘッダー
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: _borderColor),
                  left: BorderSide(color: _borderColor),
                ),
              ),
              child: Row(
                children: List<Widget>.generate(7, (int i) {
                  Color color = Colors.white;
                  if (i == 0) {
                    color = _sunColor;
                  }
                  if (i == 6) {
                    color = _satColor;
                  }
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: _borderColor),
                          bottom: BorderSide(color: _borderColor),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _weekLabels[i],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // カレンダー本体
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: _borderColor)),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: totalWeeks,
                  itemBuilder: (BuildContext context, int weekIndex) {
                    return SizedBox(
                      height: 52,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List<Widget>.generate(7, (int col) {
                          final DateTime cellDate = _startDate.add(Duration(days: weekIndex * 7 + col));

                          if (cellDate.isAfter(endDate)) {
                            return Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: _borderColor),
                                    bottom: BorderSide(color: _borderColor),
                                  ),
                                ),
                              ),
                            );
                          }

                          final String dateKey =
                              '${cellDate.year.toString().padLeft(4, '0')}-'
                              '${cellDate.month.toString().padLeft(2, '0')}-'
                              '${cellDate.day.toString().padLeft(2, '0')}';

                          final bool hasData = dataMap.containsKey(dateKey);

                          return Expanded(
                            child: _buildDayCell(date: cellDate, col: col, hasData: hasData),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell({required DateTime date, required int col, required bool hasData}) {
    Color dayNumColor = const Color(0xFFDDDDDD);
    if (col == 0) {
      dayNumColor = _sunColor;
    }
    if (col == 6) {
      dayNumColor = _satColor;
    }

    final DateTime today = DateTime.now();
    final bool isToday = date.year == today.year && date.month == today.month && date.day == today.day;

    final bool isFirstDay = date.day == 1;
    final String dayStr = date.day.toString().padLeft(2, '0');
    final String monthStr = date.month.toString().padLeft(2, '0');

    final String dateKey =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final bool isHoliday = appParamState.keepHolidayList.contains(dateKey);

    Color? bgColor;
    if (isToday) {
      bgColor = Colors.white.withValues(alpha: 0.08);
    } else if (isHoliday) {
      bgColor = Colors.green.withValues(alpha: 0.15);
    } else if (col == 0) {
      bgColor = Colors.red.withValues(alpha: 0.15);
    } else if (col == 6) {
      bgColor = Colors.blue.withValues(alpha: 0.15);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
          right: BorderSide(color: _borderColor),
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: Stack(
        children: <Widget>[
          // 月初の場合、裏に年月を表示
          if (isFirstDay)
            Positioned.fill(
              child: Center(
                child: Text(
                  '${date.year}\n$monthStr',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFFF99).withValues(alpha: 0.35),
                    height: 1.2,
                  ),
                ),
              ),
            ),

          Positioned(
            top: 3,
            left: 4,
            child: Text(
              dayStr,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: dayNumColor),
            ),
          ),

          if (hasData)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Center(child: Image.asset('assets/images/toyoda_kamon.png', width: 25, height: 25)),
            ),
        ],
      ),
    );
  }
}
