// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoneyState {
  List<MoneyModel> get moneyList => throw _privateConstructorUsedError;
  Map<String, MoneyModel> get moneyMap => throw _privateConstructorUsedError;

  /// Create a copy of MoneyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoneyStateCopyWith<MoneyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyStateCopyWith<$Res> {
  factory $MoneyStateCopyWith(
          MoneyState value, $Res Function(MoneyState) then) =
      _$MoneyStateCopyWithImpl<$Res, MoneyState>;
  @useResult
  $Res call({List<MoneyModel> moneyList, Map<String, MoneyModel> moneyMap});
}

/// @nodoc
class _$MoneyStateCopyWithImpl<$Res, $Val extends MoneyState>
    implements $MoneyStateCopyWith<$Res> {
  _$MoneyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoneyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneyList = null,
    Object? moneyMap = null,
  }) {
    return _then(_value.copyWith(
      moneyList: null == moneyList
          ? _value.moneyList
          : moneyList // ignore: cast_nullable_to_non_nullable
              as List<MoneyModel>,
      moneyMap: null == moneyMap
          ? _value.moneyMap
          : moneyMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneyModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneyStateImplCopyWith<$Res>
    implements $MoneyStateCopyWith<$Res> {
  factory _$$MoneyStateImplCopyWith(
          _$MoneyStateImpl value, $Res Function(_$MoneyStateImpl) then) =
      __$$MoneyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MoneyModel> moneyList, Map<String, MoneyModel> moneyMap});
}

/// @nodoc
class __$$MoneyStateImplCopyWithImpl<$Res>
    extends _$MoneyStateCopyWithImpl<$Res, _$MoneyStateImpl>
    implements _$$MoneyStateImplCopyWith<$Res> {
  __$$MoneyStateImplCopyWithImpl(
      _$MoneyStateImpl _value, $Res Function(_$MoneyStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoneyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneyList = null,
    Object? moneyMap = null,
  }) {
    return _then(_$MoneyStateImpl(
      moneyList: null == moneyList
          ? _value._moneyList
          : moneyList // ignore: cast_nullable_to_non_nullable
              as List<MoneyModel>,
      moneyMap: null == moneyMap
          ? _value._moneyMap
          : moneyMap // ignore: cast_nullable_to_non_nullable
              as Map<String, MoneyModel>,
    ));
  }
}

/// @nodoc

class _$MoneyStateImpl implements _MoneyState {
  const _$MoneyStateImpl(
      {final List<MoneyModel> moneyList = const <MoneyModel>[],
      final Map<String, MoneyModel> moneyMap = const <String, MoneyModel>{}})
      : _moneyList = moneyList,
        _moneyMap = moneyMap;

  final List<MoneyModel> _moneyList;
  @override
  @JsonKey()
  List<MoneyModel> get moneyList {
    if (_moneyList is EqualUnmodifiableListView) return _moneyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moneyList);
  }

  final Map<String, MoneyModel> _moneyMap;
  @override
  @JsonKey()
  Map<String, MoneyModel> get moneyMap {
    if (_moneyMap is EqualUnmodifiableMapView) return _moneyMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moneyMap);
  }

  @override
  String toString() {
    return 'MoneyState(moneyList: $moneyList, moneyMap: $moneyMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneyStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moneyList, _moneyList) &&
            const DeepCollectionEquality().equals(other._moneyMap, _moneyMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moneyList),
      const DeepCollectionEquality().hash(_moneyMap));

  /// Create a copy of MoneyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneyStateImplCopyWith<_$MoneyStateImpl> get copyWith =>
      __$$MoneyStateImplCopyWithImpl<_$MoneyStateImpl>(this, _$identity);
}

abstract class _MoneyState implements MoneyState {
  const factory _MoneyState(
      {final List<MoneyModel> moneyList,
      final Map<String, MoneyModel> moneyMap}) = _$MoneyStateImpl;

  @override
  List<MoneyModel> get moneyList;
  @override
  Map<String, MoneyModel> get moneyMap;

  /// Create a copy of MoneyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoneyStateImplCopyWith<_$MoneyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
