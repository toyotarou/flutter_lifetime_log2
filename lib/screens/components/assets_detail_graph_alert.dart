import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/stock_model.dart';
import '../../models/toushi_shintaku_model.dart';
import '../../utility/utility.dart';
import '../parts/lifetime_dialog.dart';
import 'assets_detail_list_alert.dart';

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

  List<Color> twentyFourColor = <Color>[];

  List<String> toushiGraphSelectYearList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    twentyFourColor = utility.getTwentyFourColor();
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
                  children: <Widget>[Text(widget.date), Text(widget.title)],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                if (widget.title != 'gold') ...<Widget>[
                  Expanded(child: displayAssetsNameList()),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox.shrink(),
                      GestureDetector(
                        onTap: () {
                          appParamNotifier.setSelectedToushiGraphItemName(name: '');

                          appParamNotifier.setSelectedToushiGraphYear(year: '');
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ],

                SizedBox(
                  height: (widget.title == 'gold') ? context.screenSize.height * 0.7 : context.screenSize.height * 0.5,
                  child: Stack(
                    children: <Widget>[
                      LineChart(graphData2),
                      LineChart(graphData),

                      Positioned(
                        top: 5,
                        right: 5,
                        left: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const SizedBox.shrink(),
                                Text('last date: $lastAssetsDate', style: const TextStyle(color: Colors.greenAccent)),
                              ],
                            ),

                            selectedToushiGraphYearParts(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget selectedToushiGraphYearParts() {
    if (widget.title == 'stock' || widget.title == 'toushiShintaku') {
      if (appParamState.selectedToushiGraphItemName == '') {
        return const SizedBox.shrink();
      }
    }

    final List<String> yList = toushiGraphSelectYearList.toSet().toList();

    yList.sort();

    final List<String> yearList = <String>['', ...yList];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: yearList.map((String e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () => appParamNotifier.setSelectedToushiGraphYear(year: e),
                  child: CircleAvatar(
                    radius: 15,

                    backgroundColor: (appParamState.selectedToushiGraphYear == e)
                        ? Colors.yellowAccent.withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.8),

                    child: Text(e, style: const TextStyle(fontSize: 10)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  ///
  void setChartData() {
    flspotsList.clear();

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
          bool flag = true;

          if (appParamState.selectedToushiGraphItemName != '') {
            if (appParamState.selectedToushiGraphItemName != key) {
              flag = false;
            }
          }

          if (flag) {
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
          }
        });

      case 'toushiShintaku':
        appParamState.keepToushiShintakuRelationalMap.forEach((int key, List<ToushiShintakuModel> value) {
          bool flag = true;

          if (appParamState.selectedToushiGraphItemName != '') {
            if (appParamState.selectedToushiGraphItemName != key.toString()) {
              flag = false;
            }
          }

          if (flag) {
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
            if (int.tryParse(value.goldValue.toString()) != null && int.tryParse(value.payPrice.toString()) != null) {
              final int pos = dateList.indexWhere((String element2) => element2 == key);

              final double onedata = (value.goldValue.toString().toInt() - value.payPrice.toString().toInt())
                  .toDouble();

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
            bool flag = true;

            if (appParamState.selectedToushiGraphItemName != '') {
              if (appParamState.selectedToushiGraphItemName != element2.ticker) {
                flag = false;
              }
            }

            if (appParamState.selectedToushiGraphYear != '') {
              if (appParamState.selectedToushiGraphYear != element2.year) {
                flag = false;
              }
            }

            if (flag) {
              final String jikaHyoukagaku = element2.jikaHyoukagaku.replaceAll(',', '');

              final String heikinShutokuKagaku = element2.heikinShutokuKagaku.replaceAll(',', '');

              if (int.tryParse(jikaHyoukagaku) != null && double.tryParse(heikinShutokuKagaku) != null) {
                final int pos = dateList.indexWhere(
                  (String element3) => element3 == '${element2.year}-${element2.month}-${element2.day}',
                );

                final double diff = jikaHyoukagaku.toInt() - (element2.hoyuuSuuryou * heikinShutokuKagaku.toDouble());

                flspots.add(FlSpot(pos.toDouble(), diff));

                list.add(diff.toInt());

                (dateMaxValueMapData[pos] ??= <int>[]).add(diff.toInt());

                lastDate = '${element2.year}-${element2.month}-${element2.day}';
              }
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
              bool flag = true;

              if (appParamState.selectedToushiGraphItemName != '') {
                if (appParamState.selectedToushiGraphItemName != element2.relationalId.toString()) {
                  flag = false;
                }
              }

              if (appParamState.selectedToushiGraphYear != '') {
                if (appParamState.selectedToushiGraphYear != element2.year) {
                  flag = false;
                }
              }

              if (flag) {
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

                  final double diff = (jikaHyoukagaku.toInt() - shutokuSougaku.toInt()).toDouble();

                  flspots.add(FlSpot(pos.toDouble(), diff));

                  list.add(diff.toInt());

                  (dateMaxValueMapData[pos] ??= <int>[]).add(diff.toInt());

                  lastDate = '${element2.year}-${element2.month}-${element2.day}';
                }
              }
            });

            if (flspots.isNotEmpty) {
              flspotsList.add(flspots);
            }
          });
    }

    setState(() {
      lastAssetsDate = lastDate;
    });

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
                final String date = dateList[element.x.toInt()];

                final int? maxPrice = dateMaxValueMap[element.x.toInt()];
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
          getDrawingVerticalLine: (double value) {
            final String date = dateList[value.toInt()];

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
              barWidth: 1,
              isStrokeCapRound: true,

              color: (widget.title == 'gold' || appParamState.selectedToushiGraphItemName != '')
                  ? Colors.white.withValues(alpha: 0.5)
                  : twentyFourColor[i % 24],

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
    }
  }

  ///
  Widget displayAssetsNameList() {
    final List<Widget> list = <Widget>[];

    int i = 0;

    switch (widget.title) {
      case 'gold':
        break;
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
              diff = jikaHyoukagaku.toDouble().toInt() - element2.hoyuuSuuryou * heikinShutokuKagaku.toDouble();
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
                          onTap: () => appParamNotifier.setSelectedToushiGraphItemName(name: element2.ticker),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: (appParamState.selectedToushiGraphItemName == element2.ticker)
                                ? Colors.white.withValues(alpha: 0.4)
                                : twentyFourColor[i % 24].withValues(alpha: 0.3),
                          ),
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
                diff = jikaHyoukagaku.toDouble().toInt() - shutokuSougaku.toInt().toDouble();
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
                            onTap: () =>
                                appParamNotifier.setSelectedToushiGraphItemName(name: element2.relationalId.toString()),
                            child: CircleAvatar(
                              radius: 15,

                              backgroundColor:
                                  (appParamState.selectedToushiGraphItemName == element2.relationalId.toString())
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : twentyFourColor[i % 24].withValues(alpha: 0.3),
                            ),
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
}
