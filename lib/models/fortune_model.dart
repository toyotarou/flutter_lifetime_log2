class FortuneModel {
  FortuneModel({
    required this.year,
    required this.month,
    required this.day,
    required this.rank,
    required this.love,
    required this.money,
    required this.relationship,
    required this.work,
  });

  /// JSON → モデル
  factory FortuneModel.fromJson(Map<String, dynamic> json) {
    return FortuneModel(
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
      rank: json['rank'] as String,
      love: json['love'] as String,
      money: json['money'] as String,
      relationship: json['relationship'] as String,
      work: json['work'] as String,
    );
  }

  final String year;
  final String month;
  final String day;
  final String rank;

  final String love;
  final String money;
  final String relationship;
  final String work;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'day': day,
      'rank': rank,
      'love': love,
      'money': money,
      'relationship': relationship,
      'work': work,
    };
  }
}
