// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimePlaceState {
  List<TimePlaceModel> get timePlaceList => throw _privateConstructorUsedError;
  Map<String, List<TimePlaceModel>> get timePlaceMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimePlaceStateCopyWith<TimePlaceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimePlaceStateCopyWith<$Res> {
  factory $TimePlaceStateCopyWith(
          TimePlaceState value, $Res Function(TimePlaceState) then) =
      _$TimePlaceStateCopyWithImpl<$Res, TimePlaceState>;
  @useResult
  $Res call(
      {List<TimePlaceModel> timePlaceList,
      Map<String, List<TimePlaceModel>> timePlaceMap});
}

/// @nodoc
class _$TimePlaceStateCopyWithImpl<$Res, $Val extends TimePlaceState>
    implements $TimePlaceStateCopyWith<$Res> {
  _$TimePlaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timePlaceList = null,
    Object? timePlaceMap = null,
  }) {
    return _then(_value.copyWith(
      timePlaceList: null == timePlaceList
          ? _value.timePlaceList
          : timePlaceList // ignore: cast_nullable_to_non_nullable
              as List<TimePlaceModel>,
      timePlaceMap: null == timePlaceMap
          ? _value.timePlaceMap
          : timePlaceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TimePlaceModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimePlaceStateImplCopyWith<$Res>
    implements $TimePlaceStateCopyWith<$Res> {
  factory _$$TimePlaceStateImplCopyWith(_$TimePlaceStateImpl value,
          $Res Function(_$TimePlaceStateImpl) then) =
      __$$TimePlaceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TimePlaceModel> timePlaceList,
      Map<String, List<TimePlaceModel>> timePlaceMap});
}

/// @nodoc
class __$$TimePlaceStateImplCopyWithImpl<$Res>
    extends _$TimePlaceStateCopyWithImpl<$Res, _$TimePlaceStateImpl>
    implements _$$TimePlaceStateImplCopyWith<$Res> {
  __$$TimePlaceStateImplCopyWithImpl(
      _$TimePlaceStateImpl _value, $Res Function(_$TimePlaceStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timePlaceList = null,
    Object? timePlaceMap = null,
  }) {
    return _then(_$TimePlaceStateImpl(
      timePlaceList: null == timePlaceList
          ? _value._timePlaceList
          : timePlaceList // ignore: cast_nullable_to_non_nullable
              as List<TimePlaceModel>,
      timePlaceMap: null == timePlaceMap
          ? _value._timePlaceMap
          : timePlaceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TimePlaceModel>>,
    ));
  }
}

/// @nodoc

class _$TimePlaceStateImpl implements _TimePlaceState {
  const _$TimePlaceStateImpl(
      {final List<TimePlaceModel> timePlaceList = const <TimePlaceModel>[],
      final Map<String, List<TimePlaceModel>> timePlaceMap =
          const <String, List<TimePlaceModel>>{}})
      : _timePlaceList = timePlaceList,
        _timePlaceMap = timePlaceMap;

  final List<TimePlaceModel> _timePlaceList;
  @override
  @JsonKey()
  List<TimePlaceModel> get timePlaceList {
    if (_timePlaceList is EqualUnmodifiableListView) return _timePlaceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timePlaceList);
  }

  final Map<String, List<TimePlaceModel>> _timePlaceMap;
  @override
  @JsonKey()
  Map<String, List<TimePlaceModel>> get timePlaceMap {
    if (_timePlaceMap is EqualUnmodifiableMapView) return _timePlaceMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timePlaceMap);
  }

  @override
  String toString() {
    return 'TimePlaceState(timePlaceList: $timePlaceList, timePlaceMap: $timePlaceMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimePlaceStateImpl &&
            const DeepCollectionEquality()
                .equals(other._timePlaceList, _timePlaceList) &&
            const DeepCollectionEquality()
                .equals(other._timePlaceMap, _timePlaceMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timePlaceList),
      const DeepCollectionEquality().hash(_timePlaceMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimePlaceStateImplCopyWith<_$TimePlaceStateImpl> get copyWith =>
      __$$TimePlaceStateImplCopyWithImpl<_$TimePlaceStateImpl>(
          this, _$identity);
}

abstract class _TimePlaceState implements TimePlaceState {
  const factory _TimePlaceState(
          {final List<TimePlaceModel> timePlaceList,
          final Map<String, List<TimePlaceModel>> timePlaceMap}) =
      _$TimePlaceStateImpl;

  @override
  List<TimePlaceModel> get timePlaceList;
  @override
  Map<String, List<TimePlaceModel>> get timePlaceMap;
  @override
  @JsonKey(ignore: true)
  _$$TimePlaceStateImplCopyWith<_$TimePlaceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
