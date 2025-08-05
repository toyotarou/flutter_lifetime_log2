import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class StockDataInputAlert extends ConsumerStatefulWidget {
  const StockDataInputAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<StockDataInputAlert> createState() => _StockDataInputAlertState();
}

class _StockDataInputAlertState extends ConsumerState<StockDataInputAlert> with ControllersMixin<StockDataInputAlert> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(widget.date), const SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
