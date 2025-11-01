// ignore_for_file: constant_identifier_names, join_return_with_assignment

/*
http://toyohide.work/BrainLog/api/getStationStamp

{
    "data": [
        {
            "train_code": "28001",
            "train_name": "東京メトロ銀座線",
            "station_code": "5820",
            "station_name": "浅草",
            "lat": "139.797592",
            "lng": "139.797592",
            "image_folder": "G",
            "image_code": "19",
            "poster_position": "吾妻橋方面改札付近（改札外）",
            "stamp_get_date": "2023/1/28"

                        "stamp_get_order": 5
        },

*/

import '../extensions/extensions.dart';

class MetroStampModel {
  MetroStampModel({
    required this.trainCode,
    required this.trainName,
    required this.stationCode,
    required this.stationName,
    required this.lat,
    required this.lng,
    required this.imageFolder,
    required this.imageCode,
    required this.posterPosition,
    required this.stampGetDate,
    required this.stampGetOrder,
  });

  factory MetroStampModel.fromJson(Map<String, dynamic> json) => MetroStampModel(
    trainCode: json['train_code'].toString(),
    trainName: json['train_name'].toString(),
    stationCode: json['station_code'].toString(),
    stationName: json['station_name'].toString(),
    lat: json['lat'].toString(),
    lng: json['lng'].toString(),
    imageFolder: json['image_folder'].toString(),
    imageCode: json['image_code'].toString(),
    posterPosition: json['poster_position'].toString(),
    stampGetDate: json['stamp_get_date'].toString(),
    stampGetOrder: (json['stamp_get_order'] != null) ? json['stamp_get_order'].toString().toInt() : 0,
  );

  String trainCode;
  String trainName;
  String stationCode;
  String stationName;
  String lat;
  String lng;
  String imageFolder;
  String imageCode;
  String posterPosition;
  String stampGetDate;
  int stampGetOrder;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'train_code': trainCode,
    'train_name': trainName,
    'station_code': stationCode,
    'station_name': stationName,
    'lat': lat,
    'lng': lng,
    'image_folder': imageFolder,
    'image_code': imageCode,
    'poster_position': posterPosition,
    'stamp_get_date': stampGetDate,
    'stamp_get_order': stampGetOrder,
  };
}
