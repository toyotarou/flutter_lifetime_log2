import '../extensions/extensions.dart';

class StockModel {
  StockModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.ticker,
    required this.name,
    required this.hoyuuSuuryou,
    required this.heikinShutokuKagaku,
    required this.jikaHyoukagaku,
  });

  /// JSON → Model
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as int,
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      ticker: json['ticker'] as String,

      name: (json['name'] != null) ? json['name'].toString() : '',
      hoyuuSuuryou: (json['hoyuu_suuryou'] != null) ? json['hoyuu_suuryou'].toString().toInt() : 0,
      heikinShutokuKagaku: (json['heikin_shutoku_kagaku'] != null) ? json['heikin_shutoku_kagaku'].toString() : '',

      jikaHyoukagaku: json['jika_hyoukagaku'] as String,
    );
  }

  final int id;
  final String year;
  final String month;
  final String day;
  final String ticker;
  final String name;
  final int hoyuuSuuryou;
  final String heikinShutokuKagaku;
  final String jikaHyoukagaku;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'ticker': ticker,
      'name': name,
      'hoyuu_suuryou': hoyuuSuuryou,
      'heikin_shutoku_kagaku': heikinShutokuKagaku,
      'jika_hyoukagaku': jikaHyoukagaku,
    };
  }
}
