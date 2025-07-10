// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifetime.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LifetimeState {
  List<LifetimeModel> get lifetimeList => throw _privateConstructorUsedError;
  Map<String, LifetimeModel> get lifetimeMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of LifetimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LifetimeStateCopyWith<LifetimeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifetimeStateCopyWith<$Res> {
  factory $LifetimeStateCopyWith(
          LifetimeState value, $Res Function(LifetimeState) then) =
      _$LifetimeStateCopyWithImpl<$Res, LifetimeState>;
  @useResult
  $Res call(
      {List<LifetimeModel> lifetimeList,
      Map<String, LifetimeModel> lifetimeMap});
}

/// @nodoc
class _$LifetimeStateCopyWithImpl<$Res, $Val extends LifetimeState>
    implements $LifetimeStateCopyWith<$Res> {
  _$LifetimeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LifetimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifetimeList = null,
    Object? lifetimeMap = null,
  }) {
    return _then(_value.copyWith(
      lifetimeList: null == lifetimeList
          ? _value.lifetimeList
          : lifetimeList // ignore: cast_nullable_to_non_nullable
              as List<LifetimeModel>,
      lifetimeMap: null == lifetimeMap
          ? _value.lifetimeMap
          : lifetimeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, LifetimeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifetimeStateImplCopyWith<$Res>
    implements $LifetimeStateCopyWith<$Res> {
  factory _$$LifetimeStateImplCopyWith(
          _$LifetimeStateImpl value, $Res Function(_$LifetimeStateImpl) then) =
      __$$LifetimeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LifetimeModel> lifetimeList,
      Map<String, LifetimeModel> lifetimeMap});
}

/// @nodoc
class __$$LifetimeStateImplCopyWithImpl<$Res>
    extends _$LifetimeStateCopyWithImpl<$Res, _$LifetimeStateImpl>
    implements _$$LifetimeStateImplCopyWith<$Res> {
  __$$LifetimeStateImplCopyWithImpl(
      _$LifetimeStateImpl _value, $Res Function(_$LifetimeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LifetimeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifetimeList = null,
    Object? lifetimeMap = null,
  }) {
    return _then(_$LifetimeStateImpl(
      lifetimeList: null == lifetimeList
          ? _value._lifetimeList
          : lifetimeList // ignore: cast_nullable_to_non_nullable
              as List<LifetimeModel>,
      lifetimeMap: null == lifetimeMap
          ? _value._lifetimeMap
          : lifetimeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, LifetimeModel>,
    ));
  }
}

/// @nodoc

class _$LifetimeStateImpl implements _LifetimeState {
  const _$LifetimeStateImpl(
      {final List<LifetimeModel> lifetimeList = const <LifetimeModel>[],
      final Map<String, LifetimeModel> lifetimeMap =
          const <String, LifetimeModel>{}})
      : _lifetimeList = lifetimeList,
        _lifetimeMap = lifetimeMap;

  final List<LifetimeModel> _lifetimeList;
  @override
  @JsonKey()
  List<LifetimeModel> get lifetimeList {
    if (_lifetimeList is EqualUnmodifiableListView) return _lifetimeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lifetimeList);
  }

  final Map<String, LifetimeModel> _lifetimeMap;
  @override
  @JsonKey()
  Map<String, LifetimeModel> get lifetimeMap {
    if (_lifetimeMap is EqualUnmodifiableMapView) return _lifetimeMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lifetimeMap);
  }

  @override
  String toString() {
    return 'LifetimeState(lifetimeList: $lifetimeList, lifetimeMap: $lifetimeMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifetimeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._lifetimeList, _lifetimeList) &&
            const DeepCollectionEquality()
                .equals(other._lifetimeMap, _lifetimeMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_lifetimeList),
      const DeepCollectionEquality().hash(_lifetimeMap));

  /// Create a copy of LifetimeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LifetimeStateImplCopyWith<_$LifetimeStateImpl> get copyWith =>
      __$$LifetimeStateImplCopyWithImpl<_$LifetimeStateImpl>(this, _$identity);
}

abstract class _LifetimeState implements LifetimeState {
  const factory _LifetimeState(
      {final List<LifetimeModel> lifetimeList,
      final Map<String, LifetimeModel> lifetimeMap}) = _$LifetimeStateImpl;

  @override
  List<LifetimeModel> get lifetimeList;
  @override
  Map<String, LifetimeModel> get lifetimeMap;

  /// Create a copy of LifetimeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LifetimeStateImplCopyWith<_$LifetimeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
