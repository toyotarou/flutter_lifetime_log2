class GenbaNameModel {
  GenbaNameModel({required this.yearmonth, required this.company, required this.genba});

  factory GenbaNameModel.fromJson(Map<String, dynamic> json) => GenbaNameModel(
    yearmonth: json['yearmonth'].toString(),
    company: json['company'].toString(),
    genba: json['genba'].toString(),
  );
  String yearmonth;
  String company;
  String genba;

  Map<String, dynamic> toJson() => <String, String>{'yearmonth': yearmonth, 'company': company, 'genba': genba};
}
