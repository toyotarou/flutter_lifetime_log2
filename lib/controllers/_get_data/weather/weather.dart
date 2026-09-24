import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../models/weather_model.dart';
import '../../../utility/utility.dart';

part 'weather.freezed.dart';

part 'weather.g.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(<WeatherModel>[]) List<WeatherModel> weatherList,
    @Default(<String, WeatherModel>{}) Map<String, WeatherModel> weatherMap,
  }) = _WeatherState;
}

@riverpod
class Weather extends _$Weather {
  final Utility utility = Utility();

  ///
  @override
  WeatherState build() => const WeatherState();

  //============================================== api

  ///
  Future<WeatherState> fetchAllWeatherData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final List<WeatherModel> list = <WeatherModel>[];
      final Map<String, WeatherModel> map = <String, WeatherModel>{};

      final dynamic value = await client.post(path: APIPath.getAllWeather);
      final List<dynamic> data = (value as Map<String, dynamic>)['data'] as List<dynamic>;

      for (final dynamic item in data) {
        final WeatherModel val = WeatherModel.fromJson(item as Map<String, dynamic>);

        list.add(val);

        map[val.date] = val;
      }

      return state.copyWith(weatherList: list, weatherMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました（weather）', error: e);
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllWeatherData() async {
    try {
      final WeatherState newState = await fetchAllWeatherData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
