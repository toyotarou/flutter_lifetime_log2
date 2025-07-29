// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spend_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpendInputState {
  int get pos => throw _privateConstructorUsedError;
  List<String> get inputDateList => throw _privateConstructorUsedError;
  List<String> get inputItemList => throw _privateConstructorUsedError;
  List<String> get inputValueList => throw _privateConstructorUsedError;
  List<String> get inputKindList => throw _privateConstructorUsedError;
  String get selectedBankKey => throw _privateConstructorUsedError;

  /// Create a copy of SpendInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendInputStateCopyWith<SpendInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendInputStateCopyWith<$Res> {
  factory $SpendInputStateCopyWith(
          SpendInputState value, $Res Function(SpendInputState) then) =
      _$SpendInputStateCopyWithImpl<$Res, SpendInputState>;
  @useResult
  $Res call(
      {int pos,
      List<String> inputDateList,
      List<String> inputItemList,
      List<String> inputValueList,
      List<String> inputKindList,
      String selectedBankKey});
}

/// @nodoc
class _$SpendInputStateCopyWithImpl<$Res, $Val extends SpendInputState>
    implements $SpendInputStateCopyWith<$Res> {
  _$SpendInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? inputDateList = null,
    Object? inputItemList = null,
    Object? inputValueList = null,
    Object? inputKindList = null,
    Object? selectedBankKey = null,
  }) {
    return _then(_value.copyWith(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      inputDateList: null == inputDateList
          ? _value.inputDateList
          : inputDateList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputItemList: null == inputItemList
          ? _value.inputItemList
          : inputItemList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputValueList: null == inputValueList
          ? _value.inputValueList
          : inputValueList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputKindList: null == inputKindList
          ? _value.inputKindList
          : inputKindList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankKey: null == selectedBankKey
          ? _value.selectedBankKey
          : selectedBankKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendInputStateImplCopyWith<$Res>
    implements $SpendInputStateCopyWith<$Res> {
  factory _$$SpendInputStateImplCopyWith(_$SpendInputStateImpl value,
          $Res Function(_$SpendInputStateImpl) then) =
      __$$SpendInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pos,
      List<String> inputDateList,
      List<String> inputItemList,
      List<String> inputValueList,
      List<String> inputKindList,
      String selectedBankKey});
}

/// @nodoc
class __$$SpendInputStateImplCopyWithImpl<$Res>
    extends _$SpendInputStateCopyWithImpl<$Res, _$SpendInputStateImpl>
    implements _$$SpendInputStateImplCopyWith<$Res> {
  __$$SpendInputStateImplCopyWithImpl(
      _$SpendInputStateImpl _value, $Res Function(_$SpendInputStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpendInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? inputDateList = null,
    Object? inputItemList = null,
    Object? inputValueList = null,
    Object? inputKindList = null,
    Object? selectedBankKey = null,
  }) {
    return _then(_$SpendInputStateImpl(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      inputDateList: null == inputDateList
          ? _value._inputDateList
          : inputDateList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputItemList: null == inputItemList
          ? _value._inputItemList
          : inputItemList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputValueList: null == inputValueList
          ? _value._inputValueList
          : inputValueList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputKindList: null == inputKindList
          ? _value._inputKindList
          : inputKindList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankKey: null == selectedBankKey
          ? _value.selectedBankKey
          : selectedBankKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SpendInputStateImpl implements _SpendInputState {
  const _$SpendInputStateImpl(
      {this.pos = -1,
      final List<String> inputDateList = const <String>[],
      final List<String> inputItemList = const <String>[],
      final List<String> inputValueList = const <String>[],
      final List<String> inputKindList = const <String>[],
      this.selectedBankKey = ''})
      : _inputDateList = inputDateList,
        _inputItemList = inputItemList,
        _inputValueList = inputValueList,
        _inputKindList = inputKindList;

  @override
  @JsonKey()
  final int pos;
  final List<String> _inputDateList;
  @override
  @JsonKey()
  List<String> get inputDateList {
    if (_inputDateList is EqualUnmodifiableListView) return _inputDateList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputDateList);
  }

  final List<String> _inputItemList;
  @override
  @JsonKey()
  List<String> get inputItemList {
    if (_inputItemList is EqualUnmodifiableListView) return _inputItemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputItemList);
  }

  final List<String> _inputValueList;
  @override
  @JsonKey()
  List<String> get inputValueList {
    if (_inputValueList is EqualUnmodifiableListView) return _inputValueList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputValueList);
  }

  final List<String> _inputKindList;
  @override
  @JsonKey()
  List<String> get inputKindList {
    if (_inputKindList is EqualUnmodifiableListView) return _inputKindList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputKindList);
  }

  @override
  @JsonKey()
  final String selectedBankKey;

  @override
  String toString() {
    return 'SpendInputState(pos: $pos, inputDateList: $inputDateList, inputItemList: $inputItemList, inputValueList: $inputValueList, inputKindList: $inputKindList, selectedBankKey: $selectedBankKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendInputStateImpl &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality()
                .equals(other._inputDateList, _inputDateList) &&
            const DeepCollectionEquality()
                .equals(other._inputItemList, _inputItemList) &&
            const DeepCollectionEquality()
                .equals(other._inputValueList, _inputValueList) &&
            const DeepCollectionEquality()
                .equals(other._inputKindList, _inputKindList) &&
            (identical(other.selectedBankKey, selectedBankKey) ||
                other.selectedBankKey == selectedBankKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      pos,
      const DeepCollectionEquality().hash(_inputDateList),
      const DeepCollectionEquality().hash(_inputItemList),
      const DeepCollectionEquality().hash(_inputValueList),
      const DeepCollectionEquality().hash(_inputKindList),
      selectedBankKey);

  /// Create a copy of SpendInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendInputStateImplCopyWith<_$SpendInputStateImpl> get copyWith =>
      __$$SpendInputStateImplCopyWithImpl<_$SpendInputStateImpl>(
          this, _$identity);
}

abstract class _SpendInputState implements SpendInputState {
  const factory _SpendInputState(
      {final int pos,
      final List<String> inputDateList,
      final List<String> inputItemList,
      final List<String> inputValueList,
      final List<String> inputKindList,
      final String selectedBankKey}) = _$SpendInputStateImpl;

  @override
  int get pos;
  @override
  List<String> get inputDateList;
  @override
  List<String> get inputItemList;
  @override
  List<String> get inputValueList;
  @override
  List<String> get inputKindList;
  @override
  String get selectedBankKey;

  /// Create a copy of SpendInputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendInputStateImplCopyWith<_$SpendInputStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
