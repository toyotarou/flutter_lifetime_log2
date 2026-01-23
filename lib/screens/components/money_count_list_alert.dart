
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/money_model.dart';
import '../parts/flexible_table.dart';

//////////////////////////////////////////////////////////////////////////////////////

class MoneyCountListAlert extends ConsumerStatefulWidget {
  const MoneyCountListAlert({super.key, required this.initialRowIndex, required this.moneyEntries});

  final int initialRowIndex;
  final List<MapEntry<String, MoneyModel>> moneyEntries;

  ///
  @override
  ConsumerState<MoneyCountListAlert> createState() => _MoneyCountListAlertState();
}

class _MoneyCountListAlertState extends ConsumerState<MoneyCountListAlert> with ControllersMixin<MoneyCountListAlert> {
  late final List<MapEntry<String, MoneyModel>> _entries;

  int? _initialRowIndexSafe;

  FlexibleTableController? _tableCtl;

  static const List<FlexibleColumn> headerContents = <FlexibleColumn>[
    FlexibleColumn(title: '10000', width: 80),
    FlexibleColumn(title: '5000', width: 80),
    FlexibleColumn(title: '2000', width: 80),
    FlexibleColumn(title: '1000', width: 80),
    FlexibleColumn(title: '500', width: 80),
    FlexibleColumn(title: '100', width: 80),
    FlexibleColumn(title: '50', width: 80),
    FlexibleColumn(title: '10', width: 80),
    FlexibleColumn(title: '5', width: 80),
    FlexibleColumn(title: '1', width: 80),

    FlexibleColumn(title: 'bankA', width: 80),
    FlexibleColumn(title: 'bankB', width: 80),
    FlexibleColumn(title: 'bankC', width: 80),
    FlexibleColumn(title: 'bankD', width: 80),
    FlexibleColumn(title: 'bankE', width: 80),

    FlexibleColumn(title: 'payA', width: 80),
    FlexibleColumn(title: 'payB', width: 80),
    FlexibleColumn(title: 'payC', width: 80),
    FlexibleColumn(title: 'payD', width: 80),
    FlexibleColumn(title: 'payE', width: 80),
    FlexibleColumn(title: 'payF', width: 80),
  ];

  ///
  @override
  void initState() {
    super.initState();
    _entries = widget.moneyEntries;

    if (_entries.isEmpty) {
      _initialRowIndexSafe = null;
    } else {
      _initialRowIndexSafe = widget.initialRowIndex.clamp(0, _entries.length - 1);
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    const double dateCellWidth = 80.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () => _tableCtl?.scrollToTop(),
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('先頭へ'),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      final int target = _initialRowIndexSafe ?? 0;
                      _tableCtl?.scrollToRow(target);
                    },
                    icon: const Icon(Icons.my_location_outlined),
                    label: const Text('該当行へ'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Expanded(
                child: FlexibleTable(
                  rowCount: _entries.length,
                  headerContents: headerContents,

                  leftHeader: FlexibleTable.headerCell(
                    text: 'DATE',
                    width: dateCellWidth,
                    height: 30,

                    /// 「DATE」のセルの装飾
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                  ),

                  initialScrollToRow: _initialRowIndexSafe,
                  autoScrollDuration: const Duration(milliseconds: 450),

                  buildLeftCell: (BuildContext context, int row) {
                    final String text = (row >= 0 && row < _entries.length) ? _entries[row].key : '';

                    final bool isMonthStart = text.endsWith('-01');

                    /// 日付セル
                    return FlexibleTable.bodyCell(
                      text: text,
                      width: dateCellWidth,
                      height: 50,
                      textStyle: const TextStyle(fontSize: 8),
                      decoration: BoxDecoration(
                        color: isMonthStart ? Colors.yellow.withOpacity(0.1) : Colors.transparent,
                        border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3)),
                      ),
                      holiday: appParamState.keepHolidayList,
                    );
                  },

                  buildCell: (BuildContext context, int row, int colIndex) {
                    final MapEntry<String, MoneyModel> entries = widget.moneyEntries[row];

                    final String value = getDisplayValue(entries: entries, colIndex: colIndex);

                    final bool isMonthStart = entries.key.endsWith('-01');

                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        /// 右のテーブル部分の罫線
                        border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.3))),
                        color: isMonthStart ? Colors.yellow.withOpacity(0.1) : Colors.transparent,
                      ),
                      child: Text(value, style: const TextStyle(fontSize: 10)),
                    );
                  },

                  /// 右側のヘッダーの装飾
                  headerDecoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),

                  /// 右側のテーブルセルの装飾
                  bodyCellDecoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2))),

                  onControllerReady: (FlexibleTableController ctl) => _tableCtl = ctl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  String getDisplayValue({required MapEntry<String, MoneyModel> entries, required int colIndex}) {
    switch (colIndex) {
      case 0:
        return entries.value.yen10000;
      case 1:
        return entries.value.yen5000;
      case 2:
        return entries.value.yen2000;
      case 3:
        return entries.value.yen1000;
      case 4:
        return entries.value.yen500;
      case 5:
        return entries.value.yen100;
      case 6:
        return entries.value.yen50;
      case 7:
        return entries.value.yen10;
      case 8:
        return entries.value.yen5;
      case 9:
        return entries.value.yen1;

      case 10:
        return entries.value.bankA.toCurrency();
      case 11:
        return entries.value.bankB.toCurrency();
      case 12:
        return entries.value.bankC.toCurrency();
      case 13:
        return entries.value.bankD.toCurrency();
      case 14:
        return entries.value.bankE.toCurrency();

      case 15:
        return entries.value.payA.toCurrency();
      case 16:
        return entries.value.payB.toCurrency();
      case 17:
        return entries.value.payC.toCurrency();
      case 18:
        return entries.value.payD.toCurrency();
      case 19:
        return entries.value.payE.toCurrency();
      case 20:
        return entries.value.payF.toCurrency();
    }

    return '';
  }
}

//////////////////////////////////////////////////////////////////////////////////////
