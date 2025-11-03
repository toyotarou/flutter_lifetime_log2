class StampRallyModel {
  StampRallyModel({
    required this.trainCode,
    required this.trainName,
    required this.stationCode,
    required this.stationName,
    required this.lat,
    required this.lng,
    this.imageFolder,
    this.imageCode,
    this.posterPosition,
    this.stampGetDate,
    this.stampGetOrder,
  });

  factory StampRallyModel.fromJson(Map<String, dynamic> json) => StampRallyModel(
    trainCode: json['train_code'].toString(),
    trainName: json['train_name'].toString(),
    stationCode: json['station_code'].toString(),
    stationName: json['station_name'].toString(),
    lat: json['lat'].toString(),
    lng: json['lng'].toString(),
    imageFolder: '',
    imageCode: '',
    posterPosition: '',
    stampGetDate: '',
    stampGetOrder: 0,
  );

  String trainCode;
  String trainName;
  String stationCode;
  String stationName;
  String lat;
  String lng;
  String? imageFolder;
  String? imageCode;
  String? posterPosition;
  String? stampGetDate;
  int? stampGetOrder;
}
