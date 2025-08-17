// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invest_records.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvestRecordsState {
  List<InvestRecordModel> get investRecordList =>
      throw _privateConstructorUsedError;
  Map<int, List<InvestRecordModel>> get investRecordMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of InvestRecordsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvestRecordsStateCopyWith<InvestRecordsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvestRecordsStateCopyWith<$Res> {
  factory $InvestRecordsStateCopyWith(
          InvestRecordsState value, $Res Function(InvestRecordsState) then) =
      _$InvestRecordsStateCopyWithImpl<$Res, InvestRecordsState>;
  @useResult
  $Res call(
      {List<InvestRecordModel> investRecordList,
      Map<int, List<InvestRecordModel>> investRecordMap});
}

/// @nodoc
class _$InvestRecordsStateCopyWithImpl<$Res, $Val extends InvestRecordsState>
    implements $InvestRecordsStateCopyWith<$Res> {
  _$InvestRecordsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvestRecordsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? investRecordList = null,
    Object? investRecordMap = null,
  }) {
    return _then(_value.copyWith(
      investRecordList: null == investRecordList
          ? _value.investRecordList
          : investRecordList // ignore: cast_nullable_to_non_nullable
              as List<InvestRecordModel>,
      investRecordMap: null == investRecordMap
          ? _value.investRecordMap
          : investRecordMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<InvestRecordModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvestRecordsStateImplCopyWith<$Res>
    implements $InvestRecordsStateCopyWith<$Res> {
  factory _$$InvestRecordsStateImplCopyWith(_$InvestRecordsStateImpl value,
          $Res Function(_$InvestRecordsStateImpl) then) =
      __$$InvestRecordsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<InvestRecordModel> investRecordList,
      Map<int, List<InvestRecordModel>> investRecordMap});
}

/// @nodoc
class __$$InvestRecordsStateImplCopyWithImpl<$Res>
    extends _$InvestRecordsStateCopyWithImpl<$Res, _$InvestRecordsStateImpl>
    implements _$$InvestRecordsStateImplCopyWith<$Res> {
  __$$InvestRecordsStateImplCopyWithImpl(_$InvestRecordsStateImpl _value,
      $Res Function(_$InvestRecordsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvestRecordsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? investRecordList = null,
    Object? investRecordMap = null,
  }) {
    return _then(_$InvestRecordsStateImpl(
      investRecordList: null == investRecordList
          ? _value._investRecordList
          : investRecordList // ignore: cast_nullable_to_non_nullable
              as List<InvestRecordModel>,
      investRecordMap: null == investRecordMap
          ? _value._investRecordMap
          : investRecordMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<InvestRecordModel>>,
    ));
  }
}

/// @nodoc

class _$InvestRecordsStateImpl implements _InvestRecordsState {
  const _$InvestRecordsStateImpl(
      {final List<InvestRecordModel> investRecordList =
          const <InvestRecordModel>[],
      final Map<int, List<InvestRecordModel>> investRecordMap =
          const <int, List<InvestRecordModel>>{}})
      : _investRecordList = investRecordList,
        _investRecordMap = investRecordMap;

  final List<InvestRecordModel> _investRecordList;
  @override
  @JsonKey()
  List<InvestRecordModel> get investRecordList {
    if (_investRecordList is EqualUnmodifiableListView)
      return _investRecordList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_investRecordList);
  }

  final Map<int, List<InvestRecordModel>> _investRecordMap;
  @override
  @JsonKey()
  Map<int, List<InvestRecordModel>> get investRecordMap {
    if (_investRecordMap is EqualUnmodifiableMapView) return _investRecordMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_investRecordMap);
  }

  @override
  String toString() {
    return 'InvestRecordsState(investRecordList: $investRecordList, investRecordMap: $investRecordMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvestRecordsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._investRecordList, _investRecordList) &&
            const DeepCollectionEquality()
                .equals(other._investRecordMap, _investRecordMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_investRecordList),
      const DeepCollectionEquality().hash(_investRecordMap));

  /// Create a copy of InvestRecordsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvestRecordsStateImplCopyWith<_$InvestRecordsStateImpl> get copyWith =>
      __$$InvestRecordsStateImplCopyWithImpl<_$InvestRecordsStateImpl>(
          this, _$identity);
}

abstract class _InvestRecordsState implements InvestRecordsState {
  const factory _InvestRecordsState(
          {final List<InvestRecordModel> investRecordList,
          final Map<int, List<InvestRecordModel>> investRecordMap}) =
      _$InvestRecordsStateImpl;

  @override
  List<InvestRecordModel> get investRecordList;
  @override
  Map<int, List<InvestRecordModel>> get investRecordMap;

  /// Create a copy of InvestRecordsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvestRecordsStateImplCopyWith<_$InvestRecordsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
