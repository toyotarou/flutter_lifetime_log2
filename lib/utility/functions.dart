import '../extensions/extensions.dart';
import '../models/lifetime_model.dart';

///
List<String> generateFullMonthDays() {
  final DateTime base = DateTime(2024);

  final DateTime end = DateTime(2024, 12, 31);

  final List<String> out = <String>[];

  for (DateTime d = base; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
    out.add('${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}');
  }

  return out;
}

///
List<String> getLifetimeData({required LifetimeModel lifetimeModel}) {
  return <String>[
    lifetimeModel.hour00,
    lifetimeModel.hour01,
    lifetimeModel.hour02,
    lifetimeModel.hour03,
    lifetimeModel.hour04,
    lifetimeModel.hour05,
    lifetimeModel.hour06,
    lifetimeModel.hour07,
    lifetimeModel.hour08,
    lifetimeModel.hour09,
    lifetimeModel.hour10,
    lifetimeModel.hour11,
    lifetimeModel.hour12,
    lifetimeModel.hour13,
    lifetimeModel.hour14,
    lifetimeModel.hour15,
    lifetimeModel.hour16,
    lifetimeModel.hour17,
    lifetimeModel.hour18,
    lifetimeModel.hour19,
    lifetimeModel.hour20,
    lifetimeModel.hour21,
    lifetimeModel.hour22,
    lifetimeModel.hour23,
  ];
}

///
Map<int, T> getDuplicateConsecutiveMap<T>(List<T> list) {
  if (list.isEmpty) {
    return const <int, Never>{};
  }

  final Map<int, T> result = <int, T>{};

  // ignore: always_specify_types
  var last = list[0];

  result[0] = last;

  for (int i = 1; i < list.length; i++) {
    // ignore: always_specify_types
    final current = list[i];

    if (current != last) {
      result[i] = current;
      last = current;
    }
  }

  return result;
}

///
List<Map<String, dynamic>> getStartEndTitleList({required Map<int, String> data}) {
  final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];

  final List<int> keys = data.keys.toList()..sort();

  for (int i = 0; i < keys.length; i++) {
    final int startHour = keys[i];
    final String title = data[startHour] ?? '';

    final int endHour = (i < keys.length - 1) ? keys[i + 1] : 24;

    result.add(<String, dynamic>{'startHour': startHour, 'endHour': endHour, 'title': title});
  }

  return result;
}

///
Map<String, String> getWeeklyHistoryDisplayWeekDate({required String date}) {
  final Map<String, String> map = <String, String>{};

  for (int i = 0; i < 7; i++) {
    final String youbi = DateTime.parse(date).add(Duration(days: i)).youbiStr;
    final String ymd = DateTime.parse(date).add(Duration(days: i)).yyyymmdd;

    map[youbi] = ymd;
  }

  return map;
}
