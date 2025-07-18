// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifetime_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LifetimeInputState {
  String get selectedInputChoiceChip => throw _privateConstructorUsedError;
  int get itemPos => throw _privateConstructorUsedError;
  List<String> get lifetimeStringList => throw _privateConstructorUsedError;

  /// Create a copy of LifetimeInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LifetimeInputStateCopyWith<LifetimeInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifetimeInputStateCopyWith<$Res> {
  factory $LifetimeInputStateCopyWith(
          LifetimeInputState value, $Res Function(LifetimeInputState) then) =
      _$LifetimeInputStateCopyWithImpl<$Res, LifetimeInputState>;
  @useResult
  $Res call(
      {String selectedInputChoiceChip,
      int itemPos,
      List<String> lifetimeStringList});
}

/// @nodoc
class _$LifetimeInputStateCopyWithImpl<$Res, $Val extends LifetimeInputState>
    implements $LifetimeInputStateCopyWith<$Res> {
  _$LifetimeInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LifetimeInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedInputChoiceChip = null,
    Object? itemPos = null,
    Object? lifetimeStringList = null,
  }) {
    return _then(_value.copyWith(
      selectedInputChoiceChip: null == selectedInputChoiceChip
          ? _value.selectedInputChoiceChip
          : selectedInputChoiceChip // ignore: cast_nullable_to_non_nullable
              as String,
      itemPos: null == itemPos
          ? _value.itemPos
          : itemPos // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimeStringList: null == lifetimeStringList
          ? _value.lifetimeStringList
          : lifetimeStringList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifetimeInputStateImplCopyWith<$Res>
    implements $LifetimeInputStateCopyWith<$Res> {
  factory _$$LifetimeInputStateImplCopyWith(_$LifetimeInputStateImpl value,
          $Res Function(_$LifetimeInputStateImpl) then) =
      __$$LifetimeInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String selectedInputChoiceChip,
      int itemPos,
      List<String> lifetimeStringList});
}

/// @nodoc
class __$$LifetimeInputStateImplCopyWithImpl<$Res>
    extends _$LifetimeInputStateCopyWithImpl<$Res, _$LifetimeInputStateImpl>
    implements _$$LifetimeInputStateImplCopyWith<$Res> {
  __$$LifetimeInputStateImplCopyWithImpl(_$LifetimeInputStateImpl _value,
      $Res Function(_$LifetimeInputStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LifetimeInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedInputChoiceChip = null,
    Object? itemPos = null,
    Object? lifetimeStringList = null,
  }) {
    return _then(_$LifetimeInputStateImpl(
      selectedInputChoiceChip: null == selectedInputChoiceChip
          ? _value.selectedInputChoiceChip
          : selectedInputChoiceChip // ignore: cast_nullable_to_non_nullable
              as String,
      itemPos: null == itemPos
          ? _value.itemPos
          : itemPos // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimeStringList: null == lifetimeStringList
          ? _value._lifetimeStringList
          : lifetimeStringList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$LifetimeInputStateImpl implements _LifetimeInputState {
  const _$LifetimeInputStateImpl(
      {this.selectedInputChoiceChip = '',
      this.itemPos = -1,
      final List<String> lifetimeStringList = const []})
      : _lifetimeStringList = lifetimeStringList;

  @override
  @JsonKey()
  final String selectedInputChoiceChip;
  @override
  @JsonKey()
  final int itemPos;
  final List<String> _lifetimeStringList;
  @override
  @JsonKey()
  List<String> get lifetimeStringList {
    if (_lifetimeStringList is EqualUnmodifiableListView)
      return _lifetimeStringList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lifetimeStringList);
  }

  @override
  String toString() {
    return 'LifetimeInputState(selectedInputChoiceChip: $selectedInputChoiceChip, itemPos: $itemPos, lifetimeStringList: $lifetimeStringList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifetimeInputStateImpl &&
            (identical(
                    other.selectedInputChoiceChip, selectedInputChoiceChip) ||
                other.selectedInputChoiceChip == selectedInputChoiceChip) &&
            (identical(other.itemPos, itemPos) || other.itemPos == itemPos) &&
            const DeepCollectionEquality()
                .equals(other._lifetimeStringList, _lifetimeStringList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedInputChoiceChip, itemPos,
      const DeepCollectionEquality().hash(_lifetimeStringList));

  /// Create a copy of LifetimeInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LifetimeInputStateImplCopyWith<_$LifetimeInputStateImpl> get copyWith =>
      __$$LifetimeInputStateImplCopyWithImpl<_$LifetimeInputStateImpl>(
          this, _$identity);
}

abstract class _LifetimeInputState implements LifetimeInputState {
  const factory _LifetimeInputState(
      {final String selectedInputChoiceChip,
      final int itemPos,
      final List<String> lifetimeStringList}) = _$LifetimeInputStateImpl;

  @override
  String get selectedInputChoiceChip;
  @override
  int get itemPos;
  @override
  List<String> get lifetimeStringList;

  /// Create a copy of LifetimeInputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LifetimeInputStateImplCopyWith<_$LifetimeInputStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
