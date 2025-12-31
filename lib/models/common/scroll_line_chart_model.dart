class ScrollLineChartModel {
  ScrollLineChartModel({required this.date, required this.sum});

  /// JSON → モデル
  factory ScrollLineChartModel.fromJson(Map<String, dynamic> json) {
    return ScrollLineChartModel(date: json['date'] as String, sum: json['sum'] as int);
  }

  final String date;
  final int sum;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'date': date, 'sum': sum};
  }
}
