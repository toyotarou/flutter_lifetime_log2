// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_truth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkTruthState {
  Map<String, WorkTruthModel> get workTruthModelMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of WorkTruthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkTruthStateCopyWith<WorkTruthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkTruthStateCopyWith<$Res> {
  factory $WorkTruthStateCopyWith(
          WorkTruthState value, $Res Function(WorkTruthState) then) =
      _$WorkTruthStateCopyWithImpl<$Res, WorkTruthState>;
  @useResult
  $Res call({Map<String, WorkTruthModel> workTruthModelMap});
}

/// @nodoc
class _$WorkTruthStateCopyWithImpl<$Res, $Val extends WorkTruthState>
    implements $WorkTruthStateCopyWith<$Res> {
  _$WorkTruthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkTruthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workTruthModelMap = null,
  }) {
    return _then(_value.copyWith(
      workTruthModelMap: null == workTruthModelMap
          ? _value.workTruthModelMap
          : workTruthModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkTruthModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkTruthStateImplCopyWith<$Res>
    implements $WorkTruthStateCopyWith<$Res> {
  factory _$$WorkTruthStateImplCopyWith(_$WorkTruthStateImpl value,
          $Res Function(_$WorkTruthStateImpl) then) =
      __$$WorkTruthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, WorkTruthModel> workTruthModelMap});
}

/// @nodoc
class __$$WorkTruthStateImplCopyWithImpl<$Res>
    extends _$WorkTruthStateCopyWithImpl<$Res, _$WorkTruthStateImpl>
    implements _$$WorkTruthStateImplCopyWith<$Res> {
  __$$WorkTruthStateImplCopyWithImpl(
      _$WorkTruthStateImpl _value, $Res Function(_$WorkTruthStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkTruthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workTruthModelMap = null,
  }) {
    return _then(_$WorkTruthStateImpl(
      workTruthModelMap: null == workTruthModelMap
          ? _value._workTruthModelMap
          : workTruthModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkTruthModel>,
    ));
  }
}

/// @nodoc

class _$WorkTruthStateImpl implements _WorkTruthState {
  const _$WorkTruthStateImpl(
      {final Map<String, WorkTruthModel> workTruthModelMap =
          const <String, WorkTruthModel>{}})
      : _workTruthModelMap = workTruthModelMap;

  final Map<String, WorkTruthModel> _workTruthModelMap;
  @override
  @JsonKey()
  Map<String, WorkTruthModel> get workTruthModelMap {
    if (_workTruthModelMap is EqualUnmodifiableMapView)
      return _workTruthModelMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_workTruthModelMap);
  }

  @override
  String toString() {
    return 'WorkTruthState(workTruthModelMap: $workTruthModelMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkTruthStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workTruthModelMap, _workTruthModelMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_workTruthModelMap));

  /// Create a copy of WorkTruthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkTruthStateImplCopyWith<_$WorkTruthStateImpl> get copyWith =>
      __$$WorkTruthStateImplCopyWithImpl<_$WorkTruthStateImpl>(
          this, _$identity);
}

abstract class _WorkTruthState implements WorkTruthState {
  const factory _WorkTruthState(
          {final Map<String, WorkTruthModel> workTruthModelMap}) =
      _$WorkTruthStateImpl;

  @override
  Map<String, WorkTruthModel> get workTruthModelMap;

  /// Create a copy of WorkTruthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkTruthStateImplCopyWith<_$WorkTruthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
