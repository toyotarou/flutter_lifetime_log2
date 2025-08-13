class TempleModel {
  TempleModel({required this.date, required this.startPoint, required this.endPoint, required this.templeDataList});

  String date;
  String startPoint;
  String endPoint;
  List<TempleDataModel> templeDataList;
}

/////////////////////////////////////////////////////////////////////////////

class TempleDataModel {
  TempleDataModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rank,
    this.count,
    this.templePhotoModelList,
  });

  String name;
  String address;
  String latitude;
  String longitude;
  String rank;
  int? count;
  List<TemplePhotoModel>? templePhotoModelList;
}

/////////////////////////////////////////////////////////////////////////////

class TemplePhotoModel {
  TemplePhotoModel({required this.date, required this.temple, required this.templephotos});

  factory TemplePhotoModel.fromJson(Map<String, dynamic> json) => TemplePhotoModel(
    date: json['date'].toString(),
    temple: json['temple'].toString(),
    // ignore: inference_failure_on_untyped_parameter, avoid_dynamic_calls, always_specify_types
    templephotos: List<String>.from(json['templephotos'].map((x) => x) as Iterable<dynamic>),
  );
  String date;
  String temple;
  List<String> templephotos;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date': date,
    'temple': temple,
    'templephotos': List<dynamic>.from(templephotos.map((String x) => x)),
  };
}

/////////////////////////////////////////////////////////////////////////////
