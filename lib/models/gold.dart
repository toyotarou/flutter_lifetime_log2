class GoldModel {
  GoldModel({
    required this.year,
    required this.month,
    required this.day,
    required this.goldTanka,
    required this.upDown,
    required this.diff,
    required this.gramNum,
    required this.totalGram,
    required this.goldValue,
    required this.goldPrice,
    required this.payPrice,
  });

  factory GoldModel.fromJson(Map<String, dynamic> json) => GoldModel(
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        goldTanka: json['gold_tanka'].toString(),
        upDown: json['up_down'],
        diff: json['diff'],
        gramNum: json['gram_num'],
        totalGram: json['total_gram'],
        goldValue: json['gold_value'],
        goldPrice: json['gold_price'].toString(),
        payPrice: json['pay_price'],
      );
  String year;
  String month;
  String day;
  String goldTanka;
  dynamic upDown;
  dynamic diff;
  dynamic gramNum;
  dynamic totalGram;
  dynamic goldValue;
  String goldPrice;
  dynamic payPrice;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'year': year,
        'month': month,
        'day': day,
        'gold_tanka': goldTanka,
        'up_down': upDown,
        'diff': diff,
        'gram_num': gramNum,
        'total_gram': totalGram,
        'gold_value': goldValue,
        'gold_price': goldPrice,
        'pay_price': payPrice,
      };
}
