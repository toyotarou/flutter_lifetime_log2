// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amazon_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AmazonPurchaseState {
  List<AmazonPurchaseModel> get amazonPurchaseList =>
      throw _privateConstructorUsedError;
  Map<String, List<AmazonPurchaseModel>> get amazonPurchaseMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of AmazonPurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AmazonPurchaseStateCopyWith<AmazonPurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmazonPurchaseStateCopyWith<$Res> {
  factory $AmazonPurchaseStateCopyWith(
          AmazonPurchaseState value, $Res Function(AmazonPurchaseState) then) =
      _$AmazonPurchaseStateCopyWithImpl<$Res, AmazonPurchaseState>;
  @useResult
  $Res call(
      {List<AmazonPurchaseModel> amazonPurchaseList,
      Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap});
}

/// @nodoc
class _$AmazonPurchaseStateCopyWithImpl<$Res, $Val extends AmazonPurchaseState>
    implements $AmazonPurchaseStateCopyWith<$Res> {
  _$AmazonPurchaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AmazonPurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amazonPurchaseList = null,
    Object? amazonPurchaseMap = null,
  }) {
    return _then(_value.copyWith(
      amazonPurchaseList: null == amazonPurchaseList
          ? _value.amazonPurchaseList
          : amazonPurchaseList // ignore: cast_nullable_to_non_nullable
              as List<AmazonPurchaseModel>,
      amazonPurchaseMap: null == amazonPurchaseMap
          ? _value.amazonPurchaseMap
          : amazonPurchaseMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<AmazonPurchaseModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmazonPurchaseStateImplCopyWith<$Res>
    implements $AmazonPurchaseStateCopyWith<$Res> {
  factory _$$AmazonPurchaseStateImplCopyWith(_$AmazonPurchaseStateImpl value,
          $Res Function(_$AmazonPurchaseStateImpl) then) =
      __$$AmazonPurchaseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AmazonPurchaseModel> amazonPurchaseList,
      Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap});
}

/// @nodoc
class __$$AmazonPurchaseStateImplCopyWithImpl<$Res>
    extends _$AmazonPurchaseStateCopyWithImpl<$Res, _$AmazonPurchaseStateImpl>
    implements _$$AmazonPurchaseStateImplCopyWith<$Res> {
  __$$AmazonPurchaseStateImplCopyWithImpl(_$AmazonPurchaseStateImpl _value,
      $Res Function(_$AmazonPurchaseStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AmazonPurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amazonPurchaseList = null,
    Object? amazonPurchaseMap = null,
  }) {
    return _then(_$AmazonPurchaseStateImpl(
      amazonPurchaseList: null == amazonPurchaseList
          ? _value._amazonPurchaseList
          : amazonPurchaseList // ignore: cast_nullable_to_non_nullable
              as List<AmazonPurchaseModel>,
      amazonPurchaseMap: null == amazonPurchaseMap
          ? _value._amazonPurchaseMap
          : amazonPurchaseMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<AmazonPurchaseModel>>,
    ));
  }
}

/// @nodoc

class _$AmazonPurchaseStateImpl implements _AmazonPurchaseState {
  const _$AmazonPurchaseStateImpl(
      {final List<AmazonPurchaseModel> amazonPurchaseList =
          const <AmazonPurchaseModel>[],
      final Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap =
          const <String, List<AmazonPurchaseModel>>{}})
      : _amazonPurchaseList = amazonPurchaseList,
        _amazonPurchaseMap = amazonPurchaseMap;

  final List<AmazonPurchaseModel> _amazonPurchaseList;
  @override
  @JsonKey()
  List<AmazonPurchaseModel> get amazonPurchaseList {
    if (_amazonPurchaseList is EqualUnmodifiableListView)
      return _amazonPurchaseList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amazonPurchaseList);
  }

  final Map<String, List<AmazonPurchaseModel>> _amazonPurchaseMap;
  @override
  @JsonKey()
  Map<String, List<AmazonPurchaseModel>> get amazonPurchaseMap {
    if (_amazonPurchaseMap is EqualUnmodifiableMapView)
      return _amazonPurchaseMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_amazonPurchaseMap);
  }

  @override
  String toString() {
    return 'AmazonPurchaseState(amazonPurchaseList: $amazonPurchaseList, amazonPurchaseMap: $amazonPurchaseMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmazonPurchaseStateImpl &&
            const DeepCollectionEquality()
                .equals(other._amazonPurchaseList, _amazonPurchaseList) &&
            const DeepCollectionEquality()
                .equals(other._amazonPurchaseMap, _amazonPurchaseMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_amazonPurchaseList),
      const DeepCollectionEquality().hash(_amazonPurchaseMap));

  /// Create a copy of AmazonPurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AmazonPurchaseStateImplCopyWith<_$AmazonPurchaseStateImpl> get copyWith =>
      __$$AmazonPurchaseStateImplCopyWithImpl<_$AmazonPurchaseStateImpl>(
          this, _$identity);
}

abstract class _AmazonPurchaseState implements AmazonPurchaseState {
  const factory _AmazonPurchaseState(
          {final List<AmazonPurchaseModel> amazonPurchaseList,
          final Map<String, List<AmazonPurchaseModel>> amazonPurchaseMap}) =
      _$AmazonPurchaseStateImpl;

  @override
  List<AmazonPurchaseModel> get amazonPurchaseList;
  @override
  Map<String, List<AmazonPurchaseModel>> get amazonPurchaseMap;

  /// Create a copy of AmazonPurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AmazonPurchaseStateImplCopyWith<_$AmazonPurchaseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
