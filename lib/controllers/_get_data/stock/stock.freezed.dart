// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StockState {
  List<StockModel> get stockList => throw _privateConstructorUsedError;
  Map<String, List<StockModel>> get stockMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of StockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockStateCopyWith<StockState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockStateCopyWith<$Res> {
  factory $StockStateCopyWith(
          StockState value, $Res Function(StockState) then) =
      _$StockStateCopyWithImpl<$Res, StockState>;
  @useResult
  $Res call(
      {List<StockModel> stockList, Map<String, List<StockModel>> stockMap});
}

/// @nodoc
class _$StockStateCopyWithImpl<$Res, $Val extends StockState>
    implements $StockStateCopyWith<$Res> {
  _$StockStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockList = null,
    Object? stockMap = null,
  }) {
    return _then(_value.copyWith(
      stockList: null == stockList
          ? _value.stockList
          : stockList // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      stockMap: null == stockMap
          ? _value.stockMap
          : stockMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StockModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockStateImplCopyWith<$Res>
    implements $StockStateCopyWith<$Res> {
  factory _$$StockStateImplCopyWith(
          _$StockStateImpl value, $Res Function(_$StockStateImpl) then) =
      __$$StockStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StockModel> stockList, Map<String, List<StockModel>> stockMap});
}

/// @nodoc
class __$$StockStateImplCopyWithImpl<$Res>
    extends _$StockStateCopyWithImpl<$Res, _$StockStateImpl>
    implements _$$StockStateImplCopyWith<$Res> {
  __$$StockStateImplCopyWithImpl(
      _$StockStateImpl _value, $Res Function(_$StockStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockList = null,
    Object? stockMap = null,
  }) {
    return _then(_$StockStateImpl(
      stockList: null == stockList
          ? _value._stockList
          : stockList // ignore: cast_nullable_to_non_nullable
              as List<StockModel>,
      stockMap: null == stockMap
          ? _value._stockMap
          : stockMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StockModel>>,
    ));
  }
}

/// @nodoc

class _$StockStateImpl implements _StockState {
  const _$StockStateImpl(
      {final List<StockModel> stockList = const <StockModel>[],
      final Map<String, List<StockModel>> stockMap =
          const <String, List<StockModel>>{}})
      : _stockList = stockList,
        _stockMap = stockMap;

  final List<StockModel> _stockList;
  @override
  @JsonKey()
  List<StockModel> get stockList {
    if (_stockList is EqualUnmodifiableListView) return _stockList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockList);
  }

  final Map<String, List<StockModel>> _stockMap;
  @override
  @JsonKey()
  Map<String, List<StockModel>> get stockMap {
    if (_stockMap is EqualUnmodifiableMapView) return _stockMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stockMap);
  }

  @override
  String toString() {
    return 'StockState(stockList: $stockList, stockMap: $stockMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockStateImpl &&
            const DeepCollectionEquality()
                .equals(other._stockList, _stockList) &&
            const DeepCollectionEquality().equals(other._stockMap, _stockMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stockList),
      const DeepCollectionEquality().hash(_stockMap));

  /// Create a copy of StockState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockStateImplCopyWith<_$StockStateImpl> get copyWith =>
      __$$StockStateImplCopyWithImpl<_$StockStateImpl>(this, _$identity);
}

abstract class _StockState implements StockState {
  const factory _StockState(
      {final List<StockModel> stockList,
      final Map<String, List<StockModel>> stockMap}) = _$StockStateImpl;

  @override
  List<StockModel> get stockList;
  @override
  Map<String, List<StockModel>> get stockMap;

  /// Create a copy of StockState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockStateImplCopyWith<_$StockStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
