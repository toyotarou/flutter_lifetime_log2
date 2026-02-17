import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/fortune_model.dart';

class FortuneDisplayAlert extends ConsumerStatefulWidget {
  const FortuneDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<FortuneDisplayAlert> createState() => _FortuneDisplayAlertState();
}

class _FortuneDisplayAlertState extends ConsumerState<FortuneDisplayAlert> with ControllersMixin<FortuneDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('leo fortune'), SizedBox.shrink()],
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              Expanded(child: displayFortuneWidget()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayFortuneWidget() {
    if (appParamState.keepFortuneMap[widget.date] == null) {
      return const SizedBox.shrink();
    }

    final FortuneModel? fortune = appParamState.keepFortuneMap[widget.date];

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(widget.date), Text(fortune!.rank)],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.white.withOpacity(0.4), thickness: 3, indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            const Row(
              children: <Widget>[
                Text('恋愛運', style: TextStyle(color: Colors.yellowAccent)),
                SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 10),
            Text(fortune.love),
            const SizedBox(height: 10),
            Divider(color: Colors.white.withOpacity(0.4), indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            const Row(
              children: <Widget>[
                Text('金銭運', style: TextStyle(color: Colors.yellowAccent)),
                SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 10),
            Text(fortune.money),
            const SizedBox(height: 10),
            Divider(color: Colors.white.withOpacity(0.4), indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            const Row(
              children: <Widget>[
                Text('人間関係運', style: TextStyle(color: Colors.yellowAccent)),
                SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 10),
            Text(fortune.relationship),
            const SizedBox(height: 10),
            Divider(color: Colors.white.withOpacity(0.4), indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            const Row(
              children: <Widget>[
                Text('仕事運', style: TextStyle(color: Colors.yellowAccent)),
                SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 10),
            Text(fortune.work),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
