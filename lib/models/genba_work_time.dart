class GenbaWorkTimeModel {
  GenbaWorkTimeModel({required this.company, required this.genba, required this.start, required this.end});

  factory GenbaWorkTimeModel.fromJson(Map<String, dynamic> json) => GenbaWorkTimeModel(
    company: json['company'].toString(),
    genba: json['genba'].toString(),
    start: json['start'].toString(),
    end: json['end'].toString(),
  );
  String company;
  String genba;
  String start;
  String end;

  Map<String, dynamic> toJson() => <String, String>{'company': company, 'genba': genba, 'start': start, 'end': end};
}
