// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkHistoryState {
  Map<String, WorkHistoryModel> get workHistoryModelMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkHistoryStateCopyWith<WorkHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkHistoryStateCopyWith<$Res> {
  factory $WorkHistoryStateCopyWith(
          WorkHistoryState value, $Res Function(WorkHistoryState) then) =
      _$WorkHistoryStateCopyWithImpl<$Res, WorkHistoryState>;
  @useResult
  $Res call({Map<String, WorkHistoryModel> workHistoryModelMap});
}

/// @nodoc
class _$WorkHistoryStateCopyWithImpl<$Res, $Val extends WorkHistoryState>
    implements $WorkHistoryStateCopyWith<$Res> {
  _$WorkHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workHistoryModelMap = null,
  }) {
    return _then(_value.copyWith(
      workHistoryModelMap: null == workHistoryModelMap
          ? _value.workHistoryModelMap
          : workHistoryModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkHistoryModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkHistoryStateImplCopyWith<$Res>
    implements $WorkHistoryStateCopyWith<$Res> {
  factory _$$WorkHistoryStateImplCopyWith(_$WorkHistoryStateImpl value,
          $Res Function(_$WorkHistoryStateImpl) then) =
      __$$WorkHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, WorkHistoryModel> workHistoryModelMap});
}

/// @nodoc
class __$$WorkHistoryStateImplCopyWithImpl<$Res>
    extends _$WorkHistoryStateCopyWithImpl<$Res, _$WorkHistoryStateImpl>
    implements _$$WorkHistoryStateImplCopyWith<$Res> {
  __$$WorkHistoryStateImplCopyWithImpl(_$WorkHistoryStateImpl _value,
      $Res Function(_$WorkHistoryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workHistoryModelMap = null,
  }) {
    return _then(_$WorkHistoryStateImpl(
      workHistoryModelMap: null == workHistoryModelMap
          ? _value._workHistoryModelMap
          : workHistoryModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WorkHistoryModel>,
    ));
  }
}

/// @nodoc

class _$WorkHistoryStateImpl implements _WorkHistoryState {
  const _$WorkHistoryStateImpl(
      {final Map<String, WorkHistoryModel> workHistoryModelMap =
          const <String, WorkHistoryModel>{}})
      : _workHistoryModelMap = workHistoryModelMap;

  final Map<String, WorkHistoryModel> _workHistoryModelMap;
  @override
  @JsonKey()
  Map<String, WorkHistoryModel> get workHistoryModelMap {
    if (_workHistoryModelMap is EqualUnmodifiableMapView)
      return _workHistoryModelMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_workHistoryModelMap);
  }

  @override
  String toString() {
    return 'WorkHistoryState(workHistoryModelMap: $workHistoryModelMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkHistoryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._workHistoryModelMap, _workHistoryModelMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_workHistoryModelMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkHistoryStateImplCopyWith<_$WorkHistoryStateImpl> get copyWith =>
      __$$WorkHistoryStateImplCopyWithImpl<_$WorkHistoryStateImpl>(
          this, _$identity);
}

abstract class _WorkHistoryState implements WorkHistoryState {
  const factory _WorkHistoryState(
          {final Map<String, WorkHistoryModel> workHistoryModelMap}) =
      _$WorkHistoryStateImpl;

  @override
  Map<String, WorkHistoryModel> get workHistoryModelMap;
  @override
  @JsonKey(ignore: true)
  _$$WorkHistoryStateImplCopyWith<_$WorkHistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
