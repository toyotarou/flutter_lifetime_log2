import '../extensions/extensions.dart';

class ToushiShintakuModel {
  ToushiShintakuModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.name,
    required this.shutokuSougaku,
    required this.jikaHyoukagaku,
    required this.relationalId,
    required this.hoyuuSuuryou,
  });

  /// JSON → Model
  factory ToushiShintakuModel.fromJson(Map<String, dynamic> json) {
    return ToushiShintakuModel(
      id: json['id'] as int,
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      name: json['name'] as String,
      shutokuSougaku: json['shutoku_sougaku'] as String,
      jikaHyoukagaku: json['jika_hyoukagaku'] as String,
      relationalId: json['relational_id'].toString().toInt(),
      hoyuuSuuryou: json['hoyuu_suuryou'].toString().toInt(),
    );
  }

  final int id;
  final String year;
  final String month;
  final String day;
  final String name;
  final String shutokuSougaku;
  final String jikaHyoukagaku;
  final int relationalId;
  final int hoyuuSuuryou;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'name': name,
      'shutoku_sougaku': shutokuSougaku,
      'jika_hyoukagaku': jikaHyoukagaku,
      'relational_id': relationalId,
      'hoyuu_suuryou': hoyuuSuuryou,
    };
  }
}
