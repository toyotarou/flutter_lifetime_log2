class FundModel {
  FundModel({required this.name, required this.relationalId, required this.record});

  factory FundModel.fromJson(Map<String, dynamic> json) {
    // 修正: JSON の配列は List<dynamic>（中身は Map）で届くため、
    // 以前の `as List<FundRecordModel>` は必ずキャストに失敗し、fund の取得が毎回エラーになっていた
    final List<dynamic> list = (json['record'] as List<dynamic>?) ?? <dynamic>[];

    return FundModel(
      name: json['name']?.toString() ?? '',
      // 数値で届いても落ちないよう文字列化する
      relationalId: json['relational_id']?.toString() ?? '',

      record: list.map((dynamic e) => FundRecordModel.fromJson(e as Map<String, dynamic>)).toList(),
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
      // 数値で届いても落ちないよう文字列化する
      date: json['date']?.toString() ?? '',
      basePrice: json['base_price']?.toString() ?? '',
      compareFront: json['compare_front']?.toString() ?? '',
      yearlyReturn: json['yearly_return']?.toString() ?? '',
      flag: json['flag']?.toString() ?? '',
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
