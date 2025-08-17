// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invest_names.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvestNamesState {
  List<InvestNameModel> get investNamesList =>
      throw _privateConstructorUsedError;
  Map<String, List<InvestNameModel>> get investNamesMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of InvestNamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvestNamesStateCopyWith<InvestNamesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvestNamesStateCopyWith<$Res> {
  factory $InvestNamesStateCopyWith(
          InvestNamesState value, $Res Function(InvestNamesState) then) =
      _$InvestNamesStateCopyWithImpl<$Res, InvestNamesState>;
  @useResult
  $Res call(
      {List<InvestNameModel> investNamesList,
      Map<String, List<InvestNameModel>> investNamesMap});
}

/// @nodoc
class _$InvestNamesStateCopyWithImpl<$Res, $Val extends InvestNamesState>
    implements $InvestNamesStateCopyWith<$Res> {
  _$InvestNamesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvestNamesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? investNamesList = null,
    Object? investNamesMap = null,
  }) {
    return _then(_value.copyWith(
      investNamesList: null == investNamesList
          ? _value.investNamesList
          : investNamesList // ignore: cast_nullable_to_non_nullable
              as List<InvestNameModel>,
      investNamesMap: null == investNamesMap
          ? _value.investNamesMap
          : investNamesMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<InvestNameModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvestNamesStateImplCopyWith<$Res>
    implements $InvestNamesStateCopyWith<$Res> {
  factory _$$InvestNamesStateImplCopyWith(_$InvestNamesStateImpl value,
          $Res Function(_$InvestNamesStateImpl) then) =
      __$$InvestNamesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<InvestNameModel> investNamesList,
      Map<String, List<InvestNameModel>> investNamesMap});
}

/// @nodoc
class __$$InvestNamesStateImplCopyWithImpl<$Res>
    extends _$InvestNamesStateCopyWithImpl<$Res, _$InvestNamesStateImpl>
    implements _$$InvestNamesStateImplCopyWith<$Res> {
  __$$InvestNamesStateImplCopyWithImpl(_$InvestNamesStateImpl _value,
      $Res Function(_$InvestNamesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvestNamesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? investNamesList = null,
    Object? investNamesMap = null,
  }) {
    return _then(_$InvestNamesStateImpl(
      investNamesList: null == investNamesList
          ? _value._investNamesList
          : investNamesList // ignore: cast_nullable_to_non_nullable
              as List<InvestNameModel>,
      investNamesMap: null == investNamesMap
          ? _value._investNamesMap
          : investNamesMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<InvestNameModel>>,
    ));
  }
}

/// @nodoc

class _$InvestNamesStateImpl implements _InvestNamesState {
  const _$InvestNamesStateImpl(
      {final List<InvestNameModel> investNamesList = const <InvestNameModel>[],
      final Map<String, List<InvestNameModel>> investNamesMap =
          const <String, List<InvestNameModel>>{}})
      : _investNamesList = investNamesList,
        _investNamesMap = investNamesMap;

  final List<InvestNameModel> _investNamesList;
  @override
  @JsonKey()
  List<InvestNameModel> get investNamesList {
    if (_investNamesList is EqualUnmodifiableListView) return _investNamesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_investNamesList);
  }

  final Map<String, List<InvestNameModel>> _investNamesMap;
  @override
  @JsonKey()
  Map<String, List<InvestNameModel>> get investNamesMap {
    if (_investNamesMap is EqualUnmodifiableMapView) return _investNamesMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_investNamesMap);
  }

  @override
  String toString() {
    return 'InvestNamesState(investNamesList: $investNamesList, investNamesMap: $investNamesMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvestNamesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._investNamesList, _investNamesList) &&
            const DeepCollectionEquality()
                .equals(other._investNamesMap, _investNamesMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_investNamesList),
      const DeepCollectionEquality().hash(_investNamesMap));

  /// Create a copy of InvestNamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvestNamesStateImplCopyWith<_$InvestNamesStateImpl> get copyWith =>
      __$$InvestNamesStateImplCopyWithImpl<_$InvestNamesStateImpl>(
          this, _$identity);
}

abstract class _InvestNamesState implements InvestNamesState {
  const factory _InvestNamesState(
          {final List<InvestNameModel> investNamesList,
          final Map<String, List<InvestNameModel>> investNamesMap}) =
      _$InvestNamesStateImpl;

  @override
  List<InvestNameModel> get investNamesList;
  @override
  Map<String, List<InvestNameModel>> get investNamesMap;

  /// Create a copy of InvestNamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvestNamesStateImplCopyWith<_$InvestNamesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
