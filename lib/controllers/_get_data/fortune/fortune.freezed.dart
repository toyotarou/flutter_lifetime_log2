// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fortune.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FortuneState {
  List<FortuneModel> get fortuneList => throw _privateConstructorUsedError;
  Map<String, FortuneModel> get fortuneMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FortuneStateCopyWith<FortuneState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FortuneStateCopyWith<$Res> {
  factory $FortuneStateCopyWith(
          FortuneState value, $Res Function(FortuneState) then) =
      _$FortuneStateCopyWithImpl<$Res, FortuneState>;
  @useResult
  $Res call(
      {List<FortuneModel> fortuneList, Map<String, FortuneModel> fortuneMap});
}

/// @nodoc
class _$FortuneStateCopyWithImpl<$Res, $Val extends FortuneState>
    implements $FortuneStateCopyWith<$Res> {
  _$FortuneStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fortuneList = null,
    Object? fortuneMap = null,
  }) {
    return _then(_value.copyWith(
      fortuneList: null == fortuneList
          ? _value.fortuneList
          : fortuneList // ignore: cast_nullable_to_non_nullable
              as List<FortuneModel>,
      fortuneMap: null == fortuneMap
          ? _value.fortuneMap
          : fortuneMap // ignore: cast_nullable_to_non_nullable
              as Map<String, FortuneModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FortuneStateImplCopyWith<$Res>
    implements $FortuneStateCopyWith<$Res> {
  factory _$$FortuneStateImplCopyWith(
          _$FortuneStateImpl value, $Res Function(_$FortuneStateImpl) then) =
      __$$FortuneStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FortuneModel> fortuneList, Map<String, FortuneModel> fortuneMap});
}

/// @nodoc
class __$$FortuneStateImplCopyWithImpl<$Res>
    extends _$FortuneStateCopyWithImpl<$Res, _$FortuneStateImpl>
    implements _$$FortuneStateImplCopyWith<$Res> {
  __$$FortuneStateImplCopyWithImpl(
      _$FortuneStateImpl _value, $Res Function(_$FortuneStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fortuneList = null,
    Object? fortuneMap = null,
  }) {
    return _then(_$FortuneStateImpl(
      fortuneList: null == fortuneList
          ? _value._fortuneList
          : fortuneList // ignore: cast_nullable_to_non_nullable
              as List<FortuneModel>,
      fortuneMap: null == fortuneMap
          ? _value._fortuneMap
          : fortuneMap // ignore: cast_nullable_to_non_nullable
              as Map<String, FortuneModel>,
    ));
  }
}

/// @nodoc

class _$FortuneStateImpl implements _FortuneState {
  const _$FortuneStateImpl(
      {final List<FortuneModel> fortuneList = const <FortuneModel>[],
      final Map<String, FortuneModel> fortuneMap =
          const <String, FortuneModel>{}})
      : _fortuneList = fortuneList,
        _fortuneMap = fortuneMap;

  final List<FortuneModel> _fortuneList;
  @override
  @JsonKey()
  List<FortuneModel> get fortuneList {
    if (_fortuneList is EqualUnmodifiableListView) return _fortuneList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fortuneList);
  }

  final Map<String, FortuneModel> _fortuneMap;
  @override
  @JsonKey()
  Map<String, FortuneModel> get fortuneMap {
    if (_fortuneMap is EqualUnmodifiableMapView) return _fortuneMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fortuneMap);
  }

  @override
  String toString() {
    return 'FortuneState(fortuneList: $fortuneList, fortuneMap: $fortuneMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FortuneStateImpl &&
            const DeepCollectionEquality()
                .equals(other._fortuneList, _fortuneList) &&
            const DeepCollectionEquality()
                .equals(other._fortuneMap, _fortuneMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_fortuneList),
      const DeepCollectionEquality().hash(_fortuneMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FortuneStateImplCopyWith<_$FortuneStateImpl> get copyWith =>
      __$$FortuneStateImplCopyWithImpl<_$FortuneStateImpl>(this, _$identity);
}

abstract class _FortuneState implements FortuneState {
  const factory _FortuneState(
      {final List<FortuneModel> fortuneList,
      final Map<String, FortuneModel> fortuneMap}) = _$FortuneStateImpl;

  @override
  List<FortuneModel> get fortuneList;
  @override
  Map<String, FortuneModel> get fortuneMap;
  @override
  @JsonKey(ignore: true)
  _$$FortuneStateImplCopyWith<_$FortuneStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
