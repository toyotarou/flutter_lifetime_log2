// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toushi_shintaku_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ToushiShintakuInputState {
  Map<String, int> get relationalIdMap => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToushiShintakuInputStateCopyWith<ToushiShintakuInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToushiShintakuInputStateCopyWith<$Res> {
  factory $ToushiShintakuInputStateCopyWith(ToushiShintakuInputState value,
          $Res Function(ToushiShintakuInputState) then) =
      _$ToushiShintakuInputStateCopyWithImpl<$Res, ToushiShintakuInputState>;
  @useResult
  $Res call({Map<String, int> relationalIdMap});
}

/// @nodoc
class _$ToushiShintakuInputStateCopyWithImpl<$Res,
        $Val extends ToushiShintakuInputState>
    implements $ToushiShintakuInputStateCopyWith<$Res> {
  _$ToushiShintakuInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationalIdMap = null,
  }) {
    return _then(_value.copyWith(
      relationalIdMap: null == relationalIdMap
          ? _value.relationalIdMap
          : relationalIdMap // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToushiShintakuInputStateImplCopyWith<$Res>
    implements $ToushiShintakuInputStateCopyWith<$Res> {
  factory _$$ToushiShintakuInputStateImplCopyWith(
          _$ToushiShintakuInputStateImpl value,
          $Res Function(_$ToushiShintakuInputStateImpl) then) =
      __$$ToushiShintakuInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, int> relationalIdMap});
}

/// @nodoc
class __$$ToushiShintakuInputStateImplCopyWithImpl<$Res>
    extends _$ToushiShintakuInputStateCopyWithImpl<$Res,
        _$ToushiShintakuInputStateImpl>
    implements _$$ToushiShintakuInputStateImplCopyWith<$Res> {
  __$$ToushiShintakuInputStateImplCopyWithImpl(
      _$ToushiShintakuInputStateImpl _value,
      $Res Function(_$ToushiShintakuInputStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relationalIdMap = null,
  }) {
    return _then(_$ToushiShintakuInputStateImpl(
      relationalIdMap: null == relationalIdMap
          ? _value._relationalIdMap
          : relationalIdMap // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc

class _$ToushiShintakuInputStateImpl implements _ToushiShintakuInputState {
  const _$ToushiShintakuInputStateImpl(
      {final Map<String, int> relationalIdMap = const <String, int>{}})
      : _relationalIdMap = relationalIdMap;

  final Map<String, int> _relationalIdMap;
  @override
  @JsonKey()
  Map<String, int> get relationalIdMap {
    if (_relationalIdMap is EqualUnmodifiableMapView) return _relationalIdMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_relationalIdMap);
  }

  @override
  String toString() {
    return 'ToushiShintakuInputState(relationalIdMap: $relationalIdMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToushiShintakuInputStateImpl &&
            const DeepCollectionEquality()
                .equals(other._relationalIdMap, _relationalIdMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_relationalIdMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToushiShintakuInputStateImplCopyWith<_$ToushiShintakuInputStateImpl>
      get copyWith => __$$ToushiShintakuInputStateImplCopyWithImpl<
          _$ToushiShintakuInputStateImpl>(this, _$identity);
}

abstract class _ToushiShintakuInputState implements ToushiShintakuInputState {
  const factory _ToushiShintakuInputState(
          {final Map<String, int> relationalIdMap}) =
      _$ToushiShintakuInputStateImpl;

  @override
  Map<String, int> get relationalIdMap;
  @override
  @JsonKey(ignore: true)
  _$$ToushiShintakuInputStateImplCopyWith<_$ToushiShintakuInputStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
