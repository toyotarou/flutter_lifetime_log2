class WorkTimeSummaryModel {
  WorkTimeSummaryModel({required this.data});

  factory WorkTimeSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkTimeSummaryModel(
      // ignore: avoid_dynamic_calls
      data: List<String>.from(json['data'].map((Map<String, dynamic> x) => x) as Iterable<dynamic>),
    );
  }

  List<String> data;

  Map<String, dynamic> toJson() => <String, dynamic>{'data': List<dynamic>.from(data.map((String x) => x))};
}

/////////////////////////////////////////////////////////////////////////////

class WorkTimeModel {
  WorkTimeModel({
    required this.yearmonth,
    required this.totalTime,
    required this.agentName,
    required this.genbaName,
    required this.salary,
    required this.tanka,
    required this.data,
  });

  String yearmonth;
  String totalTime;
  String agentName;
  String genbaName;
  String salary;
  String tanka;
  List<WorkTimeDataModel> data;
}

/////////////////////////////////////////////////////////////////////////////

class WorkTimeDataModel {
  WorkTimeDataModel({
    required this.day,
    required this.start,
    required this.end,
    required this.workTime,
    required this.restMinute,
    required this.youbiNum,
  });

  String day;
  String start;
  String end;
  String workTime;
  String restMinute;
  String youbiNum;
}
