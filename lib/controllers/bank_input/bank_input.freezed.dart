// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BankInputState {
  int get pos => throw _privateConstructorUsedError;
  List<String> get inputDateList => throw _privateConstructorUsedError;
  List<String> get inputBankList => throw _privateConstructorUsedError;
  List<String> get inputValueList => throw _privateConstructorUsedError;
  String get selectedBankKey => throw _privateConstructorUsedError;

  /// Create a copy of BankInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankInputStateCopyWith<BankInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankInputStateCopyWith<$Res> {
  factory $BankInputStateCopyWith(
          BankInputState value, $Res Function(BankInputState) then) =
      _$BankInputStateCopyWithImpl<$Res, BankInputState>;
  @useResult
  $Res call(
      {int pos,
      List<String> inputDateList,
      List<String> inputBankList,
      List<String> inputValueList,
      String selectedBankKey});
}

/// @nodoc
class _$BankInputStateCopyWithImpl<$Res, $Val extends BankInputState>
    implements $BankInputStateCopyWith<$Res> {
  _$BankInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? inputDateList = null,
    Object? inputBankList = null,
    Object? inputValueList = null,
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
      inputBankList: null == inputBankList
          ? _value.inputBankList
          : inputBankList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputValueList: null == inputValueList
          ? _value.inputValueList
          : inputValueList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankKey: null == selectedBankKey
          ? _value.selectedBankKey
          : selectedBankKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankInputStateImplCopyWith<$Res>
    implements $BankInputStateCopyWith<$Res> {
  factory _$$BankInputStateImplCopyWith(_$BankInputStateImpl value,
          $Res Function(_$BankInputStateImpl) then) =
      __$$BankInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pos,
      List<String> inputDateList,
      List<String> inputBankList,
      List<String> inputValueList,
      String selectedBankKey});
}

/// @nodoc
class __$$BankInputStateImplCopyWithImpl<$Res>
    extends _$BankInputStateCopyWithImpl<$Res, _$BankInputStateImpl>
    implements _$$BankInputStateImplCopyWith<$Res> {
  __$$BankInputStateImplCopyWithImpl(
      _$BankInputStateImpl _value, $Res Function(_$BankInputStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? inputDateList = null,
    Object? inputBankList = null,
    Object? inputValueList = null,
    Object? selectedBankKey = null,
  }) {
    return _then(_$BankInputStateImpl(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      inputDateList: null == inputDateList
          ? _value._inputDateList
          : inputDateList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputBankList: null == inputBankList
          ? _value._inputBankList
          : inputBankList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputValueList: null == inputValueList
          ? _value._inputValueList
          : inputValueList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedBankKey: null == selectedBankKey
          ? _value.selectedBankKey
          : selectedBankKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BankInputStateImpl implements _BankInputState {
  const _$BankInputStateImpl(
      {this.pos = -1,
      final List<String> inputDateList = const <String>[],
      final List<String> inputBankList = const <String>[],
      final List<String> inputValueList = const <String>[],
      this.selectedBankKey = ''})
      : _inputDateList = inputDateList,
        _inputBankList = inputBankList,
        _inputValueList = inputValueList;

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

  final List<String> _inputBankList;
  @override
  @JsonKey()
  List<String> get inputBankList {
    if (_inputBankList is EqualUnmodifiableListView) return _inputBankList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputBankList);
  }

  final List<String> _inputValueList;
  @override
  @JsonKey()
  List<String> get inputValueList {
    if (_inputValueList is EqualUnmodifiableListView) return _inputValueList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputValueList);
  }

  @override
  @JsonKey()
  final String selectedBankKey;

  @override
  String toString() {
    return 'BankInputState(pos: $pos, inputDateList: $inputDateList, inputBankList: $inputBankList, inputValueList: $inputValueList, selectedBankKey: $selectedBankKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankInputStateImpl &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality()
                .equals(other._inputDateList, _inputDateList) &&
            const DeepCollectionEquality()
                .equals(other._inputBankList, _inputBankList) &&
            const DeepCollectionEquality()
                .equals(other._inputValueList, _inputValueList) &&
            (identical(other.selectedBankKey, selectedBankKey) ||
                other.selectedBankKey == selectedBankKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      pos,
      const DeepCollectionEquality().hash(_inputDateList),
      const DeepCollectionEquality().hash(_inputBankList),
      const DeepCollectionEquality().hash(_inputValueList),
      selectedBankKey);

  /// Create a copy of BankInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankInputStateImplCopyWith<_$BankInputStateImpl> get copyWith =>
      __$$BankInputStateImplCopyWithImpl<_$BankInputStateImpl>(
          this, _$identity);
}

abstract class _BankInputState implements BankInputState {
  const factory _BankInputState(
      {final int pos,
      final List<String> inputDateList,
      final List<String> inputBankList,
      final List<String> inputValueList,
      final String selectedBankKey}) = _$BankInputStateImpl;

  @override
  int get pos;
  @override
  List<String> get inputDateList;
  @override
  List<String> get inputBankList;
  @override
  List<String> get inputValueList;
  @override
  String get selectedBankKey;

  /// Create a copy of BankInputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankInputStateImplCopyWith<_$BankInputStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
