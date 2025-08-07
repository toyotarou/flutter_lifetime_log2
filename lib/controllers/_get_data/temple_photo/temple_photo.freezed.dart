// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temple_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TemplePhotoState {
  List<TemplePhotoModel> get templePhotoList =>
      throw _privateConstructorUsedError;
  Map<String, List<TemplePhotoModel>> get templePhotoMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of TemplePhotoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplePhotoStateCopyWith<TemplePhotoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplePhotoStateCopyWith<$Res> {
  factory $TemplePhotoStateCopyWith(
          TemplePhotoState value, $Res Function(TemplePhotoState) then) =
      _$TemplePhotoStateCopyWithImpl<$Res, TemplePhotoState>;
  @useResult
  $Res call(
      {List<TemplePhotoModel> templePhotoList,
      Map<String, List<TemplePhotoModel>> templePhotoMap});
}

/// @nodoc
class _$TemplePhotoStateCopyWithImpl<$Res, $Val extends TemplePhotoState>
    implements $TemplePhotoStateCopyWith<$Res> {
  _$TemplePhotoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplePhotoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templePhotoList = null,
    Object? templePhotoMap = null,
  }) {
    return _then(_value.copyWith(
      templePhotoList: null == templePhotoList
          ? _value.templePhotoList
          : templePhotoList // ignore: cast_nullable_to_non_nullable
              as List<TemplePhotoModel>,
      templePhotoMap: null == templePhotoMap
          ? _value.templePhotoMap
          : templePhotoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TemplePhotoModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplePhotoStateImplCopyWith<$Res>
    implements $TemplePhotoStateCopyWith<$Res> {
  factory _$$TemplePhotoStateImplCopyWith(_$TemplePhotoStateImpl value,
          $Res Function(_$TemplePhotoStateImpl) then) =
      __$$TemplePhotoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TemplePhotoModel> templePhotoList,
      Map<String, List<TemplePhotoModel>> templePhotoMap});
}

/// @nodoc
class __$$TemplePhotoStateImplCopyWithImpl<$Res>
    extends _$TemplePhotoStateCopyWithImpl<$Res, _$TemplePhotoStateImpl>
    implements _$$TemplePhotoStateImplCopyWith<$Res> {
  __$$TemplePhotoStateImplCopyWithImpl(_$TemplePhotoStateImpl _value,
      $Res Function(_$TemplePhotoStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplePhotoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templePhotoList = null,
    Object? templePhotoMap = null,
  }) {
    return _then(_$TemplePhotoStateImpl(
      templePhotoList: null == templePhotoList
          ? _value._templePhotoList
          : templePhotoList // ignore: cast_nullable_to_non_nullable
              as List<TemplePhotoModel>,
      templePhotoMap: null == templePhotoMap
          ? _value._templePhotoMap
          : templePhotoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TemplePhotoModel>>,
    ));
  }
}

/// @nodoc

class _$TemplePhotoStateImpl implements _TemplePhotoState {
  const _$TemplePhotoStateImpl(
      {final List<TemplePhotoModel> templePhotoList =
          const <TemplePhotoModel>[],
      final Map<String, List<TemplePhotoModel>> templePhotoMap =
          const <String, List<TemplePhotoModel>>{}})
      : _templePhotoList = templePhotoList,
        _templePhotoMap = templePhotoMap;

  final List<TemplePhotoModel> _templePhotoList;
  @override
  @JsonKey()
  List<TemplePhotoModel> get templePhotoList {
    if (_templePhotoList is EqualUnmodifiableListView) return _templePhotoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templePhotoList);
  }

  final Map<String, List<TemplePhotoModel>> _templePhotoMap;
  @override
  @JsonKey()
  Map<String, List<TemplePhotoModel>> get templePhotoMap {
    if (_templePhotoMap is EqualUnmodifiableMapView) return _templePhotoMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_templePhotoMap);
  }

  @override
  String toString() {
    return 'TemplePhotoState(templePhotoList: $templePhotoList, templePhotoMap: $templePhotoMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplePhotoStateImpl &&
            const DeepCollectionEquality()
                .equals(other._templePhotoList, _templePhotoList) &&
            const DeepCollectionEquality()
                .equals(other._templePhotoMap, _templePhotoMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_templePhotoList),
      const DeepCollectionEquality().hash(_templePhotoMap));

  /// Create a copy of TemplePhotoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplePhotoStateImplCopyWith<_$TemplePhotoStateImpl> get copyWith =>
      __$$TemplePhotoStateImplCopyWithImpl<_$TemplePhotoStateImpl>(
          this, _$identity);
}

abstract class _TemplePhotoState implements TemplePhotoState {
  const factory _TemplePhotoState(
          {final List<TemplePhotoModel> templePhotoList,
          final Map<String, List<TemplePhotoModel>> templePhotoMap}) =
      _$TemplePhotoStateImpl;

  @override
  List<TemplePhotoModel> get templePhotoList;
  @override
  Map<String, List<TemplePhotoModel>> get templePhotoMap;

  /// Create a copy of TemplePhotoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplePhotoStateImplCopyWith<_$TemplePhotoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
