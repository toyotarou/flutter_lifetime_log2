class FundModel {
  FundModel({required this.name, required this.relationalId, required this.record});

  factory FundModel.fromJson(Map<String, dynamic> json) {
    final List<FundRecordModel> list = json['record'] as List<FundRecordModel>;

    return FundModel(
      name: json['name'] as String,
      relationalId: json['relational_id'] as String,

      record: list.map((FundRecordModel e) => FundRecordModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  final String name;
  final String relationalId;
  final List<FundRecordModel> record;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'relational_id': relationalId,
      'record': record.map((FundRecordModel e) => e.toJson()).toList(),
    };
  }
}

class FundRecordModel {
  FundRecordModel({
    required this.date,
    required this.basePrice,
    required this.compareFront,
    required this.yearlyReturn,
    required this.flag,
  });

  factory FundRecordModel.fromJson(Map<String, dynamic> json) {
    return FundRecordModel(
      date: json['date'] as String,
      basePrice: json['base_price'] as String,
      compareFront: json['compare_front'] as String,
      yearlyReturn: json['yearly_return'] as String,
      flag: json['flag'] as String,
    );
  }

  final String date;
  final String basePrice;
  final String compareFront;
  final String yearlyReturn;
  final String flag;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'base_price': basePrice,
      'compare_front': compareFront,
      'yearly_return': yearlyReturn,
      'flag': flag,
    };
  }
}
