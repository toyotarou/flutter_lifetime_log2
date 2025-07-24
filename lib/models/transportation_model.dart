import '../extensions/extensions.dart';

/////////////////////////////////////////////////////////////////////////////

class TransportationModel {
  TransportationModel({
    required this.date,
    required this.oufuku,
    required this.spotDataModelListMap,
    required this.rootSpotCountMap,
  });

  String date;
  bool oufuku;
  Map<int, List<SpotDataModel>> spotDataModelListMap;
  Map<int, int> rootSpotCountMap;
}

/////////////////////////////////////////////////////////////////////////////

class SpotDataModel {
  SpotDataModel({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,

    this.id,
    this.trainNumber,
  });

  String name;
  String address;
  String lat;
  String lng;

  int? id;
  String? trainNumber;
}

/////////////////////////////////////////////////////////////////////////////

class TrainBoardingModel {
  TrainBoardingModel({required this.date, required this.station, required this.price, required this.oufuku});

  factory TrainBoardingModel.fromJson(Map<String, dynamic> json) => TrainBoardingModel(
    date: DateTime.parse('${json["date"]} 00:00:00'),
    station: json['station'].toString(),
    price: json['price'].toString(),
    oufuku: json['oufuku'].toString(),
  );
  DateTime date;
  String station;
  String price;
  String oufuku;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'date':
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    'station': station,
    'price': price,
    'oufuku': oufuku,
  };
}

/////////////////////////////////////////////////////////////////////////////

class StationModel {
  StationModel({
    required this.id,
    required this.trainNumber,
    required this.stationName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.prefecture,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) => StationModel(
    id: json['id'].toString().toInt(),
    trainNumber: json['train_number'].toString(),
    stationName: json['station_name'].toString(),
    address: json['address'].toString(),
    lat: json['lat'].toString(),
    lng: json['lng'].toString(),
    prefecture: json['prefecture'].toString(),
  );
  int id;
  String trainNumber;
  String stationName;
  String address;
  String lat;
  String lng;
  String prefecture;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'train_number': trainNumber,
    'station_name': stationName,
    'address': address,
    'lat': lat,
    'lng': lng,
    'prefecture': prefecture,
  };
}

/////////////////////////////////////////////////////////////////////////////

class BusStopModel {
  BusStopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory BusStopModel.fromJson(Map<String, dynamic> json) => BusStopModel(
    id: json['id'] as int,
    name: json['name'] as String,
    address: json['address'] as String,
    latitude: json['latitude'] as String,
    longitude: json['longitude'] as String,
  );

  final int id;
  final String name;
  final String address;
  final String latitude;
  final String longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };
}

/////////////////////////////////////////////////////////////////////////////

class DupSpotModel {
  DupSpotModel({required this.id, required this.name, required this.area});

  factory DupSpotModel.fromJson(Map<String, dynamic> json) =>
      DupSpotModel(id: json['id'] as int, name: json['name'] as String, area: json['area'] as String);

  final int id;
  final String name;
  final String area;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name, 'area': area};
}

/////////////////////////////////////////////////////////////////////////////
