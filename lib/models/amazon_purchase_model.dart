class AmazonPurchaseModel {
  AmazonPurchaseModel({
    required this.year,
    required this.month,
    required this.day,
    required this.price,
    required this.item,
  });

  /// JSON → モデル
  factory AmazonPurchaseModel.fromJson(Map<String, dynamic> json) {
    return AmazonPurchaseModel(
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      price: json['price'] as int,
      item: json['item'] as String,
    );
  }

  final String year;
  final String month;
  final String day;
  final int price;
  final String item;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'year': year, 'month': month, 'day': day, 'price': price, 'item': item};
  }
}
