class TempleRecordModel {
  TempleRecordModel({
    required this.date,
    required this.startPoint,
    required this.endPoint,
    required this.templeModelList,
  });

  DateTime date;
  String startPoint;
  String endPoint;
  List<TempleModel> templeModelList;
}

class TempleModel {
  TempleModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rank,
    this.count,
    this.templePhotoList,
  });

  String name;
  String address;
  String latitude;
  String longitude;
  String rank;
  int? count;
  List<String>? templePhotoList;
}
