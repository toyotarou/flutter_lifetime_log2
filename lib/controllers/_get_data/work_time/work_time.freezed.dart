// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkTimeState {
  List<WorkTimeModel> get workTimeList => throw _privateConstructorUsedError;
  Map<String, WorkTimeModel> get workTimeMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of WorkTimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkTimeStateCopyWith<WorkTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkTimeStateCopyWith<$Res> {
  factory $WorkTimeStateCopyWith(
          WorkTimeState value, $Res Function(WorkTimeState) then) =
      _$WorkTimeStateCopyWithImpl<$Res, WorkTimeState>;
  @useResult
  $Res call(
      {List<WorkTimeModel> workTimeList,
      Map<String, WorkTimeModel> workTimeMap});
}

/// @nodoc
class _$WorkTimeStateCopyWithImpl<$Res, $Val extends WorkTimeState>
    implements $WorkTimeStateCopyWith<$Res> {
  _$WorkTimeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkTimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workTimeList = null,
    Object? workTimeMap = null,
  }) {
    return _then(_value.copyWith(
      workTimeList: null == workTimeList
          ? _value.workTimeList
          : workTimeList // ignore: cast_nullable_to_non_nullable
              as List<WorkTimeModel>,
      workTimeMap: null == workTimeMap
          ? _value.workTimeMap
          : workTimeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkTimeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkTimeStateImplCopyWith<$Res>
    implements $WorkTimeStateCopyWith<$Res> {
  factory _$$WorkTimeStateImplCopyWith(
          _$WorkTimeStateImpl value, $Res Function(_$WorkTimeStateImpl) then) =
      __$$WorkTimeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkTimeModel> workTimeList,
      Map<String, WorkTimeModel> workTimeMap});
}

/// @nodoc
class __$$WorkTimeStateImplCopyWithImpl<$Res>
    extends _$WorkTimeStateCopyWithImpl<$Res, _$WorkTimeStateImpl>
    implements _$$WorkTimeStateImplCopyWith<$Res> {
  __$$WorkTimeStateImplCopyWithImpl(
      _$WorkTimeStateImpl _value, $Res Function(_$WorkTimeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkTimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workTimeList = null,
    Object? workTimeMap = null,
  }) {
    return _then(_$WorkTimeStateImpl(
      workTimeList: null == workTimeList
          ? _value._workTimeList
          : workTimeList // ignore: cast_nullable_to_non_nullable
              as List<WorkTimeModel>,
      workTimeMap: null == workTimeMap
          ? _value._workTimeMap
          : workTimeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkTimeModel>,
    ));
  }
}

/// @nodoc

class _$WorkTimeStateImpl implements _WorkTimeState {
  const _$WorkTimeStateImpl(
      {final List<WorkTimeModel> workTimeList = const <WorkTimeModel>[],
      final Map<String, WorkTimeModel> workTimeMap =
          const <String, WorkTimeModel>{}})
      : _workTimeList = workTimeList,
        _workTimeMap = workTimeMap;

  final List<WorkTimeModel> _workTimeList;
  @override
  @JsonKey()
  List<WorkTimeModel> get workTimeList {
    if (_workTimeList is EqualUnmodifiableListView) return _workTimeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workTimeList);
  }

  final Map<String, WorkTimeModel> _workTimeMap;
  @override
  @JsonKey()
  Map<String, WorkTimeModel> get workTimeMap {
    if (_workTimeMap is EqualUnmodifiableMapView) return _workTimeMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_workTimeMap);
  }

  @override
  String toString() {
    return 'WorkTimeState(workTimeList: $workTimeList, workTimeMap: $workTimeMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkTimeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workTimeList, _workTimeList) &&
            const DeepCollectionEquality()
                .equals(other._workTimeMap, _workTimeMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workTimeList),
      const DeepCollectionEquality().hash(_workTimeMap));

  /// Create a copy of WorkTimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkTimeStateImplCopyWith<_$WorkTimeStateImpl> get copyWith =>
      __$$WorkTimeStateImplCopyWithImpl<_$WorkTimeStateImpl>(this, _$identity);
}

abstract class _WorkTimeState implements WorkTimeState {
  const factory _WorkTimeState(
      {final List<WorkTimeModel> workTimeList,
      final Map<String, WorkTimeModel> workTimeMap}) = _$WorkTimeStateImpl;

  @override
  List<WorkTimeModel> get workTimeList;
  @override
  Map<String, WorkTimeModel> get workTimeMap;

  /// Create a copy of WorkTimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkTimeStateImplCopyWith<_$WorkTimeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
