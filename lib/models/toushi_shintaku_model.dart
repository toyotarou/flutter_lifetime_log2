class ToushiShintakuModel {
  ToushiShintakuModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.name,
    required this.shutokuSougaku,
    required this.jikaHyoukagaku,
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
    );
  }

  final int id;
  final String year;
  final String month;
  final String day;
  final String name;
  final String shutokuSougaku;
  final String jikaHyoukagaku;

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
    };
  }
}
