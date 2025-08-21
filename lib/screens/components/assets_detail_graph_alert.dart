import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/gold_model.dart';
import '../../models/invest_model.dart';
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
                      GestureDetector(onTap: () {}, child: const Icon(Icons.close)),
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
                        child: Text('last date: $lastAssetsDate', style: const TextStyle(color: Colors.greenAccent)),
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
  void setChartData() {
    flspotsList.clear();

    List<String> dateList = <String>[];

    /*








    @Default(<String, GoldModel>{}) Map<String, GoldModel> keepGoldMap,
    @Default(<String, List<StockModel>>{}) Map<String, List<StockModel>> keepStockMap,
    @Default(<String, List<ToushiShintakuModel>>{}) Map<String, List<ToushiShintakuModel>> keepToushiShintakuMap,



          map['${val.year}-${val.month}-${val.day}'] = val;
  GoldModel({
    required this.year,
    required this.month,
    required this.day,
    required this.goldTanka,
    required this.upDown,
    required this.diff,
    required this.gramNum,
    required this.totalGram,
    required this.goldValue,
    required this.goldPrice,
    required this.payPrice,
  });


          (map['${val.year}-${val.month}-${val.day}'] ??= <StockModel>[]).add(val);
  StockModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.ticker,
    required this.name,
    required this.hoyuuSuuryou,
    required this.heikinShutokuKagaku,
    required this.jikaHyoukagaku,
  });


          (map['${val.year}-${val.month}-${val.day}'] ??= <ToushiShintakuModel>[]).add(val);
  ToushiShintakuModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.name,
    required this.shutokuSougaku,
    required this.jikaHyoukagaku,
    required this.relationalId,
    required this.hoyuuSuuryou,
  });







  FundModel({required this.name, required this.relationalId, required this.record});
  FundRecordModel({
    required this.date,
    required this.basePrice,
    required this.compareFront,
    required this.yearlyReturn,
    required this.flag,
  });



          (map2[val.relationalId.toInt()] ??= <FundModel>[]).add(val);

    @Default(<int, List<FundModel>>{}) Map<int, List<FundModel>> keepFundRelationMap,










    if (widget.title == 'gold') {
      appParamState.keepInvestRecordMap[0]?.forEach((InvestRecordModel element2) {
        dateList.add(element2.date);
      });
    } else {
      String roopTitle = widget.title;
      if (widget.title == 'toushiShintaku') {
        roopTitle = 'shintaku';
      }

      appParamState.keepInvestNamesMap[roopTitle]
        ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
        ..sort((InvestNameModel a, InvestNameModel b) => a.relationalId.compareTo(b.relationalId))
        ..forEach((InvestNameModel element) {
                                                      bool flag = true;

                                                      if (appParamState.selectedGraphInvestNameModel != null) {
                                                        if (appParamState.selectedGraphInvestNameModel != element) {
                                                          flag = false;
                                                        }
                                                      }

                                                      if (flag) {
                                                        appParamState.keepInvestRecordMap[element.relationalId]?.forEach((InvestRecordModel element2) {
                                                          dateList.add(element2.date);
                                                        });
                                                      }
        });
    }








    */

    switch (widget.title) {
      case 'gold':
        appParamState.keepGoldMap.forEach((String key, GoldModel value) => dateList.add(key));
      case 'stock':
        appParamState.keepStockMap.forEach((String key, List<StockModel> value) {
          dateList.add(key);
        });
      case 'toushiShintaku':
        appParamState.keepToushiShintakuMap.forEach((String key, List<ToushiShintakuModel> value) {
          dateList.add(key);
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
          if (int.tryParse(value.goldValue.toString()) != null && int.tryParse(value.payPrice.toString()) != null) {
            final int pos = dateList.indexWhere((String element2) => element2 == key);

            final double onedata = (value.goldValue.toString().toInt() - value.payPrice.toString().toInt()).toDouble();

            flspots.add(FlSpot(pos.toDouble(), onedata));

            list.add(onedata.toInt());

            (dateMaxValueMapData[pos] ??= <int>[]).add(onedata.toInt());

            lastDate = key;
          }
        });

        if (flspots.isNotEmpty) {
          flspotsList.add(flspots);
        }

      case 'stock':
        flspotsList.clear();

        /*



      appParamState.keepInvestNamesMap[roopTitle]
        ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
        ..sort((InvestNameModel a, InvestNameModel b) => a.dealNumber.compareTo(b.dealNumber))
        ..forEach((InvestNameModel element) {
          bool flag = true;

          if (appParamState.selectedGraphInvestNameModel != null) {
            if (appParamState.selectedGraphInvestNameModel != element) {
              flag = false;
            }
          }

          if (flag) {
            final List<FlSpot> flspots = <FlSpot>[];
            appParamState.keepInvestRecordMap[element.relationalId]?.forEach((InvestRecordModel element2) {
              final int pos = dateList.indexWhere((String element) => element == element2.date);

              flspots.add(FlSpot(pos.toDouble(), (element2.price - element2.cost).toDouble()));

              list.add(element2.price - element2.cost);

              (dateMaxValueMapData[pos] ??= <int>[]).add(element2.price - element2.cost);

              lastDate = element2.date;
            });

            flspotsList.add(flspots);
          }
        });



        */

        //
        // appParamState.keepStockMap.forEach((String key, List<StockModel> value) {
        //   final List<FlSpot> flspots = <FlSpot>[];
        //
        //   for (final StockModel element in value) {
        //     if (int.tryParse(element.jikaHyoukagaku.replaceAll(',', '')) != null &&
        //         double.tryParse(element.heikinShutokuKagaku.replaceAll(',', '')) != null) {
        //       final int pos = dateList.indexWhere(
        //         (String element2) => element2 == '${element.year}-${element.month}-${element.day}',
        //       );
        //
        //       final double onedata =
        //           element.jikaHyoukagaku.replaceAll(',', '').toInt() -
        //           (element.hoyuuSuuryou * element.heikinShutokuKagaku.replaceAll(',', '').toDouble());
        //
        //       flspots.add(FlSpot(pos.toDouble(), onedata));
        //
        //       list.add(onedata.toInt());
        //
        //       (dateMaxValueMapData[pos] ??= <int>[]).add(onedata.toInt());
        //
        //       lastDate = '${element.year}-${element.month}-${element.day}';
        //     }
        //   }
        //
        //   if (flspots.isNotEmpty) {
        //     flspotsList.add(flspots);
        //   }
        // });
        //
        //
        //

        break;

      case 'toushiShintaku':
        flspotsList.clear();

        // appParamState.keepToushiShintakuMap.forEach((String key, List<ToushiShintakuModel> value) {
        //   final List<FlSpot> flspots = <FlSpot>[];
        //   for (final ToushiShintakuModel element in value) {
        //     if (int.tryParse(
        //               element.jikaHyoukagaku.replaceAll(',', '').replaceAll(',', '').replaceAll('円', '').trim(),
        //             ) !=
        //             null &&
        //         int.tryParse(element.shutokuSougaku) != null) {
        //       final int pos = dateList.indexWhere(
        //         (String element2) => element2 == '${element.year}-${element.month}-${element.day}',
        //       );
        //
        //       final double onedata =
        //           (element.jikaHyoukagaku.replaceAll(',', '').replaceAll(',', '').replaceAll('円', '').trim().toInt() -
        //                   element.shutokuSougaku.toInt())
        //               .toDouble();
        //
        //       flspots.add(FlSpot(pos.toDouble(), onedata));
        //
        //       list.add(onedata.toInt());
        //
        //       (dateMaxValueMapData[pos] ??= <int>[]).add(onedata.toInt());
        //
        //       lastDate = '${element.year}-${element.month}-${element.day}';
        //     }
        //   }
        //
        //   if (flspots.isNotEmpty) {
        //     flspotsList.add(flspots);
        //   }
        // });
        //
        //
        //

        break;
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

      final List<Color> twelveColor = utility.getTwelveColor();

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

              // color: (appParamState.selectedGraphInvestNameModel != null || widget.title == 'gold')
              //     ? Colors.white.withValues(alpha: 0.5)
              //     : twelveColor[i % 12],
              //
              //
              //
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

    final List<Color> twelveColor = utility.getTwelveColor();

    /*






    if (widget.title == 'gold') {
    } else {
      String roopTitle = widget.title;
      if (widget.title == 'toushiShintaku') {
        roopTitle = 'shintaku';
      }

      appParamState.keepInvestNamesMap[roopTitle]
        ?..sort((InvestNameModel a, InvestNameModel b) => a.frame.compareTo(b.frame))
        ..sort((InvestNameModel a, InvestNameModel b) => a.dealNumber.compareTo(b.dealNumber))
        ..forEach((InvestNameModel element) {
          int lastDiff = 0;

          if (appParamState.keepInvestRecordMap[element.relationalId] != null) {
            final InvestRecordModel last = appParamState.keepInvestRecordMap[element.relationalId]!.last;

            lastDiff = last.price - last.cost;
          }

          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),

              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => appParamNotifier.setSelectedGraphInvestNameModel(investNameModel: element),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: (appParamState.selectedGraphInvestNameModel == element)
                            ? Colors.white.withValues(alpha: 0.5)
                            : twelveColor[i % 12].withValues(alpha: 0.3),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 70),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(element.frame),
                            Text(element.name),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[const SizedBox.shrink(), Text(lastDiff.toString().toCurrency())],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    GestureDetector(
                      onTap: () {
                        LifetimeDialog(
                          context: context,
                          widget: AssetsDetailListAlert(data: element),
                        );
                      },

                      child: Icon(Icons.list, color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ],
                ),
              ),
            ),
          );

          i++;
        });
    }








    */

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
