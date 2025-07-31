import '../extensions/extensions.dart';

class LifetimeModel {
  LifetimeModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.hour00,
    required this.hour01,
    required this.hour02,
    required this.hour03,
    required this.hour04,
    required this.hour05,
    required this.hour06,
    required this.hour07,
    required this.hour08,
    required this.hour09,
    required this.hour10,
    required this.hour11,
    required this.hour12,
    required this.hour13,
    required this.hour14,
    required this.hour15,
    required this.hour16,
    required this.hour17,
    required this.hour18,
    required this.hour19,
    required this.hour20,
    required this.hour21,
    required this.hour22,
    required this.hour23,
  });

  factory LifetimeModel.fromJson(Map<String, dynamic> json) => LifetimeModel(
    id: json['id'].toString().toInt(),
    year: json['year'].toString(),
    month: json['month'].toString(),
    day: json['day'].toString(),
    hour00: json['hour00'].toString(),
    hour01: json['hour01'].toString(),
    hour02: json['hour02'].toString(),
    hour03: json['hour03'].toString(),
    hour04: json['hour04'].toString(),
    hour05: json['hour05'].toString(),
    hour06: json['hour06'].toString(),
    hour07: json['hour07'].toString(),
    hour08: json['hour08'].toString(),
    hour09: json['hour09'].toString(),
    hour10: json['hour10'].toString(),
    hour11: json['hour11'].toString(),
    hour12: json['hour12'].toString(),
    hour13: json['hour13'].toString(),
    hour14: json['hour14'].toString(),
    hour15: json['hour15'].toString(),
    hour16: json['hour16'].toString(),
    hour17: json['hour17'].toString(),
    hour18: json['hour18'].toString(),
    hour19: json['hour19'].toString(),
    hour20: json['hour20'].toString(),
    hour21: json['hour21'].toString(),
    hour22: json['hour22'].toString(),
    hour23: json['hour23'].toString(),
  );

  final int id;
  final String year;
  final String month;
  final String day;
  final String hour00;
  final String hour01;
  final String hour02;
  final String hour03;
  final String hour04;
  final String hour05;
  final String hour06;
  final String hour07;
  final String hour08;
  final String hour09;
  final String hour10;
  final String hour11;
  final String hour12;
  final String hour13;
  final String hour14;
  final String hour15;
  final String hour16;
  final String hour17;
  final String hour18;
  final String hour19;
  final String hour20;
  final String hour21;
  final String hour22;
  final String hour23;

  LifetimeModel copyWith({
    int? id,
    String? year,
    String? month,
    String? day,
    String? hour00,
    String? hour01,
    String? hour02,
    String? hour03,
    String? hour04,
    String? hour05,
    String? hour06,
    String? hour07,
    String? hour08,
    String? hour09,
    String? hour10,
    String? hour11,
    String? hour12,
    String? hour13,
    String? hour14,
    String? hour15,
    String? hour16,
    String? hour17,
    String? hour18,
    String? hour19,
    String? hour20,
    String? hour21,
    String? hour22,
    String? hour23,
  }) => LifetimeModel(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    day: day ?? this.day,
    hour00: hour00 ?? this.hour00,
    hour01: hour01 ?? this.hour01,
    hour02: hour02 ?? this.hour02,
    hour03: hour03 ?? this.hour03,
    hour04: hour04 ?? this.hour04,
    hour05: hour05 ?? this.hour05,
    hour06: hour06 ?? this.hour06,
    hour07: hour07 ?? this.hour07,
    hour08: hour08 ?? this.hour08,
    hour09: hour09 ?? this.hour09,
    hour10: hour10 ?? this.hour10,
    hour11: hour11 ?? this.hour11,
    hour12: hour12 ?? this.hour12,
    hour13: hour13 ?? this.hour13,
    hour14: hour14 ?? this.hour14,
    hour15: hour15 ?? this.hour15,
    hour16: hour16 ?? this.hour16,
    hour17: hour17 ?? this.hour17,
    hour18: hour18 ?? this.hour18,
    hour19: hour19 ?? this.hour19,
    hour20: hour20 ?? this.hour20,
    hour21: hour21 ?? this.hour21,
    hour22: hour22 ?? this.hour22,
    hour23: hour23 ?? this.hour23,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'year': year,
    'month': month,
    'day': day,
    'hour00': hour00,
    'hour01': hour01,
    'hour02': hour02,
    'hour03': hour03,
    'hour04': hour04,
    'hour05': hour05,
    'hour06': hour06,
    'hour07': hour07,
    'hour08': hour08,
    'hour09': hour09,
    'hour10': hour10,
    'hour11': hour11,
    'hour12': hour12,
    'hour13': hour13,
    'hour14': hour14,
    'hour15': hour15,
    'hour16': hour16,
    'hour17': hour17,
    'hour18': hour18,
    'hour19': hour19,
    'hour20': hour20,
    'hour21': hour21,
    'hour22': hour22,
    'hour23': hour23,
  };
}

/////////////////////////////////////////////////////////////////////////////

class LifetimeItemModel {
  LifetimeItemModel({required this.item});

  factory LifetimeItemModel.fromJson(Map<String, dynamic> json) => LifetimeItemModel(item: json['item'].toString());
  final String item;

  LifetimeItemModel copyWith({String? item}) => LifetimeItemModel(item: item ?? this.item);

  Map<String, dynamic> toJson() => <String, dynamic>{'item': item};
}
