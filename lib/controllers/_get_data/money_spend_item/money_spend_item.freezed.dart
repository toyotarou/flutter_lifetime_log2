// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_spend_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoneySpendItemState {
  List<MoneySpendItemModel> get moneySpendItemList =>
      throw _privateConstructorUsedError;
  Map<String, MoneySpendItemModel> get moneySpendItemMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoneySpendItemStateCopyWith<MoneySpendItemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneySpendItemStateCopyWith<$Res> {
  factory $MoneySpendItemStateCopyWith(
          MoneySpendItemState value, $Res Function(MoneySpendItemState) then) =
      _$MoneySpendItemStateCopyWithImpl<$Res, MoneySpendItemState>;
  @useResult
  $Res call(
      {List<MoneySpendItemModel> moneySpendItemList,
      Map<String, MoneySpendItemModel> moneySpendItemMap});
}

/// @nodoc
class _$MoneySpendItemStateCopyWithImpl<$Res, $Val extends MoneySpendItemState>
    implements $MoneySpendItemStateCopyWith<$Res> {
  _$MoneySpendItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySpendItemList = null,
    Object? moneySpendItemMap = null,
  }) {
    return _then(_value.copyWith(
      moneySpendItemList: null == moneySpendItemList
          ? _value.moneySpendItemList
          : moneySpendItemList // ignore: cast_nullable_to_non_nullable
              as List<MoneySpendItemModel>,
      moneySpendItemMap: null == moneySpendItemMap
          ? _value.moneySpendItemMap
          : moneySpendItemMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneySpendItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneySpendItemStateImplCopyWith<$Res>
    implements $MoneySpendItemStateCopyWith<$Res> {
  factory _$$MoneySpendItemStateImplCopyWith(_$MoneySpendItemStateImpl value,
          $Res Function(_$MoneySpendItemStateImpl) then) =
      __$$MoneySpendItemStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MoneySpendItemModel> moneySpendItemList,
      Map<String, MoneySpendItemModel> moneySpendItemMap});
}

/// @nodoc
class __$$MoneySpendItemStateImplCopyWithImpl<$Res>
    extends _$MoneySpendItemStateCopyWithImpl<$Res, _$MoneySpendItemStateImpl>
    implements _$$MoneySpendItemStateImplCopyWith<$Res> {
  __$$MoneySpendItemStateImplCopyWithImpl(_$MoneySpendItemStateImpl _value,
      $Res Function(_$MoneySpendItemStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySpendItemList = null,
    Object? moneySpendItemMap = null,
  }) {
    return _then(_$MoneySpendItemStateImpl(
      moneySpendItemList: null == moneySpendItemList
          ? _value._moneySpendItemList
          : moneySpendItemList // ignore: cast_nullable_to_non_nullable
              as List<MoneySpendItemModel>,
      moneySpendItemMap: null == moneySpendItemMap
          ? _value._moneySpendItemMap
          : moneySpendItemMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneySpendItemModel>,
    ));
  }
}

/// @nodoc

class _$MoneySpendItemStateImpl implements _MoneySpendItemState {
  const _$MoneySpendItemStateImpl(
      {final List<MoneySpendItemModel> moneySpendItemList =
          const <MoneySpendItemModel>[],
      final Map<String, MoneySpendItemModel> moneySpendItemMap =
          const <String, MoneySpendItemModel>{}})
      : _moneySpendItemList = moneySpendItemList,
        _moneySpendItemMap = moneySpendItemMap;

  final List<MoneySpendItemModel> _moneySpendItemList;
  @override
  @JsonKey()
  List<MoneySpendItemModel> get moneySpendItemList {
    if (_moneySpendItemList is EqualUnmodifiableListView)
      return _moneySpendItemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moneySpendItemList);
  }

  final Map<String, MoneySpendItemModel> _moneySpendItemMap;
  @override
  @JsonKey()
  Map<String, MoneySpendItemModel> get moneySpendItemMap {
    if (_moneySpendItemMap is EqualUnmodifiableMapView)
      return _moneySpendItemMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moneySpendItemMap);
  }

  @override
  String toString() {
    return 'MoneySpendItemState(moneySpendItemList: $moneySpendItemList, moneySpendItemMap: $moneySpendItemMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneySpendItemStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moneySpendItemList, _moneySpendItemList) &&
            const DeepCollectionEquality()
                .equals(other._moneySpendItemMap, _moneySpendItemMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moneySpendItemList),
      const DeepCollectionEquality().hash(_moneySpendItemMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneySpendItemStateImplCopyWith<_$MoneySpendItemStateImpl> get copyWith =>
      __$$MoneySpendItemStateImplCopyWithImpl<_$MoneySpendItemStateImpl>(
          this, _$identity);
}

abstract class _MoneySpendItemState implements MoneySpendItemState {
  const factory _MoneySpendItemState(
          {final List<MoneySpendItemModel> moneySpendItemList,
          final Map<String, MoneySpendItemModel> moneySpendItemMap}) =
      _$MoneySpendItemStateImpl;

  @override
  List<MoneySpendItemModel> get moneySpendItemList;
  @override
  Map<String, MoneySpendItemModel> get moneySpendItemMap;
  @override
  @JsonKey(ignore: true)
  _$$MoneySpendItemStateImplCopyWith<_$MoneySpendItemStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
