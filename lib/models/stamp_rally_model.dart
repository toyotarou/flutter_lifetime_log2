
class StampRallyModel {
  StampRallyModel({
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
}
