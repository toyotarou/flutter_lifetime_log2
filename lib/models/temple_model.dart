class TempleModel {
  TempleModel({required this.date, required this.startPoint, required this.endPoint, required this.templeDataList});

  String date;
  String startPoint;
  String endPoint;
  List<TempleData> templeDataList;
}

class TempleData {
  TempleData({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rank,
    this.count,
    this.templePhotoMap,
  });

  String name;
  String address;
  String latitude;
  String longitude;
  String rank;
  int? count;
  Map<String, List<String>>? templePhotoMap;
}
