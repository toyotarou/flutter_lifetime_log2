import '../../extensions/extensions.dart';

//////////////////////////////////////////////////////////

class DirectionsModel {
  DirectionsModel({required this.geocodedWaypoints, required this.routes, required this.status});

  factory DirectionsModel.fromJson(Map<String, dynamic> json) {
    return DirectionsModel(
      // ignore: always_specify_types
      geocodedWaypoints: (json['geocoded_waypoints'] as List<dynamic>)
          // ignore: always_specify_types
          .map((e) => GeocodedWaypointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      // ignore: always_specify_types
      routes: (json['routes'] as List).map((e) => RouteModel.fromJson(e as Map<String, dynamic>)).toList(),
      status: json['status'].toString(),
    );
  }

  final List<GeocodedWaypointModel> geocodedWaypoints;
  final List<RouteModel> routes;
  final String status;
}

//////////////////////////////////////////////////////////

class GeocodedWaypointModel {
  GeocodedWaypointModel({
    required this.geocoderStatus,
    required this.partialMatch,
    required this.placeId,
    required this.types,
  });

  factory GeocodedWaypointModel.fromJson(Map<String, dynamic> json) {
    return GeocodedWaypointModel(
      geocoderStatus: json['geocoder_status'].toString(),
      partialMatch: json['partial_match'] as bool? ?? false, // null対策も追加
      placeId: json['place_id'].toString(),
      // ignore: always_specify_types
      types: (json['types'] as List).map((e) => e.toString()).toList(),
    );
  }

  final String geocoderStatus;
  final bool partialMatch;
  final String placeId;
  final List<String> types;
}

//////////////////////////////////////////////////////////

class RouteModel {
  RouteModel({
    required this.bounds,
    required this.copyrights,
    required this.legs,
    required this.overviewPolyline,
    required this.summary,
    required this.warnings,
    required this.waypointOrder,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      bounds: BoundsModel.fromJson(json['bounds'] as Map<String, dynamic>),
      copyrights: json['copyrights'].toString(),
      // ignore: always_specify_types
      legs: (json['legs'] as List).map((e) => LegModel.fromJson(e as Map<String, dynamic>)).toList(),
      overviewPolyline: OverviewPolylineModel.fromJson(json['overview_polyline'] as Map<String, dynamic>),
      summary: json['summary'].toString(),
      // ignore: always_specify_types
      warnings: (json['warnings'] as List).map((e) => e.toString()).toList(),
      waypointOrder: json['waypoint_order'] as List<dynamic>,
    );
  }

  final BoundsModel bounds;
  final String copyrights;
  final List<LegModel> legs;
  final OverviewPolylineModel overviewPolyline;
  final String summary;
  final List<String> warnings;
  final List<dynamic> waypointOrder;
}

//////////////////////////////////////////////////////////

class BoundsModel {
  BoundsModel({required this.northeast, required this.southwest});

  factory BoundsModel.fromJson(Map<String, dynamic> json) {
    return BoundsModel(
      northeast: LatLngModel.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: LatLngModel.fromJson(json['southwest'] as Map<String, dynamic>),
    );
  }

  final LatLngModel northeast;
  final LatLngModel southwest;
}

//////////////////////////////////////////////////////////

class LegModel {
  LegModel({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
    required this.steps,
  });

  factory LegModel.fromJson(Map<String, dynamic> json) {
    return LegModel(
      distance: DistanceModel.fromJson(json['distance'] as Map<String, dynamic>),
      duration: DurationModel.fromJson(json['duration'] as Map<String, dynamic>),
      endAddress: json['end_address'].toString(),
      endLocation: LatLngModel.fromJson(json['end_location'] as Map<String, dynamic>),
      startAddress: json['start_address'].toString(),
      startLocation: LatLngModel.fromJson(json['start_location'] as Map<String, dynamic>),
      // ignore: always_specify_types
      steps: (json['steps'] as List).map((e) => StepModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  final DistanceModel distance;
  final DurationModel duration;
  final String endAddress;
  final LatLngModel endLocation;
  final String startAddress;
  final LatLngModel startLocation;
  final List<StepModel> steps;
}

//////////////////////////////////////////////////////////

class StepModel {
  StepModel({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.startLocation,
    required this.travelMode,
    this.maneuver,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      distance: DistanceModel.fromJson(json['distance'] as Map<String, dynamic>),
      duration: DurationModel.fromJson(json['duration'] as Map<String, dynamic>),
      endLocation: LatLngModel.fromJson(json['end_location'] as Map<String, dynamic>),
      htmlInstructions: json['html_instructions'].toString(),
      polyline: PolylineModel.fromJson(json['polyline'] as Map<String, dynamic>),
      startLocation: LatLngModel.fromJson(json['start_location'] as Map<String, dynamic>),
      travelMode: json['travel_mode'].toString(),
      maneuver: json['maneuver'].toString(),
    );
  }

  final DistanceModel distance;
  final DurationModel duration;
  final LatLngModel endLocation;
  final String htmlInstructions;
  final PolylineModel polyline;
  final LatLngModel startLocation;
  final String travelMode;
  final String? maneuver;
}

//////////////////////////////////////////////////////////

class DistanceModel {
  DistanceModel({required this.text, required this.value});

  factory DistanceModel.fromJson(Map<String, dynamic> json) {
    return DistanceModel(text: json['text'].toString(), value: json['value'].toString().toInt());
  }

  final String text;
  final int value;
}

//////////////////////////////////////////////////////////

class DurationModel {
  DurationModel({required this.text, required this.value});

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(text: json['text'].toString(), value: json['value'].toString().toInt());
  }

  final String text;
  final int value;
}

//////////////////////////////////////////////////////////

class LatLngModel {
  LatLngModel({required this.lat, required this.lng});

  factory LatLngModel.fromJson(Map<String, dynamic> json) {
    return LatLngModel(lat: json['lat'].toString().toDouble(), lng: json['lng'].toString().toDouble());
  }

  final double lat;
  final double lng;
}

//////////////////////////////////////////////////////////

class PolylineModel {
  PolylineModel({required this.points});

  factory PolylineModel.fromJson(Map<String, dynamic> json) {
    return PolylineModel(points: json['points'].toString());
  }

  final String points;
}

//////////////////////////////////////////////////////////

class OverviewPolylineModel {
  OverviewPolylineModel({required this.points});

  factory OverviewPolylineModel.fromJson(Map<String, dynamic> json) {
    return OverviewPolylineModel(points: json['points'].toString());
  }

  final String points;
}

//////////////////////////////////////////////////////////
