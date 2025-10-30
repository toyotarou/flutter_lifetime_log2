// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_stamp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StationStampState {
  Map<String, String> get trainMap => throw _privateConstructorUsedError;
  List<StationStampModel> get stationStampList =>
      throw _privateConstructorUsedError;
  Map<String, List<StationStampModel>> get stationStampMap =>
      throw _privateConstructorUsedError;
  Map<String, List<StationStampModel>> get dateStationStampMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of StationStampState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationStampStateCopyWith<StationStampState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationStampStateCopyWith<$Res> {
  factory $StationStampStateCopyWith(
          StationStampState value, $Res Function(StationStampState) then) =
      _$StationStampStateCopyWithImpl<$Res, StationStampState>;
  @useResult
  $Res call(
      {Map<String, String> trainMap,
      List<StationStampModel> stationStampList,
      Map<String, List<StationStampModel>> stationStampMap,
      Map<String, List<StationStampModel>> dateStationStampMap});
}

/// @nodoc
class _$StationStampStateCopyWithImpl<$Res, $Val extends StationStampState>
    implements $StationStampStateCopyWith<$Res> {
  _$StationStampStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationStampState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainMap = null,
    Object? stationStampList = null,
    Object? stationStampMap = null,
    Object? dateStationStampMap = null,
  }) {
    return _then(_value.copyWith(
      trainMap: null == trainMap
          ? _value.trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      stationStampList: null == stationStampList
          ? _value.stationStampList
          : stationStampList // ignore: cast_nullable_to_non_nullable
              as List<StationStampModel>,
      stationStampMap: null == stationStampMap
          ? _value.stationStampMap
          : stationStampMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StationStampModel>>,
      dateStationStampMap: null == dateStationStampMap
          ? _value.dateStationStampMap
          : dateStationStampMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StationStampModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StationStampStateImplCopyWith<$Res>
    implements $StationStampStateCopyWith<$Res> {
  factory _$$StationStampStateImplCopyWith(_$StationStampStateImpl value,
          $Res Function(_$StationStampStateImpl) then) =
      __$$StationStampStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String> trainMap,
      List<StationStampModel> stationStampList,
      Map<String, List<StationStampModel>> stationStampMap,
      Map<String, List<StationStampModel>> dateStationStampMap});
}

/// @nodoc
class __$$StationStampStateImplCopyWithImpl<$Res>
    extends _$StationStampStateCopyWithImpl<$Res, _$StationStampStateImpl>
    implements _$$StationStampStateImplCopyWith<$Res> {
  __$$StationStampStateImplCopyWithImpl(_$StationStampStateImpl _value,
      $Res Function(_$StationStampStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationStampState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainMap = null,
    Object? stationStampList = null,
    Object? stationStampMap = null,
    Object? dateStationStampMap = null,
  }) {
    return _then(_$StationStampStateImpl(
      trainMap: null == trainMap
          ? _value._trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      stationStampList: null == stationStampList
          ? _value._stationStampList
          : stationStampList // ignore: cast_nullable_to_non_nullable
              as List<StationStampModel>,
      stationStampMap: null == stationStampMap
          ? _value._stationStampMap
          : stationStampMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StationStampModel>>,
      dateStationStampMap: null == dateStationStampMap
          ? _value._dateStationStampMap
          : dateStationStampMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StationStampModel>>,
    ));
  }
}

/// @nodoc

class _$StationStampStateImpl implements _StationStampState {
  const _$StationStampStateImpl(
      {final Map<String, String> trainMap = const <String, String>{},
      final List<StationStampModel> stationStampList =
          const <StationStampModel>[],
      final Map<String, List<StationStampModel>> stationStampMap =
          const <String, List<StationStampModel>>{},
      final Map<String, List<StationStampModel>> dateStationStampMap =
          const <String, List<StationStampModel>>{}})
      : _trainMap = trainMap,
        _stationStampList = stationStampList,
        _stationStampMap = stationStampMap,
        _dateStationStampMap = dateStationStampMap;

  final Map<String, String> _trainMap;
  @override
  @JsonKey()
  Map<String, String> get trainMap {
    if (_trainMap is EqualUnmodifiableMapView) return _trainMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trainMap);
  }

  final List<StationStampModel> _stationStampList;
  @override
  @JsonKey()
  List<StationStampModel> get stationStampList {
    if (_stationStampList is EqualUnmodifiableListView)
      return _stationStampList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stationStampList);
  }

  final Map<String, List<StationStampModel>> _stationStampMap;
  @override
  @JsonKey()
  Map<String, List<StationStampModel>> get stationStampMap {
    if (_stationStampMap is EqualUnmodifiableMapView) return _stationStampMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stationStampMap);
  }

  final Map<String, List<StationStampModel>> _dateStationStampMap;
  @override
  @JsonKey()
  Map<String, List<StationStampModel>> get dateStationStampMap {
    if (_dateStationStampMap is EqualUnmodifiableMapView)
      return _dateStationStampMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dateStationStampMap);
  }

  @override
  String toString() {
    return 'StationStampState(trainMap: $trainMap, stationStampList: $stationStampList, stationStampMap: $stationStampMap, dateStationStampMap: $dateStationStampMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationStampStateImpl &&
            const DeepCollectionEquality().equals(other._trainMap, _trainMap) &&
            const DeepCollectionEquality()
                .equals(other._stationStampList, _stationStampList) &&
            const DeepCollectionEquality()
                .equals(other._stationStampMap, _stationStampMap) &&
            const DeepCollectionEquality()
                .equals(other._dateStationStampMap, _dateStationStampMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_trainMap),
      const DeepCollectionEquality().hash(_stationStampList),
      const DeepCollectionEquality().hash(_stationStampMap),
      const DeepCollectionEquality().hash(_dateStationStampMap));

  /// Create a copy of StationStampState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationStampStateImplCopyWith<_$StationStampStateImpl> get copyWith =>
      __$$StationStampStateImplCopyWithImpl<_$StationStampStateImpl>(
          this, _$identity);
}

abstract class _StationStampState implements StationStampState {
  const factory _StationStampState(
          {final Map<String, String> trainMap,
          final List<StationStampModel> stationStampList,
          final Map<String, List<StationStampModel>> stationStampMap,
          final Map<String, List<StationStampModel>> dateStationStampMap}) =
      _$StationStampStateImpl;

  @override
  Map<String, String> get trainMap;
  @override
  List<StationStampModel> get stationStampList;
  @override
  Map<String, List<StationStampModel>> get stationStampMap;
  @override
  Map<String, List<StationStampModel>> get dateStationStampMap;

  /// Create a copy of StationStampState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationStampStateImplCopyWith<_$StationStampStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
