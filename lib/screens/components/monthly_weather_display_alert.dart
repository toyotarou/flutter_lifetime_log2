import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/weather_model.dart';
import '../../utility/functions.dart';

class MonthlyWeatherDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyWeatherDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyWeatherDisplayAlert> createState() => _MonthlyWeatherDisplayAlertState();
}

class _MonthlyWeatherDisplayAlertState extends ConsumerState<MonthlyWeatherDisplayAlert>
    with ControllersMixin<MonthlyWeatherDisplayAlert> {
  static const int _itemCount = 100000;
  static const int _initialIndex = _itemCount ~/ 2;

  static const List<String> _weekLabels = <String>['日', '月', '火', '水', '木', '金', '土'];

  static const Color _sunColor = Color(0xFFFF6666);
  static const Color _satColor = Color(0xFF6699FF);
  static const Color _borderColor = Color(0x22FFFFFF); // 薄い白

  // APIは日本語テキストを返す（例: "晴", "曇時々晴", "雨のち曇"）
  static const Map<String, String> _kanjiToKey = <String, String>{
    '晴': 'sunny',
    '曇': 'cloudy',
    '雨': 'rain',
    '雪': 'snow',
  };

  late final DateTime _baseMonth;

  @override
  void initState() {
    super.initState();
    _baseMonth = DateTime.parse('${widget.yearmonth}-01');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/frame_arrow.png',
              color: Colors.orangeAccent.withValues(alpha: 0.4),
              colorBlendMode: BlendMode.srcIn,
            ),
          ),

          CarouselSlider.builder(
            itemCount: _itemCount,
            initialPage: _initialIndex,
            slideTransform: const CubeTransform(),
            onSlideChanged: (int index) => setState(() {}),
            slideBuilder: (int index) => _buildSlide(index),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(int index) {
    final DateTime genDate = monthForIndex(index: index, baseMonth: _baseMonth);
    final String yearmonth = '${genDate.year.toString().padLeft(4, '0')}-${genDate.month.toString().padLeft(2, '0')}';

    final int lastDay = DateTime(genDate.year, genDate.month + 1, 0).day;
    final int offset = DateTime(genDate.year, genDate.month).weekday % 7; // Sun=0 Mon=1 ... Sat=6
    final int rowCount = ((offset + lastDay) / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              yearmonth,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(color: _borderColor),
                  left: BorderSide(color: _borderColor),
                ),
              ),
              child: Column(
                children: <Widget>[
                  // Weekday header
                  Row(
                    children: List<Widget>.generate(7, (int i) {
                      Color color = Colors.white;
                      if (i == 0) {
                        color = _sunColor;
                      }
                      if (i == 6) {
                        color = _satColor;
                      }

                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: _borderColor),
                              bottom: BorderSide(color: _borderColor),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _weekLabels[i],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                      );
                    }),
                  ),

                  // Week rows
                  for (int row = 0; row < rowCount; row++)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List<Widget>.generate(7, (int col) {
                          final int day = row * 7 + col - offset + 1;

                          if (day < 1 || day > lastDay) {
                            return Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: _borderColor),
                                    bottom: BorderSide(color: _borderColor),
                                  ),
                                ),
                              ),
                            );
                          }

                          final String date =
                              '${genDate.year.toString().padLeft(4, '0')}-'
                              '${genDate.month.toString().padLeft(2, '0')}-'
                              '${day.toString().padLeft(2, '0')}';

                          return Expanded(
                            child: _buildDayCell(date: date, day: day, col: col),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell({required String date, required int day, required int col}) {
    Color dayNumColor = const Color(0xFFDDDDDD);
    if (col == 0) {
      dayNumColor = _sunColor;
    }
    if (col == 6) {
      dayNumColor = _satColor;
    }

    final WeatherModel? weather = appParamState.keepWeatherMap[date];

    String mainKey = '';
    String subKey = '';

    if (weather != null) {
      final List<String> keys = _parseWeatherKeys(weather.weather);
      if (keys.isNotEmpty) {
        mainKey = keys[0];
      }
      if (keys.length > 1) {
        subKey = keys[1];
      }
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: _borderColor),
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 3,
            left: 4,
            child: Text(
              day.toString(),
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: dayNumColor),
            ),
          ),

          if (mainKey.isNotEmpty)
            Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.6,
                      child: Image.asset('assets/images/weather/$mainKey.png', width: 36, height: 36),
                    ),

                    if (subKey.isNotEmpty)
                      Positioned(
                        bottom: -4,
                        right: -8,
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.asset('assets/images/weather/$subKey.png', width: 18, height: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 日本語天気文字列（例: "曇時々晴"）から画像キーを出現順に返す
  List<String> _parseWeatherKeys(String weather) {
    final List<MapEntry<int, String>> found = <MapEntry<int, String>>[];

    for (final MapEntry<String, String> entry in _kanjiToKey.entries) {
      final int idx = weather.indexOf(entry.key);
      if (idx >= 0) {
        found.add(MapEntry<int, String>(idx, entry.value));
      }
    }

    found.sort((MapEntry<int, String> a, MapEntry<int, String> b) => a.key.compareTo(b.key));

    return found.map((MapEntry<int, String> e) => e.value).toList();
  }
}
