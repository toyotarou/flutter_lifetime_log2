class WorkHistoryModel {
  WorkHistoryModel({
    required this.year,
    required this.month,
    required this.workTruthName,
    required this.workContractName,
    this.endYm,
  });

  final String year;
  final String month;
  final String workTruthName;
  final String workContractName;
  final String? endYm;
}
