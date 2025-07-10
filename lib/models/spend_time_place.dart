import '../extensions/extensions.dart';

class SpendTimePlaceModel {
  SpendTimePlaceModel({required this.date, required this.time, required this.place, required this.price});

  factory SpendTimePlaceModel.fromJson(Map<String, dynamic> json) => SpendTimePlaceModel(
    date: json['date'].toString(),
    time: json['time'].toString(),
    place: json['place'].toString(),
    price: json['price'].toString().toInt(),
  );

  String date;
  String time;
  String place;
  int price;

  Map<String, dynamic> toJson() => <String, dynamic>{'date': date, 'time': time, 'place': place, 'price': price};
}
