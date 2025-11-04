class StampRallyModel {
  StampRallyModel({
    required this.stationCode,
    required this.stationName,
    required this.stampGetDate,

    ///
    required this.lat,
    required this.lng,

    ///
    required this.trainCode,
    required this.trainName,

    ///
    required this.imageFolder,
    required this.imageCode,
    required this.posterPosition,
    required this.stampGetOrder,

    ///
    required this.stamp,
    required this.time,
  });

  String stationCode;
  String stationName;
  String stampGetDate;

  ///
  String lat;
  String lng;

  ///
  String trainCode;
  String trainName;

  ///
  String imageFolder;
  String imageCode;
  String posterPosition;
  int stampGetOrder;

  ///
  String stamp;
  String time;
}
