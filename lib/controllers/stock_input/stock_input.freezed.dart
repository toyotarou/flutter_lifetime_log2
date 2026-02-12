// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockInputState {
  List<WalkModel> get walkList => throw _privateConstructorUsedError;
  Map<String, WalkModel> get walkMap => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StockInputStateCopyWith<StockInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockInputStateCopyWith<$Res> {
  factory $StockInputStateCopyWith(
          StockInputState value, $Res Function(StockInputState) then) =
      _$StockInputStateCopyWithImpl<$Res, StockInputState>;
  @useResult
  $Res call({List<WalkModel> walkList, Map<String, WalkModel> walkMap});
}

/// @nodoc
class _$StockInputStateCopyWithImpl<$Res, $Val extends StockInputState>
    implements $StockInputStateCopyWith<$Res> {
  _$StockInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
abstract class _$$StockInputStateImplCopyWith<$Res>
    implements $StockInputStateCopyWith<$Res> {
  factory _$$StockInputStateImplCopyWith(_$StockInputStateImpl value,
          $Res Function(_$StockInputStateImpl) then) =
      __$$StockInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WalkModel> walkList, Map<String, WalkModel> walkMap});
}

/// @nodoc
class __$$StockInputStateImplCopyWithImpl<$Res>
    extends _$StockInputStateCopyWithImpl<$Res, _$StockInputStateImpl>
    implements _$$StockInputStateImplCopyWith<$Res> {
  __$$StockInputStateImplCopyWithImpl(
      _$StockInputStateImpl _value, $Res Function(_$StockInputStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walkList = null,
    Object? walkMap = null,
  }) {
    return _then(_$StockInputStateImpl(
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

class _$StockInputStateImpl implements _StockInputState {
  const _$StockInputStateImpl(
      {final List<WalkModel> walkList = const <WalkModel>[],
      final Map<String, WalkModel> walkMap = const <String, WalkModel>{}})
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
    return 'StockInputState(walkList: $walkList, walkMap: $walkMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockInputStateImpl &&
            const DeepCollectionEquality().equals(other._walkList, _walkList) &&
            const DeepCollectionEquality().equals(other._walkMap, _walkMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_walkList),
      const DeepCollectionEquality().hash(_walkMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockInputStateImplCopyWith<_$StockInputStateImpl> get copyWith =>
      __$$StockInputStateImplCopyWithImpl<_$StockInputStateImpl>(
          this, _$identity);
}

abstract class _StockInputState implements StockInputState {
  const factory _StockInputState(
      {final List<WalkModel> walkList,
      final Map<String, WalkModel> walkMap}) = _$StockInputStateImpl;

  @override
  List<WalkModel> get walkList;
  @override
  Map<String, WalkModel> get walkMap;
  @override
  @JsonKey(ignore: true)
  _$$StockInputStateImplCopyWith<_$StockInputStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
