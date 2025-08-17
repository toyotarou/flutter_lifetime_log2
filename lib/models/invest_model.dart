class InvestNameModel {
  InvestNameModel({
    required this.id,
    required this.kind,
    required this.frame,
    required this.name,
    required this.dealNumber,
    required this.relationalId,
  });

  /// JSON → モデル
  factory InvestNameModel.fromJson(Map<String, dynamic> json) {
    return InvestNameModel(
      id: json['id'] as int,
      kind: json['kind'] as String,
      frame: json['frame'] as String,
      name: json['name'] as String,
      dealNumber: json['deal_number'] as int,
      relationalId: json['relational_id'] as int,
    );
  }

  final int id;
  final String kind;
  final String frame;
  final String name;
  final int dealNumber;
  final int relationalId;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'kind': kind,
      'frame': frame,
      'name': name,
      'deal_number': dealNumber,
      'relational_id': relationalId,
    };
  }
}

/////////////////////////////////////////////////////////////////////////////

class InvestRecordModel {
  InvestRecordModel({
    required this.id,
    required this.date,
    required this.relationalId,
    required this.cost,
    required this.price,
  });

  /// JSON → モデル
  factory InvestRecordModel.fromJson(Map<String, dynamic> json) {
    return InvestRecordModel(
      id: json['id'] as int,
      date: json['date'] as String,
      relationalId: json['relational_id'] as int,
      cost: json['cost'] as int,
      price: json['price'] as int,
    );
  }

  final int id;
  final String date;
  final int relationalId;
  final int cost;
  final int price;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'date': date, 'relational_id': relationalId, 'cost': cost, 'price': price};
  }
}
