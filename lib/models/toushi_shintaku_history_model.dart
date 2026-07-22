class ToushiShintakuHistoryModel {
  ToushiShintakuHistoryModel({
    required this.relationalId,
    required this.orderDate,
    required this.contractDate,
    required this.receiveDate,
    required this.accountKind,
    required this.fundName,
    required this.dealKind,
    required this.orderStatus,
    required this.orderPrice,
    required this.payPrice,
    required this.payMethod,
    required this.course,
    required this.suuryou,
    required this.kijunPrice,
    required this.costChangeDate,
  });

  factory ToushiShintakuHistoryModel.fromJson(Map<String, dynamic> json) {
    return ToushiShintakuHistoryModel(
      relationalId: (json['relational_id'] as int?) ?? 0,
      orderDate: (json['order_date'] as String?) ?? '',
      contractDate: (json['contract_date'] as String?) ?? '',
      receiveDate: (json['receive_date'] as String?) ?? '',
      accountKind: (json['account_kind'] as String?) ?? '',
      fundName: (json['fund_name'] as String?) ?? '',
      dealKind: (json['deal_kind'] as String?) ?? '',
      orderStatus: (json['order_status'] as String?) ?? '',
      orderPrice: (json['order_price'] as int?) ?? 0,
      payPrice: (json['pay_price'] as int?) ?? 0,
      payMethod: (json['pay_method'] as String?) ?? '',
      course: (json['course'] as String?) ?? '',
      suuryou: (json['suuryou'] as int?) ?? 0,
      kijunPrice: (json['kijun_price'] as int?) ?? 0,
      costChangeDate: (json['cost_change_date'] as String?) ?? '',
    );
  }

  final int relationalId;
  final String orderDate;
  final String contractDate;
  final String receiveDate;
  final String accountKind;
  final String fundName;
  final String dealKind;
  final String orderStatus;
  final int orderPrice;
  final int payPrice;
  final String payMethod;
  final String course;
  final int suuryou;
  final int kijunPrice;
  final String costChangeDate;
}
