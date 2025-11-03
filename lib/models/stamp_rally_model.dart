import '../extensions/extensions.dart';

class StampRallyModel {
  StampRallyModel({
    required this.trainCode,
    required this.trainName,
    required this.stationCode,
    required this.stationName,
    required this.lat,
    required this.lng,

    ///
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

    ///
    imageFolder: (json['image_folder'] != null) ? json['image_folder'].toString() : '',
    imageCode: (json['image_code'] != null) ? json['image_code'].toString() : '',
    posterPosition: (json['poster_position'] != null) ? json['poster_position'].toString() : '',
    stampGetDate: (json['stamp_get_date'] != null) ? json['stamp_get_date'].toString() : '',
    stampGetOrder: (json['stamp_get_order'] != null) ? json['stamp_get_order'].toString().toInt() : 0,
  );

  String trainCode;
  String trainName;
  String stationCode;
  String stationName;
  String lat;
  String lng;

  ///
  String? imageFolder;
  String? imageCode;
  String? posterPosition;
  String? stampGetDate;
  int? stampGetOrder;
}
