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
List<String> getOnedayLifetimeItemList({required LifetimeModel lifetimeModel}) {
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
