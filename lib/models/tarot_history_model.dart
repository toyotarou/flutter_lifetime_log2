import '../extensions/extensions.dart';

class TarotHistoryModel {
  TarotHistoryModel({
    required this.year,
    required this.month,
    required this.day,
    required this.id,
    required this.reverse,
    required this.name,
    required this.image,
    required this.word,
  });

  factory TarotHistoryModel.fromJson(Map<String, dynamic> json) => TarotHistoryModel(
    year: json['year'].toString(),
    month: json['month'].toString(),
    day: json['day'].toString(),
    id: json['id'].toString().toInt(),
    reverse: json['reverse'].toString(),
    name: json['name'].toString(),
    image: json['image'].toString(),
    word: json['word'].toString(),
  );
  String year;
  String month;
  String day;
  int id;
  String reverse;
  String name;
  String image;
  String word;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'year': year,
    'month': month,
    'day': day,
    'id': id,
    'reverse': reverse,
    'name': name,
    'image': image,
    'word': word,
  };
}
