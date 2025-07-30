class WeatherModel {
  WeatherModel({required this.date, required this.weather});

  /// JSON → Model
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      WeatherModel(date: json['date'] as String, weather: json['weather'] as String);

  final String date;
  final String weather;

  /// Model → JSON
  Map<String, dynamic> toJson() => <String, dynamic>{'date': date, 'weather': weather};
}
