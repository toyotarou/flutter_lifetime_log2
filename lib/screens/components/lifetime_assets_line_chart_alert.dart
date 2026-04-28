import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/scroll_line_chart_model.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';

class LifetimeAssetsLineChartAlert extends ConsumerStatefulWidget {
  const LifetimeAssetsLineChartAlert({super.key});

  @override
  ConsumerState<LifetimeAssetsLineChartAlert> createState() => _LifetimeAssetsLineChartAlertState();
}

class _LifetimeAssetsLineChartAlertState extends ConsumerState<LifetimeAssetsLineChartAlert>
    with ControllersMixin<LifetimeAssetsLineChartAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];
  List<FlSpot> _shintakuFlspots = <FlSpot>[];
  List<FlSpot> _stockFlspots = <FlSpot>[];
  List<FlSpot> _goldFlspots = <FlSpot>[];
  List<FlSpot> _insuranceFlspots = <FlSpot>[];
  List<FlSpot> _nenkinFlspots = <FlSpot>[];

  int graphMax = 0;
  List<String> _dateList = <String>[];

  final TransformationController _transformationController = TransformationController();
  bool _zoomMode = false;
  bool _showPointLabels = false;
  Map<int, int> _millionCrossings = <int, int>{};

  // insurance: 2023-01-01時点で102回払いずみ → 102ヶ月前 = 2014-07スタート
  static final DateTime _insuranceStart = DateTime(2014, 7);

  // nenkin: 2023-01-01時点で32回払いずみ → 32ヶ月前 = 2020-05スタート
  static final DateTime _nenkinStart = DateTime(2020, 5);

  static final DateTime _shintakuStart = DateTime(2022);
  static final DateTime _stockStart = DateTime(2022);

  ///
  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
  }

  ///
  void _onTransformChanged() {
    if (!_zoomMode) {
      return;
    }
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    final bool shouldShow = scale >= 3.0;
    if (shouldShow != _showPointLabels) {
      setState(() => _showPointLabels = shouldShow);
    }
  }

  ///
  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Lifetime Assets Evolution'),
                  Row(
                    children: <Widget>[
                      if (_zoomMode)
                        IconButton(
                          onPressed: () => setState(() {
                            _transformationController.value = Matrix4.identity();
                          }),
                          icon: const Icon(Icons.lock_reset),
                        ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _zoomMode = !_zoomMode;
                            if (!_zoomMode) {
                              _transformationController.value = Matrix4.identity();
                            }
                          });
                        },
                        icon: Icon(Icons.expand, color: _zoomMode ? Colors.yellowAccent : Colors.white),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              Expanded(
                child: _flspots.isEmpty
                    ? const Center(child: Text('No data'))
                    : _zoomMode
                    ? InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 1.0,
                        maxScale: 10.0,
                        child: AbsorbPointer(
                          child: Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
                        ),
                      )
                    : Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
              ),

              const SizedBox(height: 10),

              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 11),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'money',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'shintaku',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'stock',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'gold',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'insurance',
                      style: TextStyle(color: Color(0xFFEA80FC)),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'nenkin',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _setChartData() {
    // keepToushiShintakuMap → 年月キーで集約
    final Map<String, int> shintakuMap = <String, int>{};
    appParamState.keepToushiShintakuMap.forEach((String date, List<ToushiShintakuModel> list) {
      if (date.length < 7) {
        return;
      }
      final String ym = date.substring(0, 7);
      final int sum = list.fold(0, (int acc, ToushiShintakuModel m) {
        if (m.jikaHyoukagaku == '-') {
          return acc;
        }
        return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
      });
      if (sum > 0) {
        shintakuMap[ym] = sum;
      }
    });

    // keepStockMap → 年月キーで最新値を集約
    final Map<String, int> stockMap = <String, int>{};
    appParamState.keepStockMap.forEach((String date, List<StockModel> list) {
      if (date.length < 7) {
        return;
      }
      final String ym = date.substring(0, 7);
      final int sum = list.fold(0, (int acc, StockModel m) {
        if (m.jikaHyoukagaku == '-') {
          return acc;
        }
        return acc + m.jikaHyoukagaku.replaceAll(',', '').replaceAll('円', '').trim().toInt();
      });
      if (sum > 0) {
        stockMap[ym] = sum;
      }
    });

    // keepGoldMap → 年月キーで最新値を集約
    final Map<String, int> goldMap = <String, int>{};
    appParamState.keepGoldMap.forEach((String date, GoldModel model) {
      if (date.length < 7) {
        return;
      }
      final String ym = date.substring(0, 7);
      final String val = model.goldValue.toString();
      if (val != '-' && val.isNotEmpty) {
        final int? parsed = int.tryParse(val.replaceAll(',', '').replaceAll('円', '').trim());
        if (parsed != null && parsed > 0) {
          goldMap[ym] = parsed;
        }
      }
    });

    _dateList = <String>[];
    _flspots = <FlSpot>[];
    _shintakuFlspots = <FlSpot>[];
    _stockFlspots = <FlSpot>[];
    _goldFlspots = <FlSpot>[];
    _insuranceFlspots = <FlSpot>[];
    _nenkinFlspots = <FlSpot>[];

    int prevShintaku = 0;
    int prevStock = 0;
    int prevGold = 0;

    // keepMoneySumList を頭から順番にそのまま使う
    for (int idx = 0; idx < appParamState.keepMoneySumList.length; idx++) {
      final ScrollLineChartModel m = appParamState.keepMoneySumList[idx];
      final String date = m.date;
      final String ym = date.substring(0, 7);
      final DateTime d = DateTime.parse(date);

      _dateList.add(date);
      _flspots.add(FlSpot(idx.toDouble(), m.sum.toDouble()));

      // shintaku: 開始月以降のみ spot を追加（それ以前は spot なし → 0線が出ない）
      if (!d.isBefore(_shintakuStart)) {
        if (shintakuMap.containsKey(ym)) {
          prevShintaku = shintakuMap[ym]!;
        }
        _shintakuFlspots.add(FlSpot(idx.toDouble(), prevShintaku.toDouble()));
      }

      // stock: 開始月以降のみ spot を追加
      if (!d.isBefore(_stockStart)) {
        if (stockMap.containsKey(ym)) {
          prevStock = stockMap[ym]!;
        }
        _stockFlspots.add(FlSpot(idx.toDouble(), prevStock.toDouble()));
      }

      // gold: 初データ取得後のみ spot を追加
      if (goldMap.containsKey(ym)) {
        prevGold = goldMap[ym]!;
      }
      if (prevGold > 0) {
        _goldFlspots.add(FlSpot(idx.toDouble(), prevGold.toDouble()));
      }

      // insurance: 開始月以降のみ spot を追加（支払い累計額）
      if (!d.isBefore(_insuranceStart)) {
        final int insuranceMonths = (d.year - _insuranceStart.year) * 12 + (d.month - _insuranceStart.month);
        _insuranceFlspots.add(FlSpot(idx.toDouble(), (insuranceMonths * 55880).toDouble()));
      }

      // nenkin: 開始月以降のみ spot を追加（支払い累計額）
      if (!d.isBefore(_nenkinStart)) {
        final int nenkinMonths = (d.year - _nenkinStart.year) * 12 + (d.month - _nenkinStart.month);
        _nenkinFlspots.add(FlSpot(idx.toDouble(), (nenkinMonths * 26625).toDouble()));
      }
    }

    // 合計額で初めて各百万円を超えたインデックスを検出（過去最高を更新した時のみ）
    _millionCrossings = <int, int>{};
    final Map<int, double> shintakuByIdx = <int, double>{for (final FlSpot s in _shintakuFlspots) s.x.toInt(): s.y};
    final Map<int, double> stockByIdx = <int, double>{for (final FlSpot s in _stockFlspots) s.x.toInt(): s.y};
    final Map<int, double> goldByIdx = <int, double>{for (final FlSpot s in _goldFlspots) s.x.toInt(): s.y};
    final Map<int, double> insuranceByIdx = <int, double>{for (final FlSpot s in _insuranceFlspots) s.x.toInt(): s.y};
    final Map<int, double> nenkinByIdx = <int, double>{for (final FlSpot s in _nenkinFlspots) s.x.toInt(): s.y};

    int maxMillionSeen = _flspots.isEmpty
        ? 0
        : (_flspots[0].y +
                      (shintakuByIdx[0] ?? 0) +
                      (stockByIdx[0] ?? 0) +
                      (goldByIdx[0] ?? 0) +
                      (insuranceByIdx[0] ?? 0) +
                      (nenkinByIdx[0] ?? 0))
                  .floor() ~/
              1000000;
    for (int i = 1; i < _flspots.length; i++) {
      final int curr =
          (_flspots[i].y +
                  (shintakuByIdx[i] ?? 0) +
                  (stockByIdx[i] ?? 0) +
                  (goldByIdx[i] ?? 0) +
                  (insuranceByIdx[i] ?? 0) +
                  (nenkinByIdx[i] ?? 0))
              .floor() ~/
          1000000;
      if (curr > maxMillionSeen) {
        _millionCrossings[i] = curr;
        maxMillionSeen = curr;
      }
    }

    // graphMax を実データから算出
    final List<double> allVals = <double>[
      ..._flspots.map((FlSpot s) => s.y),
      ..._shintakuFlspots.map((FlSpot s) => s.y),
      ..._stockFlspots.map((FlSpot s) => s.y),
      ..._goldFlspots.map((FlSpot s) => s.y),
      ..._insuranceFlspots.map((FlSpot s) => s.y),
      ..._nenkinFlspots.map((FlSpot s) => s.y),
    ];

    if (allVals.isNotEmpty) {
      final double maxVal = allVals.reduce((double a, double b) => a > b ? a : b);
      graphMax = ((maxVal / 1000000).ceil() + 1) * 1000000;
      if (graphMax < 15000000) {
        graphMax = 15000000;
      }
    }

    if (_flspots.isNotEmpty) {
      // 奇数年の背景を薄黄色にする
      final List<VerticalRangeAnnotation> yearAnnotations = <VerticalRangeAnnotation>[];
      for (int y = 2014; y <= DateTime.now().year; y++) {
        if (y.isOdd) {
          int? firstIdx;
          int? lastIdx;
          for (int i = 0; i < _dateList.length; i++) {
            if (int.tryParse(_dateList[i].substring(0, 4)) == y) {
              firstIdx ??= i;
              lastIdx = i;
            }
          }
          if (firstIdx != null && lastIdx != null) {
            yearAnnotations.add(
              VerticalRangeAnnotation(
                x1: firstIdx.toDouble(),
                x2: lastIdx.toDouble(),
                color: Colors.yellowAccent.withValues(alpha: 0.05),
              ),
            );
          }
        }
      }

      graphData = LineChartData(
        minX: 0,
        maxX: _flspots.length.toDouble() - 1,
        minY: 0,
        maxY: graphMax.toDouble(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              String date = '';
              int moneyVal = 0, shintakuVal = 0, stockVal = 0, goldVal = 0, insuranceVal = 0, nenkinVal = 0;

              for (final LineBarSpot s in touchedSpots) {
                final int x = s.x.toInt();
                if (x >= 0 && x < _dateList.length) {
                  date = _dateList[x];
                }
                switch (s.barIndex) {
                  case 0:
                    moneyVal = s.y.round();
                  case 1:
                    shintakuVal = s.y.round();
                  case 2:
                    stockVal = s.y.round();
                  case 3:
                    goldVal = s.y.round();
                  case 4:
                    insuranceVal = s.y.round();
                  case 5:
                    nenkinVal = s.y.round();
                }
              }

              final int total = moneyVal + shintakuVal + stockVal + goldVal + insuranceVal + nenkinVal;

              return touchedSpots.map((LineBarSpot s) {
                if (s.barIndex != 0) {
                  return null;
                }
                return LineTooltipItem(
                  '$date\n',
                  const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  children: <TextSpan>[
                    const TextSpan(
                      text: '──────────\n',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: '${moneyVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '${shintakuVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                    TextSpan(
                      text: '${goldVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.lightBlueAccent),
                    ),
                    TextSpan(
                      text: '${stockVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: '${insuranceVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Color(0xFFEA80FC)),
                    ),
                    TextSpan(
                      text: '${nenkinVal.toString().toCurrency()}\n',
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                    const TextSpan(
                      text: '──────────\n',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: total.toString().toCurrency(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingVerticalLine: (double value) {
            final int idx = value.toInt();
            if (idx < 0 || idx >= _dateList.length) {
              return const FlLine(color: Colors.transparent, strokeWidth: 1);
            }
            if (_dateList[idx].substring(5, 7) == '01') {
              return FlLine(color: const Color(0xFFFBB6CE).withOpacity(0.05), strokeWidth: 1);
            }
            return const FlLine(color: Colors.transparent, strokeWidth: 1);
          },
        ),
        rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: yearAnnotations),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: _flspots,
            color: Colors.white,
            barWidth: 1,
            dotData: FlDotData(
              getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
                if (!_showPointLabels || !_millionCrossings.containsKey(index)) {
                  return FlDotCirclePainter(radius: 0, color: Colors.transparent, strokeColor: Colors.transparent);
                }
                final String date = index < _dateList.length ? _dateList[index] : '';
                return _MilestoneDotPainter(
                  millionLevel: _millionCrossings[index]!,
                  date: date,
                  totalSpots: _flspots.length,
                );
              },
            ),
          ),
          LineChartBarData(
            spots: _shintakuFlspots,
            color: Colors.yellowAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _stockFlspots,
            color: Colors.greenAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _goldFlspots,
            color: Colors.lightBlueAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _insuranceFlspots,
            color: const Color(0xFFEA80FC),
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _nenkinFlspots,
            color: Colors.orangeAccent,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      );

      graphData2 = LineChartData(
        minX: 0,
        maxX: _flspots.length.toDouble() - 1,
        minY: 0,
        maxY: graphMax.toDouble(),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          bottomTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMax) {
                  return const SizedBox();
                }
                return SideTitleWidget(
                  space: 4,
                  axisSide: AxisSide.left,
                  child: Text(value.toInt().toString().toCurrency(), style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMax) {
                  return const SizedBox();
                }
                return SideTitleWidget(
                  space: 4,
                  axisSide: AxisSide.right,
                  child: Text(value.toInt().toString().toCurrency(), style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineBarsData: <LineChartBarData>[],
      );
    }
  }
}

///
class _MilestoneDotPainter extends FlDotPainter {
  _MilestoneDotPainter({required this.millionLevel, required this.date, required this.totalSpots});

  final int millionLevel;
  final String date;
  final int totalSpots;

  String get _milestoneText => '$millionLevel百万円';

  @override
  Color get mainColor => const Color(0xFF1B5E20);

  @override
  List<Object?> get props => <Object?>[millionLevel, date, totalSpots];

  @override
  void draw(Canvas canvas, FlSpot spot, Offset center) {
    const double padding = 0.5;
    const double cornerRadius = 1.2;

    final TextPainter tp = TextPainter(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '$date\n',
            style: const TextStyle(color: Colors.white, fontSize: 1.6),
          ),
          TextSpan(
            text: _milestoneText,
            style: const TextStyle(color: Colors.white, fontSize: 1.6, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final double w = tp.width + padding * 2;
    final double h = tp.height + padding * 2;

    // 右端に近い場合はバッジを左寄せにして見切れを防ぐ
    final bool nearRightEdge = totalSpots > 0 && spot.x / totalSpots > 0.75;
    final double badgeCenterX = nearRightEdge ? center.dx - w / 2 : center.dx;

    final Rect rect = Rect.fromCenter(center: Offset(badgeCenterX, center.dy - h / 2 - 3), width: w, height: h);
    final RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(cornerRadius));

    canvas.drawRRect(rRect, Paint()..color = const Color(0xFF1B5E20).withOpacity(0.9));
    tp.paint(canvas, Offset(rect.left + padding, rect.top + padding));

    canvas.drawCircle(center, 1.2, Paint()..color = const Color(0xFF1B5E20));
  }

  @override
  Size getSize(FlSpot spot) => const Size(28, 16);

  @override
  bool hitTest(FlSpot spot, Offset touched, Offset center, double extraThreshold) =>
      (touched - center).distance <= 3 + extraThreshold;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;
}
