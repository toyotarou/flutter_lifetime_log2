// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreditSummaryState {
  List<CreditSummaryModel> get creditSummaryList =>
      throw _privateConstructorUsedError;
  Map<String, List<CreditSummaryModel>> get creditSummaryMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of CreditSummaryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditSummaryStateCopyWith<CreditSummaryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditSummaryStateCopyWith<$Res> {
  factory $CreditSummaryStateCopyWith(
          CreditSummaryState value, $Res Function(CreditSummaryState) then) =
      _$CreditSummaryStateCopyWithImpl<$Res, CreditSummaryState>;
  @useResult
  $Res call(
      {List<CreditSummaryModel> creditSummaryList,
      Map<String, List<CreditSummaryModel>> creditSummaryMap});
}

/// @nodoc
class _$CreditSummaryStateCopyWithImpl<$Res, $Val extends CreditSummaryState>
    implements $CreditSummaryStateCopyWith<$Res> {
  _$CreditSummaryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditSummaryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditSummaryList = null,
    Object? creditSummaryMap = null,
  }) {
    return _then(_value.copyWith(
      creditSummaryList: null == creditSummaryList
          ? _value.creditSummaryList
          : creditSummaryList // ignore: cast_nullable_to_non_nullable
              as List<CreditSummaryModel>,
      creditSummaryMap: null == creditSummaryMap
          ? _value.creditSummaryMap
          : creditSummaryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<CreditSummaryModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreditSummaryStateImplCopyWith<$Res>
    implements $CreditSummaryStateCopyWith<$Res> {
  factory _$$CreditSummaryStateImplCopyWith(_$CreditSummaryStateImpl value,
          $Res Function(_$CreditSummaryStateImpl) then) =
      __$$CreditSummaryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CreditSummaryModel> creditSummaryList,
      Map<String, List<CreditSummaryModel>> creditSummaryMap});
}

/// @nodoc
class __$$CreditSummaryStateImplCopyWithImpl<$Res>
    extends _$CreditSummaryStateCopyWithImpl<$Res, _$CreditSummaryStateImpl>
    implements _$$CreditSummaryStateImplCopyWith<$Res> {
  __$$CreditSummaryStateImplCopyWithImpl(_$CreditSummaryStateImpl _value,
      $Res Function(_$CreditSummaryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreditSummaryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditSummaryList = null,
    Object? creditSummaryMap = null,
  }) {
    return _then(_$CreditSummaryStateImpl(
      creditSummaryList: null == creditSummaryList
          ? _value._creditSummaryList
          : creditSummaryList // ignore: cast_nullable_to_non_nullable
              as List<CreditSummaryModel>,
      creditSummaryMap: null == creditSummaryMap
          ? _value._creditSummaryMap
          : creditSummaryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<CreditSummaryModel>>,
    ));
  }
}

/// @nodoc

class _$CreditSummaryStateImpl implements _CreditSummaryState {
  const _$CreditSummaryStateImpl(
      {final List<CreditSummaryModel> creditSummaryList =
          const <CreditSummaryModel>[],
      final Map<String, List<CreditSummaryModel>> creditSummaryMap =
          const <String, List<CreditSummaryModel>>{}})
      : _creditSummaryList = creditSummaryList,
        _creditSummaryMap = creditSummaryMap;

  final List<CreditSummaryModel> _creditSummaryList;
  @override
  @JsonKey()
  List<CreditSummaryModel> get creditSummaryList {
    if (_creditSummaryList is EqualUnmodifiableListView)
      return _creditSummaryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_creditSummaryList);
  }

  final Map<String, List<CreditSummaryModel>> _creditSummaryMap;
  @override
  @JsonKey()
  Map<String, List<CreditSummaryModel>> get creditSummaryMap {
    if (_creditSummaryMap is EqualUnmodifiableMapView) return _creditSummaryMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_creditSummaryMap);
  }

  @override
  String toString() {
    return 'CreditSummaryState(creditSummaryList: $creditSummaryList, creditSummaryMap: $creditSummaryMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditSummaryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._creditSummaryList, _creditSummaryList) &&
            const DeepCollectionEquality()
                .equals(other._creditSummaryMap, _creditSummaryMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_creditSummaryList),
      const DeepCollectionEquality().hash(_creditSummaryMap));

  /// Create a copy of CreditSummaryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditSummaryStateImplCopyWith<_$CreditSummaryStateImpl> get copyWith =>
      __$$CreditSummaryStateImplCopyWithImpl<_$CreditSummaryStateImpl>(
          this, _$identity);
}

abstract class _CreditSummaryState implements CreditSummaryState {
  const factory _CreditSummaryState(
          {final List<CreditSummaryModel> creditSummaryList,
          final Map<String, List<CreditSummaryModel>> creditSummaryMap}) =
      _$CreditSummaryStateImpl;

  @override
  List<CreditSummaryModel> get creditSummaryList;
  @override
  Map<String, List<CreditSummaryModel>> get creditSummaryMap;

  /// Create a copy of CreditSummaryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditSummaryStateImplCopyWith<_$CreditSummaryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
