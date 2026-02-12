// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gold.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoldState {
  List<GoldModel> get goldList => throw _privateConstructorUsedError;
  Map<String, GoldModel> get goldMap => throw _privateConstructorUsedError;
  bool get goldFlag => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GoldStateCopyWith<GoldState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoldStateCopyWith<$Res> {
  factory $GoldStateCopyWith(GoldState value, $Res Function(GoldState) then) =
      _$GoldStateCopyWithImpl<$Res, GoldState>;
  @useResult
  $Res call(
      {List<GoldModel> goldList,
      Map<String, GoldModel> goldMap,
      bool goldFlag});
}

/// @nodoc
class _$GoldStateCopyWithImpl<$Res, $Val extends GoldState>
    implements $GoldStateCopyWith<$Res> {
  _$GoldStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goldList = null,
    Object? goldMap = null,
    Object? goldFlag = null,
  }) {
    return _then(_value.copyWith(
      goldList: null == goldList
          ? _value.goldList
          : goldList // ignore: cast_nullable_to_non_nullable
              as List<GoldModel>,
      goldMap: null == goldMap
          ? _value.goldMap
          : goldMap // ignore: cast_nullable_to_non_nullable
              as Map<String, GoldModel>,
      goldFlag: null == goldFlag
          ? _value.goldFlag
          : goldFlag // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoldStateImplCopyWith<$Res>
    implements $GoldStateCopyWith<$Res> {
  factory _$$GoldStateImplCopyWith(
          _$GoldStateImpl value, $Res Function(_$GoldStateImpl) then) =
      __$$GoldStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GoldModel> goldList,
      Map<String, GoldModel> goldMap,
      bool goldFlag});
}

/// @nodoc
class __$$GoldStateImplCopyWithImpl<$Res>
    extends _$GoldStateCopyWithImpl<$Res, _$GoldStateImpl>
    implements _$$GoldStateImplCopyWith<$Res> {
  __$$GoldStateImplCopyWithImpl(
      _$GoldStateImpl _value, $Res Function(_$GoldStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goldList = null,
    Object? goldMap = null,
    Object? goldFlag = null,
  }) {
    return _then(_$GoldStateImpl(
      goldList: null == goldList
          ? _value._goldList
          : goldList // ignore: cast_nullable_to_non_nullable
              as List<GoldModel>,
      goldMap: null == goldMap
          ? _value._goldMap
          : goldMap // ignore: cast_nullable_to_non_nullable
              as Map<String, GoldModel>,
      goldFlag: null == goldFlag
          ? _value.goldFlag
          : goldFlag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GoldStateImpl implements _GoldState {
  const _$GoldStateImpl(
      {final List<GoldModel> goldList = const <GoldModel>[],
      final Map<String, GoldModel> goldMap = const <String, GoldModel>{},
      this.goldFlag = false})
      : _goldList = goldList,
        _goldMap = goldMap;

  final List<GoldModel> _goldList;
  @override
  @JsonKey()
  List<GoldModel> get goldList {
    if (_goldList is EqualUnmodifiableListView) return _goldList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goldList);
  }

  final Map<String, GoldModel> _goldMap;
  @override
  @JsonKey()
  Map<String, GoldModel> get goldMap {
    if (_goldMap is EqualUnmodifiableMapView) return _goldMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_goldMap);
  }

  @override
  @JsonKey()
  final bool goldFlag;

  @override
  String toString() {
    return 'GoldState(goldList: $goldList, goldMap: $goldMap, goldFlag: $goldFlag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoldStateImpl &&
            const DeepCollectionEquality().equals(other._goldList, _goldList) &&
            const DeepCollectionEquality().equals(other._goldMap, _goldMap) &&
            (identical(other.goldFlag, goldFlag) ||
                other.goldFlag == goldFlag));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_goldList),
      const DeepCollectionEquality().hash(_goldMap),
      goldFlag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoldStateImplCopyWith<_$GoldStateImpl> get copyWith =>
      __$$GoldStateImplCopyWithImpl<_$GoldStateImpl>(this, _$identity);
}

abstract class _GoldState implements GoldState {
  const factory _GoldState(
      {final List<GoldModel> goldList,
      final Map<String, GoldModel> goldMap,
      final bool goldFlag}) = _$GoldStateImpl;

  @override
  List<GoldModel> get goldList;
  @override
  Map<String, GoldModel> get goldMap;
  @override
  bool get goldFlag;
  @override
  @JsonKey(ignore: true)
  _$$GoldStateImplCopyWith<_$GoldStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
