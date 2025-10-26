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
List<String> getOnedayLifetimeItemList({required LifetimeModel value}) {
  return <String>[
    value.hour00,
    value.hour01,
    value.hour02,
    value.hour03,
    value.hour04,
    value.hour05,
    value.hour06,
    value.hour07,
    value.hour08,
    value.hour09,
    value.hour10,
    value.hour11,
    value.hour12,
    value.hour13,
    value.hour14,
    value.hour15,
    value.hour16,
    value.hour17,
    value.hour18,
    value.hour19,
    value.hour20,
    value.hour21,
    value.hour22,
    value.hour23,
  ];
}
