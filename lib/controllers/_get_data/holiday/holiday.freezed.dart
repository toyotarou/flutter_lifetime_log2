// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HolidayState {
  List<String> get holidayList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HolidayStateCopyWith<HolidayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayStateCopyWith<$Res> {
  factory $HolidayStateCopyWith(
          HolidayState value, $Res Function(HolidayState) then) =
      _$HolidayStateCopyWithImpl<$Res, HolidayState>;
  @useResult
  $Res call({List<String> holidayList});
}

/// @nodoc
class _$HolidayStateCopyWithImpl<$Res, $Val extends HolidayState>
    implements $HolidayStateCopyWith<$Res> {
  _$HolidayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayList = null,
  }) {
    return _then(_value.copyWith(
      holidayList: null == holidayList
          ? _value.holidayList
          : holidayList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HolidayStateImplCopyWith<$Res>
    implements $HolidayStateCopyWith<$Res> {
  factory _$$HolidayStateImplCopyWith(
          _$HolidayStateImpl value, $Res Function(_$HolidayStateImpl) then) =
      __$$HolidayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> holidayList});
}

/// @nodoc
class __$$HolidayStateImplCopyWithImpl<$Res>
    extends _$HolidayStateCopyWithImpl<$Res, _$HolidayStateImpl>
    implements _$$HolidayStateImplCopyWith<$Res> {
  __$$HolidayStateImplCopyWithImpl(
      _$HolidayStateImpl _value, $Res Function(_$HolidayStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayList = null,
  }) {
    return _then(_$HolidayStateImpl(
      holidayList: null == holidayList
          ? _value._holidayList
          : holidayList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$HolidayStateImpl implements _HolidayState {
  const _$HolidayStateImpl({final List<String> holidayList = const <String>[]})
      : _holidayList = holidayList;

  final List<String> _holidayList;
  @override
  @JsonKey()
  List<String> get holidayList {
    if (_holidayList is EqualUnmodifiableListView) return _holidayList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_holidayList);
  }

  @override
  String toString() {
    return 'HolidayState(holidayList: $holidayList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayStateImpl &&
            const DeepCollectionEquality()
                .equals(other._holidayList, _holidayList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_holidayList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayStateImplCopyWith<_$HolidayStateImpl> get copyWith =>
      __$$HolidayStateImplCopyWithImpl<_$HolidayStateImpl>(this, _$identity);
}

abstract class _HolidayState implements HolidayState {
  const factory _HolidayState({final List<String> holidayList}) =
      _$HolidayStateImpl;

  @override
  List<String> get holidayList;
  @override
  @JsonKey(ignore: true)
  _$$HolidayStateImplCopyWith<_$HolidayStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
