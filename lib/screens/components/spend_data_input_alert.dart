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

          if (_isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
        ],
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    final List<String> dropDownItemName = <String>[''];

    utility.getItemName().forEach((String element) => dropDownItemName.add(element));

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
                      children: <Widget>[
                        ChoiceChip(
                          label: const Text('daily', style: TextStyle(fontSize: 10)),
                          backgroundColor: Colors.black.withOpacity(0.1),
                          selectedColor: Colors.greenAccent.withOpacity(0.2),
                          selected: spendInputState.inputKindList[i] == 'daily',
                          onSelected: (bool isSelected) async =>
                              spendInputNotifier.setInputKindList(pos: i, kind: 'daily'),
                          showCheckmark: false,
                        ),
                        ChoiceChip(
                          label: const Text('credit', style: TextStyle(fontSize: 10)),
                          backgroundColor: Colors.black.withValues(alpha: 0.1),
                          selectedColor: Colors.greenAccent.withValues(alpha: 0.2),
                          selected: spendInputState.inputKindList[i] == 'credit',
                          onSelected: (bool isSelected) async =>
                              spendInputNotifier.setInputKindList(pos: i, kind: 'credit'),
                          showCheckmark: false,
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

  ///
  Future<void> _inputSpendData() async {
    bool errFlg = false;

    final List<Map<String, dynamic>> insertDataDaily = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> insertDataCredit = <Map<String, dynamic>>[];

    for (int i = 0; i < priceTecs.length; i++) {
      if (spendInputState.inputItemList[i] != '' &&
          spendInputState.inputValueList[i] != '' &&
          spendInputState.inputKindList[i] != '') {
        if (spendInputState.inputKindList[i] == 'daily') {
          insertDataDaily.add(<String, dynamic>{
            'date': widget.date,
            'koumoku': spendInputState.inputItemList[i],
            'price': spendInputState.inputValueList[i],
          });
        } else if (spendInputState.inputKindList[i] == 'credit') {
          insertDataCredit.add(<String, dynamic>{
            'date': widget.date,
            'item': spendInputState.inputItemList[i],
            'price': spendInputState.inputValueList[i],
          });
        }
      }
    }

    if (insertDataDaily.isEmpty && insertDataCredit.isEmpty) {
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
