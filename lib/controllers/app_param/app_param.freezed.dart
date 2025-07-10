// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamState {
  Map<String, WalkModel> get keepWalkModelMap =>
      throw _privateConstructorUsedError;
  Map<String, MoneyModel> get keepMoneyMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamStateCopyWith<AppParamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamStateCopyWith<$Res> {
  factory $AppParamStateCopyWith(
          AppParamState value, $Res Function(AppParamState) then) =
      _$AppParamStateCopyWithImpl<$Res, AppParamState>;
  @useResult
  $Res call(
      {Map<String, WalkModel> keepWalkModelMap,
      Map<String, MoneyModel> keepMoneyMap});
}

/// @nodoc
class _$AppParamStateCopyWithImpl<$Res, $Val extends AppParamState>
    implements $AppParamStateCopyWith<$Res> {
  _$AppParamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keepWalkModelMap = null,
    Object? keepMoneyMap = null,
  }) {
    return _then(_value.copyWith(
      keepWalkModelMap: null == keepWalkModelMap
          ? _value.keepWalkModelMap
          : keepWalkModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkModel>,
      keepMoneyMap: null == keepMoneyMap
          ? _value.keepMoneyMap
          : keepMoneyMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneyModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamStateImplCopyWith<$Res>
    implements $AppParamStateCopyWith<$Res> {
  factory _$$AppParamStateImplCopyWith(
          _$AppParamStateImpl value, $Res Function(_$AppParamStateImpl) then) =
      __$$AppParamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, WalkModel> keepWalkModelMap,
      Map<String, MoneyModel> keepMoneyMap});
}

/// @nodoc
class __$$AppParamStateImplCopyWithImpl<$Res>
    extends _$AppParamStateCopyWithImpl<$Res, _$AppParamStateImpl>
    implements _$$AppParamStateImplCopyWith<$Res> {
  __$$AppParamStateImplCopyWithImpl(
      _$AppParamStateImpl _value, $Res Function(_$AppParamStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keepWalkModelMap = null,
    Object? keepMoneyMap = null,
  }) {
    return _then(_$AppParamStateImpl(
      keepWalkModelMap: null == keepWalkModelMap
          ? _value._keepWalkModelMap
          : keepWalkModelMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkModel>,
      keepMoneyMap: null == keepMoneyMap
          ? _value._keepMoneyMap
          : keepMoneyMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneyModel>,
    ));
  }
}

/// @nodoc

class _$AppParamStateImpl implements _AppParamState {
  const _$AppParamStateImpl(
      {final Map<String, WalkModel> keepWalkModelMap =
          const <String, WalkModel>{},
      final Map<String, MoneyModel> keepMoneyMap =
          const <String, MoneyModel>{}})
      : _keepWalkModelMap = keepWalkModelMap,
        _keepMoneyMap = keepMoneyMap;

  final Map<String, WalkModel> _keepWalkModelMap;
  @override
  @JsonKey()
  Map<String, WalkModel> get keepWalkModelMap {
    if (_keepWalkModelMap is EqualUnmodifiableMapView) return _keepWalkModelMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keepWalkModelMap);
  }

  final Map<String, MoneyModel> _keepMoneyMap;
  @override
  @JsonKey()
  Map<String, MoneyModel> get keepMoneyMap {
    if (_keepMoneyMap is EqualUnmodifiableMapView) return _keepMoneyMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keepMoneyMap);
  }

  @override
  String toString() {
    return 'AppParamState(keepWalkModelMap: $keepWalkModelMap, keepMoneyMap: $keepMoneyMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamStateImpl &&
            const DeepCollectionEquality()
                .equals(other._keepWalkModelMap, _keepWalkModelMap) &&
            const DeepCollectionEquality()
                .equals(other._keepMoneyMap, _keepMoneyMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keepWalkModelMap),
      const DeepCollectionEquality().hash(_keepMoneyMap));

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      __$$AppParamStateImplCopyWithImpl<_$AppParamStateImpl>(this, _$identity);
}

abstract class _AppParamState implements AppParamState {
  const factory _AppParamState(
      {final Map<String, WalkModel> keepWalkModelMap,
      final Map<String, MoneyModel> keepMoneyMap}) = _$AppParamStateImpl;

  @override
  Map<String, WalkModel> get keepWalkModelMap;
  @override
  Map<String, MoneyModel> get keepMoneyMap;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
