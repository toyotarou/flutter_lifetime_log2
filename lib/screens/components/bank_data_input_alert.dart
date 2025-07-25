import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../utility/utility.dart';

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

  ///
  @override
  void initState() {
    super.initState();

    for (int i = 0; i <= 23; i++) {
      dateTecs.add(TextEditingController(text: ''));
      bankTecs.add(TextEditingController(text: ''));
      priceTecs.add(TextEditingController(text: ''));
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('BankDataInputAlert'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                _displayInputParts(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),

                    TextButton(
                      onPressed: () => _inputBankData(),
                      child: const Text('データを登録する', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
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

    final List<Map<String, String>> dropDownBankName = <Map<String, String>>[
      <String, String>{'': ''},
      ...utility.getBankName().entries.map((MapEntry<String, String> e) => <String, String>{e.key: e.value}),
    ];

    for (int i = 0; i < bankTecs.length; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  lifetimeInputNotifier.setItemPos(pos: i);
                },
                child: CircleAvatar(
                  backgroundColor: (i == lifetimeInputState.itemPos)
                      ? Colors.yellowAccent.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),
                  child: Text(i.toString().padLeft(2, '0'), style: const TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: <Widget>[
                    IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(bankInputState.inputDateList[i])),
                  ],
                ),
              ),

              const SizedBox(width: 10),
              // ignore: always_specify_types
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                  iconEnabledColor: Colors.white,
                  value: bankInputState.inputBankList[i],
                  onChanged: (String? value) => bankInputNotifier.setInputBankList(pos: i, bank: value ?? ''),
                  items: dropDownBankName.map((Map<String, String> e) {
                    final MapEntry<String, String> entry = e.entries.first;
                    return DropdownMenuItem<String>(value: entry.key, child: Text(entry.value));
                  }).toList(),
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 12),

                  controller: priceTecs[i],
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Future<void> _inputBankData() async {}
}
