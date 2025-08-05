import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../main.dart';
import '../parts/error_dialog.dart';

class StockDataInputAlert extends ConsumerStatefulWidget {
  const StockDataInputAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<StockDataInputAlert> createState() => _StockDataInputAlertState();
}

class _StockDataInputAlertState extends ConsumerState<StockDataInputAlert> with ControllersMixin<StockDataInputAlert> {
  TextEditingController tickerEPIEditingController = TextEditingController();
  TextEditingController tickerINFYEditingController = TextEditingController();
  TextEditingController tickerJMIAEditingController = TextEditingController();

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.date), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                _displayInputParts(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),

                    TextButton(
                      onPressed: () => _inputStockData(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('EPI : ウィズダムツリー インド株収益ファンド'),

                const SizedBox(height: 5),

                TextField(
                  keyboardType: TextInputType.number,
                  controller: tickerEPIEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'EPI : ウィズダムツリー インド株収益ファンド',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[0],
                  onTap: () => context.showKeyboard(focusNodeList[0]),
                ),

                const SizedBox(height: 20),

                const Text('INFY : インフォシス・テクノロジーズ'),

                const SizedBox(height: 5),

                TextField(
                  keyboardType: TextInputType.number,
                  controller: tickerINFYEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'INFY : インフォシス・テクノロジーズ',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[1],
                  onTap: () => context.showKeyboard(focusNodeList[1]),
                ),

                const SizedBox(height: 20),

                const Text('JMIA : ジュミア・テクノロジーズ'),

                const SizedBox(height: 5),

                TextField(
                  keyboardType: TextInputType.number,
                  controller: tickerJMIAEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintText: 'JMIA : ジュミア・テクノロジーズ',
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  ),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                  focusNode: focusNodeList[2],
                  onTap: () => context.showKeyboard(focusNodeList[2]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputStockData() async {
    bool errFlg = false;

    if (tickerEPIEditingController.text.trim() == '' ||
        tickerINFYEditingController.text.trim() == '' ||
        tickerJMIAEditingController.text.trim() == '') {
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

    await stockInputNotifier
        .inputStockRecord(
          date: widget.date,
          data: <String, String>{
            'EPI': tickerEPIEditingController.text.trim(),
            'INFY': tickerINFYEditingController.text.trim(),
            'JMIA': tickerJMIAEditingController.text.trim(),
          },
        )
        // ignore: always_specify_types
        .then((value) {
          if (mounted) {
            context.findAncestorStateOfType<AppRootState>()?.restartApp();
          }
        });
  }
}
