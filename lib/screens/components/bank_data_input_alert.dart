import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../models/money_model.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/lifetime_dialog.dart';
import 'bank_price_list_alert.dart';

class BankDataInputAlert extends ConsumerStatefulWidget {
  const BankDataInputAlert({super.key});

  @override
  ConsumerState<BankDataInputAlert> createState() => _BankDataInputAlertState();
}

class _BankDataInputAlertState extends ConsumerState<BankDataInputAlert> with ControllersMixin<BankDataInputAlert> {
  final List<TextEditingController> dateTecs = <TextEditingController>[];
  final List<TextEditingController> bankTecs = <TextEditingController>[];
  final List<TextEditingController> priceTecs = <TextEditingController>[];

  Utility utility = Utility();

  Map<String, String> bankNameMap = <String, String>{};

  List<FocusNode> focusNodeList = <FocusNode>[];

  bool _isLoading = false;

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) {
      dateTecs.add(TextEditingController(text: ''));
      bankTecs.add(TextEditingController(text: ''));
      priceTecs.add(TextEditingController(text: ''));
    }

    bankNameMap = utility.getBankName();

    // ignore: always_specify_types
    focusNodeList = List.generate(10, (int index) => FocusNode());
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: <Widget>[
          SafeArea(
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white, fontSize: 12),

              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('BankDataInputAlert'),
                        ElevatedButton(
                          onPressed: () {
                            _inputBankData();
                          },

                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                          child: const Text('input'),
                        ),
                      ],
                    ),

                    Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                    _displayBankPriceList(),

                    _displayLastPriceBox(),

                    Expanded(child: _displayInputParts()),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading) ...<Widget>[const CircularProgressIndicator()],
        ],
      ),
    );
  }

  ///
  Widget _displayLastPriceBox() {
    final RegExp reg = RegExp('bank');
    final RegExp reg2 = RegExp('pay');

    return ExpansionTile(
      iconColor: Colors.white,

      title: const Text('LAST PRICE', style: TextStyle(fontSize: 10, color: Colors.white)),

      children: <Widget>[
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.5))),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 230),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: bankNameMap.entries.map((MapEntry<String, String> e) {
                      if (reg.firstMatch(e.key) != null) {
                        final List<Map<String, int>>? mapList = moneyState.bankMoneyMap[e.key];
                        if (mapList != null) {
                          // 日付順にソートした新しいリストを作成
                          final List<Map<String, int>> sortedMapList = List<Map<String, int>>.from(mapList)
                            ..sort((Map<String, int> a, Map<String, int> b) {
                              final DateTime dateA = DateTime.parse(a.entries.first.key);
                              final DateTime dateB = DateTime.parse(b.entries.first.key);
                              return dateA.compareTo(dateB); // 昇順
                            });

                          Map<String, int> map = <String, int>{};
                          int keepPrice = 0;

                          for (final Map<String, int> element in sortedMapList) {
                            final MapEntry<String, int> entry = element.entries.first;
                            if (keepPrice != entry.value) {
                              map = element;
                            }
                            keepPrice = entry.value;
                          }
                          final MapEntry<String, int> last1 = map.entries.first;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(e.value),
                                    Text(e.key, style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(last1.value.toString().toCurrency()),
                                    Text(last1.key, style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: bankNameMap.entries.map((MapEntry<String, String> e) {
                      if (reg2.firstMatch(e.key) != null) {
                        final List<Map<String, int>>? mapList = moneyState.bankMoneyMap[e.key];
                        if (mapList != null) {
                          Map<String, int> map = <String, int>{};
                          int keepPrice = 0;
                          for (final Map<String, int> element in mapList) {
                            final MapEntry<String, int> entry = element.entries.first;
                            if (keepPrice != entry.value) {
                              map = element;
                            }
                            keepPrice = entry.value;
                          }
                          final MapEntry<String, int> last1 = map.entries.first;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(e.value),
                                    Text(e.key, style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(last1.value.toString().toCurrency()),
                                    Text(last1.key, style: const TextStyle(fontSize: 8)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  ///
  Widget _displayBankPriceList() {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Row(
          children: utility.getBankName().entries.map((MapEntry<String, String> e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),

              child: GestureDetector(
                onTap: () {
                  bankInputNotifier.setSelectedBankKey(key: e.key);

                  LifetimeDialog(
                    context: context,
                    widget: BankPriceListAlert(bankKey: e.key),
                    clearBarrierColor: true,
                    executeFunctionWhenDialogClose: true,
                    ref: ref,
                    from: 'BankPriceListAlert',
                  );
                },
                child: CircleAvatar(
                  backgroundColor: (e.key == bankInputState.selectedBankKey)
                      ? Colors.yellowAccent.withValues(alpha: 0.4)
                      : Colors.blueGrey.withValues(alpha: 0.4),

                  child: Text(e.key, style: const TextStyle(fontSize: 10)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    final List<Map<String, String>> dropDownBankName = <Map<String, String>>[
      <String, String>{'': ''},
      ...bankNameMap.entries.map((MapEntry<String, String> e) => <String, String>{e.key: e.value}),
    ];

    for (int i = 0; i < bankTecs.length; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),

          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  lifetimeInputNotifier.setItemPos(pos: i);
                },
                child: CircleAvatar(
                  backgroundColor: (i == lifetimeInputState.itemPos)
                      ? Colors.yellowAccent.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showDP(pos: i);
                          },
                          child: Icon(Icons.calendar_month, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(bankInputState.inputDateList[i])),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                            iconEnabledColor: Colors.white,
                            value: bankInputState.inputBankList[i],
                            onChanged: (String? value) => bankInputNotifier.setInputBankList(pos: i, bank: value ?? ''),
                            items: dropDownBankName.map((Map<String, String> e) {
                              final MapEntry<String, String> entry = e.entries.first;
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value, style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 2,
                          child: TextField(
                            style: const TextStyle(fontSize: 12),
                            controller: priceTecs[i],
                            decoration: const InputDecoration(
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String value) => bankInputNotifier.setInputValueList(pos: i, value: value),
                            onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                            focusNode: focusNodeList[i],
                            onTap: () => context.showKeyboard(focusNodeList[i]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
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

  ///
  Future<void> _showDP({required int pos}) async {
    final DateTime? selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      bankInputNotifier.setInputDateList(pos: pos, date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _inputBankData() async {
    bool errFlg = false;

    if (appParamState.keepMoneyMap.isNotEmpty) {
      final MapEntry<String, MoneyModel> lastMoney = appParamState.keepMoneyMap.entries.last;

      for (final String element in bankInputState.inputDateList) {
        if (element != '') {
          if (DateTime(
            element.split('-')[0].toInt(),
            element.split('-')[1].toInt(),
            element.split('-')[2].toInt(),
          ).isAfter(
            DateTime(
              lastMoney.key.split('-')[0].toInt(),
              lastMoney.key.split('-')[1].toInt(),
              lastMoney.key.split('-')[2].toInt(),
            ),
          )) {
            errFlg = true;
          }
        }
      }
    }

    final List<Map<String, dynamic>> uploadDataList = <Map<String, dynamic>>[];

    for (int i = 0; i < bankTecs.length; i++) {
      if (bankInputState.inputDateList[i] != '' &&
          bankInputState.inputBankList[i] != '' &&
          bankInputState.inputValueList[i] != '') {
        uploadDataList.add(<String, dynamic>{
          'date': bankInputState.inputDateList[i],
          'bank': bankInputState.inputBankList[i],
          'price': bankInputState.inputValueList[i],
        });
      }
    }

    if (uploadDataList.isEmpty) {
      errFlg = true;
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
          // ignore: use_build_context_synchronously
          context: context,
          title: '登録できません。',
          content: '値を正しく入力してください。',
        ),
      );

      return;
    }

    setState(() => _isLoading = true);

    for (final Map<String, dynamic> element in uploadDataList) {
      await bankInputNotifier.updateBankMoney(uploadData: element);
    }

    // ignore: always_specify_types
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _isLoading = false);

        context.findAncestorStateOfType<AppRootState>()?.restartApp();
      }
    });
  }
}
