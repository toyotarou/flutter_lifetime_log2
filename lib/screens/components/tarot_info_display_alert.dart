import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tarot_history_model.dart';
import '../../models/tarot_model.dart';

class TarotInfoDisplayAlert extends ConsumerStatefulWidget {
  const TarotInfoDisplayAlert({super.key, this.tarot, this.tarotHistory});

  final TarotModel? tarot;
  final TarotHistoryModel? tarotHistory;

  @override
  ConsumerState<TarotInfoDisplayAlert> createState() => _TarotInfoDisplayAlertState();
}

class _TarotInfoDisplayAlertState extends ConsumerState<TarotInfoDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    if (widget.tarot == null || widget.tarotHistory == null) {
      return const SizedBox.shrink();
    }

    final TarotModel tarot = widget.tarot!;
    final TarotHistoryModel tarotHistory = widget.tarotHistory!;

    final bool isJust = tarotHistory.reverse == '0';
    final int qt = isJust ? 0 : 2;
    final String imageUrl = 'http://toyohide.work/BrainLog/tarotcards/${tarot.image}.jpg';

    final String word = isJust ? tarot.wordJ : tarot.wordR;
    final String msg = isJust ? tarot.msgJ : tarot.msgR;
    final String msg2 = isJust ? tarot.msg2J : tarot.msg2R;
    final String msg3 = isJust ? tarot.msg3J : tarot.msg3R;

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(tarot.name, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(child: Container()),
                RotatedBox(quarterTurns: qt, child: Image.network(imageUrl)),
                Expanded(child: Container()),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(tarot.prof2),
            ),
            const Divider(color: Colors.indigo),
            Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.3)),
              padding: const EdgeInsets.only(left: 10),
              child: Text(isJust ? '正位置' : '逆位置'),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(word, style: const TextStyle(color: Colors.yellowAccent)),
            ),
            Container(padding: const EdgeInsets.all(10), alignment: Alignment.topLeft, child: Text(msg)),
            Container(padding: const EdgeInsets.all(10), child: Text(msg2)),
            Container(padding: const EdgeInsets.all(10), child: Text(msg3)),
          ],
        ),
      ),
    );
  }
}
