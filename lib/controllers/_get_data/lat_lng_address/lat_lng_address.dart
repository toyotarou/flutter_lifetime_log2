import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/lat_lng_address.dart';

part 'lat_lng_address.freezed.dart';

part 'lat_lng_address.g.dart';

@freezed
class LatLngAddressControllerState with _$LatLngAddressControllerState {
  const factory LatLngAddressControllerState({
    @Default(<LatLngAddressDetailModel>[]) List<LatLngAddressDetailModel> latLngAddressList,
    @Default(<String, List<LatLngAddressDetailModel>>{}) Map<String, List<LatLngAddressDetailModel>> latLngAddressMap,
  }) = _LatLngAddressControllerState;
}

@Riverpod(keepAlive: true)
class LatLngAddressController extends _$LatLngAddressController {
  ///
  @override
  Future<LatLngAddressControllerState> build({required String latitude, required String longitude}) async {
    return getLatLngAddress(latitude: latitude, longitude: longitude);
  }

  ///
  Future<LatLngAddressControllerState> getLatLngAddress({required String latitude, required String longitude}) async {
    final String url = 'https://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=$longitude&y=$latitude';

    final Response response = await get(Uri.parse(url));

    final LatLngAddressModel result = latLngAddressFromJson(response.body);

    final List<LatLngAddressDetailModel> list = <LatLngAddressDetailModel>[];
    final Map<String, List<LatLngAddressDetailModel>> map = <String, List<LatLngAddressDetailModel>>{};

    for (final LatLngAddressDetailModel val in result.response.location) {
      list.add(val);

      (map['${val.y}|${val.x}'] ??= <LatLngAddressDetailModel>[]).add(val);
    }

    return LatLngAddressControllerState(latLngAddressList: list, latLngAddressMap: map);
  }
}
