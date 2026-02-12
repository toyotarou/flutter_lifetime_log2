// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifetime_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LifetimeItemState {
  List<LifetimeItemModel> get lifetimeItemList =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LifetimeItemStateCopyWith<LifetimeItemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifetimeItemStateCopyWith<$Res> {
  factory $LifetimeItemStateCopyWith(
          LifetimeItemState value, $Res Function(LifetimeItemState) then) =
      _$LifetimeItemStateCopyWithImpl<$Res, LifetimeItemState>;
  @useResult
  $Res call({List<LifetimeItemModel> lifetimeItemList});
}

/// @nodoc
class _$LifetimeItemStateCopyWithImpl<$Res, $Val extends LifetimeItemState>
    implements $LifetimeItemStateCopyWith<$Res> {
  _$LifetimeItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifetimeItemList = null,
  }) {
    return _then(_value.copyWith(
      lifetimeItemList: null == lifetimeItemList
          ? _value.lifetimeItemList
          : lifetimeItemList // ignore: cast_nullable_to_non_nullable
              as List<LifetimeItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifetimeItemStateImplCopyWith<$Res>
    implements $LifetimeItemStateCopyWith<$Res> {
  factory _$$LifetimeItemStateImplCopyWith(_$LifetimeItemStateImpl value,
          $Res Function(_$LifetimeItemStateImpl) then) =
      __$$LifetimeItemStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LifetimeItemModel> lifetimeItemList});
}

/// @nodoc
class __$$LifetimeItemStateImplCopyWithImpl<$Res>
    extends _$LifetimeItemStateCopyWithImpl<$Res, _$LifetimeItemStateImpl>
    implements _$$LifetimeItemStateImplCopyWith<$Res> {
  __$$LifetimeItemStateImplCopyWithImpl(_$LifetimeItemStateImpl _value,
      $Res Function(_$LifetimeItemStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifetimeItemList = null,
  }) {
    return _then(_$LifetimeItemStateImpl(
      lifetimeItemList: null == lifetimeItemList
          ? _value._lifetimeItemList
          : lifetimeItemList // ignore: cast_nullable_to_non_nullable
              as List<LifetimeItemModel>,
    ));
  }
}

/// @nodoc

class _$LifetimeItemStateImpl implements _LifetimeItemState {
  const _$LifetimeItemStateImpl(
      {final List<LifetimeItemModel> lifetimeItemList =
          const <LifetimeItemModel>[]})
      : _lifetimeItemList = lifetimeItemList;

  final List<LifetimeItemModel> _lifetimeItemList;
  @override
  @JsonKey()
  List<LifetimeItemModel> get lifetimeItemList {
    if (_lifetimeItemList is EqualUnmodifiableListView)
      return _lifetimeItemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lifetimeItemList);
  }

  @override
  String toString() {
    return 'LifetimeItemState(lifetimeItemList: $lifetimeItemList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifetimeItemStateImpl &&
            const DeepCollectionEquality()
                .equals(other._lifetimeItemList, _lifetimeItemList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_lifetimeItemList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LifetimeItemStateImplCopyWith<_$LifetimeItemStateImpl> get copyWith =>
      __$$LifetimeItemStateImplCopyWithImpl<_$LifetimeItemStateImpl>(
          this, _$identity);
}

abstract class _LifetimeItemState implements LifetimeItemState {
  const factory _LifetimeItemState(
          {final List<LifetimeItemModel> lifetimeItemList}) =
      _$LifetimeItemStateImpl;

  @override
  List<LifetimeItemModel> get lifetimeItemList;
  @override
  @JsonKey(ignore: true)
  _$$LifetimeItemStateImplCopyWith<_$LifetimeItemStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
