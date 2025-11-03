import '../extensions/extensions.dart';

class MetroStamp20AnniversaryModel {
  MetroStamp20AnniversaryModel({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.getDate,
    required this.stamp,
    required this.latitude,
    required this.longitude,
  });

  factory MetroStamp20AnniversaryModel.fromJson(Map<String, dynamic> json) => MetroStamp20AnniversaryModel(
    id: json['id'].toString().toInt(),
    stationId: json['station_id'].toString().toInt(),
    stationName: json['station_name'].toString(),
    getDate: json['get_date'].toString(),
    stamp: json['stamp'].toString(),
    latitude: '',
    longitude: '',
  );
  int id;
  int stationId;
  String stationName;
  String getDate;
  String stamp;
  String latitude;
  String longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'station_id': stationId,
    'station_name': stationName,
    'get_date': getDate,
    'stamp': stamp,
    'latitude': latitude,
    'longitude': longitude,
  };
}
