// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SalaryState {
  List<SalaryModel> get salaryList => throw _privateConstructorUsedError;
  Map<String, List<SalaryModel>> get salaryMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SalaryStateCopyWith<SalaryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryStateCopyWith<$Res> {
  factory $SalaryStateCopyWith(
          SalaryState value, $Res Function(SalaryState) then) =
      _$SalaryStateCopyWithImpl<$Res, SalaryState>;
  @useResult
  $Res call(
      {List<SalaryModel> salaryList, Map<String, List<SalaryModel>> salaryMap});
}

/// @nodoc
class _$SalaryStateCopyWithImpl<$Res, $Val extends SalaryState>
    implements $SalaryStateCopyWith<$Res> {
  _$SalaryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salaryList = null,
    Object? salaryMap = null,
  }) {
    return _then(_value.copyWith(
      salaryList: null == salaryList
          ? _value.salaryList
          : salaryList // ignore: cast_nullable_to_non_nullable
              as List<SalaryModel>,
      salaryMap: null == salaryMap
          ? _value.salaryMap
          : salaryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SalaryModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalaryStateImplCopyWith<$Res>
    implements $SalaryStateCopyWith<$Res> {
  factory _$$SalaryStateImplCopyWith(
          _$SalaryStateImpl value, $Res Function(_$SalaryStateImpl) then) =
      __$$SalaryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SalaryModel> salaryList, Map<String, List<SalaryModel>> salaryMap});
}

/// @nodoc
class __$$SalaryStateImplCopyWithImpl<$Res>
    extends _$SalaryStateCopyWithImpl<$Res, _$SalaryStateImpl>
    implements _$$SalaryStateImplCopyWith<$Res> {
  __$$SalaryStateImplCopyWithImpl(
      _$SalaryStateImpl _value, $Res Function(_$SalaryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salaryList = null,
    Object? salaryMap = null,
  }) {
    return _then(_$SalaryStateImpl(
      salaryList: null == salaryList
          ? _value._salaryList
          : salaryList // ignore: cast_nullable_to_non_nullable
              as List<SalaryModel>,
      salaryMap: null == salaryMap
          ? _value._salaryMap
          : salaryMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SalaryModel>>,
    ));
  }
}

/// @nodoc

class _$SalaryStateImpl implements _SalaryState {
  const _$SalaryStateImpl(
      {final List<SalaryModel> salaryList = const <SalaryModel>[],
      final Map<String, List<SalaryModel>> salaryMap =
          const <String, List<SalaryModel>>{}})
      : _salaryList = salaryList,
        _salaryMap = salaryMap;

  final List<SalaryModel> _salaryList;
  @override
  @JsonKey()
  List<SalaryModel> get salaryList {
    if (_salaryList is EqualUnmodifiableListView) return _salaryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_salaryList);
  }

  final Map<String, List<SalaryModel>> _salaryMap;
  @override
  @JsonKey()
  Map<String, List<SalaryModel>> get salaryMap {
    if (_salaryMap is EqualUnmodifiableMapView) return _salaryMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_salaryMap);
  }

  @override
  String toString() {
    return 'SalaryState(salaryList: $salaryList, salaryMap: $salaryMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._salaryList, _salaryList) &&
            const DeepCollectionEquality()
                .equals(other._salaryMap, _salaryMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_salaryList),
      const DeepCollectionEquality().hash(_salaryMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryStateImplCopyWith<_$SalaryStateImpl> get copyWith =>
      __$$SalaryStateImplCopyWithImpl<_$SalaryStateImpl>(this, _$identity);
}

abstract class _SalaryState implements SalaryState {
  const factory _SalaryState(
      {final List<SalaryModel> salaryList,
      final Map<String, List<SalaryModel>> salaryMap}) = _$SalaryStateImpl;

  @override
  List<SalaryModel> get salaryList;
  @override
  Map<String, List<SalaryModel>> get salaryMap;
  @override
  @JsonKey(ignore: true)
  _$$SalaryStateImplCopyWith<_$SalaryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
