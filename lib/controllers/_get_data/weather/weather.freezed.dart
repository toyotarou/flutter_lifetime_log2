// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WeatherState {
  List<WeatherModel> get weatherList => throw _privateConstructorUsedError;
  Map<String, WeatherModel> get weatherMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of WeatherState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherStateCopyWith<WeatherState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherStateCopyWith<$Res> {
  factory $WeatherStateCopyWith(
          WeatherState value, $Res Function(WeatherState) then) =
      _$WeatherStateCopyWithImpl<$Res, WeatherState>;
  @useResult
  $Res call(
      {List<WeatherModel> weatherList, Map<String, WeatherModel> weatherMap});
}

/// @nodoc
class _$WeatherStateCopyWithImpl<$Res, $Val extends WeatherState>
    implements $WeatherStateCopyWith<$Res> {
  _$WeatherStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weatherList = null,
    Object? weatherMap = null,
  }) {
    return _then(_value.copyWith(
      weatherList: null == weatherList
          ? _value.weatherList
          : weatherList // ignore: cast_nullable_to_non_nullable
              as List<WeatherModel>,
      weatherMap: null == weatherMap
          ? _value.weatherMap
          : weatherMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WeatherModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherStateImplCopyWith<$Res>
    implements $WeatherStateCopyWith<$Res> {
  factory _$$WeatherStateImplCopyWith(
          _$WeatherStateImpl value, $Res Function(_$WeatherStateImpl) then) =
      __$$WeatherStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WeatherModel> weatherList, Map<String, WeatherModel> weatherMap});
}

/// @nodoc
class __$$WeatherStateImplCopyWithImpl<$Res>
    extends _$WeatherStateCopyWithImpl<$Res, _$WeatherStateImpl>
    implements _$$WeatherStateImplCopyWith<$Res> {
  __$$WeatherStateImplCopyWithImpl(
      _$WeatherStateImpl _value, $Res Function(_$WeatherStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeatherState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weatherList = null,
    Object? weatherMap = null,
  }) {
    return _then(_$WeatherStateImpl(
      weatherList: null == weatherList
          ? _value._weatherList
          : weatherList // ignore: cast_nullable_to_non_nullable
              as List<WeatherModel>,
      weatherMap: null == weatherMap
          ? _value._weatherMap
          : weatherMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WeatherModel>,
    ));
  }
}

/// @nodoc

class _$WeatherStateImpl implements _WeatherState {
  const _$WeatherStateImpl(
      {final List<WeatherModel> weatherList = const <WeatherModel>[],
      final Map<String, WeatherModel> weatherMap =
          const <String, WeatherModel>{}})
      : _weatherList = weatherList,
        _weatherMap = weatherMap;

  final List<WeatherModel> _weatherList;
  @override
  @JsonKey()
  List<WeatherModel> get weatherList {
    if (_weatherList is EqualUnmodifiableListView) return _weatherList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weatherList);
  }

  final Map<String, WeatherModel> _weatherMap;
  @override
  @JsonKey()
  Map<String, WeatherModel> get weatherMap {
    if (_weatherMap is EqualUnmodifiableMapView) return _weatherMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weatherMap);
  }

  @override
  String toString() {
    return 'WeatherState(weatherList: $weatherList, weatherMap: $weatherMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherStateImpl &&
            const DeepCollectionEquality()
                .equals(other._weatherList, _weatherList) &&
            const DeepCollectionEquality()
                .equals(other._weatherMap, _weatherMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_weatherList),
      const DeepCollectionEquality().hash(_weatherMap));

  /// Create a copy of WeatherState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherStateImplCopyWith<_$WeatherStateImpl> get copyWith =>
      __$$WeatherStateImplCopyWithImpl<_$WeatherStateImpl>(this, _$identity);
}

abstract class _WeatherState implements WeatherState {
  const factory _WeatherState(
      {final List<WeatherModel> weatherList,
      final Map<String, WeatherModel> weatherMap}) = _$WeatherStateImpl;

  @override
  List<WeatherModel> get weatherList;
  @override
  Map<String, WeatherModel> get weatherMap;

  /// Create a copy of WeatherState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherStateImplCopyWith<_$WeatherStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
