// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_spend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoneySpendState {
  List<MoneySpendModel> get moneySpendList =>
      throw _privateConstructorUsedError;
  Map<String, List<MoneySpendModel>> get moneySpendMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of MoneySpendState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoneySpendStateCopyWith<MoneySpendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneySpendStateCopyWith<$Res> {
  factory $MoneySpendStateCopyWith(
          MoneySpendState value, $Res Function(MoneySpendState) then) =
      _$MoneySpendStateCopyWithImpl<$Res, MoneySpendState>;
  @useResult
  $Res call(
      {List<MoneySpendModel> moneySpendList,
      Map<String, List<MoneySpendModel>> moneySpendMap});
}

/// @nodoc
class _$MoneySpendStateCopyWithImpl<$Res, $Val extends MoneySpendState>
    implements $MoneySpendStateCopyWith<$Res> {
  _$MoneySpendStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoneySpendState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySpendList = null,
    Object? moneySpendMap = null,
  }) {
    return _then(_value.copyWith(
      moneySpendList: null == moneySpendList
          ? _value.moneySpendList
          : moneySpendList // ignore: cast_nullable_to_non_nullable
              as List<MoneySpendModel>,
      moneySpendMap: null == moneySpendMap
          ? _value.moneySpendMap
          : moneySpendMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<MoneySpendModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneySpendStateImplCopyWith<$Res>
    implements $MoneySpendStateCopyWith<$Res> {
  factory _$$MoneySpendStateImplCopyWith(_$MoneySpendStateImpl value,
          $Res Function(_$MoneySpendStateImpl) then) =
      __$$MoneySpendStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MoneySpendModel> moneySpendList,
      Map<String, List<MoneySpendModel>> moneySpendMap});
}

/// @nodoc
class __$$MoneySpendStateImplCopyWithImpl<$Res>
    extends _$MoneySpendStateCopyWithImpl<$Res, _$MoneySpendStateImpl>
    implements _$$MoneySpendStateImplCopyWith<$Res> {
  __$$MoneySpendStateImplCopyWithImpl(
      _$MoneySpendStateImpl _value, $Res Function(_$MoneySpendStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoneySpendState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySpendList = null,
    Object? moneySpendMap = null,
  }) {
    return _then(_$MoneySpendStateImpl(
      moneySpendList: null == moneySpendList
          ? _value._moneySpendList
          : moneySpendList // ignore: cast_nullable_to_non_nullable
              as List<MoneySpendModel>,
      moneySpendMap: null == moneySpendMap
          ? _value._moneySpendMap
          : moneySpendMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<MoneySpendModel>>,
    ));
  }
}

/// @nodoc

class _$MoneySpendStateImpl implements _MoneySpendState {
  const _$MoneySpendStateImpl(
      {final List<MoneySpendModel> moneySpendList = const <MoneySpendModel>[],
      final Map<String, List<MoneySpendModel>> moneySpendMap =
          const <String, List<MoneySpendModel>>{}})
      : _moneySpendList = moneySpendList,
        _moneySpendMap = moneySpendMap;

  final List<MoneySpendModel> _moneySpendList;
  @override
  @JsonKey()
  List<MoneySpendModel> get moneySpendList {
    if (_moneySpendList is EqualUnmodifiableListView) return _moneySpendList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moneySpendList);
  }

  final Map<String, List<MoneySpendModel>> _moneySpendMap;
  @override
  @JsonKey()
  Map<String, List<MoneySpendModel>> get moneySpendMap {
    if (_moneySpendMap is EqualUnmodifiableMapView) return _moneySpendMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moneySpendMap);
  }

  @override
  String toString() {
    return 'MoneySpendState(moneySpendList: $moneySpendList, moneySpendMap: $moneySpendMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneySpendStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moneySpendList, _moneySpendList) &&
            const DeepCollectionEquality()
                .equals(other._moneySpendMap, _moneySpendMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moneySpendList),
      const DeepCollectionEquality().hash(_moneySpendMap));

  /// Create a copy of MoneySpendState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneySpendStateImplCopyWith<_$MoneySpendStateImpl> get copyWith =>
      __$$MoneySpendStateImplCopyWithImpl<_$MoneySpendStateImpl>(
          this, _$identity);
}

abstract class _MoneySpendState implements MoneySpendState {
  const factory _MoneySpendState(
          {final List<MoneySpendModel> moneySpendList,
          final Map<String, List<MoneySpendModel>> moneySpendMap}) =
      _$MoneySpendStateImpl;

  @override
  List<MoneySpendModel> get moneySpendList;
  @override
  Map<String, List<MoneySpendModel>> get moneySpendMap;

  /// Create a copy of MoneySpendState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoneySpendStateImplCopyWith<_$MoneySpendStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
