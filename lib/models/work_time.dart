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

/*
        "2024-01;
        131.75;
        ココナラ;
        NTT DATA;
        ;
        ;

        01(月)|||||1|0/
        02(火)|||||2|0/
        03(水)|||||3|0/
        04(木)|||||4|0/05(金)|||||5|0/06(土)|||||6|0/07(日)|||||0|0/08(月)|||||1|0/

        09(火)|
        09:30|
        18:00|
        7.5|
        60|
        2|
        */
