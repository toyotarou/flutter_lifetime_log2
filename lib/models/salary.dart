import '../extensions/extensions.dart';

class SalaryTotalModel {
  SalaryTotalModel({
    required this.year,
    required this.salary,
  });

  factory SalaryTotalModel.fromJson(Map<String, dynamic> json) =>
      SalaryTotalModel(
        year: json['year'].toString().toInt(),
        salary: json['salary'].toString(),
      );
  int year;
  String salary;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'year': year,
        'salary': salary,
      };
}

class SalaryModel {
  SalaryModel({required this.yearmonth, required this.salary});

  String yearmonth;
  String salary;
}
