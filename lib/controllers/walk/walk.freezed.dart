// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalkState {
  List<WalkModel> get walkList => throw _privateConstructorUsedError;
  Map<String, WalkModel> get walkMap => throw _privateConstructorUsedError;

  /// Create a copy of WalkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalkStateCopyWith<WalkState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalkStateCopyWith<$Res> {
  factory $WalkStateCopyWith(WalkState value, $Res Function(WalkState) then) =
      _$WalkStateCopyWithImpl<$Res, WalkState>;
  @useResult
  $Res call({List<WalkModel> walkList, Map<String, WalkModel> walkMap});
}

/// @nodoc
class _$WalkStateCopyWithImpl<$Res, $Val extends WalkState>
    implements $WalkStateCopyWith<$Res> {
  _$WalkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walkList = null,
    Object? walkMap = null,
  }) {
    return _then(_value.copyWith(
      walkList: null == walkList
          ? _value.walkList
          : walkList // ignore: cast_nullable_to_non_nullable
              as List<WalkModel>,
      walkMap: null == walkMap
          ? _value.walkMap
          : walkMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalkStateImplCopyWith<$Res>
    implements $WalkStateCopyWith<$Res> {
  factory _$$WalkStateImplCopyWith(
          _$WalkStateImpl value, $Res Function(_$WalkStateImpl) then) =
      __$$WalkStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WalkModel> walkList, Map<String, WalkModel> walkMap});
}

/// @nodoc
class __$$WalkStateImplCopyWithImpl<$Res>
    extends _$WalkStateCopyWithImpl<$Res, _$WalkStateImpl>
    implements _$$WalkStateImplCopyWith<$Res> {
  __$$WalkStateImplCopyWithImpl(
      _$WalkStateImpl _value, $Res Function(_$WalkStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walkList = null,
    Object? walkMap = null,
  }) {
    return _then(_$WalkStateImpl(
      walkList: null == walkList
          ? _value._walkList
          : walkList // ignore: cast_nullable_to_non_nullable
              as List<WalkModel>,
      walkMap: null == walkMap
          ? _value._walkMap
          : walkMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkModel>,
    ));
  }
}

/// @nodoc

class _$WalkStateImpl implements _WalkState {
  const _$WalkStateImpl(
      {final List<WalkModel> walkList = const [],
      final Map<String, WalkModel> walkMap = const {}})
      : _walkList = walkList,
        _walkMap = walkMap;

  final List<WalkModel> _walkList;
  @override
  @JsonKey()
  List<WalkModel> get walkList {
    if (_walkList is EqualUnmodifiableListView) return _walkList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_walkList);
  }

  final Map<String, WalkModel> _walkMap;
  @override
  @JsonKey()
  Map<String, WalkModel> get walkMap {
    if (_walkMap is EqualUnmodifiableMapView) return _walkMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_walkMap);
  }

  @override
  String toString() {
    return 'WalkState(walkList: $walkList, walkMap: $walkMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalkStateImpl &&
            const DeepCollectionEquality().equals(other._walkList, _walkList) &&
            const DeepCollectionEquality().equals(other._walkMap, _walkMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_walkList),
      const DeepCollectionEquality().hash(_walkMap));

  /// Create a copy of WalkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalkStateImplCopyWith<_$WalkStateImpl> get copyWith =>
      __$$WalkStateImplCopyWithImpl<_$WalkStateImpl>(this, _$identity);
}

abstract class _WalkState implements WalkState {
  const factory _WalkState(
      {final List<WalkModel> walkList,
      final Map<String, WalkModel> walkMap}) = _$WalkStateImpl;

  @override
  List<WalkModel> get walkList;
  @override
  Map<String, WalkModel> get walkMap;

  /// Create a copy of WalkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalkStateImplCopyWith<_$WalkStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
