import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/weather_model.dart';

class MonthlyWeatherDisplayAlert extends ConsumerStatefulWidget {
  const MonthlyWeatherDisplayAlert({super.key, required this.yearmonth});

  final String yearmonth;

  @override
  ConsumerState<MonthlyWeatherDisplayAlert> createState() => _MonthlyWeatherDisplayAlertState();
}

class _MonthlyWeatherDisplayAlertState extends ConsumerState<MonthlyWeatherDisplayAlert>
    with ControllersMixin<MonthlyWeatherDisplayAlert> {
  static const List<String> _weekLabels = <String>['日', '月', '火', '水', '木', '金', '土'];

  // APIは日本語テキストを返す（例: "晴", "曇時々晴", "雨のち曇"）
  // 文字列中の漢字の出現位置順に main/sub を決定する
  static const Map<String, String> _kanjiToKey = <String, String>{
    '晴': 'sunny',
    '曇': 'cloudy',
    '雨': 'rain',
    '雪': 'snow',
  };

  static const Color _sunColor = Color(0xFFFF6666);
  static const Color _satColor = Color(0xFF6699FF);
  static const Color _borderColor = Color(0xFF333333);
  static const Color _cellBg = Color(0xFF1A1A1A);
  static const Color _emptyBg = Color(0xFF111111);
  static const Color _headerBg = Color(0xFF222222);

  late final int _year;
  late final int _month;

  @override
  void initState() {
    super.initState();
    final List<String> parts = widget.yearmonth.split('-');
    final DateTime now = DateTime.now();
    _year = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? now.year) : now.year;
    final int rawMonth = parts.length > 1 ? (int.tryParse(parts[1]) ?? now.month) : now.month;
    _month = rawMonth.clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) {
    final int lastDay = DateTime(_year, _month + 1, 0).day;
    final int offset = DateTime(_year, _month).weekday % 7; // Sun=0 Mon=1 ... Sat=6
    final int rowCount = ((offset + lastDay) / 7).ceil();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.yearmonth,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
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
                                color: _headerBg,
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
                                      color: _emptyBg,
                                      border: Border(
                                        right: BorderSide(color: _borderColor),
                                        bottom: BorderSide(color: _borderColor),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final String date =
                                  '${_year.toString().padLeft(4, '0')}-'
                                  '${_month.toString().padLeft(2, '0')}-'
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
        ),
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
        color: _cellBg,
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
