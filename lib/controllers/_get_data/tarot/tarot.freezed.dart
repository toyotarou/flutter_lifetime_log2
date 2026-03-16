// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tarot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TarotState {
  List<TarotModel> get tarotList => throw _privateConstructorUsedError;
  Map<String, TarotModel> get tarotMap => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TarotStateCopyWith<TarotState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TarotStateCopyWith<$Res> {
  factory $TarotStateCopyWith(
          TarotState value, $Res Function(TarotState) then) =
      _$TarotStateCopyWithImpl<$Res, TarotState>;
  @useResult
  $Res call({List<TarotModel> tarotList, Map<String, TarotModel> tarotMap});
}

/// @nodoc
class _$TarotStateCopyWithImpl<$Res, $Val extends TarotState>
    implements $TarotStateCopyWith<$Res> {
  _$TarotStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tarotList = null,
    Object? tarotMap = null,
  }) {
    return _then(_value.copyWith(
      tarotList: null == tarotList
          ? _value.tarotList
          : tarotList // ignore: cast_nullable_to_non_nullable
              as List<TarotModel>,
      tarotMap: null == tarotMap
          ? _value.tarotMap
          : tarotMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TarotModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TarotStateImplCopyWith<$Res>
    implements $TarotStateCopyWith<$Res> {
  factory _$$TarotStateImplCopyWith(
          _$TarotStateImpl value, $Res Function(_$TarotStateImpl) then) =
      __$$TarotStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TarotModel> tarotList, Map<String, TarotModel> tarotMap});
}

/// @nodoc
class __$$TarotStateImplCopyWithImpl<$Res>
    extends _$TarotStateCopyWithImpl<$Res, _$TarotStateImpl>
    implements _$$TarotStateImplCopyWith<$Res> {
  __$$TarotStateImplCopyWithImpl(
      _$TarotStateImpl _value, $Res Function(_$TarotStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tarotList = null,
    Object? tarotMap = null,
  }) {
    return _then(_$TarotStateImpl(
      tarotList: null == tarotList
          ? _value._tarotList
          : tarotList // ignore: cast_nullable_to_non_nullable
              as List<TarotModel>,
      tarotMap: null == tarotMap
          ? _value._tarotMap
          : tarotMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TarotModel>,
    ));
  }
}

/// @nodoc

class _$TarotStateImpl implements _TarotState {
  const _$TarotStateImpl(
      {final List<TarotModel> tarotList = const <TarotModel>[],
      final Map<String, TarotModel> tarotMap = const <String, TarotModel>{}})
      : _tarotList = tarotList,
        _tarotMap = tarotMap;

  final List<TarotModel> _tarotList;
  @override
  @JsonKey()
  List<TarotModel> get tarotList {
    if (_tarotList is EqualUnmodifiableListView) return _tarotList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tarotList);
  }

  final Map<String, TarotModel> _tarotMap;
  @override
  @JsonKey()
  Map<String, TarotModel> get tarotMap {
    if (_tarotMap is EqualUnmodifiableMapView) return _tarotMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tarotMap);
  }

  @override
  String toString() {
    return 'TarotState(tarotList: $tarotList, tarotMap: $tarotMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TarotStateImpl &&
            const DeepCollectionEquality()
                .equals(other._tarotList, _tarotList) &&
            const DeepCollectionEquality().equals(other._tarotMap, _tarotMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tarotList),
      const DeepCollectionEquality().hash(_tarotMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TarotStateImplCopyWith<_$TarotStateImpl> get copyWith =>
      __$$TarotStateImplCopyWithImpl<_$TarotStateImpl>(this, _$identity);
}

abstract class _TarotState implements TarotState {
  const factory _TarotState(
      {final List<TarotModel> tarotList,
      final Map<String, TarotModel> tarotMap}) = _$TarotStateImpl;

  @override
  List<TarotModel> get tarotList;
  @override
  Map<String, TarotModel> get tarotMap;
  @override
  @JsonKey(ignore: true)
  _$$TarotStateImplCopyWith<_$TarotStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
