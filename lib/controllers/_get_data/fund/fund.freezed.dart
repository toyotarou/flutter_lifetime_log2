// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FundState {
  List<FundModel> get fundList => throw _privateConstructorUsedError;
  Map<String, List<FundModel>> get fundMap =>
      throw _privateConstructorUsedError;
  Map<int, List<FundModel>> get fundRelationMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of FundState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FundStateCopyWith<FundState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundStateCopyWith<$Res> {
  factory $FundStateCopyWith(FundState value, $Res Function(FundState) then) =
      _$FundStateCopyWithImpl<$Res, FundState>;
  @useResult
  $Res call(
      {List<FundModel> fundList,
      Map<String, List<FundModel>> fundMap,
      Map<int, List<FundModel>> fundRelationMap});
}

/// @nodoc
class _$FundStateCopyWithImpl<$Res, $Val extends FundState>
    implements $FundStateCopyWith<$Res> {
  _$FundStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FundState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundList = null,
    Object? fundMap = null,
    Object? fundRelationMap = null,
  }) {
    return _then(_value.copyWith(
      fundList: null == fundList
          ? _value.fundList
          : fundList // ignore: cast_nullable_to_non_nullable
              as List<FundModel>,
      fundMap: null == fundMap
          ? _value.fundMap
          : fundMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<FundModel>>,
      fundRelationMap: null == fundRelationMap
          ? _value.fundRelationMap
          : fundRelationMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<FundModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FundStateImplCopyWith<$Res>
    implements $FundStateCopyWith<$Res> {
  factory _$$FundStateImplCopyWith(
          _$FundStateImpl value, $Res Function(_$FundStateImpl) then) =
      __$$FundStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FundModel> fundList,
      Map<String, List<FundModel>> fundMap,
      Map<int, List<FundModel>> fundRelationMap});
}

/// @nodoc
class __$$FundStateImplCopyWithImpl<$Res>
    extends _$FundStateCopyWithImpl<$Res, _$FundStateImpl>
    implements _$$FundStateImplCopyWith<$Res> {
  __$$FundStateImplCopyWithImpl(
      _$FundStateImpl _value, $Res Function(_$FundStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FundState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundList = null,
    Object? fundMap = null,
    Object? fundRelationMap = null,
  }) {
    return _then(_$FundStateImpl(
      fundList: null == fundList
          ? _value._fundList
          : fundList // ignore: cast_nullable_to_non_nullable
              as List<FundModel>,
      fundMap: null == fundMap
          ? _value._fundMap
          : fundMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<FundModel>>,
      fundRelationMap: null == fundRelationMap
          ? _value._fundRelationMap
          : fundRelationMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<FundModel>>,
    ));
  }
}

/// @nodoc

class _$FundStateImpl implements _FundState {
  const _$FundStateImpl(
      {final List<FundModel> fundList = const <FundModel>[],
      final Map<String, List<FundModel>> fundMap =
          const <String, List<FundModel>>{},
      final Map<int, List<FundModel>> fundRelationMap =
          const <int, List<FundModel>>{}})
      : _fundList = fundList,
        _fundMap = fundMap,
        _fundRelationMap = fundRelationMap;

  final List<FundModel> _fundList;
  @override
  @JsonKey()
  List<FundModel> get fundList {
    if (_fundList is EqualUnmodifiableListView) return _fundList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fundList);
  }

  final Map<String, List<FundModel>> _fundMap;
  @override
  @JsonKey()
  Map<String, List<FundModel>> get fundMap {
    if (_fundMap is EqualUnmodifiableMapView) return _fundMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fundMap);
  }

  final Map<int, List<FundModel>> _fundRelationMap;
  @override
  @JsonKey()
  Map<int, List<FundModel>> get fundRelationMap {
    if (_fundRelationMap is EqualUnmodifiableMapView) return _fundRelationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fundRelationMap);
  }

  @override
  String toString() {
    return 'FundState(fundList: $fundList, fundMap: $fundMap, fundRelationMap: $fundRelationMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundStateImpl &&
            const DeepCollectionEquality().equals(other._fundList, _fundList) &&
            const DeepCollectionEquality().equals(other._fundMap, _fundMap) &&
            const DeepCollectionEquality()
                .equals(other._fundRelationMap, _fundRelationMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_fundList),
      const DeepCollectionEquality().hash(_fundMap),
      const DeepCollectionEquality().hash(_fundRelationMap));

  /// Create a copy of FundState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FundStateImplCopyWith<_$FundStateImpl> get copyWith =>
      __$$FundStateImplCopyWithImpl<_$FundStateImpl>(this, _$identity);
}

abstract class _FundState implements FundState {
  const factory _FundState(
      {final List<FundModel> fundList,
      final Map<String, List<FundModel>> fundMap,
      final Map<int, List<FundModel>> fundRelationMap}) = _$FundStateImpl;

  @override
  List<FundModel> get fundList;
  @override
  Map<String, List<FundModel>> get fundMap;
  @override
  Map<int, List<FundModel>> get fundRelationMap;

  /// Create a copy of FundState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundStateImplCopyWith<_$FundStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
