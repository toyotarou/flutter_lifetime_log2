import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class MetroStamp20AnniversaryInfoDisplayAlert extends ConsumerStatefulWidget {
  const MetroStamp20AnniversaryInfoDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<MetroStamp20AnniversaryInfoDisplayAlert> createState() =>
      _MetroStamp20AnniversaryInfoDisplayAlertState();
}

class _MetroStamp20AnniversaryInfoDisplayAlertState extends ConsumerState<MetroStamp20AnniversaryInfoDisplayAlert>
    with ControllersMixin<MetroStamp20AnniversaryInfoDisplayAlert> {
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
                  children: <Widget>[Text('metro 20 anniversary stamp rally'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                // Expanded(child: displayAmazonPurchaseList()),
                //
                //
                //
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
