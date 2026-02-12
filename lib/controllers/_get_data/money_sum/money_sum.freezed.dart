// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_sum.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoneySumState {
  List<ScrollLineChartModel> get moneySumList =>
      throw _privateConstructorUsedError;
  Map<String, ScrollLineChartModel> get moneySumMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoneySumStateCopyWith<MoneySumState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneySumStateCopyWith<$Res> {
  factory $MoneySumStateCopyWith(
          MoneySumState value, $Res Function(MoneySumState) then) =
      _$MoneySumStateCopyWithImpl<$Res, MoneySumState>;
  @useResult
  $Res call(
      {List<ScrollLineChartModel> moneySumList,
      Map<String, ScrollLineChartModel> moneySumMap});
}

/// @nodoc
class _$MoneySumStateCopyWithImpl<$Res, $Val extends MoneySumState>
    implements $MoneySumStateCopyWith<$Res> {
  _$MoneySumStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySumList = null,
    Object? moneySumMap = null,
  }) {
    return _then(_value.copyWith(
      moneySumList: null == moneySumList
          ? _value.moneySumList
          : moneySumList // ignore: cast_nullable_to_non_nullable
              as List<ScrollLineChartModel>,
      moneySumMap: null == moneySumMap
          ? _value.moneySumMap
          : moneySumMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ScrollLineChartModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneySumStateImplCopyWith<$Res>
    implements $MoneySumStateCopyWith<$Res> {
  factory _$$MoneySumStateImplCopyWith(
          _$MoneySumStateImpl value, $Res Function(_$MoneySumStateImpl) then) =
      __$$MoneySumStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ScrollLineChartModel> moneySumList,
      Map<String, ScrollLineChartModel> moneySumMap});
}

/// @nodoc
class __$$MoneySumStateImplCopyWithImpl<$Res>
    extends _$MoneySumStateCopyWithImpl<$Res, _$MoneySumStateImpl>
    implements _$$MoneySumStateImplCopyWith<$Res> {
  __$$MoneySumStateImplCopyWithImpl(
      _$MoneySumStateImpl _value, $Res Function(_$MoneySumStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneySumList = null,
    Object? moneySumMap = null,
  }) {
    return _then(_$MoneySumStateImpl(
      moneySumList: null == moneySumList
          ? _value._moneySumList
          : moneySumList // ignore: cast_nullable_to_non_nullable
              as List<ScrollLineChartModel>,
      moneySumMap: null == moneySumMap
          ? _value._moneySumMap
          : moneySumMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ScrollLineChartModel>,
    ));
  }
}

/// @nodoc

class _$MoneySumStateImpl implements _MoneySumState {
  const _$MoneySumStateImpl(
      {final List<ScrollLineChartModel> moneySumList =
          const <ScrollLineChartModel>[],
      final Map<String, ScrollLineChartModel> moneySumMap =
          const <String, ScrollLineChartModel>{}})
      : _moneySumList = moneySumList,
        _moneySumMap = moneySumMap;

  final List<ScrollLineChartModel> _moneySumList;
  @override
  @JsonKey()
  List<ScrollLineChartModel> get moneySumList {
    if (_moneySumList is EqualUnmodifiableListView) return _moneySumList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moneySumList);
  }

  final Map<String, ScrollLineChartModel> _moneySumMap;
  @override
  @JsonKey()
  Map<String, ScrollLineChartModel> get moneySumMap {
    if (_moneySumMap is EqualUnmodifiableMapView) return _moneySumMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moneySumMap);
  }

  @override
  String toString() {
    return 'MoneySumState(moneySumList: $moneySumList, moneySumMap: $moneySumMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneySumStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moneySumList, _moneySumList) &&
            const DeepCollectionEquality()
                .equals(other._moneySumMap, _moneySumMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moneySumList),
      const DeepCollectionEquality().hash(_moneySumMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneySumStateImplCopyWith<_$MoneySumStateImpl> get copyWith =>
      __$$MoneySumStateImplCopyWithImpl<_$MoneySumStateImpl>(this, _$identity);
}

abstract class _MoneySumState implements MoneySumState {
  const factory _MoneySumState(
          {final List<ScrollLineChartModel> moneySumList,
          final Map<String, ScrollLineChartModel> moneySumMap}) =
      _$MoneySumStateImpl;

  @override
  List<ScrollLineChartModel> get moneySumList;
  @override
  Map<String, ScrollLineChartModel> get moneySumMap;
  @override
  @JsonKey(ignore: true)
  _$$MoneySumStateImplCopyWith<_$MoneySumStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
