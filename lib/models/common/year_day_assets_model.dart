class YearDayAssetsModel {
  YearDayAssetsModel({
    required this.date,
    required this.mmdd,
    required this.youbiStr,
    required this.youbiShort,
    required this.money,
    required this.gold,
    required this.stock,
    required this.toushiShintaku,
    required this.insurance,
    required this.insurancePassedMonths,
    required this.nenkinKikin,
    required this.nenkinKikinPassedMonths,
    required this.total,
    required this.totalBefore,
  });

  final String date;
  final String mmdd;
  final String youbiStr;
  final String youbiShort;

  final int money;
  final int gold;
  final int stock;
  final int toushiShintaku;

  final int insurance;
  final int insurancePassedMonths;

  final int nenkinKikin;
  final int nenkinKikinPassedMonths;

  final int total;
  final int? totalBefore;
}
