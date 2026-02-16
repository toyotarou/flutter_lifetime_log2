class CreditSummaryModel {
  CreditSummaryModel({
    required this.id,
    required this.year,
    required this.month,
    required this.useDate,
    required this.item,
    required this.detail,
    required this.price,
    required this.subscription,
  });

  /// JSON → モデル変換
  factory CreditSummaryModel.fromJson(Map<String, dynamic> json) {
    return CreditSummaryModel(
      id: json['id'] as int,
      year: json['year'] as String,
      month: json['month'] as String,
      useDate: json['use_date'] as String,
      item: json['item'] as String,
      detail: json['detail'] as String,
      price: json['price'] as int,
      subscription: json['subscription'] as int,
    );
  }

  final int id;
  final String year;
  final String month;
  final String useDate;
  final String item;
  final String detail;
  final int price;
  final int subscription;

  /// モデル → JSON変換
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'use_date': useDate,
      'item': item,
      'detail': detail,
      'price': price,
      'subscription': subscription,
    };
  }
}
