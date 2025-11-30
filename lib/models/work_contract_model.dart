class WorkContractModel {

  WorkContractModel({
    required this.year,
    required this.month,
    required this.name,
    required this.place,
    required this.flag,
  });

  /// JSON → モデル
  factory WorkContractModel.fromJson(Map<String, dynamic> json) {
    return WorkContractModel(
      year: json['year'] as String,
      month: json['month'] as String,
      name: json['name'] as String,
      place: json['place'] as String,
      flag: json['flag'] as String,
    );
  }
  final String year;
  final String month;
  final String name;
  final String place;
  final String flag;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'year': year, 'month': month, 'name': name, 'place': place, 'flag': flag};
  }
}
