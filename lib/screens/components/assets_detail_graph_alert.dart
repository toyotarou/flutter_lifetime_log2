import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/scroll_line_chart_model.dart';
import '../../models/common/scroll_line_chart_y_axis_range_model.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/functions.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import '../parts/scroll_line_chart.dart';
import 'assets_detail_list_alert.dart';
import 'assets_detail_percent_display_alert.dart';

class AssetsDetailGraphAlert extends ConsumerStatefulWidget {
  const AssetsDetailGraphAlert({super.key, required this.date, required this.title});

  final String date;
  final String title;

  @override
  ConsumerState<AssetsDetailGraphAlert> createState() => _AssetsDetailGraphAlertState();
}

class _AssetsDetailGraphAlertState extends ConsumerState<AssetsDetailGraphAlert>
    with ControllersMixin<AssetsDetailGraphAlert> {
  List<List<FlSpot>> flspotsList = <List<FlSpot>>[];

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  int graphMin = 0;
  int graphMax = 0;

  Utility utility = Utility();

  String lastAssetsDate = '';

  List<Color> fortyEightColor = <Color>[];

  List<String> toushiGraphSelectYearList = <String>[];

  final TransformationController transformationController = TransformationController();

  bool zoomMode = false;
  double _currentScale = 1.0;

  ///
  @override
  void initState() {
    super.initState();

    fortyEightColor = utility.getFortyEightColor();
    transformationController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  ///
  void _onTransformChanged() {
    if (!zoomMode) {
      return;
    }
    final double scale = transformationController.value.getMaxScaleOnAxis();
    if (scale != _currentScale) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    setChartData();

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
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(widget.title), const SizedBox(height: 5), Text(widget.date)],
                    ),

                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            appParamNotifier.setIsShowAssetsDetailGraph(flag: !appParamState.isShowAssetsDetailGraph);
                          },
                          child: const Icon(Icons.check_box_outline_blank),
                        ),

                        const SizedBox(width: 20),

                        GestureDetector(
                          onTap: () {
                            LifetimeDialog(
                              context: context,
                              widget: AssetsDetailPercentDisplayAlert(
                                title: widget.title,
                                goldMap: appParamState.keepGoldMap,
                                stockTickerMap: appParamState.keepStockTickerMap,
                                toushiShintakuRelationalMap: appParamState.keepToushiShintakuRelationalMap,
                              ),
                            );
                          },
                          child: const Icon(Icons.list),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Expanded(child: displayAssetsNameList()),

                if (appParamState.isShowAssetsDetailGraph) ...<Widget>[
                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                  SizedBox(
                    height: (widget.title == 'gold')
                        ? context.screenSize.height * 0.65
                        : (widget.title == 'stock')
                        ? context.screenSize.height * 0.5
                        : context.screenSize.height * 0.4,
                    child: Stack(
                      children: <Widget>[
                        if (zoomMode)
                          InteractiveViewer(
                            transformationController: transformationController,

                            panEnabled: zoomMode,
                            scaleEnabled: zoomMode,

                            minScale: 1.0,
                            maxScale: 10.0,

                            child: AbsorbPointer(
                              child: Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
                            ),
                          )
                        else
                          Stack(children: <Widget>[LineChart(graphData2), LineChart(graphData)]),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void setChartData() {
    flspotsList.clear();
    toushiGraphSelectYearList.clear();

    List<String> dateList = <String>[];

    switch (widget.title) {
      case 'gold':
        appParamState.keepGoldMap.forEach((String key, GoldModel value) {
          bool flag = true;

          if (appParamState.selectedToushiGraphYear != '') {
            if (appParamState.selectedToushiGraphYear != value.year) {
              flag = false;
            }
          }

          if (flag) {
            dateList.add(key);
          }

          toushiGraphSelectYearList.add(value.year);
        });
      case 'stock':
        appParamState.keepStockTickerMap.forEach((String key, List<StockModel> value) {
          for (final StockModel element in value) {
            bool flag2 = true;
            if (appParamState.selectedToushiGraphYear != '') {
              if (appParamState.selectedToushiGraphYear != element.year) {
                flag2 = false;
              }
            }

            if (flag2) {
              dateList.add('${element.year}-${element.month}-${element.day}');
            }

            toushiGraphSelectYearList.add(element.year);
          }
        });

      case 'toushiShintaku':
        appParamState.keepToushiShintakuRelationalMap.forEach((int key, List<ToushiShintakuModel> value) {
          for (final ToushiShintakuModel element in value) {
            bool flag2 = true;
            if (appParamState.selectedToushiGraphYear != '') {
              if (appParamState.selectedToushiGraphYear != element.year) {
                flag2 = false;
              }
            }

            if (flag2) {
              dateList.add('${element.year}-${element.month}-${element.day}');
            }

            toushiGraphSelectYearList.add(element.year);
          }
        });
    }

    dateList = dateList.toSet().toList();
    dateList.sort();

    final List<String> eachMonthStartDateList = <String>[];

    String keepYearmonth = '';
    for (final String element in dateList) {
      if (keepYearmonth != '${element.split('-')[0]}-${element.split('-')[1]}') {
        eachMonthStartDateList.add(element);
      }

      keepYearmonth = '${element.split('-')[0]}-${element.split('-')[1]}';
    }

    final List<int> list = <int>[];

    final Map<int, List<int>> dateMaxValueMapData = <int, List<int>>{};

    String lastDate = '';

    switch (widget.title) {
      case 'gold':
        final List<FlSpot> flspots = <FlSpot>[];
        appParamState.keepGoldMap.forEach((String key, GoldModel value) {
          bool flag = true;

          if (appParamState.selectedToushiGraphYear != '') {
            if (appParamState.selectedToushiGraphYear != value.year) {
              flag = false;
            }
          }

          if (flag) {
            final int? goldValue = _tryParseIntValue(value.goldValue.toString());
            final int? payPrice = _tryParseIntValue(value.payPrice.toString());

            if (goldValue != null && payPrice != null) {
              final int pos = dateList.indexWhere((String element2) => element2 == key);
              if (pos < 0) {
                return;
              }

              final double onedata = (goldValue - payPrice).toDouble();

              flspots.add(FlSpot(pos.toDouble(), onedata));

              list.add(onedata.toInt());

              (dateMaxValueMapData[pos] ??= <int>[]).add(onedata.toInt());

              lastDate = key;
            }
          }
        });

        if (flspots.isNotEmpty) {
          flspotsList.add(flspots);
        }

      case 'stock':
        flspotsList.clear();

        for (final String element in <String>['EPI', 'INFY', 'JMIA']) {
          final List<FlSpot> flspots = <FlSpot>[];
          appParamState.keepStockTickerMap[element]?.forEach((StockModel element2) {
            final String jikaHyoukagaku = element2.jikaHyoukagaku.replaceAll(',', '');

            final String heikinShutokuKagaku = element2.heikinShutokuKagaku.replaceAll(',', '');

            if (int.tryParse(jikaHyoukagaku) != null && double.tryParse(heikinShutokuKagaku) != null) {
              final int pos = dateList.indexWhere(
                (String element3) => element3 == '${element2.year}-${element2.month}-${element2.day}',
              );
              if (pos < 0) {
                return;
              }

              final double? jika = _tryParseDoubleValue(jikaHyoukagaku);
              final double? heikin = _tryParseDoubleValue(heikinShutokuKagaku);
              if (jika == null || heikin == null) {
                return;
              }
              final double diff = jika - (element2.hoyuuSuuryou * heikin);

              flspots.add(FlSpot(pos.toDouble(), diff));

              list.add(diff.toInt());

              (dateMaxValueMapData[pos] ??= <int>[]).add(diff.toInt());

              lastDate = '${element2.year}-${element2.month}-${element2.day}';
            }
          });

          if (flspots.isNotEmpty) {
            flspotsList.add(flspots);
          }
        }

      case 'toushiShintaku':
        flspotsList.clear();

        final List<int> relationalIdList = <int>[];

        appParamState.keepToushiShintakuRelationalMap.forEach((int key, List<ToushiShintakuModel> value) {
          relationalIdList.add(key);
        });

        relationalIdList
          ..sort((int a, int b) => a.compareTo(b))
          ..forEach((int element) {
            final List<FlSpot> flspots = <FlSpot>[];
            appParamState.keepToushiShintakuRelationalMap[element]?.forEach((ToushiShintakuModel element2) {
              final String jikaHyoukagaku = element2.jikaHyoukagaku
                  .replaceAll(',', '')
                  .replaceAll(',', '')
                  .replaceAll('円', '')
                  .trim();

              final String shutokuSougaku = element2.shutokuSougaku.replaceAll(',', '').replaceAll('円', '').trim();

              if (int.tryParse(jikaHyoukagaku) != null && int.tryParse(shutokuSougaku) != null) {
                final int pos = dateList.indexWhere(
                  (String element3) => element3 == '${element2.year}-${element2.month}-${element2.day}',
                );
                if (pos < 0) {
                  return;
                }

                final int? jika = _tryParseIntValue(jikaHyoukagaku);
                final int? shutoku = _tryParseIntValue(shutokuSougaku);
                if (jika == null || shutoku == null) {
                  return;
                }
                final double diff = (jika - shutoku).toDouble();

                flspots.add(FlSpot(pos.toDouble(), diff));

                list.add(diff.toInt());

                (dateMaxValueMapData[pos] ??= <int>[]).add(diff.toInt());

                lastDate = '${element2.year}-${element2.month}-${element2.day}';
              }
            });

            if (flspots.isNotEmpty) {
              flspotsList.add(flspots);
            }
          });
    }

    lastAssetsDate = lastDate;

    if (dateList.isEmpty) {
      graphData = LineChartData();
      graphData2 = LineChartData();
      return;
    }

    if (list.isNotEmpty) {
      final int warisuu = (widget.title == 'stock') ? 10000 : 50000;

      final int minValue = list.reduce(min);
      final int maxValue = list.reduce(max);

      graphMin = ((minValue / warisuu).floor()) * warisuu;
      graphMax = ((maxValue / warisuu).ceil()) * warisuu;

      final Map<int, int> dateMaxValueMap = <int, int>{};

      dateMaxValueMapData.forEach((int key, List<int> value) => dateMaxValueMap[key] = value.reduce(max));

      graphData = LineChartData(
        ///
        minX: 1,
        maxX: dateList.length.toDouble(),
        //
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        ///
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              final List<LineTooltipItem> list = <LineTooltipItem>[];

              final List<String> toolTipDisplayValue = <String>[];

              for (final LineBarSpot element in touchedSpots) {
                final int x = element.x.toInt();
                if (x < 0 || x >= dateList.length) {
                  continue;
                }
                final String date = dateList[x];

                final int? maxPrice = dateMaxValueMap[x];
                if (element.y.toInt() == maxPrice) {
                  toolTipDisplayValue.add(date);
                }

                final String price = element.y.toInt().toString().toCurrency();

                toolTipDisplayValue.add(price);

                list.add(
                  LineTooltipItem(
                    toolTipDisplayValue.join('\n'),
                    TextStyle(
                      color: (element.y < 0) ? const Color(0xFFFBB6CE) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                );

                toolTipDisplayValue.clear();
              }

              return list;
            },
          ),
        ),

        ///
        gridData: FlGridData(
          verticalInterval: 1,

          getDrawingHorizontalLine: (double value) {
            return FlLine(
              color: (value == 0.0) ? Colors.greenAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
              strokeWidth: (value == 0.0) ? 3 : 1,
            );
          },

          getDrawingVerticalLine: (double value) {
            final int idx = value.toInt();
            if (idx < 0 || idx >= dateList.length) {
              return const FlLine(color: Colors.transparent);
            }
            final String date = dateList[idx];

            return FlLine(
              color: (eachMonthStartDateList.contains(date))
                  ? Colors.yellowAccent.withOpacity(0.1)
                  : Colors.transparent,
            );
          },
        ),

        ///
        titlesData: const FlTitlesData(show: false),

        ///
        borderData: FlBorderData(show: false),

        ///
        lineBarsData: <LineChartBarData>[
          for (int i = 0; i < flspotsList.length; i++)
            LineChartBarData(
              spots: flspotsList[i],
              barWidth: 1.0 / _currentScale,
              isStrokeCapRound: true,
              color: _colorAt(i),
              dotData: const FlDotData(show: false),
            ),
        ],
      );

      graphData2 = LineChartData(
        ///
        minX: 1,
        maxX: dateList.length.toDouble(),
        //
        minY: graphMin.toDouble(),
        maxY: graphMax.toDouble(),

        borderData: FlBorderData(show: false),

        ///
        lineTouchData: const LineTouchData(enabled: false),

        ///
        gridData: const FlGridData(show: false),

        ///
        titlesData: FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: const AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: const AxisTitles(),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMin || value == graphMax) {
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
          //-------------------------// 左側の目盛り

          //-------------------------// 右側の目盛り
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == graphMin || value == graphMax) {
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
          //-------------------------// 右側の目盛り
        ),

        ///
        lineBarsData: <LineChartBarData>[],
      );
    } else {
      graphData = LineChartData();
      graphData2 = LineChartData();
    }
  }

  ///
  Widget displayAssetsNameList() {
    final List<Widget> list = <Widget>[];

    int i = 0;

    switch (widget.title) {
      case 'gold':
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  final List<ScrollLineChartModel> scrollLineChartModelList = <ScrollLineChartModel>[];

                  if (appParamState.keepGoldMap.isNotEmpty) {
                    final List<String> sortedKeys = appParamState.keepGoldMap.keys.toList()
                      ..sort((String a, String b) {
                        final DateTime? dateA = _tryParseDate(a);
                        final DateTime? dateB = _tryParseDate(b);
                        if (dateA == null && dateB == null) {
                          return a.compareTo(b);
                        }
                        if (dateA == null) {
                          return -1;
                        }
                        if (dateB == null) {
                          return 1;
                        }
                        return dateA.compareTo(dateB);
                      });

                    if (sortedKeys.isNotEmpty) {
                      final List<int> sumList = <int>[];

                      for (final String key3 in sortedKeys) {
                        final GoldModel? value3 = appParamState.keepGoldMap[key3];
                        if (value3 == null) {
                          continue;
                        }

                        if (value3.goldValue != '-' && value3.goldPrice != '-') {
                          final int? goldValue = _tryParseIntValue(value3.goldValue.toString());
                          final int? payPrice = _tryParseIntValue(value3.payPrice.toString());
                          if (goldValue == null || payPrice == null) {
                            continue;
                          }
                          final int sum = goldValue - payPrice;

                          scrollLineChartModelList.add(ScrollLineChartModel(date: key3, sum: sum));

                          sumList.add(sum);
                        }
                      }

                      if (sumList.isEmpty || scrollLineChartModelList.isEmpty) {
                        return;
                      }

                      final ScrollLineChartYAxisRangeModel yAxisRange = calcYAxisRange(
                        minValue: sumList.reduce(min).toDouble(),
                        maxValue: sumList.reduce(max).toDouble(),
                      );

                      final DateTime? startDate = _tryParseDate(sortedKeys[0]);
                      if (startDate == null) {
                        return;
                      }

                      LifetimeDialog(
                        context: context,
                        widget: ScrollLineChart(
                          name: 'gold',
                          startDate: startDate,
                          windowDays: 35,
                          pixelsPerDay: 16.0,
                          fixedMinY: yAxisRange.min,
                          fixedMaxY: yAxisRange.max,
                          fixedIntervalY: yAxisRange.interval,
                          seed: DateTime.now().year,
                          labelShowScaleThreshold: 3.0,
                          scrollLineChartModelList: scrollLineChartModelList,
                        ),
                      );
                    }
                  }
                },
                child: CircleAvatar(radius: 15, backgroundColor: _colorAt(0).withValues(alpha: 0.3)),
              ),

              const SizedBox.shrink(),
            ],
          ),
        );

      case 'stock':
        final Map<String, int> lastDiffMap = <String, int>{};
        final Map<String, String> lastDateMap = <String, String>{};

        for (final String element in <String>['EPI', 'INFY', 'JMIA']) {
          double diff = 0;
          String date = '';

          appParamState.keepStockTickerMap[element]?.forEach((StockModel element2) {
            final String jikaHyoukagaku = element2.jikaHyoukagaku.replaceAll(',', '');
            final String heikinShutokuKagaku = element2.heikinShutokuKagaku.replaceAll(',', '');
            if (int.tryParse(jikaHyoukagaku) != null && double.tryParse(heikinShutokuKagaku) != null) {
              final double? jika = _tryParseDoubleValue(jikaHyoukagaku);
              final double? heikin = _tryParseDoubleValue(heikinShutokuKagaku);
              if (jika == null || heikin == null) {
                return;
              }
              diff = jika.toInt() - element2.hoyuuSuuryou * heikin;
              date = '${element2.year}-${element2.month}-${element2.day}';
            }
          });

          lastDiffMap[element] = diff.toInt();
          lastDateMap[element] = date;
        }

        final List<String> tickerList = <String>[];
        for (final String element in <String>['EPI', 'INFY', 'JMIA']) {
          String name = '';
          appParamState.keepStockTickerMap[element]?.forEach((StockModel element2) {
            if (!tickerList.contains(element2.ticker)) {
              if (element2.name != '') {
                name = element2.name;
              }

              list.add(
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: context.screenSize.height / 15),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                    ),
                    padding: const EdgeInsets.all(5),

                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            final List<ScrollLineChartModel> scrollLineChartModelList = <ScrollLineChartModel>[];

                            final List<StockModel>? sorted = appParamState.keepStockTickerMap[element2.ticker]
                              ?..sort(
                                (StockModel a, StockModel b) =>
                                    '${a.year}-${a.month}-${a.day}'.compareTo('${b.year}-${b.month}-${b.day}'),
                              );

                            if (sorted != null) {
                              final List<int> sumList = <int>[];

                              for (final StockModel element3 in sorted) {
                                final int hoyuuSuuryou = element3.hoyuuSuuryou;
                                final double? heikinShutokuKagaku = _tryParseDoubleValue(element3.heikinShutokuKagaku);
                                final double? jikaHyoukagaku = _tryParseDoubleValue(element3.jikaHyoukagaku);
                                if (heikinShutokuKagaku == null || jikaHyoukagaku == null) {
                                  continue;
                                }

                                final int sum = (jikaHyoukagaku - (heikinShutokuKagaku * hoyuuSuuryou)).toInt();

                                scrollLineChartModelList.add(
                                  ScrollLineChartModel(
                                    date: '${element3.year}-${element3.month}-${element3.day}',
                                    sum: sum,
                                  ),
                                );

                                sumList.add(sum);
                              }

                              if (sumList.isEmpty || scrollLineChartModelList.isEmpty) {
                                return;
                              }

                              final ScrollLineChartYAxisRangeModel yAxisRange = calcYAxisRange(
                                minValue: sumList.reduce(min).toDouble(),
                                maxValue: sumList.reduce(max).toDouble(),
                              );

                              final DateTime? startDate = _tryParseDate(
                                '${sorted[0].year}-${sorted[0].month}-${sorted[0].day}',
                              );
                              if (startDate == null) {
                                return;
                              }

                              LifetimeDialog(
                                context: context,

                                widget: ScrollLineChart(
                                  name: '[${element2.ticker}] ${element2.name}',
                                  startDate: startDate,
                                  windowDays: 35,
                                  pixelsPerDay: 16.0,
                                  fixedMinY: yAxisRange.min,
                                  fixedMaxY: yAxisRange.max,
                                  fixedIntervalY: yAxisRange.interval,
                                  seed: DateTime.now().year,
                                  labelShowScaleThreshold: 3.0,
                                  scrollLineChartModelList: scrollLineChartModelList,
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(radius: 15, backgroundColor: _colorAt(i).withValues(alpha: 0.3)),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: DefaultTextStyle(
                            style: const TextStyle(fontSize: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(element2.name),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const SizedBox.shrink(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text((lastDiffMap[element] ?? 0).toString().toCurrency()),
                                        Text(lastDateMap[element] ?? ''),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        GestureDetector(
                          onTap: () => LifetimeDialog(
                            context: context,
                            widget: AssetsDetailListAlert(title: widget.title, item: element2.ticker, name: name),
                          ),

                          child: Icon(Icons.list, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            tickerList.add(element2.ticker);
          });

          i++;
        }

      case 'toushiShintaku':
        final List<int> relationalIdList = <int>[];

        appParamState.keepToushiShintakuRelationalMap.forEach((int key, List<ToushiShintakuModel> value) {
          relationalIdList.add(key);
        });

        final Map<int, int> lastDiffMap = <int, int>{};
        final Map<int, String> lastDateMap = <int, String>{};

        relationalIdList
          ..sort((int a, int b) => a.compareTo(b))
          ..forEach((int element) {
            double diff = 0;
            String date = '';

            appParamState.keepToushiShintakuRelationalMap[element]?.forEach((ToushiShintakuModel element2) {
              final String jikaHyoukagaku = element2.jikaHyoukagaku
                  .replaceAll(',', '')
                  .replaceAll(',', '')
                  .replaceAll('円', '')
                  .trim();

              final String shutokuSougaku = element2.shutokuSougaku.replaceAll(',', '').replaceAll('円', '').trim();

              if (int.tryParse(jikaHyoukagaku) != null && int.tryParse(shutokuSougaku) != null) {
                final int? jika = _tryParseIntValue(jikaHyoukagaku);
                final int? shutoku = _tryParseIntValue(shutokuSougaku);
                if (jika == null || shutoku == null) {
                  return;
                }
                diff = jika.toDouble() - shutoku.toDouble();
                date = '${element2.year}-${element2.month}-${element2.day}';
              }
            });

            lastDiffMap[element] = diff.toInt();
            lastDateMap[element] = date;
          });

        final List<int> relIdList = <int>[];
        relationalIdList
          ..sort((int a, int b) => a.compareTo(b))
          ..forEach((int element) {
            String name = '';
            appParamState.keepToushiShintakuRelationalMap[element]?.forEach((ToushiShintakuModel element2) {
              if (!relIdList.contains(element2.relationalId)) {
                if (element2.name != '') {
                  name = element2.name;
                }

                list.add(
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: context.screenSize.height / 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                      ),
                      padding: const EdgeInsets.all(5),

                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              final List<ScrollLineChartModel> scrollLineChartModelList = <ScrollLineChartModel>[];

                              final List<ToushiShintakuModel>? sorted =
                                  appParamState.keepToushiShintakuRelationalMap[element2.relationalId]?..sort(
                                    (ToushiShintakuModel a, ToushiShintakuModel b) =>
                                        '${a.year}-${a.month}-${a.day}'.compareTo('${b.year}-${b.month}-${b.day}'),
                                  );

                              if (sorted != null) {
                                final List<int> sumList = <int>[];

                                for (final ToushiShintakuModel element3 in sorted) {
                                  final int? shutokuSougaku = _tryParseIntValue(element3.shutokuSougaku);
                                  final int? jikaHyoukagaku = _tryParseIntValue(element3.jikaHyoukagaku);
                                  if (shutokuSougaku == null || jikaHyoukagaku == null) {
                                    continue;
                                  }

                                  final int sum = jikaHyoukagaku - shutokuSougaku;

                                  scrollLineChartModelList.add(
                                    ScrollLineChartModel(
                                      date: '${element3.year}-${element3.month}-${element3.day}',
                                      sum: sum,
                                    ),
                                  );

                                  sumList.add(sum);
                                }

                                if (sumList.isEmpty || scrollLineChartModelList.isEmpty) {
                                  return;
                                }

                                final ScrollLineChartYAxisRangeModel yAxisRange = calcYAxisRange(
                                  minValue: sumList.reduce(min).toDouble(),
                                  maxValue: sumList.reduce(max).toDouble(),
                                );

                                final DateTime? startDate = _tryParseDate(
                                  '${sorted[0].year}-${sorted[0].month}-${sorted[0].day}',
                                );
                                if (startDate == null) {
                                  return;
                                }

                                LifetimeDialog(
                                  context: context,
                                  widget: ScrollLineChart(
                                    name: '[${element2.relationalId}] ${element2.name}',
                                    startDate: startDate,
                                    windowDays: 35,
                                    pixelsPerDay: 16.0,
                                    fixedMinY: yAxisRange.min,
                                    fixedMaxY: yAxisRange.max,
                                    fixedIntervalY: yAxisRange.interval,
                                    seed: DateTime.now().year,
                                    labelShowScaleThreshold: 3.0,
                                    scrollLineChartModelList: scrollLineChartModelList,
                                  ),
                                );
                              }
                            },
                            child: CircleAvatar(radius: 15, backgroundColor: _colorAt(i).withValues(alpha: 0.3)),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: DefaultTextStyle(
                              style: const TextStyle(fontSize: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(element2.name),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const SizedBox.shrink(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            (lastDiffMap[element] ?? 0).toString().toCurrency(),

                                            style: TextStyle(
                                              color: ((lastDiffMap[element] ?? 0) > 100000)
                                                  ? Colors.yellowAccent
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(lastDateMap[element] ?? ''),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          GestureDetector(
                            onTap: () => LifetimeDialog(
                              context: context,
                              widget: AssetsDetailListAlert(
                                title: widget.title,
                                item: element2.relationalId.toString(),
                                name: name,
                              ),
                            ),

                            child: Icon(Icons.list, color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              relIdList.add(element2.relationalId);
            });

            i++;
          });
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
  double makeFixedY({required List<int> sumList}) {
    final int minSum = sumList.reduce(min);
    final int maxSum = sumList.reduce(max);

    final int diff = maxSum - minSum;

    switch (diff.toString().length) {
      case 6:
        return 1000000;

      default:
        return 100000;
    }
  }

  ///
  int? _tryParseIntValue(String raw) {
    final String normalized = raw.replaceAll(',', '').replaceAll('円', '').trim();
    return int.tryParse(normalized);
  }

  ///
  double? _tryParseDoubleValue(String raw) {
    final String normalized = raw.replaceAll(',', '').replaceAll('円', '').trim();
    return double.tryParse(normalized);
  }

  ///
  DateTime? _tryParseDate(String ymd) => DateTime.tryParse(ymd);

  ///
  Color _colorAt(int index) {
    if (fortyEightColor.isEmpty) {
      return Colors.white;
    }
    return fortyEightColor[index % fortyEightColor.length];
  }
}
