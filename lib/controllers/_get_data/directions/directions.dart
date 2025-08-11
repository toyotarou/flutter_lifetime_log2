import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/direction_model.dart';

part 'directions.g.dart'; // ← 追加

@riverpod
class Directions extends _$Directions {
  @override
  DirectionsModel? build() => null;

  Future<void> fetch({required String origin, required String destination, required String apiKey}) async {
    final String encodedOrigin = Uri.encodeComponent(origin);
    final String encodedDestination = Uri.encodeComponent(destination);
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$encodedOrigin&destination=$encodedDestination&mode=walking&key=$apiKey';

    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('API Error: ${res.statusCode}');
    }

    // ignore: always_specify_types
    final jsonMap = json.decode(res.body);
    state = DirectionsModel.fromJson(jsonMap as Map<String, dynamic>);
  }
}
