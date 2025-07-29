import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';

class SpendDateInputAlert extends ConsumerStatefulWidget {
  const SpendDateInputAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<SpendDateInputAlert> createState() => _SpendInputAlertState();
}

class _SpendInputAlertState extends ConsumerState<SpendDateInputAlert> with ControllersMixin<SpendDateInputAlert> {
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
                          onPressed: () {
                            _inputSpendData();
                          },

                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                          child: const Text('input'),
                        ),
                      ],
                    ),

                    Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

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
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    final List<String> dropDownItemName = <String>[];

    dropDownItemName.addAll(getItemName());

    for (int i = 0; i < priceTecs.length; i++) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _showDP(pos: i);
                                },
                                child: Icon(Icons.calendar_month, color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(spendInputState.inputDateList[i])),
                            ],
                          ),
                        ),

                        Row(
                          children: <Widget>[
                            ChoiceChip(
                              label: const Text('daily', style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.black.withValues(alpha: 0.1),
                              selectedColor: Colors.greenAccent.withValues(alpha: 0.4),
                              selected: spendInputState.inputKindList[i] == 'daily',
                              onSelected: (bool isSelected) async {
                                spendInputNotifier.setInputKindList(pos: i, kind: 'daily');
                              },
                              showCheckmark: false,
                            ),
                            ChoiceChip(
                              label: const Text('credit', style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.black.withValues(alpha: 0.1),
                              selectedColor: Colors.greenAccent.withValues(alpha: 0.4),
                              selected: spendInputState.inputKindList[i] == 'credit',
                              onSelected: (bool isSelected) async {
                                spendInputNotifier.setInputKindList(pos: i, kind: 'credit');
                              },
                              showCheckmark: false,
                            ),
                          ],
                        ),
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
                            value: spendInputState.inputItemList[i],
                            onChanged: (String? value) =>
                                spendInputNotifier.setInputItemList(pos: i, item: value ?? ''),
                            items: dropDownItemName.map((String e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e, style: const TextStyle(fontSize: 12)),
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
                            onChanged: (String value) => spendInputNotifier.setInputValueList(pos: i, value: value),
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

  List<String> getItemName() {
    final List<String> list = <String>[];

    const String str = '''
    食費
    牛乳代
    弁当代
    住居費
    交通費
    支払い
    credit
    遊興費
    ジム会費
    お賽銭
    交際費
    雑費
    教育費
    機材費
    被服費
    医療費
    美容費
    通信費
    保険料
    水道光熱費
    共済代
    投資
    アイアールシー
    手数料
    不明
    メルカリ
    利息
    プラス
    所得税
    住民税
    年金
    国民年金基金
    国民健康保険
    ''';

    final List<String> exStr = str.split('\n');

    for (final String element in exStr) {
      if (element != '') {
        list.add(element.trim());
      }
    }

    return list;
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
      spendInputNotifier.setInputDateList(pos: pos, date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _inputSpendData() async {
    bool errFlg = false;

    final List<Map<String, dynamic>> insertDataDaily = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> insertDataCredit = <Map<String, dynamic>>[];

    for (int i = 0; i < priceTecs.length; i++) {
      if (spendInputState.inputDateList[i] != '' &&
          spendInputState.inputItemList[i] != '' &&
          spendInputState.inputValueList[i] != '' &&
          spendInputState.inputKindList[i] != '') {
        if (spendInputState.inputKindList[i] == 'daily') {
          insertDataDaily.add(<String, dynamic>{
            'date': spendInputState.inputDateList[i],
            'koumoku': spendInputState.inputItemList[i],
            'price': spendInputState.inputValueList[i],
          });
        } else if (spendInputState.inputKindList[i] == 'credit') {
          insertDataCredit.add(<String, dynamic>{
            'date': spendInputState.inputDateList[i],
            'item': spendInputState.inputItemList[i],
            'price': spendInputState.inputValueList[i],
          });
        }
      }
    }

    if (insertDataDaily.isEmpty || insertDataCredit.isEmpty) {
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

    if (insertDataDaily.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      insertDataDaily.forEach((Map<String, dynamic> element) async {
        await spendInputNotifier.insertDataDaily(insertData: element);
      });
    }

    if (insertDataCredit.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      insertDataCredit.forEach((Map<String, dynamic> element) async {
        await spendInputNotifier.insertDataCredit(insertData: element);
      });
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
