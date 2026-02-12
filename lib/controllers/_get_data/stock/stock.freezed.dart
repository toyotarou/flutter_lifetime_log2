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
  Map<String, List<StockModel>> get stockTickerMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {List<StockModel> stockList,
      Map<String, List<StockModel>> stockMap,
      Map<String, List<StockModel>> stockTickerMap});
}

/// @nodoc
class _$StockStateCopyWithImpl<$Res, $Val extends StockState>
    implements $StockStateCopyWith<$Res> {
  _$StockStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockList = null,
    Object? stockMap = null,
    Object? stockTickerMap = null,
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
      stockTickerMap: null == stockTickerMap
          ? _value.stockTickerMap
          : stockTickerMap // ignore: cast_nullable_to_non_nullable
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
      {List<StockModel> stockList,
      Map<String, List<StockModel>> stockMap,
      Map<String, List<StockModel>> stockTickerMap});
}

/// @nodoc
class __$$StockStateImplCopyWithImpl<$Res>
    extends _$StockStateCopyWithImpl<$Res, _$StockStateImpl>
    implements _$$StockStateImplCopyWith<$Res> {
  __$$StockStateImplCopyWithImpl(
      _$StockStateImpl _value, $Res Function(_$StockStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockList = null,
    Object? stockMap = null,
    Object? stockTickerMap = null,
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
      stockTickerMap: null == stockTickerMap
          ? _value._stockTickerMap
          : stockTickerMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<StockModel>>,
    ));
  }
}

/// @nodoc

class _$StockStateImpl implements _StockState {
  const _$StockStateImpl(
      {final List<StockModel> stockList = const <StockModel>[],
      final Map<String, List<StockModel>> stockMap =
          const <String, List<StockModel>>{},
      final Map<String, List<StockModel>> stockTickerMap =
          const <String, List<StockModel>>{}})
      : _stockList = stockList,
        _stockMap = stockMap,
        _stockTickerMap = stockTickerMap;

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

  final Map<String, List<StockModel>> _stockTickerMap;
  @override
  @JsonKey()
  Map<String, List<StockModel>> get stockTickerMap {
    if (_stockTickerMap is EqualUnmodifiableMapView) return _stockTickerMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stockTickerMap);
  }

  @override
  String toString() {
    return 'StockState(stockList: $stockList, stockMap: $stockMap, stockTickerMap: $stockTickerMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockStateImpl &&
            const DeepCollectionEquality()
                .equals(other._stockList, _stockList) &&
            const DeepCollectionEquality().equals(other._stockMap, _stockMap) &&
            const DeepCollectionEquality()
                .equals(other._stockTickerMap, _stockTickerMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stockList),
      const DeepCollectionEquality().hash(_stockMap),
      const DeepCollectionEquality().hash(_stockTickerMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockStateImplCopyWith<_$StockStateImpl> get copyWith =>
      __$$StockStateImplCopyWithImpl<_$StockStateImpl>(this, _$identity);
}

abstract class _StockState implements StockState {
  const factory _StockState(
      {final List<StockModel> stockList,
      final Map<String, List<StockModel>> stockMap,
      final Map<String, List<StockModel>> stockTickerMap}) = _$StockStateImpl;

  @override
  List<StockModel> get stockList;
  @override
  Map<String, List<StockModel>> get stockMap;
  @override
  Map<String, List<StockModel>> get stockTickerMap;
  @override
  @JsonKey(ignore: true)
  _$$StockStateImplCopyWith<_$StockStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
