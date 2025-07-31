import '../extensions/extensions.dart';

class MoneySpendModel {
  MoneySpendModel(this.date, this.item, this.price, this.kind);

  final String date;
  final String item;
  final int price;
  final String kind;
}

/////////////////////////////////////////////////////////////////////////////

class DailySpendModel {
  DailySpendModel({
    required this.year,
    required this.month,
    required this.day,
    required this.price,
    required this.koumoku,

    required this.id,
    required this.ymd,
    required this.flag,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON → Model
  factory DailySpendModel.fromJson(Map<String, dynamic> json) {
    return DailySpendModel(
      id: json['id'] as int,
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      ymd: json['ymd'] as String,
      price: json['price'] as int,
      koumoku: json['koumoku'] as String,
      flag: json['flag'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  final int id;
  final String year;
  final String month;
  final String day;
  final String ymd;
  final int price;
  final String koumoku;
  final String flag;
  final String createdAt;
  final String updatedAt;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'ymd': ymd,
      'price': price,
      'koumoku': koumoku,
      'flag': flag,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/////////////////////////////////////////////////////////////////////////////

class CreditModel {
  CreditModel({
    required this.year,
    required this.month,
    required this.day,
    required this.item,
    required this.price,

    required this.id,
    required this.ymd,
    required this.bank,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON → Model
  factory CreditModel.fromJson(Map<String, dynamic> json) {
    return CreditModel(
      id: json['id'] as int,
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      ymd: (json['ymd'] != null) ? json['ymd'].toString() : '',
      item: json['item'] as String,
      price: json['price'] as String,
      bank: (json['bank'] != null) ? json['bank'].toString() : '',
      createdAt: (json['created_at'] != null) ? json['created_at'].toString() : '',
      updatedAt: (json['updated_at'] != null) ? json['updated_at'].toString() : '',
    );
  }

  final int id;
  final String year;
  final String month;
  final String day;
  final String ymd;
  final String item;
  final String price;
  final String bank;
  final String createdAt;
  final String updatedAt;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'ymd': ymd,
      'item': item,
      'price': price,
      'bank': bank,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/////////////////////////////////////////////////////////////////////////////

class MoneySpendItemModel {
  MoneySpendItemModel({required this.id, required this.name, required this.orderNo});

  /// JSON → Model
  factory MoneySpendItemModel.fromJson(Map<String, dynamic> json) {
    return MoneySpendItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      orderNo: json['order_no'].toString().toInt(),
    );
  }

  final int id;
  final String name;
  final int orderNo;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'order_no': orderNo};
  }
}

/////////////////////////////////////////////////////////////////////////////
