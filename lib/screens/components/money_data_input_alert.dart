// ignore_for_file: always_specify_types

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../models/money_model.dart';
import '../parts/lifetime_log_overlay.dart';

class MoneyDataInputAlert extends ConsumerStatefulWidget {
  const MoneyDataInputAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<MoneyDataInputAlert> createState() => _MoneyDataInputAlertState();
}

class _MoneyDataInputAlertState extends ConsumerState<MoneyDataInputAlert> with ControllersMixin<MoneyDataInputAlert> {
  List<String> moneyKind = <String>['10000', '5000', '2000', '1000', '500', '100', '50', '10', '5', '1'];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  final TextEditingController inputDigitsEditingController = TextEditingController();

  MoneyModel? money;

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!moneyInputState.isReplaceInputValueList) {
        List<String> list = List.generate(10, (index) => '');

        var date = '';

        for (var i = 0; i < 7; i++) {
          date = DateTime(
            widget.date.split('-')[0].toInt(),
            widget.date.split('-')[1].toInt(),
            widget.date.split('-')[2].toInt() - i,
          ).yyyymmdd;

          if (appParamState.keepMoneyMap[date] != null) {
            money = appParamState.keepMoneyMap[date];
            break;
          }
        }

        if (money != null) {
          list = [
            money!.yen10000,
            money!.yen5000,
            money!.yen2000,
            money!.yen1000,
            money!.yen500,
            money!.yen100,
            money!.yen50,
            money!.yen10,
            money!.yen5,
            money!.yen1,
          ];
        }

        moneyInputNotifier.setIsReplaceInputValueList(flag: true);
        moneyInputNotifier.setReplaceInputValueListDate(date: date);
        moneyInputNotifier.setReplaceInputValueList(list: list);
      }
    });

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
                  children: <Widget>[
                    Text(widget.date),

                    ElevatedButton(
                      onPressed: () => insertMoneyData(),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('input', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                _displayInputParts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < moneyKind.length; i++) {
      if ((i % 2) == 1) {
        continue;
      }

      final int leftNum = i;
      final int rightNum = i + 1;

      list.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                moneyKind[leftNum],

                style: TextStyle(color: (moneyInputState.pos == leftNum) ? Colors.yellowAccent : Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  moneyInputNotifier.setPos(pos: leftNum);

                  callFirstBox();
                  callSecondBox();
                },

                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),

                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2)),
                  alignment: Alignment.topRight,

                  child: Text(
                    (moneyInputState.inputValueList[leftNum] == '') ? '0' : moneyInputState.inputValueList[leftNum],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                moneyKind[rightNum],

                style: TextStyle(color: (moneyInputState.pos == rightNum) ? Colors.yellowAccent : Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  moneyInputNotifier.setPos(pos: rightNum);

                  callFirstBox();
                  callSecondBox();
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2)),
                  alignment: Alignment.topRight,

                  child: Text(
                    (moneyInputState.inputValueList[rightNum] == '') ? '0' : moneyInputState.inputValueList[rightNum],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      list.add(const SizedBox(height: 10));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),

                    Text(
                      moneyInputState.replaceInputValueListDate,

                      style: TextStyle(
                        color: (moneyInputState.replaceInputValueListDate != widget.date)
                            ? Colors.yellowAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Column(children: list),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void callFirstBox() {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: MediaQuery.of(context).size.width * 0.6,
      height: 210,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(MediaQuery.of(context).size.width * 0.4, 360),

      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text(moneyKind[moneyInputState.pos])),

          DragTarget<String>(
            // ignore: strict_raw_type
            builder: (BuildContext context, List<String?> candidate, List rejected) {
              return TextField(
                controller: inputDigitsEditingController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'ここにカードをドロップ',
                  border: const OutlineInputBorder(),
                  filled: candidate.isNotEmpty,
                  fillColor: candidate.isNotEmpty ? Colors.lightBlue.withValues(alpha: 0.2) : null,
                ),
              );
            },
            onAcceptWithDetails: (DragTargetDetails<String> details) =>
                setState(() => inputDigitsEditingController.text += details.data),
          ),

          const SizedBox(height: 24),

          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    moneyInputNotifier.setInputValueList(value: inputDigitsEditingController.text.trim());

                    inputDigitsEditingController.clear();

                    moneyInputNotifier.setPos(pos: -1);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2)),
                  child: const Text('反映'),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    inputDigitsEditingController.clear();

                    moneyInputNotifier.setPos(pos: -1);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2)),
                  child: const Text('消去'),
                ),
              ),
            ],
          ),
        ],
      ),

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }

  ///
  void callSecondBox() {
    appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

    addSecondOverlay(
      context: context,
      secondEntries: _secondEntries,
      setStateCallback: setState,
      width: context.screenSize.width,
      height: context.screenSize.height * 0.3,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(0, context.screenSize.height * 0.7),

      widget: Wrap(
        alignment: WrapAlignment.center,

        children: List.generate(10, (index) {
          final String digit = index.toString();

          return Draggable<String>(
            data: digit,
            feedback: Material(color: Colors.transparent, child: _buildCard(digit, 0.8)),
            childWhenDragging: _buildCard(digit, 0.3),
            child: _buildCard(digit, 1.0),
          );
        }),
      ),

      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
      fixedFlag: true,
    );
  }

  ///
  Widget _buildCard(String digit, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 50,
        height: 60,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(2, 2)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  ///
  Future<void> insertMoneyData() async {
    final Map<String, dynamic> uploadData = {
      'date': widget.date,

      'yen_10000': (moneyInputState.inputValueList[0] != money?.yen10000)
          ? moneyInputState.inputValueList[0]
          : money?.yen10000,

      'yen_5000': (moneyInputState.inputValueList[1] != money?.yen5000)
          ? moneyInputState.inputValueList[1]
          : money?.yen5000,

      'yen_2000': (moneyInputState.inputValueList[2] != money?.yen2000)
          ? moneyInputState.inputValueList[2]
          : money?.yen2000,

      'yen_1000': (moneyInputState.inputValueList[3] != money?.yen1000)
          ? moneyInputState.inputValueList[3]
          : money?.yen1000,

      'yen_500': (moneyInputState.inputValueList[4] != money?.yen500)
          ? moneyInputState.inputValueList[4]
          : money?.yen500,

      'yen_100': (moneyInputState.inputValueList[5] != money?.yen100)
          ? moneyInputState.inputValueList[5]
          : money?.yen100,

      'yen_50': (moneyInputState.inputValueList[6] != money?.yen50) ? moneyInputState.inputValueList[6] : money?.yen50,

      'yen_10': (moneyInputState.inputValueList[7] != money?.yen10) ? moneyInputState.inputValueList[7] : money?.yen10,

      'yen_5': (moneyInputState.inputValueList[8] != money?.yen5) ? moneyInputState.inputValueList[8] : money?.yen5,

      'yen_1': (moneyInputState.inputValueList[9] != money?.yen1) ? moneyInputState.inputValueList[9] : money?.yen1,

      'bank_a': money?.bankA,
      'bank_b': money?.bankB,
      'bank_c': money?.bankC,
      'bank_d': money?.bankD,
      'bank_e': money?.bankE,

      'pay_a': money?.payA,
      'pay_b': money?.payB,
      'pay_c': money?.payC,
      'pay_d': money?.payD,
      'pay_e': money?.payE,
      'pay_f': money?.payF,
    };

    await moneyInputNotifier.insertMoney(uploadData: uploadData).then((value) {
      if (mounted) {
        context.findAncestorStateOfType<AppRootState>()?.restartApp();
      }
    });
  }
}
