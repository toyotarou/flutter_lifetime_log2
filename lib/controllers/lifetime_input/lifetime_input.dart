import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utility/utility.dart';

part 'lifetime_input.freezed.dart';

part 'lifetime_input.g.dart';

@freezed
class LifetimeInputState with _$LifetimeInputState {
  const factory LifetimeInputState({@Default('') String selectedInputChoiceChip}) = _LifetimeInputState;
}

@riverpod
class LifetimeInput extends _$LifetimeInput {
  final Utility utility = Utility();

  ///
  @override
  LifetimeInputState build() => const LifetimeInputState();

  ///
  void setSelectedInputChoiceChip({required String item}) => state = state.copyWith(selectedInputChoiceChip: item);
}
