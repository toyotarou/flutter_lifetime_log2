class TimePlaceModel {
  TimePlaceModel({
    required this.year,
    required this.month,
    required this.day,
    required this.time,
    required this.place,
    required this.price,
  });

  /// JSON → モデル
  factory TimePlaceModel.fromJson(Map<String, dynamic> json) {
    return TimePlaceModel(
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      place: json['place'] as String,
      price: json['price'] as int,
    );
  }

  final String year;
  final String month;
  final String day;
  final String time;
  final String place;
  final int price;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'year': year, 'month': month, 'day': day, 'time': time, 'place': place, 'price': price};
  }
}
