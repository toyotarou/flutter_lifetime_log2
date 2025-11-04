// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transportation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransportationState {
  List<TransportationModel> get transportationList =>
      throw _privateConstructorUsedError;
  Map<String, TransportationModel> get transportationMap =>
      throw _privateConstructorUsedError;
  List<StationModel> get stationList => throw _privateConstructorUsedError;
  Map<String, String> get trainMap => throw _privateConstructorUsedError;

  /// Create a copy of TransportationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportationStateCopyWith<TransportationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportationStateCopyWith<$Res> {
  factory $TransportationStateCopyWith(
          TransportationState value, $Res Function(TransportationState) then) =
      _$TransportationStateCopyWithImpl<$Res, TransportationState>;
  @useResult
  $Res call(
      {List<TransportationModel> transportationList,
      Map<String, TransportationModel> transportationMap,
      List<StationModel> stationList,
      Map<String, String> trainMap});
}

/// @nodoc
class _$TransportationStateCopyWithImpl<$Res, $Val extends TransportationState>
    implements $TransportationStateCopyWith<$Res> {
  _$TransportationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportationList = null,
    Object? transportationMap = null,
    Object? stationList = null,
    Object? trainMap = null,
  }) {
    return _then(_value.copyWith(
      transportationList: null == transportationList
          ? _value.transportationList
          : transportationList // ignore: cast_nullable_to_non_nullable
              as List<TransportationModel>,
      transportationMap: null == transportationMap
          ? _value.transportationMap
          : transportationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TransportationModel>,
      stationList: null == stationList
          ? _value.stationList
          : stationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      trainMap: null == trainMap
          ? _value.trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransportationStateImplCopyWith<$Res>
    implements $TransportationStateCopyWith<$Res> {
  factory _$$TransportationStateImplCopyWith(_$TransportationStateImpl value,
          $Res Function(_$TransportationStateImpl) then) =
      __$$TransportationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransportationModel> transportationList,
      Map<String, TransportationModel> transportationMap,
      List<StationModel> stationList,
      Map<String, String> trainMap});
}

/// @nodoc
class __$$TransportationStateImplCopyWithImpl<$Res>
    extends _$TransportationStateCopyWithImpl<$Res, _$TransportationStateImpl>
    implements _$$TransportationStateImplCopyWith<$Res> {
  __$$TransportationStateImplCopyWithImpl(_$TransportationStateImpl _value,
      $Res Function(_$TransportationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransportationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportationList = null,
    Object? transportationMap = null,
    Object? stationList = null,
    Object? trainMap = null,
  }) {
    return _then(_$TransportationStateImpl(
      transportationList: null == transportationList
          ? _value._transportationList
          : transportationList // ignore: cast_nullable_to_non_nullable
              as List<TransportationModel>,
      transportationMap: null == transportationMap
          ? _value._transportationMap
          : transportationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TransportationModel>,
      stationList: null == stationList
          ? _value._stationList
          : stationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      trainMap: null == trainMap
          ? _value._trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$TransportationStateImpl implements _TransportationState {
  const _$TransportationStateImpl(
      {final List<TransportationModel> transportationList =
          const <TransportationModel>[],
      final Map<String, TransportationModel> transportationMap =
          const <String, TransportationModel>{},
      final List<StationModel> stationList = const <StationModel>[],
      final Map<String, String> trainMap = const <String, String>{}})
      : _transportationList = transportationList,
        _transportationMap = transportationMap,
        _stationList = stationList,
        _trainMap = trainMap;

  final List<TransportationModel> _transportationList;
  @override
  @JsonKey()
  List<TransportationModel> get transportationList {
    if (_transportationList is EqualUnmodifiableListView)
      return _transportationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transportationList);
  }

  final Map<String, TransportationModel> _transportationMap;
  @override
  @JsonKey()
  Map<String, TransportationModel> get transportationMap {
    if (_transportationMap is EqualUnmodifiableMapView)
      return _transportationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_transportationMap);
  }

  final List<StationModel> _stationList;
  @override
  @JsonKey()
  List<StationModel> get stationList {
    if (_stationList is EqualUnmodifiableListView) return _stationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stationList);
  }

  final Map<String, String> _trainMap;
  @override
  @JsonKey()
  Map<String, String> get trainMap {
    if (_trainMap is EqualUnmodifiableMapView) return _trainMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trainMap);
  }

  @override
  String toString() {
    return 'TransportationState(transportationList: $transportationList, transportationMap: $transportationMap, stationList: $stationList, trainMap: $trainMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._transportationList, _transportationList) &&
            const DeepCollectionEquality()
                .equals(other._transportationMap, _transportationMap) &&
            const DeepCollectionEquality()
                .equals(other._stationList, _stationList) &&
            const DeepCollectionEquality().equals(other._trainMap, _trainMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transportationList),
      const DeepCollectionEquality().hash(_transportationMap),
      const DeepCollectionEquality().hash(_stationList),
      const DeepCollectionEquality().hash(_trainMap));

  /// Create a copy of TransportationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportationStateImplCopyWith<_$TransportationStateImpl> get copyWith =>
      __$$TransportationStateImplCopyWithImpl<_$TransportationStateImpl>(
          this, _$identity);
}

abstract class _TransportationState implements TransportationState {
  const factory _TransportationState(
      {final List<TransportationModel> transportationList,
      final Map<String, TransportationModel> transportationMap,
      final List<StationModel> stationList,
      final Map<String, String> trainMap}) = _$TransportationStateImpl;

  @override
  List<TransportationModel> get transportationList;
  @override
  Map<String, TransportationModel> get transportationMap;
  @override
  List<StationModel> get stationList;
  @override
  Map<String, String> get trainMap;

  /// Create a copy of TransportationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportationStateImplCopyWith<_$TransportationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
