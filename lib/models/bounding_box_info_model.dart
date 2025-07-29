class BoundingBoxInfoModel {
  BoundingBoxInfoModel({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.areaKm2,
  });

  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final double areaKm2;
}
