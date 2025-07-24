// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TempleState {
  List<TempleModel> get templeList => throw _privateConstructorUsedError;
  Map<String, TempleModel> get templeMap => throw _privateConstructorUsedError;

  /// Create a copy of TempleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TempleStateCopyWith<TempleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempleStateCopyWith<$Res> {
  factory $TempleStateCopyWith(
          TempleState value, $Res Function(TempleState) then) =
      _$TempleStateCopyWithImpl<$Res, TempleState>;
  @useResult
  $Res call({List<TempleModel> templeList, Map<String, TempleModel> templeMap});
}

/// @nodoc
class _$TempleStateCopyWithImpl<$Res, $Val extends TempleState>
    implements $TempleStateCopyWith<$Res> {
  _$TempleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TempleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeList = null,
    Object? templeMap = null,
  }) {
    return _then(_value.copyWith(
      templeList: null == templeList
          ? _value.templeList
          : templeList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      templeMap: null == templeMap
          ? _value.templeMap
          : templeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TempleStateImplCopyWith<$Res>
    implements $TempleStateCopyWith<$Res> {
  factory _$$TempleStateImplCopyWith(
          _$TempleStateImpl value, $Res Function(_$TempleStateImpl) then) =
      __$$TempleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TempleModel> templeList, Map<String, TempleModel> templeMap});
}

/// @nodoc
class __$$TempleStateImplCopyWithImpl<$Res>
    extends _$TempleStateCopyWithImpl<$Res, _$TempleStateImpl>
    implements _$$TempleStateImplCopyWith<$Res> {
  __$$TempleStateImplCopyWithImpl(
      _$TempleStateImpl _value, $Res Function(_$TempleStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TempleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeList = null,
    Object? templeMap = null,
  }) {
    return _then(_$TempleStateImpl(
      templeList: null == templeList
          ? _value._templeList
          : templeList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      templeMap: null == templeMap
          ? _value._templeMap
          : templeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleModel>,
    ));
  }
}

/// @nodoc

class _$TempleStateImpl implements _TempleState {
  const _$TempleStateImpl(
      {final List<TempleModel> templeList = const <TempleModel>[],
      final Map<String, TempleModel> templeMap = const <String, TempleModel>{}})
      : _templeList = templeList,
        _templeMap = templeMap;

  final List<TempleModel> _templeList;
  @override
  @JsonKey()
  List<TempleModel> get templeList {
    if (_templeList is EqualUnmodifiableListView) return _templeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templeList);
  }

  final Map<String, TempleModel> _templeMap;
  @override
  @JsonKey()
  Map<String, TempleModel> get templeMap {
    if (_templeMap is EqualUnmodifiableMapView) return _templeMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_templeMap);
  }

  @override
  String toString() {
    return 'TempleState(templeList: $templeList, templeMap: $templeMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TempleStateImpl &&
            const DeepCollectionEquality()
                .equals(other._templeList, _templeList) &&
            const DeepCollectionEquality()
                .equals(other._templeMap, _templeMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_templeList),
      const DeepCollectionEquality().hash(_templeMap));

  /// Create a copy of TempleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TempleStateImplCopyWith<_$TempleStateImpl> get copyWith =>
      __$$TempleStateImplCopyWithImpl<_$TempleStateImpl>(this, _$identity);
}

abstract class _TempleState implements TempleState {
  const factory _TempleState(
      {final List<TempleModel> templeList,
      final Map<String, TempleModel> templeMap}) = _$TempleStateImpl;

  @override
  List<TempleModel> get templeList;
  @override
  Map<String, TempleModel> get templeMap;

  /// Create a copy of TempleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TempleStateImplCopyWith<_$TempleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
