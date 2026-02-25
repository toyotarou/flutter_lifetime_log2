import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';

class WeeklyAssetsAverageDisplayAlert extends ConsumerStatefulWidget {
  const WeeklyAssetsAverageDisplayAlert({super.key, required this.weeklyAverageMap});

  final Map<String, int> weeklyAverageMap;

  @override
  ConsumerState<WeeklyAssetsAverageDisplayAlert> createState() => _WeeklyAssetsDiffDisplayAlertState();
}

class _WeeklyAssetsDiffDisplayAlertState extends ConsumerState<WeeklyAssetsAverageDisplayAlert> {
  late final ScrollController _scrollController;

  static const double _moveAmount = 18;
  static const int _tickMs = 16;

  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    _scrollController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('weekly average'), SizedBox.shrink()],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /// 一気ボタン / s
                    Row(
                      children: <Widget>[
                        IconButton(
                          tooltip: '一気に下',
                          onPressed: () {
                            if (!_scrollController.hasClients) {
                              return;
                            }

                            final double max = _scrollController.position.maxScrollExtent;
                            _scrollController.jumpTo(max);
                          },
                          icon: const Icon(Icons.vertical_align_bottom, color: Colors.white70),
                        ),
                        IconButton(
                          tooltip: '一気に上',
                          onPressed: () {
                            if (!_scrollController.hasClients) {
                              return;
                            }

                            _scrollController.jumpTo(0.0);
                          },
                          icon: const Icon(Icons.vertical_align_top, color: Colors.white70),
                        ),
                      ],
                    ),

                    /// 一気ボタン / e

                    /// 押しっぱなしボタン / s
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (_) {
                            if (widget.weeklyAverageMap.isEmpty) {
                              return;
                            }
                            _startRepeating(() => _scrollBy(_moveAmount));
                          },
                          onTapUp: (_) => _stopRepeating(),
                          onTapCancel: _stopRepeating,
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(child: Icon(Icons.arrow_downward, color: Colors.white70)),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (_) {
                            if (widget.weeklyAverageMap.isEmpty) {
                              return;
                            }
                            _startRepeating(() => _scrollBy(-_moveAmount));
                          },
                          onTapUp: (_) => _stopRepeating(),
                          onTapCancel: _stopRepeating,
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(child: Icon(Icons.arrow_upward, color: Colors.white70)),
                          ),
                        ),
                      ],
                    ),

                    /// 押しっぱなしボタン / e
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Expanded(child: displayAssetsWeeklyAverageList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayAssetsWeeklyAverageList() {
    final List<Widget> list = <Widget>[];

    widget.weeklyAverageMap.forEach((String key, int value) {
      list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(key), Text(value.toString().toCurrency())],
            ),
          ),
        ),
      );
    });

    return CustomScrollView(
      controller: _scrollController,
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
  void _startRepeating(VoidCallback action) {
    _repeatTimer?.cancel();

    action();

    _repeatTimer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) => action());
  }

  ///
  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  ///
  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) {
      return;
    }

    final ScrollPosition pos = _scrollController.position;
    final double newOffset = (_scrollController.offset + delta).clamp(0.0, pos.maxScrollExtent);

    _scrollController.jumpTo(newOffset);
  }
}
